#####################################################
#
# Pumpkin MCU Python Service Installation
#
#####################################################
KUBOS_PUMPKIN_MCU_VERSION = $(KUBOS_VERSION)
KUBOS_PUMPKIN_MCU_LICENSE = Apache-2.0
KUBOS_PUMPKIN_MCU_LICENSE_FILES = LICENSE
KUBOS_PUMPKIN_MCU_SITE = $(BUILD_DIR)/kubos-$(KUBOS_PUMPKIN_MCU_VERSION)/services/pumpkin-mcu-service
KUBOS_PUMPKIN_MCU_SITE_METHOD = local
KUBOS_PUMPKIN_MCU_DEPENDENCIES = kubos

KUBOS_PUMPKIN_MCU_INSTALL_STAGING = YES
KUBOS_PUMPKIN_MCU_POST_INSTALL_STAGING_HOOKS += PUMPKIN_MCU_INSTALL_STAGING_CMDS

# Generate the config settings for the service and add them to a fragment file
define PUMPKIN_MCU_INSTALL_STAGING_CMDS
	echo '[pumpkin-mcu-service.addr]' > $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service
	echo 'ip = ${BR2_KUBOS_PUMPKIN_MCU_IP}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service
	echo -e 'port = ${BR2_KUBOS_PUMPKIN_MCU_PORT}\n' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service
	echo '[pumpkin-mcu-service.modules]' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service
	if [ "${BR2_KUBOS_PUMPKIN_MCU_SIM}" = "y" ] ; then \
		echo '[pumpkin-mcu-service.modules.sim]' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service;\
		echo 'address = ${BR2_KUBOS_PUMPKIN_MCU_SIM_ADDR}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service;\
	fi
	if [ "${BR2_KUBOS_PUMPKIN_MCU_BIM}" = "y" ] ; then \
		echo '[pumpkin-mcu-service.modules.bim]' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service;\
		echo 'address = ${BR2_KUBOS_PUMPKIN_MCU_BIM_ADDR}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service;\
	fi
	if [ "${BR2_KUBOS_PUMPKIN_MCU_PIM}" = "y" ] ; then \
		echo '[pumpkin-mcu-service.modules.pim]' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service;\
		echo 'address = ${BR2_KUBOS_PUMPKIN_MCU_PIM_ADDR}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service;\
	fi
	if [ "${BR2_KUBOS_PUMPKIN_MCU_GPSRM}" = "y" ] ; then \
		echo '[pumpkin-mcu-service.modules.gpsrm]' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service;\
		echo 'address = ${BR2_KUBOS_PUMPKIN_MCU_GPSRM_ADDR}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service;\
	fi
	if [ "${BR2_KUBOS_PUMPKIN_MCU_AIM2}" = "y" ] ; then \
		echo '[pumpkin-mcu-service.modules.aim2]' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service;\
		echo 'address = ${BR2_KUBOS_PUMPKIN_MCU_AIM2_ADDR}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service; \
	fi
	if [ "${BR2_KUBOS_PUMPKIN_MCU_RHM}" = "y" ] ; then \
		echo '[pumpkin-mcu-service.modules.rhm]' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service;\
		echo 'address = ${BR2_KUBOS_PUMPKIN_MCU_RHM_ADDR}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service; \
	fi
	if [ "${BR2_KUBOS_PUMPKIN_MCU_BSM}" = "y" ] ; then \
		echo '[pumpkin-mcu-service.modules.bsm]' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service;\
		echo 'address = ${BR2_KUBOS_PUMPKIN_MCU_BSM_ADDR}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service; \
	fi
	if [ "${BR2_KUBOS_PUMPKIN_MCU_BM2}" = "y" ] ; then \
		echo '[pumpkin-mcu-service.modules.bm2]' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service;\
		echo 'address = ${BR2_KUBOS_PUMPKIN_MCU_BM2_ADDR}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service; \
	fi
	if [ "${BR2_KUBOS_PUMPKIN_MCU_DASA}" = "y" ] ; then \
		echo '[pumpkin-mcu-service.modules.dasa]' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service;\
		echo 'address = ${BR2_KUBOS_PUMPKIN_MCU_DASA_ADDR}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service; \
	fi
	if [ "${BR2_KUBOS_PUMPKIN_MCU_EPSM}" = "y" ] ; then \
		echo '[pumpkin-mcu-service.modules.epsm]' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service;\
		echo 'address = ${BR2_KUBOS_PUMPKIN_MCU_EPSM_ADDR}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service; \
	fi
	echo '' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/pumpkin-mcu-service
endef

# Install the application into the rootfs file system
define KUBOS_PUMPKIN_MCU_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin/pumpkin-mcu-service
	cp -R $(@D)/* $(TARGET_DIR)/usr/sbin/pumpkin-mcu-service
endef

# Install the init script
define KUBOS_PUMPKIN_MCU_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-pumpkin-mcu/kubos-pumpkin-mcu \
		$(TARGET_DIR)/etc/init.d/S$(BR2_KUBOS_PUMPKIN_MCU_INIT_LVL)kubos-pumpkin-mcu
endef

$(eval $(generic-package))