# Vagrant

This directory contains files for use with Vagrant, including the source code for the Cumulus Linux guest plugin, an example Vagrantfile and some demonstrations of using Cumulus VX with Vagrant.

## Files

### Vagrantfile

An example Vagrantfile for use with the Vagrant box file produced by Packer.

#### vagrant-cumulus

The source for the Cumulus specific Vagrant guest plugin.

### demos

Complete examples of using Cumulus VX with Vagrant and Ansible to create and configure multi-VM OSPF, BGP, and MLAG topologies.

## Dependencies

* [VirtualBox](https://www.virtualbox.org/)
* Enough memory to create multiple virtual machines.

## Installing the vagrant-cumulus plugin

In order to use Vagrant with all of its available features, you will need to install the Cumulus guest plugin. Run `vagrant plugin install vagrant-cumulus` to install the officially released plugin.

## Building the vagrant-cumulus plugin

If you prefer to build the plugin yourself:

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

Alternatively you can run `vagrant up` in one of the demo directories: 

```
$ cd vagrant/demos/clos-ospf/
$ vagrant up
```
---

![Cumulus icon](http://cumulusnetworks.com/static/cumulus/img/logo_2014.png)

### Cumulus Linux

Cumulus Linux is a software distribution that runs on top of industry standard
networking hardware. It enables the latest Linux applications and automation
tools on networking gear while delivering new levels of innovation and
ﬂexibility to the data center.

For further details please see: [cumulusnetworks.com](http://www.cumulusnetworks.com)