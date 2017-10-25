################################################################################
#
# python-promise
#
################################################################################

PYTHON_PROMISE_VERSION = 2.0.1
PYTHON_PROMISE_SOURCE = promise-$(PYTHON_PROMISE_VERSION).tar.gz
PYTHON_PROMISE_SITE = https://pypi.python.org/packages/f8/0e/36c2768278d827fbe8cd168f212bf33974fb54da14f92cc36041c0b642fe
PYTHON_PROMISE_SETUP_TYPE = setuptools
PYTHON_PROMISE_LICENSE = MIT

define PYTHON_PROMISE_PRE_BUILD_FIX
    # This is a Python3 module, so needs to be removed before we attempt to build using Python2.7
    rm $(BUILD_DIR)/python-promise-$(PYTHON_PROMISE_VERSION)/promise/iterate_promise.py
endef

PYTHON_PROMISE_PRE_BUILD_HOOKS += PYTHON_PROMISE_PRE_BUILD_FIX

$(eval $(python-package))
