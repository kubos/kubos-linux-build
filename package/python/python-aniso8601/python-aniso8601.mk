################################################################################
#
# python-aniso8601
#
################################################################################

PYTHON_ANISO8601_VERSION = 3.0.0
PYTHON_ANISO8601_SOURCE = aniso8601-$(PYTHON_ANISO8601_VERSION).tar.gz
PYTHON_ANISO8601_SITE = https://files.pythonhosted.org/packages/22/33/f22de651052cb0111cb68ff17f5cccce4fd05f67de62d53a638b5138e2b5
PYTHON_ANISO8601_SETUP_TYPE = setuptools
PYTHON_ANISO8601_LICENSE = BSD
PYTHON_ANISO8601_LICENSE_FILES = LICENSE

$(eval $(python-package))
