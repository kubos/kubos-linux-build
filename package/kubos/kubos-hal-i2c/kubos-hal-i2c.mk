#####################################################
#
# Kubos Python I2C HAL Installation
#
#####################################################
KUBOS_HAL_I2C_VERSION = $(KUBOS_VERSION)
KUBOS_HAL_I2C_LICENSE = Apache-2.0
KUBOS_HAL_I2C_LICENSE_FILES = LICENSE
KUBOS_HAL_I2C_SITE = $(BUILD_DIR)/kubos-$(KUBOS_HAL_I2C_VERSION)/hal/python-hal/i2c
KUBOS_HAL_I2C_SITE_METHOD = local
KUBOS_HAL_I2C_SETUP_TYPE = setuptools
KUBOS_HAL_I2C_DEPENDENCIES = kubos

$(eval $(python-package))