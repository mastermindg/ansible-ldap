# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables used for Vagrant
class SharedVariables
  attr_accessor :setupscript, :machines, :ansiblegroups
  def initialize
    @setupscript = 'vagrant_scripts/setup.sh'
    @machines = [{ 'name' => 'ldapserver1', 'ip' => '10.199.0.10',
                   'role' => %w[server initial] },
                 { 'name' => 'ldapserver2', 'ip' => '10.199.0.11',
                   'role' => 'server' },
                 { 'name' => 'ldapclient', 'ip' => '10.199.0.12',
                   'role' => 'client' }]
    @ansiblegroups = build_groups
  end

  # Generates the roles arrays for machines
  # Returns Array
  def build_roles(role)
    results = @machines.reject { |m| [*m['role']].grep(role).empty? }
    rolesarray = []
    results.each do |machine|
      rolesarray.push(machine['name'])
    end
    rolesarray
  end

  # Builds the Ansible groups from machine keys/values
  # Returns Hash
  def build_groups
    groups = {}
    roles = %w[client server initial]
    roles.each do |role|
      groups[role] = build_roles(role)
    end
    groups
  end

  # Exports node IP's used by provisioner for /etc/hosts
  # Returns Array
  def set_ips
    array = []
    @machines.each do |machine|
      name = machine['name']
      ip = machine['ip']
      array.push("#{ip}\t#{name}")
    end
    array
  end

  # Writes machines lines into inventory
  def write_machines(f)
    @machines.each do |m|
      f.write("#{m['name']}\tansible_ssh_host=#{m['ip']}\t")
      f.write('ansible_ssh_private_key_file=')
      f.write("/vagrant/.vagrant/machines/#{m['name']}")
      f.write("/virtualbox/private_key\n")
    end
  end

  # Writes role groups into inventory
  def write_groups(groups, f)
    groups.each do |key, array|
      f.write("\n[#{key}]\n")
      if array.count > 1
        array.each do |value|
          f.write("#{value}\n")
        end
      else
        f.write("#{array.join('')}\n")
      end
    end
  end

  # Build inventory file for ansible_local
  # Creates the files needed
  def build_inventory
    Dir.mkdir 'inventory' unless File.directory?('inventory')
    File.open('inventory/ldap', 'w') do |f|
      f.write("controller\tansible_connection=local\n")
      write_machines(f)
      groups = build_groups
      write_groups(groups, f)
    end
  end
end

myshare = SharedVariables.new
setupscript = myshare.setupscript
machines = myshare.machines
ips = myshare.set_ips
myshare.build_inventory

Vagrant.configure(2) do |config|
  config.vm.box_check_update = false
  config.vbguest.auto_update = false
  config.vm.box = 'ubuntu/xenial64'
  config.vm.provider 'virtualbox' do |vb|
    vb.customize ['modifyvm', :id, '--uartmode1', 'disconnected']
  end
  config.trigger.after :destroy do
    run 'rm -rf inventory'
    run 'rm -rf certs'
  end

  machines.each do |machine|
    name = machine['name']
    ip = machine['ip']
    config.vm.define name do |node|
      node.vm.hostname = name
      node.vm.network :private_network, ip: ip
      config.vm.provision 'shell', path: setupscript, args: ips
      node.vm.provision :ansible_local do |ansible|
        ansible.playbook = 'site.yml'
        ansible.inventory_path = 'inventory'
      end
    end
  end
end
