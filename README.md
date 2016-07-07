# vagrant-stacki

Vagrant demo of a [Stacki][stacki] frontend and backend running Vagrant and plain 'ol VirtualBox.

## Getting Started

Bringing up the frontend with `vagrant up` will give you a Stacki frontend. You'll need the `rfkrocktk/stacki-3.2-7.x`
Vagrant box to start the Stacki server, which can be built following the instructions in the
[vagrant-boxes][vagrant-boxes] repository.

Backend VMs can be created and destroyed with the `./create-backend.sh` and `./destroy-backend.sh` scripts:

```
# from your host OS
$ ./create-backend.sh 1
Virtual machine 'stacki-backend-1' is created and registered.
UUID: c9682f33-d456-4281-92a2-9cf10ef2f170
Settings file: '/home/naftuli/VirtualBox VMs/stacki-backend-1/stacki-backend-1.vbox'
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
Medium created. UUID: d4c8f56a-4264-4628-9a1c-ac6b93321b8c
Created new backend VM:
stacki-backend-1,backend,0,1,10.168.42.151,08:00:27:68:73:71,eth0,private,True
```

A new backend VM with default settings has been created and attached to the proper network with storage. The VM won't
be automatically started.

Now, from within the Vagrant frontend box, the `hostfile.csv` file should be imported and machine settings should be
configured:

```
vagrant@stackifrontend /vagrant $ sudo /opt/stack/bin/stack \
    set host boot stacki-backend-1 action=install
vagrant@stackifrontend /vagrant $ sudo /opt/stack/bin/stack \
    set host attr stack-backend-1 attr=nukedisks value=true
```

Now that the VM has been created and the Stack frontend has been informed of its MAC address, start the machine from
VirtualBox either using the UI or with:

```
$ VBoxManage controlvm stacki-backend-1 start
```

A GUI should pop up, the machine should DHCP to the Stacki frontend, and should begin installing.

When you're done with the VM, it can be destroyed using the `./destroy-backend.sh` script:

```
$ ./destroy-backend.sh 1
```

 [stacki]: http://www.stacki.com
 [vagrant-boxes]: https://github.com/rfkrocktk/vagrant-boxes
