#!/bin/bash
set -e

# Install any additional network configuration scripts which have been added
# to the VM
function network_setup
{
  for SCRIPT in rename_eth_swp rename_mgmt_intf
  do
    if [ -e /tmp/$SCRIPT ]
    then
      mv /tmp/$SCRIPT /etc/init.d/
      chown root:root /etc/init.d/$SCRIPT
      chmod 0755 /etc/init.d/$SCRIPT
    fi
  done

  if [ -e /tmp/eth_remap ]
  then
    mv /tmp/eth_remap /etc/default/
    chown root:root /etc/default/eth_remap
  fi
}

function install_fake_tools
{
  FAKE_TOOLS=/tmp/fake_tools

  if [ -e $FAKE_TOOLS ]
  then
    if [ -e $FAKE_TOOLS/cl-license ]
    then
      mv $FAKE_TOOLS/cl-license /usr/cumulus/bin
      chown root:root /usr/cumulus/bin/cl-license
      chmod 0755 /usr/cumulus/bin/cl-license
    fi

    for CONF in $FAKE_TOOLS/*.conf
    do
      mv $CONF /etc/cumulus/

      NAME=$(basename $CONF)
      chown root:root /etc/cumulus/$NAME
      chmod 0644 /etc/cumulus/$NAME
    done

    if [ -e $FAKE_TOOLS/switchd ]
    then
      mv $FAKE_TOOLS/switchd /usr/sbin/switchd
      chown root:root /usr/sbin/switchd
      chmod 0755 /usr/sbin/switchd
    fi

    if [ -e $FAKE_TOOLS/switchd_init ]
    then
      mv $FAKE_TOOLS/switchd_init /etc/init.d/switchd
      chown root:root /etc/init.d/switchd
      chmod 0755 /etc/init.d/switchd
    fi
  fi
}

# Defaults
WANT_NETWORK_SETUP=1
WANT_FAKE_TOOLS=1

# Perform configuration
if [ $WANT_NETWORK_SETUP -ne 0 ]
then
  network_setup
fi
if [ $WANT_FAKE_TOOLS -ne 0 ]
then
  install_fake_tools
fi

exit 0
