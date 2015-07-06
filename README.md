# ceng-packer-vagrant
Packer &amp; Vagrant configuration for building Vagrant boxes from Cumulus VM Lite OVA file

[Packer](https://www.packer.io/) is a popular tool for modifying and provisioning virtual machines, particularly virtual machine images intended for use with [Vagrant](https://www.vagrantup.com/).

Vagrant is a lightweight virtual machine abstraction layer that can create, provision and manage virtual machines across platforms and hypervisors.

## Files

There are three files in this repository:

### packer/cumulus.json

The Packer build configuration. Contains the information Packer needs to produce the Vagrant box file(s) from the OVA.

### scripts/setup.sh

Invoked during the Packer build process during the provisioning step. This script runs *inside* of the virtual machine as it is being built.

### vagrant/Vagrantfile

An example Vagrantfile for use with the Vagrant box file produced by Packer.

## Dependencies

* [VirtualBox](https://www.virtualbox.org/)
* [Packer](https://www.packer.io/)
* Enough disk space for both the OVA and the box file, and enough memory to create 1GB virtual machine.

## Building a Vagrant box file

* Place the Cumulux VX 2.5.3 OVA image in the same directory as this README. Name the file `CumulusLinux-2.5.3.ova`
* Run Packer with `packer build packer/cumulus.json`
* Packer will produce a Vagrant "box" file named `cumulus-vx-2.5.3.box`

Currently the configuration is hard-coded into the Packer configuration and setup script. If you wish to make any changes to the build process, modify the `packer/cumulus.json` and `scripts/setup.sh` files and re-run the build process.

## Pre-installed software

Vagrant can be combined with other software such as Test Kitchen or Beaker to test Ansible, Puppet & Chef configuration management scripts. The installation script is therefore capable of pre-installing software when it builds the Vagrant virtual machine. This is particularly important as software such as Test Kitchen will attempt to install Chef automatically if it is not already available, which fails as the default installer does not know how to install Chef on Cumulus.

Right now there is no mechanism to select what software to install at build time; you must edit `scripts/setup.sh` manually and re-run Packer to produce a new box with the software pre-installed. You can then import the new box file with a different name which distinguishes it from the other boxes, and indicates what software is installed.

The Vagrant box naming scheme is as follows:

* cumulus-vx-2.5.3        - "Standard" Cumulus VX box file with no additional software (E.g. Ansible, Puppet or Chef) pre-installed
* cumulus-vx-2.5.3-chef   - Cumulus VX with Chef pre-installed
* cumulus-vx-2.5.3-puppet - Cumulus VX with Puppet pre-installed

## Using the Vagrant box file

* Import the `cumulus-vx-2.5.3.box` into Vagrant with `vagrant box add cumulux-vx cumulus-vx-2.5.3.box`
* Copy (or symlink) the `vagrant/Vagrantfile` file to a working directory and run `vagrant up`
* When Vagrant has started the virtual machine, you can log in with `vagrant ssh`.
* When you are finished, you can destroy the virtual machine instance with `vagrant destroy`

## Example
```
$ ls -l
total 1043672
-rw-r--r--  1 kristian  staff  534353920 22 Jun 13:14 CumulusLinux-2.5.3.ova
-rw-r--r--  1 kristian  staff       2045  1 Jul 11:17 README.md
drwxr-xr-x  3 kristian  staff        102  1 Jul 11:04 packer
drwxr-xr-x  3 kristian  staff        102  1 Jul 10:56 scripts
drwxr-xr-x  4 kristian  staff        136  1 Jul 11:10 vagrant
$  packer build packer/cumulus.json
virtualbox-ovf output will be in this color.

==> virtualbox-ovf: Downloading or copying Guest additions
    virtualbox-ovf: Downloading or copying: file:///Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso
==> virtualbox-ovf: Importing VM: CumulusLinux-2.5.3.ova
...
Build 'virtualbox-ovf' finished.

==> Builds finished. The artifacts of successful builds are:
--> virtualbox-ovf: 'virtualbox' provider box: cumulus-vx-2.5.3.box
$ ln -s vagrant/Vagrantfile Vagrantfile
$ ls -l
total 2157160
-rw-r--r--  1 kristian  staff  534353920 22 Jun 13:14 CumulusLinux-2.5.3.ova
-rw-r--r--  1 kristian  staff       2045  1 Jul 11:17 README.md
lrwxr-xr-x  1 kristian  staff         19  1 Jul 11:22 Vagrantfile -> vagrant/Vagrantfile
-rw-r--r--  1 kristian  staff  570099632  1 Jul 11:21 cumulus-vx-2.5.3.box
drwxr-xr-x  3 kristian  staff        102  1 Jul 11:04 packer
drwxr-xr-x  2 kristian  staff         68  1 Jul 11:18 packer_cache
drwxr-xr-x  3 kristian  staff        102  1 Jul 10:56 scripts
drwxr-xr-x  4 kristian  staff        136  1 Jul 11:10 vagrant
$ vagrant box add cumulus-vx cumulus-vx-2.5.3.box
==> box: Adding box 'cumulus-vx' (v0) for provider:
    box: Downloading: file:///Users/kristian/Source/Cumulus-VX/cumulus-vx-2.5.3.box
==> box: Successfully added box 'cumulus-vx' (v0) for 'virtualbox'!
$  vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'cumulus-vx'...
...
``` 
