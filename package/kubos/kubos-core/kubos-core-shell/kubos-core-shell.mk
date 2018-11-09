###############################################
#
# Kubos Shell Service
#
###############################################

KUBOS_CORE_SHELL_POST_BUILD_HOOKS += SHELL_BUILD_CMDS
KUBOS_CORE_SHELL_POST_INSTALL_TARGET_HOOKS += SHELL_INSTALL_TARGET_CMDS
KUBOS_CORE_SHELL_POST_INSTALL_TARGET_HOOKS += SHELL_INSTALL_INIT_SYSV

define SHELL_BUILD_CMDS
	cd $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/services/shell-service && \
    PATH=$(PATH):~/.cargo/bin && \
	CC=$(TARGET_CC) cargo build --target $(CARGO_TARGET) --release
endef

# Install the application into the rootfs file system
define SHELL_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
	$(INSTALL) -D -m 0755 $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/$(CARGO_OUTPUT_DIR)/shell-service \
		$(TARGET_DIR)/usr/sbin
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