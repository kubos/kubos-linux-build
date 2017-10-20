################################################################################
#
# python-graphql-server-core
#
################################################################################

PYTHON_GRAPHQL_SERVER_CORE_VERSION = 1.0.dev20170322001
PYTHON_GRAPHQL_SERVER_CORE_SOURCE = graphql-server-core-$(PYTHON_GRAPHQL_SERVER_CORE_VERSION).tar.gz
PYTHON_GRAPHQL_SERVER_CORE_SITE = https://pypi.python.org/packages/80/ee/cd118bdcf6a2d9e731a0e1d758e8ed6ac8fc3a0f9475a7035f66c50d255c
PYTHON_GRAPHQL_SERVER_CORE_SETUP_TYPE = setuptools
PYTHON_GRAPHQL_SERVER_CORE_LICENSE = MIT

$(eval $(python-package))
