###############################################
#
# KubOS Telemetry Service
#
###############################################
KUBOS_TELEMETRY_VERSION = master
KUBOS_TELEMETRY_LICENSE = Apache-2.0
KUBOS_TELEMETRY_LICENSE_FILES = LICENSE
KUBOS_TELEMETRY_SITE = git://github.com/kubostech/kubos-linux-telemetry

PATH := "$(PATH):/usr/bin/iobc_toolchain/usr/bin"

#This section is required to fix some bugs currently present in the Kubos CLI.  Once
#the bug is fixed, this can be removed.
define KUBOS_TELEMETRY_CONFIGURE_CMDS
	cd $(HOME)/.kubos/kubos/targets/target-kubos-linux-isis-gcc; kubos link-target
	cd $(HOME)/.kubos/kubos/targets/target-kubos-gcc; kubos link-target
	cd $(@D); kubos link-target kubos-linux-isis-gcc; kubos link-target kubos-gcc
	#cd $(HOME)/git/kubos/telemetry; kubos link
	#cd $(HOME)/git/kubos/telemetry-aggregator; kubos link
	#cd $(HOME)/git/kubos/ipc; kubos link
	#cd $(@D); kubos link telemetry; kubos link telemetry-aggregator; kubos link ipc
	
endef

#Use the Kubos SDK to build the telemetry application
define KUBOS_TELEMETRY_BUILD_CMDS
	@echo "Building telemetry with Kubos SDK"
	cd $(@D); kubos target kubos-linux-isis-gcc; kubos build
endef

#Install the application into the rootfs file system
define KUBOS_TELEMETRY_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/bin
	#cp -dpf $(@D)/build/kubos-linux-isis-gcc/source/kubos-telemetry $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/build/kubos-linux-isis-gcc/source/kubos-telemetry $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
