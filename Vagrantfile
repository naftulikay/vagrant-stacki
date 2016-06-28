# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # CentOS 7 Development Machine
  config.vm.define "default", autostart: true, primary: true do |devel|
    devel.vm.box = "bento/centos-7.2"

    # set the hostname
    devel.vm.hostname = "vagrant-stacki"

    # Create a private network, which allows host-only access to the machine using a specific IP.
    devel.vm.network "private_network", type: "dhcp"

    devel.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end

    # ansible provision to bootstrap the machine
    devel.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/playbook.yml"
    end

    # puppet to actually configure the hard stuff
    devel.vm.provision "puppet" do |puppet|
      puppet.environment_path  = "environments"
      puppet.environment = "production"
      puppet.options = ENV.fetch("PUPPET_ARGS", "")
      puppet.working_directory = "/vagrant"
      puppet.hiera_config_path = "hiera.yaml"
    end
  end
end
