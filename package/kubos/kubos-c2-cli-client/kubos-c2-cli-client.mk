###############################################
#
# Kubos Command and Control CLI Client
#
###############################################
KUBOS_C2_CLI_CLIENT_VERSION = $(call qstrip,$(BR2_KUBOS_VERSION))
KUBOS_C2_CLI_CLIENT_LICENSE = Apache-2.0
KUBOS_C2_CLI_CLIENT_LICENSE_FILES = LICENSE
KUBOS_C2_CLI_CLIENT_SITE = $(BUILD_DIR)/kubos-$(KUBOS_C2_CLI_CLIENT_VERSION)/cmd-control-client
KUBOS_C2_CLI_CLIENT_SITE_METHOD = local
KUBOS_C2_CLI_CLIENT_DEPENDENCIES = kubos
# The path from the C2_CLI_CLIENT module to the build artifact directory
KUBOS_ARTIFACT_BUILD_PATH = build/$(KUBOS_TARGET)/source

# Link the local Kubos modules
define KUBOS_C2_CLI_CLIENT_CONFIGURE_CMDS
	cd $(@D) && \
	kubos link -a
endef

# Use the Kubos SDK to build the C2_CLI_CLIENT application
define KUBOS_C2_CLI_CLIENT_BUILD_CMDS
	cd $(@D) && \
	PATH=$(PATH):/usr/bin/iobc_toolchain/usr/bin && \
	kubos -t $(KUBOS_TARGET) build
endef
# Install the application into the rootfs file system
define KUBOS_C2_CLI_CLIENT_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/$(KUBOS_ARTIFACT_BUILD_PATH)/cmd-control-client \
		$(TARGET_DIR)/usr/bin/c2
endef

kubos-c2-cli-client-fullclean: kubos-c2-cli-client-clean-for-reconfigure kubos-c2-cli-client-dirclean
	rm -f $(BUILD_DIR)/kubos-c2-cli-client-$(KUBOS_C2_CLI_CLIENT_VERSION)/.stamp_downloaded
	rm -f $(DL_DIR)/kubos-c2-cli-client-$(KUBOS_C2_CLI_CLIENT_VERSION).tar.gz

kubos-c2-cli-client-clean: kubos-c2-cli-client-clean-for-rebuild
	cd $(BUILD_DIR)/kubos-c2-cli-client-$(KUBOS_C2_CLI_CLIENT_VERSION)/$(KUBOS_REPO_C2_CLI_CLIENT_PATH); kubos clean

$(eval $(generic-package))
