################################################################################
#
# python-graphql-core
#
################################################################################

PYTHON_GRAPHQL_CORE_VERSION = 1.1
PYTHON_GRAPHQL_CORE_SOURCE = graphql-core-$(PYTHON_GRAPHQL_CORE_VERSION).tar.gz
PYTHON_GRAPHQL_CORE_SITE = https://pypi.python.org/packages/b0/89/00ad5e07524d8c523b14d70c685e0299a8b0de6d0727e368c41b89b7ed0b
PYTHON_GRAPHQL_CORE_SETUP_TYPE = setuptools
PYTHON_GRAPHQL_CORE_LICENSE = MIT
PYTHON_GRAPHQL_CORE_LICENSE_FILES = LICENSE

$(eval $(python-package))
