###############################################
#
# Kubos Telemetry Database Service
#
###############################################

KUBOS_CORE_TELEMETRY_DB_POST_BUILD_HOOKS += TELEMETRY_DB_BUILD_CMDS
KUBOS_CORE_TELEMETRY_DB_POST_INSTALL_TARGET_HOOKS += TELEMETRY_DB_INSTALL_TARGET_CMDS
KUBOS_CORE_TELEMETRY_DB_POST_INSTALL_TARGET_HOOKS += TELEMETRY_DB_INSTALL_INIT_SYSV

define TELEMETRY_DB_BUILD_CMDS
	cd $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/services/telemetry-service && \
    PATH=$(PATH):~/.cargo/bin && \
	CC=$(TARGET_CC) cargo build --target $(CARGO_TARGET) --release
endef

# Install the application into the rootfs file system
define TELEMETRY_DB_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
	$(INSTALL) -D -m 0755 $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/$(CARGO_OUTPUT_DIR)/telemetry-service \
		$(TARGET_DIR)/usr/sbin
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
