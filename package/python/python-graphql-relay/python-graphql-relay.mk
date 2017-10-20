################################################################################
#
# python-graphql-relay
#
################################################################################

PYTHON_GRAPHQL_RELAY_VERSION = 0.4.5
PYTHON_GRAPHQL_RELAY_SOURCE = graphql-relay-$(PYTHON_GRAPHQL_RELAY_VERSION).tar.gz
PYTHON_GRAPHQL_RELAY_SITE = https://pypi.python.org/packages/5e/b0/b91fadc180544fc9e3c156d7049561fd5f1e2211d26fd29033548fd50934
PYTHON_GRAPHQL_RELAY_SETUP_TYPE = setuptools
PYTHON_GRAPHQL_RELAY_LICENSE = MIT

$(eval $(python-package))
