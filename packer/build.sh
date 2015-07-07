#!/bin/bash

function usage
{
  echo "$0: -o [OVA file] -v [VERSION] (-a|-p|-c)" >&2
  exit 1
}

function error
{
  echo "$1" >&2
  usage
}

# Defaults
OVA=""
VERSION=""
INSTALL_ANSIBLE=0
INSTALL_PUPPET=0
INSTALL_CHEF=0
SETUP_ARGS=""
BOX_SUFFIX=""

# Parse options
while getopts "o:v:apch" OPT
do
  case $OPT in
    o)
      OVA=$OPTARG
      ;;
    v)
      VERSION=$OPTARG
      ;;
    a)
      INSTALL_ANSIBLE=1
      ;;
    p)
      INSTALL_PUPPET=1
      ;;
    c)
      INSTALL_CHEF=1
      ;;
    h|\?)
      usage
      ;;
  esac
done

if [ -z $OVA ]
then
  error "You must specify the OVA image to build from"
fi
if [ -z $VERSION ]
then
  error "You must specify the version that is being built"
fi

# Build up some internal variables based on the flags
BOX_SUFFIX="${VERSION}"

if [ $INSTALL_ANSIBLE -eq 1 ]
then
  SETUP_ARGS="${SETUP_ARGS} -a"
  BOX_SUFFIX="${BOX_SUFFIX}-ansible"
elif [ $INSTALL_PUPPET -eq 1 ]
then
  SETUP_ARGS="${SETUP_ARGS} -p"
  BOX_SUFFIX="${BOX_SUFFIX}-puppet"
elif [ $INSTALL_CHEF -eq 1 ]
then
  SETUP_ARGS="${SETUP_ARGS} -c"
  BOX_SUFFIX="${BOX_SUFFIX}-chef"
fi

packer build -var "source=$OVA" \
             -var "version=$VERSION" \
             -var "suffix=$BOX_SUFFIX" \
             -var "setup_args=$SETUP_ARGS" \
             cumulus-vbox.json

