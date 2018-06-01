################################################################################
#
# python-typing
#
################################################################################

PYTHON_TYPING_VERSION = 3.6.4
PYTHON_TYPING_SOURCE = typing-$(PYTHON_TYPING_VERSION).tar.gz
PYTHON_TYPING_SITE = https://files.pythonhosted.org/packages/ec/cc/28444132a25c113149cec54618abc909596f0b272a74c55bab9593f8876c
PYTHON_TYPING_SETUP_TYPE = setuptools
PYTHON_TYPING_LICENSE = Python Software Foundation License
PYTHON_TYPING_LICENSE_FILES = LICENSE

$(eval $(python-package))
