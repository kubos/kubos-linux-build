#####################################################
#
# Kubos Pumpkin MCU Python API Installation
#
#####################################################
KUBOS_PUMPKIN_MCU_API_VERSION = $(KUBOS_VERSION)
KUBOS_PUMPKIN_MCU_API_LICENSE = Apache-2.0
KUBOS_PUMPKIN_MCU_API_LICENSE_FILES = LICENSE
KUBOS_PUMPKIN_MCU_API_SITE = $(BUILD_DIR)/kubos-$(KUBOS_PUMPKIN_MCU_API_VERSION)/apis/pumpkin-mcu-api
KUBOS_PUMPKIN_MCU_API_SITE_METHOD = local
KUBOS_PUMPKIN_MCU_API_SETUP_TYPE = setuptools
KUBOS_PUMPKIN_MCU_API_DEPENDENCIES = kubos

$(eval $(python-package))