Kubos Linux Changelog
=====================

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
