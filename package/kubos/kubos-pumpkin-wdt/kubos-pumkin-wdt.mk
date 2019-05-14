#####################################################
#
# Pumpkin Stack Gating Watchdog Enable Installation
#
#####################################################
KUBOS_PUMPKIN_WDT_VERSION = $(KUBOS_VERSION)
KUBOS_PUMPKIN_WDT_LICENSE = Apache-2.0
KUBOS_PUMPKIN_WDT_LICENSE_FILES = LICENSE
KUBOS_PUMPKIN_WDT_SITE = $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-pumpkin-wdt
KUBOS_PUMPKIN_WDT_SITE_METHOD = local

# Install the init script
define KUBOS_PUMPKIN_WDT_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-pumpkin-wdt/kubos-pumpkin-wdt \
	    $(TARGET_DIR)/etc/init.d/S$(BR2_KUBOS_PUMPKIN_WDT_INIT_LVL)kubos-pumpkin-wdt
    $(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-pumpkin-wdt/pumpkin-wdt-enable.sh \
	    $(TARGET_DIR)/usr/bin/pumpkin-wdt-enable.sh
endef

$(eval $(generic-package))