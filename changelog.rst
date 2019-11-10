Kubos Linux Changelog
=====================

v1.19 - Oct 30 2019
-------------------

- `Added Scheduler Service package <https://docs.kubos.com/1.19.0/ecosystem/services/scheduler.html>`__
    - **note**: The scheduler service is currently not included in Kubos Linux builds for the iOBC.
- `Migrated to new default service ports <https://docs.kubos.com/master/1.19.0/ecosystem/services/service-dev.html#service-configuration>`__
- Added partition verification for BBB/MBM2 when no SD card is present
- Updated release testing script

v1.18 - Sept 13 2019
--------------------

- `Improving OS recovery logic <https://docs.kubos.com/1.18.0/ecosystem/linux-docs/kubos-linux-recovery.html>`__
- Adding device tree file to base upgrade image for BBB and MBM2 targets

Bug Fixes
~~~~~~~~~

- Increasing iOBC rootfs size to allow room for Monit and Dropbear temporary files

v1.17 - Aug 15 2019
-------------------

- Updated Rust-based packages to ensure only requested package is built

**Note:** This release is being generated primarily to pick up changes in the `KubOS core services <https://docs.kubos.com/1.16.0/changelog.html#v1-17-0-aug-15-2019>`__

v1.16 - July 10 2019
--------------------

- `Set up release image auto-generation for the iOBC <https://github.com/kubos/kubos-linux-build/blob/master/board/kubos/at91sam9g20isis/post-image.sh>`__
- Updated the way OS upgrade files are generated to reduce the RAM overhead for system upgrade/recovery

Bug Fixes
~~~~~~~~~

- Updated all build helper scripts to use latest Buildroot and U-Boot versions
- Restricted the iOBC rootfs size to 20M to prevent memory overflow when doing system upgrade/recovery

v1.15 - May 23 2019
-------------------

- Migrated to lastest Buildroot LTS release, 2019.02.2
- `Added useful Python libraries to default BBB and MBM2 configs (mostly related to peripheral interaction) <https://github.com/kubos/kubos-linux-build/blob/master/configs/beaglebone-black_defconfig>`__
- `Added package for NSL EyeStar-D2 Duplex radio comms service <https://github.com/kubos/kubos-linux-build/tree/master/package/kubos/kubos-nsl-duplex>`__

v1.14 - Apr 3 2019
------------------

- `Added a progress bar to the OS install script for BBB and MBM2 <https://docs.kubos.com/latest/installation-docs/installing-linux-bbb.html#flash-the-emmc>`__
- Added the Kubos service Python library to the default MBM2 and BBB configurations
- Added ``PKG_CONFIG_ALLOW_CROSS=1`` to app service Makefile

Bug Fixes
~~~~~~~~~

- Updated the ``BR2_TAR_OPTIONS`` setting so that builds won't fail in CI

v1.13 - Feb 15 2019
-------------------

- Added ``curl`` to all configurations to support HTTP communication with Kubos services
- Added Python Flask-GraphQL package to support HTTP operations for Python-based Kubos services
- Updated default configuration in response to removal of yotta from main kubos repo
- Removed ``kubos link`` operation from main Kubos package Makefile

v1.12 - Feb 1 2019
------------------

- Updated all configurations and packages to use Python3

Bug Fixes
~~~~~~~~~

- Corrected Monit's log rotation script

v1.11 - Jan 21 2019
-------------------

- `Updated the default log rotation policies <https://github.com/kubos/kubos-linux-build/blob/master/common/overlay/etc/rsyslog.conf#L31>`__
- Updated the default logging policies to place all logs in the ``/home/system/log`` folder

v1.10 - Dec 20 2018
-------------------

- `Added process monitoring support to all boards <https://docs.kubos.com/latest/os-docs/monitoring.html>`__
- `Added an installation script to make eMMC installation more streamlined for BBB and MBM2 targets <https://docs.kubos.com/latest/installation-docs/installing-linux-bbb.html#flash-the-emmc>`__
- `Updated the default logging template to include message severity <https://github.com/kubos/kubos-linux-build/blob/master/common/overlay/etc/rsyslog.conf#L31>`__
- Updated all boards to run `fsck` against all mounted, writeable partitions at boot time
- Moved the U-Boot environment variables to be located in their own partition

v1.9 - Dec 6 2018
-----------------

- Added `rsyslog <https://www.rsyslog.com/>`__ logging support to all boards
- `Added SLIP support to all boards <https://docs.kubos.com/latest/os-docs/using-kubos-linux.html#slip>`__

v1.8 - Nov 9 2018
-----------------

- `Added package for Pumpkin MCU API <https://github.com/kubos/kubos-linux-build/tree/master/package/kubos/kubos-pumpkin-mcu-api>`__
- `Added package for shell service in Rust <https://github.com/kubos/kubos-linux-build/tree/master/package/kubos/kubos-core/kubos-core-shell>`__
- Removing remaining Kubos Core Lua components
- `Added support for the Pumpkin MBM2's RTC chip <https://docs.kubos.com/latest/os-docs/working-with-the-mbm2.html#rtc>`__
- `Added a release candidate test to more easily verify new KubOS releases <https://github.com/kubos/kubos-linux-build/tree/master/tools/release-test>`__

Bug Fixes
~~~~~~~~~

- `Updating the default file transfer service storage directory <https://github.com/kubos/kubos-linux-build/blob/master/common/overlay/home/system/etc/config.toml>`__


v1.7 - Oct 12 2018
------------------

