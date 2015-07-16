# cumulus-vx-vagrant
Packer &amp; Vagrant configuration for building Vagrant boxes from a Cumulus VX OVA file

[Packer](https://www.packer.io/) is a popular tool for modifying and provisioning virtual machines, particularly virtual machine images intended for use with [Vagrant](https://www.vagrantup.com/).

Vagrant is a lightweight virtual machine abstraction layer that can create, provision and manage virtual machines across platforms and hypervisors.

## Files

There are three directories in this repository:

### packer

Contains files for the Packer build process.

### vagrant

Contains files relevent to using Cumulus VX with Vagrant

### test-kitchen

Contains files relevent to using Cumulus VX with Test Kitchen.

## Dependencies

* [VirtualBox](https://www.virtualbox.org/)
* [Packer](https://www.packer.io/)
* Enough disk space for both the OVA and the box file, and enough memory to create 512MB virtual machine.
