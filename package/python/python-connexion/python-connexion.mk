################################################################################
#
# python-connexion
#
################################################################################

PYTHON_CONNEXION_VERSION = 1.2
PYTHON_CONNEXION_SOURCE = connexion-$(PYTHON_CONNEXION_VERSION).tar.gz
PYTHON_CONNEXION_SITE = https://pypi.python.org/packages/cc/7b/7206d546e27dbcbbbd88feb97cee99093274c3b46f705e7e60e632abe976
PYTHON_CONNEXION_SETUP_TYPE = setuptools
PYTHON_CONNEXION_LICENSE = Apache License Version 2.0
PYTHON_CONNEXION_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
