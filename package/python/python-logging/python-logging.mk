################################################################################
#
# python-logging
#
################################################################################

PYTHON_LOGGING_VERSION = 0.4.9.6
PYTHON_LOGGING_SOURCE = logging-$(PYTHON_LOGGING_VERSION).tar.gz
PYTHON_LOGGING_SITE = https://pypi.python.org/packages/93/4b/979db9e44be09f71e85c9c8cfc42f258adfb7d93ce01deed2788b2948919
PYTHON_LOGGING_SETUP_TYPE = distutils
PYTHON_LOGGING_LICENSE = Copyright (C) 2001-2005 by Vinay Sajip. All Rights Reserved. See LICENSE for license.
PYTHON_LOGGING_LICENSE_FILES = LICENSE

$(eval $(python-package))
