###############################################
#
# Kubos Monitor Service
#
###############################################

KUBOS_MONITOR_POST_BUILD_HOOKS += MONITOR_BUILD_CMDS
KUBOS_MONITOR_INSTALL_STAGING = YES
KUBOS_MONITOR_POST_INSTALL_STAGING_HOOKS += MONITOR_INSTALL_STAGING_CMDS
KUBOS_MONITOR_POST_INSTALL_TARGET_HOOKS += MONITOR_INSTALL_TARGET_CMDS
KUBOS_MONITOR_POST_INSTALL_TARGET_HOOKS += MONITOR_INSTALL_INIT_SYSV

define MONITOR_BUILD_CMDS
	cd $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/services/monitor-service && \
	PATH=$(PATH):~/.cargo/bin:/usr/bin/iobc_toolchain/usr/bin && \
	CC=$(TARGET_CC) cargo build --package monitor-service --target $(CARGO_TARGET) --release
endef

# Generate the config settings for the service and add them to a fragment file
define MONITOR_INSTALL_STAGING_CMDS
	echo '[monitor-service.addr]' > $(KUBOS_CONFIG_FRAGMENT_DIR)/monitor-service
	echo 'ip = ${BR2_KUBOS_MONITOR_IP}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/monitor-service
	echo -e 'port = ${BR2_KUBOS_MONITOR_PORT}\n' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/monitor-service
endef

# Install the application into the rootfs file system
define MONITOR_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
	PATH=$(PATH):~/.cargo/bin:$(HOST_DIR)/usr/bin && \
	arm-linux-strip $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/$(CARGO_OUTPUT_DIR)/monitor-service
	$(INSTALL) -D -m 0755 $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/$(CARGO_OUTPUT_DIR)/monitor-service \
		$(TARGET_DIR)/usr/sbin
				
	echo 'CHECK PROCESS kubos-monitor PIDFILE /var/run/monitor-service.pid' > $(TARGET_DIR)/etc/monit.d/kubos-monitor.cfg
	echo '	START PROGRAM = "/etc/init.d/S${BR2_KUBOS_MONITOR_INIT_LVL}kubos-monitor start"' >> $(TARGET_DIR)/etc/monit.d/kubos-monitor.cfg 
	echo '	IF ${BR2_KUBOS_MONITOR_RESTART_COUNT} RESTART WITHIN ${BR2_KUBOS_MONITOR_RESTART_CYCLES} CYCLES THEN TIMEOUT' \
	>> $(TARGET_DIR)/etc/monit.d/kubos-monitor.cfg 
endef

# Install the init script
define MONITOR_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-monitor/kubos-monitor \
		$(TARGET_DIR)/etc/init.d/S$(BR2_KUBOS_MONITOR_INIT_LVL)kubos-monitor
endef

$(eval $(virtual-package))