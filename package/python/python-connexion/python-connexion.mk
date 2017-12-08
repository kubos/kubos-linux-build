################################################################################
#
# python-connexion
#
################################################################################

PYTHON_CONNEXION_VERSION = 1.2
PYTHON_CONNEXION_SOURCE = connexion-$(PYTHON_CONNEXION_VERSION).tar.gz
PYTHON_CONNEXION_SITE = https://pypi.python.org/pypi/connexion
PYTHON_CONNEXION_SETUP_TYPE = setuptools
PYTHON_CONNEXION_LICENSE = Apache License Version 2.0
PYTHON_CONNEXION_LICENSE_FILES = LICENSE
PYTHON_CONNEXION_DEPENDENCIES = testfixtures pytest-cov pytest mock flask decorator typing pathlib swagger-spec-validator six requests jsonschema inflection clickclick PyYAML
$(eval $(python-package))
