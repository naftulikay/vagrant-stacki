# -*- mode: ruby -*-
# vi: set ft=ruby :

# stacki has some minimum requirements above what's provided by most vagrant boxes
# this includes 2gb of ram, 64GB of disk, and a dedicated non-NAT nic
# for details, see https://github.com/StackIQ/stacki/wiki/Frontend-Installation

Vagrant.configure(2) do |config|
  config.vm.box = "rfkrocktk/stacki-3.2-7.x"

  # Add a nic for a backend install network
  config.vm.network "private_network", ip: "10.168.42.101", :mac => "0800d00dc189"

  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the VM:
    vb.memory = "2048"
    # give the VM a pretty name in VBox Manager
    vb.name = "stacki-frontend-3.2-" + Time.new.strftime("%Y%m%d%H%M%S")
  end
end
