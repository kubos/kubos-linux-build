###############################################
#
# Kubos Shell Service
#
###############################################

KUBOS_CORE_SHELL_POST_BUILD_HOOKS += SHELL_BUILD_CMDS
KUBOS_CORE_SHELL_INSTALL_STAGING = YES
KUBOS_CORE_SHELL_POST_INSTALL_STAGING_HOOKS += SHELL_INSTALL_STAGING_CMDS
KUBOS_CORE_SHELL_POST_INSTALL_TARGET_HOOKS += SHELL_INSTALL_TARGET_CMDS
KUBOS_CORE_SHELL_POST_INSTALL_TARGET_HOOKS += SHELL_INSTALL_INIT_SYSV

define SHELL_BUILD_CMDS
	cd $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/services/shell-service && \
	PATH=$(PATH):~/.cargo/bin && \
	CC=$(TARGET_CC) cargo build --package shell-service --target $(CARGO_TARGET) --release
endef

# Generate the config settings for the service and add them to a fragment file
define SHELL_INSTALL_STAGING_CMDS
	echo '[shell-service.addr]' > $(KUBOS_CONFIG_FRAGMENT_DIR)/shell-service
	echo 'ip = ${BR2_KUBOS_CORE_SHELL_IP}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/shell-service
	echo -e 'port = ${BR2_KUBOS_CORE_SHELL_PORT}\n' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/shell-service
	
endef

# Install the application into the rootfs file system
define SHELL_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
	PATH=$(PATH):~/.cargo/bin:$(HOST_DIR)/usr/bin && \
	arm-linux-strip $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/$(CARGO_OUTPUT_DIR)/shell-service
	$(INSTALL) -D -m 0755 $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/$(CARGO_OUTPUT_DIR)/shell-service \
		$(TARGET_DIR)/usr/sbin
		
	echo 'CHECK PROCESS kubos-shell-service PIDFILE /var/run/shell-service.pid' > $(TARGET_DIR)/etc/monit.d/kubos-shell-service.cfg
	echo '	START PROGRAM = "/etc/init.d/S${BR2_KUBOS_CORE_SHELL_INIT_LVL}kubos-core-shell start"' >> $(TARGET_DIR)/etc/monit.d/kubos-shell-service.cfg 
	echo '	IF ${BR2_KUBOS_CORE_SHELL_RESTART_COUNT} RESTART WITHIN ${BR2_KUBOS_CORE_SHELL_RESTART_CYCLES} CYCLES THEN TIMEOUT' \
	>> $(TARGET_DIR)/etc/monit.d/kubos-shell-service.cfg
endef

# Install the init script
define SHELL_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-core/kubos-core-shell/kubos-core-shell \
		$(TARGET_DIR)/etc/init.d/S$(BR2_KUBOS_CORE_SHELL_INIT_LVL)kubos-core-shell
endef

kubos-core-shell-cargoclean: kubos-core-shell-dirclean
	cd $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/services/shell-service && \
	PATH=$(PATH):~/.cargo/bin && \
	cargo clean

$(eval $(virtual-package))
