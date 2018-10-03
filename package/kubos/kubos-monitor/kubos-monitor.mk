###############################################
#
# Kubos Monitor Service
#
###############################################

KUBOS_MONITOR_POST_BUILD_HOOKS += MONITOR_BUILD_CMDS
KUBOS_MONITOR_POST_INSTALL_TARGET_HOOKS += MONITOR_INSTALL_TARGET_CMDS
KUBOS_MONITOR_POST_INSTALL_TARGET_HOOKS += MONITOR_INSTALL_INIT_SYSV

define MONITOR_BUILD_CMDS
	cd $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/services/monitor-service && \
	PATH=$(PATH):~/.cargo/bin:/usr/bin/iobc_toolchain/usr/bin && \
	CC=$(TARGET_CC) cargo build --target $(CARGO_TARGET) --release
endef

# Install the application into the rootfs file system
define MONITOR_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
	$(INSTALL) -D -m 0755 $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/$(CARGO_OUTPUT_DIR)/monitor-service \
		$(TARGET_DIR)/usr/sbin
endef

# Install the init script
define MONITOR_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-monitor/kubos-monitor \
	    $(TARGET_DIR)/etc/init.d/S$(BR2_KUBOS_MONITOR_INIT_LVL)kubos-monitor
endef

$(eval $(virtual-package))