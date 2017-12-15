################################################################################
#
# python-pathlib
#
################################################################################

PYTHON_PATHLIB_VERSION = 1.0.1
PYTHON_PATHLIB_SOURCE = pathlib-$(PYTHON_PATHLIB_VERSION).tar.gz
PYTHON_PATHLIB_SITE = https://pypi.python.org/packages/ac/aa/9b065a76b9af472437a0059f77e8f962fe350438b927cb80184c32f075eb
PYTHON_PATHLIB_SETUP_TYPE = distutils
PYTHON_PATHLIB_LICENSE = MIT
PYTHON_PATHLIB_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
