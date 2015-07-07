# ceng-packer-vagrant
Packer &amp; Vagrant configuration for building Vagrant boxes from Cumulus VX OVA file

[Packer](https://www.packer.io/) is a popular tool for modifying and provisioning virtual machines, particularly virtual machine images intended for use with [Vagrant](https://www.vagrantup.com/).

Vagrant is a lightweight virtual machine abstraction layer that can create, provision and manage virtual machines across platforms and hypervisors.

## Files

There are three directories in this repository:

### packer

Contains files relevent to the Packer build process.

#### build.sh

Invokes the Packer build process with the correct arguments.

#### cumulus-vbox.json

The Packer build configuration. Contains the information Packer needs to produce the Vagrant box file(s) from the OVA.

#### scripts/setup.sh

Invoked during the Packer build process during the provisioning step. This script runs *inside* of the virtual machine as it is being built.

### vagrant

Contains files relevent to using Cumulus VX with Vagrant

#### Vagrantfile

An example Vagrantfile for use with the Vagrant box file produced by Packer.

##### vagrant-cumulus

The source for the Cumulus specific Vagrant guest plugin.

#### demos

Complete examples of using Cumulus VX with Vagrant and Ansible to create and configure multi-VM OSPF & BGP topologies.

### test-kitchen

Contains files relevent to using Cumulus VX with Test Kitchen.

#### .kitchen.yml

An example Kitchen configuration for use with Vagrant.

## Dependencies

* [VirtualBox](https://www.virtualbox.org/)
* [Packer](https://www.packer.io/)
* Enough disk space for both the OVA and the box file, and enough memory to create 512MB virtual machine.

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

The build process will insert "puppet" or "chef" into the Vagrant box filename as appropriate. The Vagrant box naming scheme is as follows:

* cumulus-vx-2.5.3-vbox        - "Standard" Cumulus VX box file with no additional software (E.g. Puppet or Chef) pre-installed
* cumulus-vx-2.5.3-chef-vbox   - Cumulus VX with Chef pre-installed
* cumulus-vx-2.5.3-puppet-vbox - Cumulus VX with Puppet pre-installed

## Installing the vagrant-cumulus plugin

In order to use Vagrant with all of its available features, you will need to install the Cumulus guest plugin. In order to build and install the plugin:

* Change to the plugin source directory: `$ cd vagrant/vagrant-cumulus`
* Install the build dependencies using `bundle install`
* Build the plugin with `bundle exec rake build`
* Install the resulting Ruby Gem with `vagrant plugin install pkg/vagrant-cumulus-0.1.gem`

If the plugin was built and installed successfully, the `vagrant plugin list` command should show the vagrant-cumulus plugin:

```
$ vagrant plugin list
vagrant-cumulus (0.1)
  - Version Constraint: 0.1
vagrant-share (1.1.3, system)
```

## Using the Vagrant box file

* Import the box file into Vagrant with the `vagrant box add` command. For example, to import a box file with Puppet pre-installed, you would run `vagrant box add cumulux-vx-2.5.3-puppet cumulus-vx-2.5.3-puppet-vbox.box`
* Copy (or symlink) the `vagrant/Vagrantfile` file to a working directory and run `vagrant up`
* When Vagrant has started the virtual machine, you can log in with `vagrant ssh`.
* When you are finished, you can destroy the virtual machine instance with `vagrant destroy`

Alternatively you can run `vagrant up` in one of the directories containing a demo: 

```
$ cd vagrant/demos/clos-ospf/
$ vagrant up
```

## Example
```
$ ls -l
total 16
-rw-r--r--   1 kristian  staff  5818  7 Jul 16:09 README.md
drwxr-xr-x  10 kristian  staff   340  7 Jul 16:10 packer
drwxr-xr-x  10 kristian  staff   340  7 Jul 13:21 test-kitchen
drwxr-xr-x   6 kristian  staff   204  7 Jul 13:18 vagrant
$ cd packer
$ mv ~/CumulusLinux-2.5.3.ova .
$ ls -l
total 1043688
-rw-r--r--  1 kristian  staff  534353920 22 Jun 13:14 CumulusLinux-2.5.3.ova
-rwxr-xr-x  1 kristian  staff       1123  7 Jul 15:31 build.sh
-rw-r--r--  1 kristian  staff       5745  7 Jul 15:32 cumulus-vbox.json
drwxr-xr-x  3 kristian  staff        102  7 Jul 15:30 scripts
$ ./build.sh -o CumulusLinux-2.5.3.ova -v 2.5.3
virtualbox-ovf output will be in this color.

==> virtualbox-ovf: Downloading or copying Guest additions
    virtualbox-ovf: Downloading or copying: file:///Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso
==> virtualbox-ovf: Importing VM: CumulusLinux-2.5.3.ova
...
Build 'virtualbox-ovf' finished.

==> Builds finished. The artifacts of successful builds are:
--> virtualbox-ovf: 'virtualbox' provider box: cumulus-vx-2.5.3-vbox.box
$ vagrant box add cumulus-vx-2.5.3 cumulus-vx-2.5.3-vbox.box
==> box: Adding box 'cumulus-vx-2.5.3' (v0) for provider:
    box: Downloading: file:///Users/kristian/Source/Cumulus-VX/packer/cumulus-vx-2.5.3-vbox.box
==> box: Successfully added box 'cumulus-vx-2.5.3' (v0) for 'virtualbox'!
$ cd ../vagrant/vagrant-cumulus
$ bundle install --path vendor/bundle
Resolving dependencies...
...
Your bundle is complete!
It was installed into ./vendor/bundle
$ bundle exec rake build
vagrant-cumulus 0.1 built to pkg/vagrant-cumulus-0.1.gem.
$ vagrant plugin install pkg/vagrant-cumulus-0.1.gem
Installing the 'pkg/vagrant-cumulus-0.1.gem' plugin. This can take a few minutes...
Installed the plugin 'vagrant-cumulus (0.1)'!
$ cd ..
$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'cumulus-vx-2.5.3'...
...
```
