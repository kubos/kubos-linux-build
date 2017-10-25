################################################################################
#
# python-graphene-sqlalchemy
#
################################################################################

PYTHON_GRAPHENE_SQLALCHEMY_VERSION = 1.1.1
PYTHON_GRAPHENE_SQLALCHEMY_SOURCE = graphene-sqlalchemy-$(PYTHON_GRAPHENE_SQLALCHEMY_VERSION).tar.gz
PYTHON_GRAPHENE_SQLALCHEMY_SITE = https://pypi.python.org/packages/f7/15/89c38483f2fe90834b1ecc0fd7935bcac3e1b880fee1fc3d8da3475e0df9
PYTHON_GRAPHENE_SQLALCHEMY_SETUP_TYPE = setuptools
PYTHON_GRAPHENE_SQLALCHEMY_LICENSE = MIT
PYTHON_GRAPHENE_SQLALCHEMY_LICENSE_FILES = LICENSE

$(eval $(python-package))
