###############################################
#
# Kubos Telemetry Database Service
#
###############################################

KUBOS_CORE_TELEMETRY_DB_POST_BUILD_HOOKS += TELEMETRY_DB_BUILD_CMDS
KUBOS_CORE_TELEMETRY_DB_INSTALL_STAGING = YES
KUBOS_CORE_TELEMETRY_DB_POST_INSTALL_STAGING_HOOKS += TELEMETRY_DB_INSTALL_STAGING_CMDS
KUBOS_CORE_TELEMETRY_DB_POST_INSTALL_TARGET_HOOKS += TELEMETRY_DB_INSTALL_TARGET_CMDS
KUBOS_CORE_TELEMETRY_DB_POST_INSTALL_TARGET_HOOKS += TELEMETRY_DB_INSTALL_INIT_SYSV

define TELEMETRY_DB_BUILD_CMDS
	cd $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/services/telemetry-service && \
	PATH=$(PATH):~/.cargo/bin && \
	CC=$(TARGET_CC) cargo build --package telemetry-service --target $(CARGO_TARGET) --release
endef

# Generate the config settings for the service and add them to a fragment file
define TELEMETRY_DB_INSTALL_STAGING_CMDS
	echo '[telemetry-service.addr]' > $(KUBOS_CONFIG_FRAGMENT_DIR)/telemetry-service
	echo 'ip = ${BR2_KUBOS_CORE_TELEMETRY_DB_IP}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/telemetry-service
	echo -e 'port = ${BR2_KUBOS_CORE_TELEMETRY_DB_PORT}\n' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/telemetry-service
	echo '[telemetry-service]' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/telemetry-service
	echo 'database = ${BR2_KUBOS_CORE_TELEMETRY_DB_DATABASE}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/telemetry-service
	echo -e 'direct_port = ${BR2_KUBOS_CORE_TELEMETRY_DB_DIRECT_PORT}\n' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/telemetry-service
endef

# Install the application into the rootfs file system
define TELEMETRY_DB_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
	PATH=$(PATH):~/.cargo/bin:$(HOST_DIR)/usr/bin && \
	arm-linux-strip $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/$(CARGO_OUTPUT_DIR)/telemetry-service
	$(INSTALL) -D -m 0755 $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/$(CARGO_OUTPUT_DIR)/telemetry-service \
		$(TARGET_DIR)/usr/sbin
		
	echo 'CHECK PROCESS kubos-telemetry-db PIDFILE /var/run/telemetry-service.pid' > $(TARGET_DIR)/etc/monit.d/kubos-telemetry-db.cfg
	echo '	START PROGRAM = "/etc/init.d/S${BR2_KUBOS_CORE_TELEMETRY_DB_INIT_LVL}kubos-core-telemetry-db start"' >> $(TARGET_DIR)/etc/monit.d/kubos-telemetry-db.cfg 
	echo '	IF ${BR2_KUBOS_CORE_TELEMETRY_DB_RESTART_COUNT} RESTART WITHIN ${BR2_KUBOS_CORE_TELEMETRY_DB_RESTART_CYCLES} CYCLES THEN TIMEOUT' \
	>> $(TARGET_DIR)/etc/monit.d/kubos-telemetry-db.cfg  
endef

# Install the init script
define TELEMETRY_DB_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-core/kubos-core-telemetry-db/kubos-core-telemetry-db \
		$(TARGET_DIR)/etc/init.d/S$(BR2_KUBOS_CORE_TELEMETRY_DB_INIT_LVL)kubos-core-telemetry-db
endef

kubos-core-telemetry-db-cargoclean: kubos-core-telemetry-db-dirclean
	cd $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/services/telemetry-service && \
	PATH=$(PATH):~/.cargo/bin && \
	cargo clean

$(eval $(virtual-package))
