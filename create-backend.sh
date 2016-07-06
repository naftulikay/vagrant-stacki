#!/bin/bash

set -e

function usage() {
    echo "Usage: $0 machine_id"
    echo
    echo "Creates a new Stacki backend machine and attaches it to the frontend Vagrant box."
    echo
    echo "    machine_id    Numeric ID of machine to create."
    echo
    exit 1
}

function create_vm() {
    machine_id="$1"
    machine_name="stacki-backend-$machine_id"
    machine_ram="2048"

    # learn about the frontend
    frontend_uuid="$(cat .vagrant/machines/default/virtualbox/id)"
    frontend_adapter="$(VBoxManage showvminfo $frontend_uuid --machinereadable | \
        sed -n -E "s/hostonlyadapter.*=\"(.*)\"/\1/p")"
    frontend_mac="$(VBoxManage showvminfo $frontend_uuid --machinereadable | \
        grep macaddress1 | sed -n -E "s/macaddress1=\"(.*)\"/\1/p" | \
            sed -e 's/\([0-9A-Fa-f]\{2\}\)/\1:/g' -e 's/\(.*\):$/\1/')"

    # create vm
    VBoxManage createvm --name "$machine_name" --register

    # setup virtual hardware
    VBoxManage modifyvm "$machine_name" --ostype RedHat_64 --ioapic on --rtcuseutc on \
        --boot1 net --boot2 disk --boot3 none \
        --nic1 hostonly --nictype1 82540EM --hostonlyadapter1 $frontend_adapter

    # save machine's mac
    machine_mac="$(VBoxManage showvminfo $machine_name --machinereadable | \
        grep macaddress1 | sed -n -E "s/macaddress1=\"(.*)\"/\1/p" | \
            sed -e 's/\([0-9A-Fa-f]\{2\}\)/\1:/g' -e 's/\(.*\):$/\1/')"

    # storage settings
    vm_dirname="$(dirname "$(VBoxManage showvminfo $machine_name --machinereadable | \
         sed -n -E "s/CfgFile=\"(.*)\"/\1/p" )")"

    VBoxManage storagectl "$machine_name" --name SATA --add sata --controller IntelAhci \
        --portcount 1 --bootable on
    VBoxManage createhd --filename "$vm_dirname/${machine_name}.vdi" --size 8192
    VBoxManage storageattach "$machine_name" --storagectl SATA --port 0 --device 0 \
        --type hdd --medium "$vm_dirname/${machine_name}.vdi"

    # create hostfile.csv if it doesn't exist
    test -f hostfile.csv || \
        echo "Name,Appliance,Rack,Rank,IP,MAC,Interface,Network,Default" > hostfile.csv

    # append this host
    echo "Created new backend VM:"
    echo "$machine_name,backend,0,$machine_id,10.168.42.15$machine_id,$machine_mac,eth0,private,True" | tee -a hostfile.csv
}

if [[ ! $1 =~ ^[0-9]+ ]]; then
    usage
fi

# create the vm
create_vm $1
