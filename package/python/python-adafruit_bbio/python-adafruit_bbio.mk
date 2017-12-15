################################################################################
#
# python-adafruit_bbio
#
################################################################################

PYTHON_ADAFRUIT_BBIO_VERSION = 1.0.9
PYTHON_ADAFRUIT_BBIO_SOURCE = Adafruit_BBIO-$(PYTHON_ADAFRUIT_BBIO_VERSION).tar.gz
PYTHON_ADAFRUIT_BBIO_SITE = https://pypi.python.org/packages/b9/4c/43c4cb8e226aa03e30b17dfbf20ec07bae2e2e16024d3ca2ed8996f260cd
PYTHON_ADAFRUIT_BBIO_SETUP_TYPE = setuptools
PYTHON_ADAFRUIT_BBIO_LICENSE = MIT

$(eval $(python-package))
