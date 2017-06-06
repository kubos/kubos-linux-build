###############################################
#
# Kubos Command and Control CLI Client
#
###############################################
UPDATE_DUMMY = $(shell kubos update) #unused dummy variable to run update before getting the version...
KUBOS_C2_CLI_CLIENT_VERSION = $(shell kubos versions 2>&1 | grep recent | awk '{print $$7}')
KUBOS_C2_CLI_CLIENT_LICENSE = Apache-2.0
KUBOS_C2_CLI_CLIENT_LICENSE_FILES = LICENSE
KUBOS_C2_CLI_CLIENT_SITE = git://github.com/kubostech/kubos
# The path to the command-and-control module in the kubos repo
KUBOS_REPO_C2_CLI_CLIENT_PATH = cmd-control-client
# The path from the command-and-control module to the build artifact directory
KUBOS_ARTIFACT_BUILD_PATH = build/kubos-linux-isis-gcc/source


#Use the Kubos SDK to build the command-and-control application
define KUBOS_C2_CLI_CLIENT_BUILD_CMDS
	cd $(@D) && \
	./tools/kubos_link.py --sys --app $(KUBOS_REPO_C2_CLI_CLIENT_PATH) && \
	cd $(@D)/$(KUBOS_REPO_C2_CLI_CLIENT_PATH) && \
	PATH=$(PATH):/usr/bin/iobc_toolchain/usr/bin && \
	kubos -t kubos-linux-isis-gcc build
endef


#Install the application into the rootfs file system
define KUBOS_C2_CLI_CLIENT_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/$(KUBOS_REPO_C2_CLI_CLIENT_PATH)/$(KUBOS_ARTIFACT_BUILD_PATH)/cmd-control-client \
		$(TARGET_DIR)/usr/bin/c2
endef


kubos-c2-cli-client-fullclean: kubos-c2-cli-client-clean-for-reconfigure kubos-c2-cli-client-dirclean
	rm -f $(BUILD_DIR)/kubos-command-and-control-$(KUBOS_C2_CLI_CLIENT_VERSION)/.stamp_downloaded
	rm -f $(DL_DIR)/kubos-command-and-control-$(KUBOS_C2_CLI_CLIENT_VERSION).tar.gz


kubos-c2-cli-client-clean: kubos-c2-cli-client-clean-for-rebuild
	cd $(BUILD_DIR)/kubos-command-and-control-$(KUBOS_C2_CLI_CLIENT_VERSION)/$(KUBOS_REPO_C2_CLI_CLIENT_PATH); kubos clean
	cd $(TARGET_DIR)/etc/init.d; rm -f S*kubos-command-and-control

$(eval $(generic-package))
