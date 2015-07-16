#!/bin/bash

function usage
{
  echo "$0: -o [OVA file] -v [VERSION] [-p|-c] [-t TYPE]" >&2
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
INSTALL_PUPPET=0
INSTALL_CHEF=0
SETUP_ARGS=""
BOX_SUFFIX=""
TYPE="none"
PACKER_CONFIG="cumulus-vbox.json"

# Parse options
while getopts "o:v:pct:h" OPT
do
  case $OPT in
    o)
      OVA=$OPTARG
      ;;
    v)
      VERSION=$OPTARG
      ;;
    p)
      INSTALL_PUPPET=1
      ;;
    c)
      INSTALL_CHEF=1
      ;;
    t)
      TYPE=$OPTARG
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

if [ $INSTALL_PUPPET -eq 1 ]
then
  SETUP_ARGS="${SETUP_ARGS} -p"
  BOX_SUFFIX="${BOX_SUFFIX}-puppet"
elif [ $INSTALL_CHEF -eq 1 ]
then
  SETUP_ARGS="${SETUP_ARGS} -c"
  BOX_SUFFIX="${BOX_SUFFIX}-chef"
fi

# Allow users to specify a special "type" of box I.e. a 2s leaf, a 2lt22s
# spine; this changes how the NICs are re-mapped within the VM. Default is
# "none" with always performs the "simple" remap method.
if [ "$TYPE" != "none" ]
then
  case $TYPE in
    "2s")
      PACKER_CONFIG="cumulus-vbox-ceng.json"
      ;;
    *)
      echo "Invalid type $TYPE"
      ;;
  esac
  BOX_SUFFIX="${BOX_SUFFIX}-${TYPE}"
fi

packer build -var "source=$OVA" \
             -var "version=$VERSION" \
             -var "suffix=$BOX_SUFFIX" \
             -var "setup_args=$SETUP_ARGS" \
             -var "netmap=$TYPE" \
             $PACKER_CONFIG
