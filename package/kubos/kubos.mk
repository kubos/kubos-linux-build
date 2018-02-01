###############################################
#
# Kubos Master Package
#
# This package downloads the Kubos repo,
# globally links all the modules, and sets the
# target for the subsequent Kubos child 
# packages
#
###############################################
KUBOS_VERSION = $(call qstrip,$(BR2_KUBOS_VERSION))
KUBOS_LICENSE = Apache-2.0
KUBOS_LICENSE_FILES = LICENSE
KUBOS_SITE = git://github.com/kubos/kubos
KUBOS_BR_TARGET = $(lastword $(subst /, ,$(dir $(BR2_LINUX_KERNEL_CUSTOM_DTS_PATH))))
ifeq ($(KUBOS_BR_TARGET),at91sam9g20isis)
	KUBOS_TARGET = kubos-linux-isis-gcc
else ifeq ($(KUBOS_BR_TARGET),pumpkin-mbm2)
	KUBOS_TARGET = kubos-linux-pumpkin-mbm2-gcc
else ifeq ($(KUBOS_BR_TARGET),beaglebone-black)
	KUBOS_TARGET = kubos-linux-beaglebone-gcc
else
	KUBOS_TARGET = unknown
endif

# Globally link all of the modules so that Kubos packages can use them
define KUBOS_BUILD_CMDS
	cd $(@D) && \
	./tools/kubos_link.py --sys
endef

kubos-deepclean:
	rm -fR $(BUILD_DIR)/kubos-*
	rm -f $(DL_DIR)/kubos-*
	rm -f $(TARGET_DIR)/etc/init.d/*kubos*

kubos-fullclean: kubos-clean-for-reconfigure kubos-dirclean
	rm -f $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/.stamp_downloaded
	rm -f $(DL_DIR)/kubos-$(KUBOS_VERSION).tar.gz


kubos-clean: kubos-clean-for-rebuild

$(eval $(generic-package))
