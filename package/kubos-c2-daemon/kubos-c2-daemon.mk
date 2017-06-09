###############################################
#
# Kubos Command and Control Daemon
#
###############################################
UPDATE_DUMMY := $(shell kubos update) #unused dummy variable to run update before getting the version...
KUBOS_C2_DAEMON_VERSION = $(shell kubos versions 2>&1 | grep recent | awk '{print $$7}')
KUBOS_C2_DAEMON_LICENSE = Apache-2.0
KUBOS_C2_DAEMON_LICENSE_FILES = LICENSE
KUBOS_C2_DAEMON_SITE = git://github.com/kubostech/kubos
# The path to the command-and-control module in the kubos repo
KUBOS_REPO_C2_DAEMON_PATH = cmd-control-daemon
# The path from the command-and-control module to the build artifact directory
KUBOS_ARTIFACT_BUILD_PATH = build/kubos-linux-isis-gcc/source


#Use the Kubos SDK to build the command-and-control application
define KUBOS_C2_DAEMON_BUILD_CMDS
	cd $(@D) && \
	./tools/kubos_link.py --sys --app $(KUBOS_REPO_C2_DAEMON_PATH) && \
	cd $(@D)/$(KUBOS_REPO_C2_DAEMON_PATH) && \
	PATH=$(PATH):/usr/bin/iobc_toolchain/usr/bin && \
	kubos -t kubos-linux-isis-gcc build
endef


#Install the application into the rootfs file system
define KUBOS_C2_DAEMON_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/bin
	mkdir -p $(TARGET_DIR)/usr/local/kubos
	mkdir -p $(TARGET_DIR)/var/log/
	$(INSTALL) -D -m 0755 $(@D)/$(KUBOS_REPO_C2_DAEMON_PATH)/$(KUBOS_ARTIFACT_BUILD_PATH)/cmd-control-daemon \
		$(TARGET_DIR)/usr/sbin/kubos-c2-daemon
	test -e $(TARGET_DIR)/usr/local/kubos/client-to-server || mkfifo  $(TARGET_DIR)/usr/local/kubos/client-to-server
	test -e $(TARGET_DIR)/usr/local/kubos/server-to-client || mkfifo  $(TARGET_DIR)/usr/local/kubos/server-to-client
endef


#Install the init script
define KUBOS_C2_DAEMON_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos-c2-daemon/kubos-c2-daemon \
		$(TARGET_DIR)/etc/init.d/S$(BR2_KUBOS_C2_DAEMON_INIT_LVL)kubos-c2-daemon
endef


kubos-c2-daemon-fullclean: kubos-c2-daemon-clean-for-reconfigure kubos-c2-daemon-dirclean
	rm -f $(BUILD_DIR)/kubos-c2-daemon-$(KUBOS_C2_DAEMON_VERSION)/.stamp_downloaded
	rm -f $(DL_DIR)/kubos-c2-daemon-$(KUBOS_C2_DAEMON_VERSION).tar.gz


kubos-c2-daemon-clean: kubos-c2-daemon-clean-for-rebuild
	cd $(BUILD_DIR)/kubos-c2-daemon-$(KUBOS_C2_DAEMON_VERSION)/$(KUBOS_REPO_C2_DAEMON_PATH); kubos clean
	cd $(TARGET_DIR)/etc/init.d; rm -f S*kubos-c2-daemon

$(eval $(generic-package))
