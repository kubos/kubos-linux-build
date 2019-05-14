#####################################################
#
# Kubos Python App API Installation
#
#####################################################
KUBOS_APP_API_VERSION = $(KUBOS_VERSION)
KUBOS_APP_API_LICENSE = Apache-2.0
KUBOS_APP_API_LICENSE_FILES = LICENSE
KUBOS_APP_API_SITE = $(BUILD_DIR)/kubos-$(KUBOS_APP_API_VERSION)/apis/app-api/python
KUBOS_APP_API_SITE_METHOD = local
KUBOS_APP_API_SETUP_TYPE = setuptools
KUBOS_APP_API_DEPENDENCIES = kubos

$(eval $(python-package))