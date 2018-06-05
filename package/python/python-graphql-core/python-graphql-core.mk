################################################################################
#
# python-graphql-core
#
################################################################################

PYTHON_GRAPHQL_CORE_VERSION = 2.0
PYTHON_GRAPHQL_CORE_SOURCE = graphql-core-$(PYTHON_GRAPHQL_CORE_VERSION).tar.gz
PYTHON_GRAPHQL_CORE_SITE = https://files.pythonhosted.org/packages/fb/0a/f4a542c11802a309ad70481d260d3610d1af35b97349a138897c6a27dce0
PYTHON_GRAPHQL_CORE_SETUP_TYPE = setuptools
PYTHON_GRAPHQL_CORE_LICENSE = MIT
PYTHON_GRAPHQL_CORE_LICENSE_FILES = LICENSE

$(eval $(python-package))
