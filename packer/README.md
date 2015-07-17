# Packer

This directory contains the files for use with Packer to build Vagrant box files from the Cumulus VX OVA image.

## Building a Vagrant box file

* Either place the Cumulux VX OVA image in the `packer` directory, or copy the `packer` directory to a working location and place the Cumulus VX OVA image in it.
* Run `build.sh` to invoke Packer. You must pass the path to the OVA image, and the Cumulus VX version information:

```
$ ./build.sh -o CumulusLinux-2.5.3.ova -v 2.5.3
```
* Packer will produce a Vagrant "box" with a name that indicates the version and any additional software that was installed E.g. `cumulus-vx-2.5.3-vbox.box`

## Pre-installed software

Vagrant can be combined with other software such as Test Kitchen or Beaker to test Ansible, Puppet & Chef configuration management scripts. The installation script is therefore capable of pre-installing software when it builds the Vagrant virtual machine. This is particularly important as software such as Test Kitchen will attempt to install Chef automatically if it is not already available, which fails as the default installer does not know how to install Chef on Cumulus.

You can choose to install either Puppet or Chef using one of the following options to `build.sh`:

* `-p`: Install Puppet
* `-c`: Install Chef

The build process will insert "puppet" or "chef" into the Vagrant box filename as appropriate. For example, to build a box file with Puppet pre-installed:

```
$ ./build.sh -o CumulusLinux-2.5.3.ova -v 2.5.3 -p
```
This will produce a box file called `cumulus-vx-2.5.3-puppet-vbox.box`

The Vagrant box naming scheme is as follows:

* `cumulus-vx-2.5.3-vbox`        - "Standard" Cumulus VX box file with no additional software (E.g. Puppet or Chef) pre-installed
* `cumulus-vx-2.5.3-chef-vbox`   - Cumulus VX with Chef pre-installed
* `cumulus-vx-2.5.3-puppet-vbox` - Cumulus VX with Puppet pre-installed

## Files

### build.sh

Invokes the Packer build process with the correct arguments.

### cumulus-vbox.json

The standard Packer build configuration. Contains the information Packer needs to produce the Vagrant box file(s) from the OVA.

### cumulus-vbox-ceng.json

An extended Packer build configuration which is used to produce a Vagrant box file which can be used to configure more complex configurations, including Vagrant instances which can emulate a Cumulus Workbench.

### scripts/setup.sh

Invoked during the Packer build process during the provisioning step. This script runs *inside* of the virtual machine as it is being built.

### The files directory

Contains various files which can be added to the virtual machine during the Packer build process. These files are largely only relevent to the `cumulus-vbox-ceng.json` Packer configuration.

## Dependencies

* [VirtualBox](https://www.virtualbox.org/)
* [Packer](https://www.packer.io/)
* Enough disk space for both the OVA and the box file, and enough memory to create 512MB virtual machine.

## Using the Vagrant box file

Import the box file into Vagrant with the `vagrant box add` command. For example, to import a box file with Puppet pre-installed, you would run `vagrant box add cumulux-vx-2.5.3-puppet cumulus-vx-2.5.3-puppet-vbox.box`

Once the box file has been imported you can refer to it in your Vagrantfile using the name you imported it under. For example, to use the box imported above:

```
Vagrant.configure(2) do |config|
  config.vm.box = 'cumulux-vx-2.5.3-puppet'
end
```
---

![Cumulus icon](http://cumulusnetworks.com/static/cumulus/img/logo_2014.png)

### Cumulus Linux

Cumulus Linux is a software distribution that runs on top of industry standard
networking hardware. It enables the latest Linux applications and automation
tools on networking gear while delivering new levels of innovation and
ﬂexibility to the data center.

For further details please see: [cumulusnetworks.com](http://www.cumulusnetworks.com)