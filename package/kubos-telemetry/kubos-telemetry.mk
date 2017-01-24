###############################################
#
# KubOS Telemetry Service
#
###############################################
KUBOS_TELEMETRY_VERSION = master
KUBOS_TELEMETRY_LICENSE = Apache-2.0
KUBOS_TELEMETRY_LICENSE_FILES = LICENSE
KUBOS_TELEMETRY_SITE = git://github.com/kubostech/kubos-linux-telemetry

#Use the Kubos SDK to build the telemetry application
define KUBOS_TELEMETRY_BUILD_CMDS
	export PATH=$(PATH):/usr/bin/iobc_toolchain/usr/bin; cd $(@D); kubos target kubos-linux-isis-gcc; kubos build
endef

#Install the application into the rootfs file system
define KUBOS_TELEMETRY_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
	$(INSTALL) -D -m 0755 $(@D)/build/kubos-linux-isis-gcc/source/kubos-telemetry $(TARGET_DIR)/usr/sbin
endef

kubos-telemetry-fullclean: kubos-telemetry-clean-for-reconfigure
	rm -f $(BUILD_DIR)/kubos-telemetry-master/.stamp_downloaded
	rm -f $(DL_DIR)/kubos-telemetry-master.tar.gz
	kubos-telemetry-dirclean

kubos-telemetry-clean: kubos-telemetry-clean-for-rebuild
	cd $(BUILD_DIR)/kubos-telemetry-master; kubos clean

$(eval $(generic-package))
