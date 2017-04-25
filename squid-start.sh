#!/bin/bash

function squid_config() {

	#Comment user deny to open proxy
        echo "Comment http_access deny all"
        sed -i "s/^\(http_access deny all\)/# \1/g" /etc/squid3/squid.conf


        #If set to off, Squid will dont append your client's IP address
        echo "forwarded_for off"
        echo "forwarded_for off" >> /etc/squid3/squid.conf

	#Copy LDAP config file
	echo "Copy ldap.conf -> /etc/squid3"
        cp /opt/ldap.config /etc/squid3/

        #Loading LDAP variable
        source /etc/squid3/ldap.config

        if $LDAP_ENABLE
        then
		echo "LDAP Enable"
		echo "LDAP Port = $LDAP_PORT"

		case $LDAP_PORT in
		389)
                	echo -e "auth_param basic program /usr/lib/squid3/basic_ldap_auth -b $LDAP_DN -f $LDAP_ATTRIBUT -h $LDAP_HOST:$LDAP_PORT\nauth_param basic children 5\nauth_param basic realm $PROXY_NAME\nauth_param basic credentialsttl 2 hours\nacl ldapauth proxy_auth REQUIRED\nacl authenticated proxy_auth REQUIRED\nhttp_access allow ldapauth" >> /etc/squid3/squid.conf
			;;
		636)
			#check if TLS_REQCERT is present
                        if !(grep -q "TLS_REQCERT" /etc/ldap/ldap.conf)
                        then
                                echo "TLS_REQCERT isn't present"
                                echo -e "TLS_REQCERT\tnever" >> /etc/ldap/ldap.conf
                        fi

                	echo -e "auth_param basic program /usr/lib/squid3/basic_ldap_auth -ZZ -b $LDAP_DN -f $LDAP_ATTRIBUT -h $LDAP_HOST:$LDAP_PORT\nauth_param basic children 5\nauth_param basic realm $PROXY_NAME\nauth_param basic credentialsttl 2 hours\nacl ldapauth proxy_auth REQUIRED\nacl authenticated proxy_auth REQUIRED\nhttp_access allow ldapauth" >> /etc/squid3/squid.conf
			;;
		esac
        else
		echo "LDAP Disable"
                #Add allow directive and fowarded_for
                echo "http_access allow all"
                echo "http_access allow all" >> /etc/squid3/squid.conf
        fi
}

#Check if /etc/squid3/squid.conf.origin exist
if [ -f /etc/squid3/squid.conf.origin ]
then
        echo "File /etc/squid3/squid.conf.origin exist"
        #Erase file config
        cp /etc/squid3/squid.conf.origin /etc/squid3/squid.conf
        echo "Copy squid.conf.origin -> squid.conf"
	
        #Squid config
        squid_config

else
        #Backup original config file
        echo "File /etc/squid3/squid.conf.origin doesn't exist"
        cp /etc/squid3/squid.conf /etc/squid3/squid.conf.origin
        echo "Copy squid.conf -> squid.conf.origin"
	
        #Squid config
        squid_config
fi

#Delete PID file before else crash on docker restart
rm -rf /var/run/squid3.pid

#Launch squid on foreground
/usr/sbin/squid3 -NCd1 -f /etc/squid3/squid.conf
