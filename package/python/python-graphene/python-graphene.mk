################################################################################
#
# python-graphene
#
################################################################################

PYTHON_GRAPHENE_VERSION = 1.4.1
PYTHON_GRAPHENE_SOURCE = graphene-$(PYTHON_GRAPHENE_VERSION).tar.gz
PYTHON_GRAPHENE_SITE = https://pypi.python.org/packages/3a/12/04b4b89eec5f5dd97d06c2143e5db3ec0801f4b940e69db072dd89de8514
PYTHON_GRAPHENE_SETUP_TYPE = setuptools
PYTHON_GRAPHENE_LICENSE = MIT
PYTHON_GRAPHENE_LICENSE_FILES = LICENSE

$(eval $(python-package))
