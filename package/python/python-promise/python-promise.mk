################################################################################
#
# python-promise
#
################################################################################

PYTHON_PROMISE_VERSION = 2.1
PYTHON_PROMISE_SOURCE = promise-$(PYTHON_PROMISE_VERSION).tar.gz
PYTHON_PROMISE_SITE = https://files.pythonhosted.org/packages/e2/23/ff9e53fb9a00f89573646729e04a2c0933e845dcca758113f0281c396cdf
PYTHON_PROMISE_SETUP_TYPE = setuptools
PYTHON_PROMISE_LICENSE = MIT

$(eval $(python-package))
