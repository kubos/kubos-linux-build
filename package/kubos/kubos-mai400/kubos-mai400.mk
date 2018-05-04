###############################################
#
# Kubos MAI400 Service
#
###############################################

KUBOS_MAI400_POST_BUILD_HOOKS += MAI400_BUILD_CMDS
KUBOS_MAI400_POST_INSTALL_TARGET_HOOKS += MAI400_INSTALL_TARGET_CMDS
KUBOS_MAI400_POST_INSTALL_TARGET_HOOKS += MAI400_INSTALL_INIT_SYSV

define MAI400_BUILD_CMDS
	cd $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/services/mai400-service && \
	PATH=$(PATH):~/.cargo/bin:/usr/bin/iobc_toolchain/usr/bin && \
	cargo build --target $(CARGO_TARGET) --release
endef

# Install the application into the rootfs file system
define MAI400_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
	$(INSTALL) -D -m 0755 $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/$(CARGO_OUTPUT_DIR)/mai400-service \
		$(TARGET_DIR)/usr/sbin
endef

# Install the init script
define MAI400_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-mai400/kubos-mai400 \
	    $(TARGET_DIR)/etc/init.d/S$(BR2_KUBOS_MAI400_INIT_LVL)kubos-mai400
endef

$(eval $(virtual-package))