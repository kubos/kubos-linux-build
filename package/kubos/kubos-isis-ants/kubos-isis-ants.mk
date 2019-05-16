###############################################
#
# Kubos ISIS Antenna Systems Service
#
###############################################

KUBOS_ISIS_ANTS_POST_BUILD_HOOKS += ISIS_ANTS_BUILD_CMDS
KUBOS_ISIS_ANTS_POST_INSTALL_TARGET_HOOKS += ISIS_ANTS_INSTALL_TARGET_CMDS
KUBOS_ISIS_ANTS_POST_INSTALL_TARGET_HOOKS += ISIS_ANTS_INSTALL_INIT_SYSV

define ISIS_ANTS_BUILD_CMDS
	cd $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/services/isis-ants-service && \
	PATH=$(PATH):~/.cargo/bin:/usr/bin/iobc_toolchain/usr/bin && \
	CC=$(TARGET_CC) CXX=$(TARGET_CXX) cargo kubos -c build -t $(KUBOS_TARGET) -- --release
endef

# Install the application into the rootfs file system
define ISIS_ANTS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
	$(INSTALL) -D -m 0755 $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/$(CARGO_OUTPUT_DIR)/isis-ants-service \
		$(TARGET_DIR)/usr/sbin
		
    echo 'CHECK PROCESS kubos-isis-ants PIDFILE /var/run/isis-ants-service.pid' > $(TARGET_DIR)/etc/monit.d/kubos-isis-ants.cfg
    echo '    START PROGRAM = "/etc/init.d/S${BR2_KUBOS_ISIS_ANTS_INIT_LVL}kubos-isis-ants start"' >> $(TARGET_DIR)/etc/monit.d/kubos-isis-ants.cfg 
    echo '    IF ${BR2_KUBOS_ISIS_ANTS_RESTART_COUNT} RESTART WITHIN ${BR2_KUBOS_ISIS_ANTS_RESTART_CYCLES} CYCLES THEN TIMEOUT' \
    >> $(TARGET_DIR)/etc/monit.d/kubos-isis-ants.cfg 
endef

# Install the init script
define ISIS_ANTS_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-isis-ants/kubos-isis-ants \
	    $(TARGET_DIR)/etc/init.d/S$(BR2_KUBOS_ISIS_ANTS_INIT_LVL)kubos-isis-ants
endef

$(eval $(virtual-package))