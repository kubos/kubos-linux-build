################################################################################
#
# python-typing
#
################################################################################

PYTHON_TYPING_VERSION = 3.6.2
PYTHON_TYPING_SOURCE = typing-$(PYTHON_TYPING_VERSION).tar.gz
PYTHON_TYPING_SITE = https://pypi.python.org/packages/ca/38/16ba8d542e609997fdcd0214628421c971f8c395084085354b11ff4ac9c3
PYTHON_TYPING_SETUP_TYPE = setuptools
PYTHON_TYPING_LICENSE = Python Software Foundation License
PYTHON_TYPING_LICENSE_FILES = LICENSE

$(eval $(python-package))