- `Added config info for the file transfer service to the default config.toml file <https://github.com/kubos/kubos-linux-build/blob/master/common/overlay/home/system/etc/config.toml>`__
- `Added package for monitor service <https://github.com/kubos/kubos-linux-build/tree/master/package/kubos/kubos-monitor>`__
- `Added package for Python app API <https://github.com/kubos/kubos-linux-build/tree/master/package/kubos/kubos-app-api>`__
- `Added package for Python I2C HAL <https://github.com/kubos/kubos-linux-build/tree/master/package/kubos/kubos-hal-i2c>`__
- `Added package for Python service library <https://github.com/kubos/kubos-linux-build/tree/master/package/kubos/kubos-service-lib>`__

v1.6 - Sept 28 2018
-------------------

- `Added a community Trello board for contributors and KubOS team members <https://trello.com/b/pIWxmFua/kubos-community>`__
- `Added telemetry database service's direct UDP port configuration to the default config.toml file <https://github.com/kubos/kubos-linux-build/blob/master/common/overlay/home/system/etc/config.toml>`__
- Added ``CC`` envar to all Rust package makefiles
- `Added package for file transfer service in Rust <https://github.com/kubos/kubos-linux-build/tree/master/package/kubos/kubos-core/kubos-core-file-transfer>`__
- Updated applications service init script to trigger the OnBoot logic of all applications

v1.4 - July 23 2018
-------------------

- Added ``nc`` command to all configurations
- `Added package for ISIS Antenna Systems service <https://github.com/kubos/kubos-linux-build/tree/master/package/kubos/kubos-isis-ants>`__
- `Added package for mission applications service <https://github.com/kubos/kubos-linux-build/tree/master/package/kubos/kubos-core/kubos-core-app-service>`__
- `Added automatic auxiliary SD image generation to BBB and MBM2 build processes <https://github.com/kubos/kubos-linux-build/blob/master/board/kubos/beaglebone-black/genimage.cfg>`__
- `Upgraded CircleCI automation config to use the 2.0 configuration format <https://github.com/kubos/kubos-linux-build/blob/master/.circleci/config.yml>`__



v1.3 - Jun 21 2018
------------------

- `Added packages for Kubos core services <https://github.com/kubos/kubos-linux-build/tree/master/package/kubos/kubos-core>`__
- `Added package for Pumpkin MBM2 WDT <https://github.com/kubos/kubos-linux-build/tree/master/package/kubos/kubos-pumpkin-wdt>`__
- `Added package for Pumpkin MCU service <https://github.com/kubos/kubos-linux-build/tree/master/package/kubos/kubos-pumpkin-mcu>`__
- `Added package for ClydeSpace 3G EPS service <https://github.com/kubos/kubos-linux-build/tree/master/package/kubos/kubos-clyde-3g-eps>`__
- `Added package for NovAtel OEM6 service <https://github.com/kubos/kubos-linux-build/tree/master/package/kubos/kubos-novatel-oem6>`__
- `Added package for Adcole Maryland Aerospace MAI-400 service <https://github.com/kubos/kubos-linux-build/tree/master/package/kubos/kubos-mai400>`__
- `Added default config.toml file to system overlay <https://github.com/kubos/kubos-linux-build/blob/master/common/overlay/home/system/etc/config.toml>`__
- `Upgraded Python packages to support Graphene v2.1.1 <https://github.com/kubos/kubos-linux-build/tree/master/package/python>`__
- Upgraded Vagrant and Docker images to use `Rust 1.26 <https://blog.rust-lang.org/2018/05/10/Rust-1.26.html>`__

Bug Fixes
~~~~~~~~~

- Spelled 'package' correctly to properly include setuptools


v1.2 - Feb 26 2018
------------------

- Adding support for iOBC PWM pins
- Adding support for iOBC ADC pins
- Updating BBB/MBM2 image creation to add disk signatures
- Updating BBB/MBM2 Linux boot logic to mount system partitions by PARTUUID
- Updating BBB/MBM2 U-Boot to dynamically select the rootfs partition based on available devices
- Updating all U-Boot configurations to enable hush parser CLI support

Bug Fixes:
~~~~~~~~~~

- BBB/MBM2 can now successfully boot into Linux without a microSD card present
- iOBC won't get stuck in reboot loop anymore if no SD card is present

v1.1 - Jan 19 2018
------------------

- Migrating to BuildRoot LTS v2017.02.8
- Adding support for Python
- Adding Python packages in order to support SQLite and GraphQL
- Expanding the rootfs and upgrade parititions to handle the new space requirements of Python
- Adding support for iOBC SPI bus 1
- Improving the CircleCI automated testing
- Removing deprecated Kubos packages
- Changing product name from "KubOS Linux" to "Kubos Linux"

Community Contributions:
~~~~~~~~~~~~~~~~~~~~~~~~
- Fixing discrepancies between BBB and MBM2 configurations
- Changing the default IP address for BBB and MBM2 targets
- Improving tools scripts' formatting and code

v1.0.2 - Oct 5 2017
-------------------

- Enabling ISIS-OBC daughterboard UART ports
- Adding ethernet support for Beaglebone Black and Pumpkin MBM2
- Adding SSH (Dropbear) support for Beaglebone Black and Pumpkin MBM2

v1.0.1 - Aug 4 2017
-------------------

- Updating repo to be portable between supported boards
- Adding initial support for Beaglebone Black
- Adding initial support for Pumpkin MBM2

v1.0.0 - June 27 2017
---------------------

- Creating KubOS Linux for the ISIS-OBC
- Creating Kubos Telemetry package
- Creating Kubos Command and Control package
