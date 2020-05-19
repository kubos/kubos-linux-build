################################################################################
#
# python-cython
#
################################################################################

PYTHON_NEWER_CYTHON_VERSION = 0.29.17
PYTHON_NEWER_CYTHON_SOURCE = Cython-$(PYTHON_NEWER_CYTHON_VERSION).tar.gz
PYTHON_NEWER_CYTHON_SITE = https://files.pythonhosted.org/packages/99/36/a3dc962cc6d08749aa4b9d85af08b6e354d09c5468a3e0edc610f44c856b
PYTHON_NEWER_CYTHON_SETUP_TYPE = setuptools
PYTHON_NEWER_CYTHON_LICENSE = Apache-2.0
PYTHON_NEWER_CYTHON_LICENSE_FILES = COPYING.txt LICENSE.txt

$(eval $(host-python-package))
