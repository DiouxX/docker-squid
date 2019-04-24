#!/bin/bash

function squid_config() {

	#Comment user deny to open proxy
        echo "Comment http_access deny all"
        sed -i "s/^\(http_access deny all\)/# \1/g" /etc/squid/squid.conf


        #If set to off, Squid will dont append your client's IP address
        echo "forwarded_for off"
        echo "forwarded_for off" >> /etc/squid/squid.conf

	if ${LDAP_ENABLE}
        then
		echo "LDAP Enable"
		echo "LDAP Port = ${LDAP_PORT}"

		case ${LDAP_PORT} in
		389)
                	echo -e "auth_param basic program /usr/lib/squid/basic_ldap_auth -b ${LDAP_DN} -f ${LDAP_ATTRIBUT} -h ${LDAP_HOST}:${LDAP_PORT}\nauth_param basic children 5\nauth_param basic realm ${PROXY_NAME}\nauth_param basic credentialsttl 2 hours\nacl ldapauth proxy_auth REQUIRED\nacl authenticated proxy_auth REQUIRED\nhttp_access allow ldapauth" >> /etc/squid/squid.conf
			;;
		636)
			#check if TLS_REQCERT is present
                        if !(grep -q "TLS_REQCERT" /etc/ldap/ldap.conf)
                        then
                                echo "TLS_REQCERT isn't present"
                                echo -e "TLS_REQCERT\tnever" >> /etc/ldap/ldap.conf
                        fi

                	echo -e "auth_param basic program /usr/lib/squid/basic_ldap_auth -b ${LDAP_DN} -f ${LDAP_ATTRIBUT} -h ldaps://${LDAP_HOST}:${LDAP_PORT}\nauth_param basic children 5\nauth_param basic realm ${PROXY_NAME}\nauth_param basic credentialsttl 2 hours\nacl ldapauth proxy_auth REQUIRED\nacl authenticated proxy_auth REQUIRED\nhttp_access allow ldapauth" >> /etc/squid/squid.conf
			;;
		esac
        else
		echo "LDAP Disable"
                #Add allow directive and fowarded_for
                echo "http_access allow all"
                echo "http_access allow all" >> /etc/squid/squid.conf
        fi
}

squid_config

#Launch squid on foreground
/usr/sbin/squid -NCd1 -f /etc/squid/squid.conf
