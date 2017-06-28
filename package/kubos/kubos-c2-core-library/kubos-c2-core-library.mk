###############################################
#
# Kubos Command and Control Core Library
#
###############################################
KUBOS_C2_CORE_LIBRARY_VERSION = $(call qstrip,$(BR2_KUBOS_VERSION))
KUBOS_C2_CORE_LIBRARY_LICENSE = Apache-2.0
KUBOS_C2_CORE_LIBRARY_LICENSE_FILES = LICENSE
KUBOS_C2_CORE_LIBRARY_SITE = $(BUILD_DIR)/kubos-$(KUBOS_C2_CORE_LIBRARY_VERSION)/commands
KUBOS_C2_CORE_LIBRARY_SITE_METHOD = local
KUBOS_C2_CORE_LIBRARY_DEPENDENCIES = kubos
# The path from the C2_CORE_LIBRARY module to the build artifact directory
KUBOS_ARTIFACT_BUILD_PATH = build/$(KUBOS_TARGET)/source

# Link the local Kubos modules
define KUBOS_C2_CORE_LIBRARY_CONFIGURE_CMDS
	cd $(@D) && \
	kubos link -a
endef

#Use the Kubos SDK to build the C2_CORE_LIBRARY application
define KUBOS_C2_CORE_LIBRARY_BUILD_CMDS
	cd $(@D) && \
	PATH=$(PATH):/usr/bin/iobc_toolchain/usr/bin && \
	kubos -t $(KUBOS_TARGET) build
endef
#Install the application into the rootfs file system
define KUBOS_C2_CORE_LIBRARY_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/local/kubos
	$(INSTALL) -D -m 0755 $(@D)/$(KUBOS_ARTIFACT_BUILD_PATH)/commands \
		$(TARGET_DIR)/usr/local/kubos/core
endef

kubos-c2-core-library-fullclean: kubos-c2-core-library-clean-for-reconfigure kubos-c2-core-library-dirclean
	rm -f $(BUILD_DIR)/kubos-c2-core-library-$(KUBOS_C2_CORE_LIBRARY_VERSION)/.stamp_downloaded
	rm -f $(DL_DIR)/kubos-c2-core-library-$(KUBOS_C2_CORE_LIBRARY_VERSION).tar.gz

kubos-c2-core-library-clean: kubos-core-library-clean-for-rebuild
	cd $(BUILD_DIR)/kubos-c2-core-library-$(KUBOS_C2_CORE_LIBRARY_VERSION)/$(KUBOS_REPO_C2_CORE_LIBRARY_PATH); kubos clean

$(eval $(generic-package))
