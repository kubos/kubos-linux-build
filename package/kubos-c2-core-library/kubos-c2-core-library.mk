###############################################
#
# Kubos Command and Control Core Library
#
###############################################
UPDATE_DUMMY = $(shell kubos update) #unused dummy variable to run update before getting the version...
KUBOS_C2_CORE_LIBRARY_VERSION = $(shell kubos versions 2>&1 | grep recent | awk '{print $$7}')
KUBOS_C2_CORE_LIBRARY_LICENSE = Apache-2.0
KUBOS_C2_CORE_LIBRARY_LICENSE_FILES = LICENSE
KUBOS_C2_CORE_LIBRARY_SITE = git://github.com/kubostech/kubos
# The path to the command-and-control module in the kubos repo
KUBOS_REPO_C2_CORE_LIBRARY_PATH = commands
# The path from the command-and-control module to the build artifact directory
KUBOS_C2_CORE_LIBRARY_ARTIFACT_BUILD_PATH = build/kubos-linux-isis-gcc/source

#Use the Kubos SDK to build the command-and-control application
define KUBOS_C2_CORE_LIBRARY_BUILD_CMDS
	cd $(@D) && \
	./tools/kubos_link.py --sys --app $(KUBOS_REPO_C2_CORE_LIBRARY_PATH) && \
	cd $(@D)/$(KUBOS_REPO_C2_CORE_LIBRARY_PATH) && \
	PATH=$(PATH):/usr/bin/iobc_toolchain/usr/bin && \
	kubos -t kubos-linux-isis-gcc build
endef

#Install the application into the rootfs file system
define KUBOS_C2_CORE_LIBRARY_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/local/kubos
	$(INSTALL) -D -m 0755 $(@D)/$(KUBOS_REPO_C2_CORE_LIBRARY_PATH)/$(KUBOS_ARTIFACT_BUILD_PATH)/commands \
		$(TARGET_DIR)/usr/local/kubos/core
endef

kubos-c2-core-library-fullclean: kubos-c2-core-library-clean-for-reconfigure kubos-c2-core-library-dirclean
	rm -f $(BUILD_DIR)/kubos-c2-core-library-$(KUBOS_C2_CORE_LIBRARY_VERSION)/.stamp_downloaded
	rm -f $(DL_DIR)/kubos-c2-core-library-$(KUBOS_C2_CORE_LIBRARY_VERSION).tar.gz

kubos-c2-core-library-clean: kubos-core-library-clean-for-rebuild
	cd $(BUILD_DIR)/kubos-c2-core-library-$(KUBOS_C2_CORE_LIBRARY_VERSION)/$(KUBOS_REPO_C2_CORE_LIBRARY_PATH); kubos clean

$(eval $(generic-package))
