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
KUBOS_LICENSE = Apache-2.0
KUBOS_LICENSE_FILES = LICENSE
KUBOS_SITE = git://github.com/kubos/kubos
KUBOS_PROVIDES = kubos-mai400
KUBOS_INSTALL_STAGING = YES
KUBOS_TARGET_FINALIZE_HOOKS += KUBOS_CREATE_CONFIG

KUBOS_CONFIG_FRAGMENT_DIR = $(STAGING_DIR)/etc/kubos
KUBOS_CONFIG_FILE = $(TARGET_DIR)/etc/kubos-config.toml

VERSION = $(call qstrip,$(BR2_KUBOS_VERSION))
# If the version specified is a branch name, we need to go fetch the SHA1 for the branch's HEAD
ifeq ($(shell git ls-remote --heads $(KUBOS_SITE) $(VERSION) | wc -l), 1)
	KUBOS_VERSION := $(shell git ls-remote $(KUBOS_SITE) $(VERSION) | cut -c1-8)
else
	KUBOS_VERSION = $(VERSION)
endif

KUBOS_BR_TARGET = $(lastword $(subst /, ,$(dir $(BR2_LINUX_KERNEL_CUSTOM_DTS_PATH))))
ifeq ($(KUBOS_BR_TARGET),at91sam9g20isis)
	KUBOS_TARGET = kubos-linux-isis-gcc
	CARGO_TARGET = armv5te-unknown-linux-gnueabi
else ifeq ($(KUBOS_BR_TARGET),pumpkin-mbm2)
	KUBOS_TARGET = kubos-linux-pumpkin-mbm2-gcc
	CARGO_TARGET = arm-unknown-linux-gnueabihf
else ifeq ($(KUBOS_BR_TARGET),beaglebone-black)
	KUBOS_TARGET = kubos-linux-beaglebone-gcc
	CARGO_TARGET = arm-unknown-linux-gnueabihf
else
	KUBOS_TARGET = unknown
endif

CARGO_OUTPUT_DIR = target/$(CARGO_TARGET)/release

define KUBOS_INSTALL_STAGING_CMDS
	mkdir -p $(KUBOS_CONFIG_FRAGMENT_DIR)
endef

define KUBOS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/monit.d
endef

define KUBOS_CREATE_CONFIG
	# Collect all config fragment files into the final master config.toml file
	cat $(KUBOS_CONFIG_FRAGMENT_DIR)/* > $(KUBOS_CONFIG_FILE)
endef


kubos-deepclean:
	rm -fR $(BUILD_DIR)/kubos-*
	rm -f $(DL_DIR)/kubos-*
	rm -f $(TARGET_DIR)/etc/init.d/*kubos*
	rm -f $(TARGET_DIR)/etc/monit.d/kubos*
	rm -fR $(KUBOS_CONFIG_FRAGMENT_DIR)
	rm -fR $(BUILD_DIR)/../staging/etc/kubos
	rm -f $(KUBOS_CONFIG_FILE)

kubos-fullclean: kubos-clean-for-reconfigure kubos-dirclean
	rm -f $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/.stamp_downloaded
	rm -f $(DL_DIR)/kubos-$(KUBOS_VERSION).tar.gz
	rm -fR $(KUBOS_CONFIG_FRAGMENT_DIR)
	rm -fR $(BUILD_DIR)/../staging/etc/kubos
	rm -f $(KUBOS_CONFIG_FILE)

kubos-clean: kubos-clean-for-rebuild
	rm -fR $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/target

$(eval $(generic-package))
