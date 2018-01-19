Kubos Linux Changelog
=====================

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
