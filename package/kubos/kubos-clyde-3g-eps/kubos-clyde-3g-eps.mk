###############################################
#
# Kubos ClydeSpace 3G EPS Service
#
###############################################

KUBOS_CLYDE_3G_EPS_POST_BUILD_HOOKS += CLYDE_3G_EPS_BUILD_CMDS
KUBOS_CLYDE_3G_EPS_POST_INSTALL_TARGET_HOOKS += CLYDE_3G_EPS_INSTALL_TARGET_CMDS
KUBOS_CLYDE_3G_EPS_POST_INSTALL_TARGET_HOOKS += CLYDE_3G_EPS_INSTALL_INIT_SYSV

define CLYDE_3G_EPS_BUILD_CMDS
	cd $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/services/clyde-3g-eps-service && \
	PATH=$(PATH):~/.cargo/bin:/usr/bin/iobc_toolchain/usr/bin && \
	cargo build --target $(CARGO_TARGET) --release
endef

# Install the application into the rootfs file system
define CLYDE_3G_EPS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
	$(INSTALL) -D -m 0755 $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/$(CARGO_OUTPUT_DIR)/clyde-3g-eps-service \
		$(TARGET_DIR)/usr/sbin
endef

# Install the init script
define CLYDE_3G_EPS_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-clyde-3g-eps/kubos-clyde-3g-eps \
	    $(TARGET_DIR)/etc/init.d/S$(BR2_KUBOS_CLYDE_3G_EPS_INIT_LVL)kubos-clyde-3g-eps
endef

$(eval $(virtual-package))