################################################################################
#
# python-flask_graphql
#
################################################################################

PYTHON_FLASK_GRAPHQL_VERSION = 1.4.1
PYTHON_FLASK_GRAPHQL_SOURCE = Flask-GraphQL-$(PYTHON_FLASK_GRAPHQL_VERSION).tar.gz
PYTHON_FLASK_GRAPHQL_SITE = https://pypi.python.org/packages/d5/3d/54698202bb63f134e68b1891208cf80021195c9a5d728fd76d21dc8a86c0
PYTHON_FLASK_GRAPHQL_SETUP_TYPE = setuptools
PYTHON_FLASK_GRAPHQL_LICENSE = MIT

$(eval $(python-package))
