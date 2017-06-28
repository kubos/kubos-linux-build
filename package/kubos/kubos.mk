###############################################
#
# KubOS Telemetry Service
#
###############################################
KUBOS_VERSION = $(call qstrip,$(BR2_KUBOS_VERSION))
KUBOS_LICENSE = Apache-2.0
KUBOS_LICENSE_FILES = LICENSE
KUBOS_SITE = git://github.com/kubostech/kubos

# Globally link all of the modules so that telemetry and C2 can use them
define KUBOS_BUILD_CMDS
	cd $(@D) && \
	./tools/kubos_link.py --sys
endef

kubos-fullclean: kubos-clean-for-reconfigure kubos-dirclean
	rm -f $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/.stamp_downloaded
	rm -f $(DL_DIR)/kubos-$(KUBOS_VERSION).tar.gz


kubos-clean: kubos-clean-for-rebuild
	cd $(BUILD_DIR)/kubos-$(KUBOS_VERSION); kubos clean
	cd $(TARGET_DIR)/etc/init.d; rm -f S*kubos*

$(eval $(generic-package))
