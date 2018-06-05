################################################################################
#
# python-rx
#
################################################################################

PYTHON_RX_VERSION = 1.6.1
PYTHON_RX_SOURCE = Rx-$(PYTHON_RX_VERSION).tar.gz
PYTHON_RX_SITE = https://files.pythonhosted.org/packages/25/d7/9bc30242d9af6a9e9bf65b007c56e17b7dc9c13f86e440b885969b3bbdcf
PYTHON_RX_SETUP_TYPE = setuptools
PYTHON_RX_LICENSE = Apache-2.0

$(eval $(python-package))
