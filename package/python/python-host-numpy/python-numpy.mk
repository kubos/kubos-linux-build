################################################################################
#
# python-numpy
#
################################################################################

HOST_PYTHON_HOST_NUMPY_VERSION = 1.15.1
HOST_PYTHON_HOST_NUMPY_SOURCE = numpy-$(HOST_PYTHON_HOST_NUMPY_VERSION).tar.gz
HOST_PYTHON_HOST_NUMPY_SITE = https://github.com/numpy/numpy/releases/download/v$(HOST_PYTHON_HOST_NUMPY_VERSION)
HOST_PYTHON_HOST_NUMPY_LICENSE = BSD-3-Clause
HOST_PYTHON_HOST_NUMPY_LICENSE_FILES = LICENSE.txt
HOST_PYTHON_HOST_NUMPY_SETUP_TYPE = setuptools

ifeq ($(BR2_PACKAGE_CLAPACK),y)
HOST_PYTHON_HOST_NUMPY_DEPENDENCIES += clapack
HOST_PYTHON_HOST_NUMPY_SITE_CFG_LIBS += blas lapack
else
HOST_PYTHON_HOST_NUMPY_ENV += BLAS=None LAPACK=None
endif

HOST_PYTHON_HOST_NUMPY_BUILD_OPTS = --fcompiler=None

define HOST_PYTHON_HOST_NUMPY_CONFIGURE_CMDS
	-rm -f $(@D)/site.cfg
	echo "[DEFAULT]" >> $(@D)/site.cfg
	echo "library_dirs = $(STAGING_DIR)/usr/lib" >> $(@D)/site.cfg
	echo "include_dirs = $(STAGING_DIR)/usr/include" >> $(@D)/site.cfg
	echo "libraries =" $(subst $(space),$(comma),$(HOST_PYTHON_HOST_NUMPY_SITE_CFG_LIBS)) >> $(@D)/site.cfg
endef

# Some package may include few headers from NumPy, so let's install it
# in the staging area.
HOST_PYTHON_HOST_NUMPY_INSTALL_STAGING = YES

$(eval $(host-python-package))
