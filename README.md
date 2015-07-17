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

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
* Author:: Cumulus Networks Inc.

* Copyright:: 2015 Cumulus Networks Inc.

Licensed under the MIT License.

---

![Cumulus icon](http://cumulusnetworks.com/static/cumulus/img/logo_2014.png)

### Cumulus Linux

Cumulus Linux is a software distribution that runs on top of industry standard
networking hardware. It enables the latest Linux applications and automation
tools on networking gear while delivering new levels of innovation and
ﬂexibility to the data center.

For further details please see: [cumulusnetworks.com](http://www.cumulusnetworks.com)