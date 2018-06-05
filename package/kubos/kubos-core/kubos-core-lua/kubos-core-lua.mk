#####################################################
#
# Kubos Lua Package Installation
#
#####################################################
KUBOS_CORE_LUA_VERSION = $(call qstrip,$(BR2_KUBOS_VERSION))
KUBOS_CORE_LUA_LICENSE = Apache-2.0
KUBOS_CORE_LUA_LICENSE_FILES = LICENSE
KUBOS_CORE_LUA_SITE = $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-core/kubos-core-lua
KUBOS_CORE_LUA_SITE_METHOD = file
KUBOS_CORE_LUA_SOURCE = kubos-core-lua.tar.gz

# Install the files
define KUBOS_CORE_LUA_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
	cp -R $(@D)/bin $(TARGET_DIR)/usr
	cp -R $(@D)/init.d $(TARGET_DIR)/etc
	cp $(@D)/comms.toml $(TARGET_DIR)/etc
endef

$(eval $(generic-package))

kubos-core-lua-fullclean: kubos-core-lua-clean-for-reconfigure kubos-core-lua-dirclean
	rm -f $(DL_DIR)/kubos-core-lua.tar.gz