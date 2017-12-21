# KubOS Linux

## Overview

Kubos uses BuildRoot as its main Linux build tool.  This repo contains the configuration and patch files required by BuildRoot to build
Linux for each of the OBCs that Kubos supports.

## Files and folders

### external.desc

This file contains the name and description for the kubos-linux-build folder.  BuildRoot will use it to create a link between the 
main BuildRoot folder and the kubos-linux-build folder.

### external.mk

Currently (intentionally) empty.  This file is required by BuildRoot when creating the external link to the kubos-linux-build folder,
but no content is actually required.

### Config.in

Currently empty.  Same as the external.mk file, BuildRoot requires that this file exist, but not that it have any content.

### board/kubos/{board}

Inside of each of these folders are the patches and configuration files for each of the components required to build Linux for
a particular board.

### configs

This folder contains the BuildRoot configuration files needed to build each OBC supported by Kubos.

## Installation

Create new folder

    $ mkdir kubos-linux

Enter the new folder

    $ cd kubos-linux
  
Download BuildRoot-2017.02 (more current versions of BuildRoot may work as well,
but all testing has been done against 2017.02)

.. note:: All Kubos documentation will refer to v2017.02.8, which is the latest version of the LTS release at the time of this writing.

    $ wget https://buildroot.uclibc.org/downloads/buildroot-2017.02.8.tar.gz && tar xvzf buildroot-2017.02.8.tar.gz && rm buildroot-2017.02.8.tar.gz
  
Pull the kubos-linux-build repo

    $ git clone http://github.com/kubostech/kubos-linux-build
  
Move into the buildroot directory

    $ cd buildroot-2017.02.8
  
Point BuildRoot to the external kubos-linux-build folder and tell it which configuration you want to run (config files are located in
kubos-linux-build/configs)

    $ make BR2_EXTERNAL=../kubos-linux-build {board}_defconfig
  
Build everything

    $ make
  
The full build process will take a while.  Running on a Linux VM, it took about an hour.  Running in native Linux, it took about
twenty minutes.  Once this build process has completed once, you can run other BuildRoot commands to rebuild only certain sections
and it will go much more quickly (<5 min).

BuildRoot documentation can be found [**here**](https://buildroot.org/docs.html)

The generated files will be located in buildroot-2017.02.8/output/images.  They are:

- uboot.bin   - The U-Boot binary
- zImage      - The compressed Linux kernel file
- {board}.dtb - The Device Tree Binary that Linux uses to configure itself for your board
- rootfs.tar  - The root file system.  Contains BusyBox and other libraries
  

