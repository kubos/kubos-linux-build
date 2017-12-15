################################################################################
#
# python-swagger-spec-validator
#
################################################################################

PYTHON_SWAGGER_SPEC_VALIDATOR_VERSION = 2.1.0
PYTHON_SWAGGER_SPEC_VALIDATOR_SOURCE = swagger-spec-validator-$(PYTHON_SWAGGER_SPEC_VALIDATOR_VERSION).tar.gz
PYTHON_SWAGGER_SPEC_VALIDATOR_SITE = https://pypi.python.org/packages/e3/2f/3767da696617ee72190361805dff4bca68a611d4673de848857654789534
PYTHON_SWAGGER_SPEC_VALIDATOR_SETUP_TYPE = setuptools
PYTHON_SWAGGER_SPEC_VALIDATOR_LICENSE = Apache License, Version 2.0

$(eval $(python-package))
