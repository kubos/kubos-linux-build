################################################################################
#
# python-graphene
#
################################################################################

PYTHON_GRAPHENE_VERSION = 2.1.1
PYTHON_GRAPHENE_SOURCE = graphene-$(PYTHON_GRAPHENE_VERSION).tar.gz
PYTHON_GRAPHENE_SITE = https://files.pythonhosted.org/packages/e9/20/bb11dfc4d270e60758da17ef53b9a6722dacd1c175bcf0789803eab9537e
PYTHON_GRAPHENE_SETUP_TYPE = setuptools
PYTHON_GRAPHENE_LICENSE = MIT
PYTHON_GRAPHENE_LICENSE_FILES = LICENSE

$(eval $(python-package))
