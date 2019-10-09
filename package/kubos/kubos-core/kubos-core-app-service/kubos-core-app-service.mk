###############################################
#
# Kubos Application Service
#
###############################################

KUBOS_CORE_APP_SERVICE_POST_BUILD_HOOKS += APP_SERVICE_BUILD_CMDS
KUBOS_CORE_APP_SERVICE_INSTALL_STAGING = YES
KUBOS_CORE_APP_SERVICE_POST_INSTALL_STAGING_HOOKS += APP_SERVICE_INSTALL_STAGING_CMDS
KUBOS_CORE_APP_SERVICE_POST_INSTALL_TARGET_HOOKS += APP_SERVICE_INSTALL_TARGET_CMDS
KUBOS_CORE_APP_SERVICE_POST_INSTALL_TARGET_HOOKS += APP_SERVICE_INSTALL_INIT_SYSV

define APP_SERVICE_BUILD_CMDS
	cd $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/services/app-service && \
	PATH=$(PATH):~/.cargo/bin && \
	PKG_CONFIG_ALLOW_CROSS=1 CC=$(TARGET_CC) cargo build --package kubos-app-service --target $(CARGO_TARGET) --release
endef

# Generate the config settings for the service and add them to a fragment file
define APP_SERVICE_INSTALL_STAGING_CMDS
	echo '[app-service.addr]' > $(KUBOS_CONFIG_FRAGMENT_DIR)/app-service
	echo 'ip = ${BR2_KUBOS_CORE_APP_SERVICE_IP}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/app-service
	echo -e 'port = ${BR2_KUBOS_CORE_APP_SERVICE_PORT}\n' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/app-service
	echo '[app-service]' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/app-service
	echo -e 'registry-dir = ${BR2_KUBOS_CORE_APP_SERVICE_REGISTRY}\n' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/app-service
endef

# Install the application into the rootfs file system
define APP_SERVICE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
	PATH=$(PATH):~/.cargo/bin:$(HOST_DIR)/usr/bin && \
	arm-linux-strip $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/$(CARGO_OUTPUT_DIR)/kubos-app-service
	$(INSTALL) -D -m 0755 $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/$(CARGO_OUTPUT_DIR)/kubos-app-service \
		$(TARGET_DIR)/usr/sbin

	echo 'CHECK PROCESS kubos-app-service PIDFILE /var/run/kubos-app-service.pid' > $(TARGET_DIR)/etc/monit.d/kubos-app-service.cfg
	echo '	START PROGRAM = "/etc/init.d/S${BR2_KUBOS_CORE_APP_SERVICE_INIT_LVL}kubos-core-app-service start"' >> $(TARGET_DIR)/etc/monit.d/kubos-app-service.cfg 
	echo '	IF ${BR2_KUBOS_CORE_APP_SERVICE_RESTART_COUNT} RESTART WITHIN ${BR2_KUBOS_CORE_APP_SERVICE_RESTART_CYCLES} CYCLES THEN TIMEOUT' \
	>> $(TARGET_DIR)/etc/monit.d/kubos-app-service.cfg  
endef

# Install the init script
define APP_SERVICE_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-core/kubos-core-app-service/kubos-core-app-service \
		$(TARGET_DIR)/etc/init.d/S$(BR2_KUBOS_CORE_APP_SERVICE_INIT_LVL)kubos-core-app-service
endef

kubos-core-app-service-cargoclean: kubos-core-app-service-dirclean
	cd $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/services/app-service && \
	PATH=$(PATH):~/.cargo/bin && \
	cargo clean

$(eval $(virtual-package))