# ldap

Installs 2 Master-Master replicated OpenLDAP servers and a client system to authenticate against them all running on Ubuntu 16.04.

Couple of things:
1) A single slef-signed certificate is generated and shared between the servers
2) It's copied for distribution using the variable local_certs_path
3) TLS can be turned off-on by using the TLS variable

First create an instance somewhere that's reachable - cloud or local. Here's an example using the kvm-install role:

```ansible-playbook -i "power2.kensnet.priv," --extra-vars "vm_hostname=ldap1" playbooks/kvm-install/site.yml
```

Then provision the servers:

```
ansible-playbook -i inventory/ldap playbooks/ldap/site.yml
```

## Vagrant

Testing with Vagrant. Requires the vagrant-triggers plugin.

This will create three Virtualbox "machines", 2 LDAP servers and 1 client:

```
vagrant plugin install vagrant-triggers
vagrant up
#vagrant ssh ldapserver1/2
#vagrant ssh ldapclient1
```


##TODO:

- Completely remove debconf dependency
- Replicate with TLS
- Not entirely sure that config replication is working

##Useful commands:

ldapsearch -W -D "cn=admin,dc=example,dc=com" -b "dc=example,dc=com" -s sub "objectclass=*"

ldapsearch -W -Z -D cn=admin,dc=example,dc=com -b dc=example,dc=com -LLL dn

ldapmodify -W -D cn=admin,dc=example,dc=com -f forcetls.ldif

ldapsearch -W -Z -D cn=admin,dc=kensawesome,dc=priv -b dc=kensawesome,dc=priv -LLL dn

ldapsearch -H ldap://ldapserver1 -W -Z -D cn=admin,dc=kensawesome,dc=priv -b dc=kensawesome,dc=priv -LLL dn