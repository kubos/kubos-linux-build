###############################################
#
# Kubos MAI400 Service
#
###############################################
KUBOS_MAI400_VERSION = $(call qstrip,$(BR2_KUBOS_VERSION))
KUBOS_MAI400_LICENSE = Apache-2.0
KUBOS_MAI400_LICENSE_FILES = LICENSE
KUBOS_MAI400_SITE = $(BUILD_DIR)/kubos-$(KUBOS_MAI400_VERSION)/services/mai400-service
KUBOS_MAI400_SITE_METHOD = local
KUBOS_MAI400_DEPENDENCIES = kubos
# The path from the MAI400 module to the build artifact directory
KUBOS_ARTIFACT_BUILD_PATH = target/$(CARGO_TARGET)/release

# Use the Kubos SDK to build the MAI400 application
define KUBOS_MAI400_BUILD_CMDS
	cd $(@D) && \
	PATH=$(PATH):~/.cargo/bin:/usr/bin/iobc_toolchain/usr/bin && \
	cargo build --target $(CARGO_TARGET) --release && \
	arm-linux-strip $(KUBOS_ARTIFACT_BUILD_PATH)/mai400-service
endef

# Install the application into the rootfs file system
define KUBOS_MAI400_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
	$(INSTALL) -D -m 0755 $(@D)/$(KUBOS_ARTIFACT_BUILD_PATH)/mai400-service \
		$(TARGET_DIR)/usr/sbin
endef

# Install the init script
define KUBOS_MAI400_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-mai400/kubos-mai400 \
	    $(TARGET_DIR)/etc/init.d/S$(BR2_KUBOS_MAI400_INIT_LVL)kubos-mai400
endef

kubos-mai400-fullclean: kubos-mai400-clean kubos-mai400-clean-for-reconfigure kubos-mai400-dirclean
	rm -f $(BUILD_DIR)/kubos-mai400-$(KUBOS_MAI400_VERSION)/.stamp_downloaded
	rm -f $(DL_DIR)/kubos-mai400-$(KUBOS_MAI400_VERSION).tar.gz

kubos-mai400-clean: kubos-mai400-clean-for-rebuild
	cd $(BUILD_DIR)/kubos-mai400-$(KUBOS_MAI400_VERSION); PATH=$(PATH):~/.cargo/bin cargo clean
	cd $(TARGET_DIR)/etc/init.d; rm -f S*kubos-mai400

$(eval $(generic-package))