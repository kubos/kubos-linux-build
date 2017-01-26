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
	cd $(@D); PATH=$(PATH):/usr/bin/iobc_toolchain/usr/bin kubos -t kubos-linux-isis-gcc build
endef

#Install the application into the rootfs file system
define KUBOS_TELEMETRY_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
	$(INSTALL) -D -m 0755 $(@D)/build/kubos-linux-isis-gcc/source/kubos-telemetry $(TARGET_DIR)/usr/sbin
endef

#Install the init script
define KUBOS_TELEMETRY_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos-telemetry/S70kubos-telemetry \
	    $(TARGET_DIR)/etc/init.d/S70kubos-telemetry
endef

kubos-telemetry-fullclean: kubos-telemetry-clean-for-reconfigure kubos-telemetry-dirclean
	rm -f $(BUILD_DIR)/kubos-telemetry-master/.stamp_downloaded
	rm -f $(DL_DIR)/kubos-telemetry-master.tar.gz


kubos-telemetry-clean: kubos-telemetry-clean-for-rebuild
	cd $(BUILD_DIR)/kubos-telemetry-master; kubos clean

$(eval $(generic-package))
