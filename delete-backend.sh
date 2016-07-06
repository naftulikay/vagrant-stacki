#!/bin/bash

set -e

function usage() {
    echo "Usage: $0 machine_id"
    echo
    echo "Deletes a Stacki backend machine and its storage devices."
    echo
    echo "    machine_id    Numeric ID of machine to delete."
    echo
    exit 1
}

function delete_vm() {
    machine_id="$1"
    machine_name="stacki-backend-$machine_id"

    # sanity check
    if ! VBoxManage list vms | grep "$machine_name" &>/dev/null ; then
        echo "ERROR: Machine '$machine_name' does not exist." >&2
        exit 1
    fi

    machine_uuid="$(VBoxManage showvminfo "$machine_name" --machinereadable | \
        sed -n -E "s/UUID=\"(.*)\"/\1/p")"
    machine_state="$(VBoxManage showvminfo "$machine_uuid" --machinereadable | \
        sed -n -E "s/VMState=\"(.*)\"/\1/p")"

    # delete the previous host from the file
    test -f hostfile.csv && \
        sed -i "/^$machine_name.*\$/d" hostfile.csv

    # if it's running, stop it
    if [[ "$machine_state" == "running" ]]; then
        VBoxManage controlvm "$machine_uuid" poweroff
    fi

    # delete the VM
    VBoxManage unregistervm "$machine_uuid" --delete
}

if [[ ! $1 =~ ^[0-9]+ ]]; then
    usage
fi

delete_vm "$1"
