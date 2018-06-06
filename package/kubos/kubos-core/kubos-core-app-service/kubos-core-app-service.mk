###############################################
#
# Kubos Application Service
#
###############################################

KUBOS_CORE_APP_SERVICE_POST_BUILD_HOOKS += APP_SERVICE_BUILD_CMDS
KUBOS_CORE_APP_SERVICE_POST_INSTALL_TARGET_HOOKS += APP_SERVICE_INSTALL_TARGET_CMDS
KUBOS_CORE_APP_SERVICE_POST_INSTALL_TARGET_HOOKS += APP_SERVICE_INSTALL_INIT_SYSV

define APP_SERVICE_BUILD_CMDS
	cd $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/services/app-service && \
	PATH=$(PATH):~/.cargo/bin && \
	cargo build --target $(CARGO_TARGET) --release
endef

# Install the application into the rootfs file system
define APP_SERVICE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
	$(INSTALL) -D -m 0755 $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/$(CARGO_OUTPUT_DIR)/app-service \
		$(TARGET_DIR)/usr/sbin
endef

# Install the init script
define APP_SERVICE_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-core/kubos-core-app-service/kubos-core-app-service \
	    $(TARGET_DIR)/etc/init.d/S$(BR2_KUBOS_CORE_APP_SERVICE_INIT_LVL)kubos-core-app-service
endef

$(eval $(virtual-package))