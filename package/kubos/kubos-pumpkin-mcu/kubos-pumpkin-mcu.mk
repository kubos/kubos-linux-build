#####################################################
#
# Pumpkin MCU Python Service Installation
#
#####################################################
KUBOS_PUMPKIN_MCU_VERSION = $(call qstrip,$(BR2_KUBOS_VERSION))
KUBOS_PUMPKIN_MCU_LICENSE = Apache-2.0
KUBOS_PUMPKIN_MCU_LICENSE_FILES = LICENSE
KUBOS_PUMPKIN_MCU_SITE = $(BUILD_DIR)/kubos-$(KUBOS_PUMPKIN_MCU_VERSION)/services/pumpkin-mcu-service
KUBOS_PUMPKIN_MCU_SITE_METHOD = local
KUBOS_PUMPKIN_MCU_DEPENDENCIES = kubos

# Install the application into the rootfs file system
define KUBOS_PUMPKIN_MCU_INSTALL_TARGET_CMDS
    mkdir -p $(TARGET_DIR)/usr/sbin/pumpkin-mcu-service
    cp -R $(@D)/* $(TARGET_DIR)/usr/sbin/pumpkin-mcu-service
endef

# Install the init script
define KUBOS_PUMPKIN_MCU_INSTALL_INIT_SYSV
    $(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-pumpkin-mcu/kubos-pumpkin-mcu \
        $(TARGET_DIR)/etc/init.d/S$(BR2_KUBOS_PUMPKIN_MCU_INIT_LVL)kubos-pumpkin-mcu
        		
    echo 'CHECK PROCESS kubos-pumpkin-mcu PIDFILE /var/run/TODO.pid' > $(TARGET_DIR)/etc/monit.d/kubos-pumpkin-mcu.cfg
    echo '    START PROGRAM = "/etc/init.d/S${BR2_KUBOS_PUMPKIN_MCU_INIT_LVL}kubos-pumpkin-mcu"' >> $(TARGET_DIR)/etc/monit.d/kubos-pumpkin-mcu.cfg 
    echo '    IF ${BR2_KUBOS_PUMPKIN_MCU_RESTART_COUNT} RESTART WITHIN ${BR2_KUBOS_PUMPKIN_MCU_RESTART_CYCLES} CYCLES THEN TIMEOUT' \
    >> $(TARGET_DIR)/etc/monit.d/kubos-pumpkin-mcu.cfg 
endef

$(eval $(generic-package))