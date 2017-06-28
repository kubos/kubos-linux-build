###############################################
#
# KubOS Telemetry Service
#
###############################################
KUBOS_TELEMETRY_VERSION = $(call qstrip,$(BR2_KUBOS_VERSION))
KUBOS_TELEMETRY_LICENSE = Apache-2.0
KUBOS_TELEMETRY_LICENSE_FILES = LICENSE
#KUBOS_TELEMETRY_SOURCE = linux-telemetry-service
KUBOS_TELEMETRY_SITE = $(BUILD_DIR)/kubos-$(KUBOS_TELEMETRY_VERSION)/linux-telemetry-service
KUBOS_TELEMETRY_SITE_METHOD = local
KUBOS_TELEMETRY_DEPENDENCIES = kubos
# The path from the telemetry module to the build artifact directory
KUBOS_ARTIFACT_BUILD_PATH = build/kubos-linux-isis-gcc/source


#Use the Kubos SDK to build the telemetry application
define KUBOS_TELEMETRY_BUILD_CMDS
	cd $(@D) && \
	kubos link -a && \
	PATH=$(PATH):/usr/bin/iobc_toolchain/usr/bin && \
	kubos -t kubos-linux-isis-gcc build
endef

#Install the application into the rootfs file system
define KUBOS_TELEMETRY_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
	$(INSTALL) -D -m 0755 $(@D)/$(KUBOS_ARTIFACT_BUILD_PATH)/linux-telemetry-service \
		$(TARGET_DIR)/usr/sbin
endef

#Install the init script
define KUBOS_TELEMETRY_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-telemetry/kubos-telemetry \
	    $(TARGET_DIR)/etc/init.d/S$(BR2_KUBOS_TELEMETRY_INIT_LVL)kubos-telemetry
endef

kubos-telemetry-fullclean: kubos-telemetry-clean kubos-telemetry-clean-for-reconfigure kubos-telemetry-dirclean
	rm -f $(BUILD_DIR)/kubos-telemetry-$(KUBOS_TELEMETRY_VERSION)/.stamp_downloaded
	rm -f $(DL_DIR)/kubos-telemetry-$(KUBOS_TELEMETRY_VERSION).tar.gz


kubos-telemetry-clean: kubos-telemetry-clean-for-rebuild
	cd $(BUILD_DIR)/kubos-telemetry-$(KUBOS_TELEMETRY_VERSION); kubos clean
	cd $(TARGET_DIR)/etc/init.d; rm -f S*kubos-telemetry

$(eval $(generic-package))
