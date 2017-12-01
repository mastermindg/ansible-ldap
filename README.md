# ldap

Installs 2 Master-Master replicated OpenLDAP servers and a client system to authenticate against them all running on Ubuntu 16.04.

Couple of things:
1) A self-signed CA Certificate is generated on ldapserver1.
2) It's copied for distribution using the variable local_certs_path
3) The CA Certificate is used to build the server certificates and passed to the client.
3) TLS can be turned off-on by using the TLS variable

First create an instance somewhere that's reachable - cloud or local. Here's an example using the kvm-install role:

```ansible-playbook -i "power2.kensnet.priv," --extra-vars "vm_hostname=ldap1" playbooks/kvm-install/site.yml
```

Then provision the servers:

```
ansible-playbook -i inventory/ldap playbooks/ldap/site.yml
```

## Vagrant

Testing with Vagrant. Requires some plugins.

This will create three Virtualbox "machines", 2 LDAP servers and 1 client:

```
vagrant plugin install vagrant-triggers vagrant-vbguest
vagrant up
#vagrant ssh ldapserver1/2
#vagrant ssh ldapclient1
```

The vagrant-restart script can be used for testing to clean up the environment and start fresh.

## TODO:

- Completely remove debconf dependency
- Replicate both ways with TLS
- Not entirely sure that config replication is working

## Useful commands:

ldapsearch -W -D "cn=admin,dc=example,dc=com" -b "dc=example,dc=com" -s sub "objectclass=*"

ldapsearch -W -Z -D cn=admin,dc=example,dc=com -b dc=example,dc=com -LLL dn

ldapmodify -W -D cn=admin,dc=example,dc=com -f forcetls.ldif

ldapsearch -W -Z -D cn=admin,dc=kensawesome,dc=priv -b dc=kensawesome,dc=priv -LLL dn

ldapsearch -H ldap://ldapserver1 -W -Z -D cn=admin,dc=kensawesome,dc=priv -b dc=kensawesome,dc=priv -LLL dn