################################################################################
#
# python-configparser
#
################################################################################

PYTHON_CONFIGPARSER_VERSION = 3.5.0
PYTHON_CONFIGPARSER_SOURCE = configparser-$(PYTHON_CONFIGPARSER_VERSION).tar.gz
PYTHON_CONFIGPARSER_SITE = https://pypi.python.org/packages/7c/69/c2ce7e91c89dc073eb1aa74c0621c3eefbffe8216b3f9af9d3885265c01c
PYTHON_CONFIGPARSER_SETUP_TYPE = setuptools
PYTHON_CONFIGPARSER_LICENSE = MIT

$(eval $(python-package))
