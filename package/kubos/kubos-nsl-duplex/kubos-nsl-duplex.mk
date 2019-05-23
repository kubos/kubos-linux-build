###############################################
#
# Kubos NSL Duplex Comms Service
#
###############################################

KUBOS_NSL_DUPLEX_DEPENDENCIES = kubos

KUBOS_NSL_DUPLEX_POST_BUILD_HOOKS += NSL_DUPLEX_BUILD_CMDS
KUBOS_NSL_DUPLEX_POST_INSTALL_TARGET_HOOKS += NSL_DUPLEX_INSTALL_TARGET_CMDS
KUBOS_NSL_DUPLEX_POST_INSTALL_TARGET_HOOKS += NSL_DUPLEX_INSTALL_INIT_SYSV

define NSL_DUPLEX_BUILD_CMDS
	cd $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/services/nsl-duplex-d2-comms-service && \
	PATH=$(PATH):~/.cargo/bin:/usr/bin/iobc_toolchain/usr/bin && \
	PKG_CONFIG_ALLOW_CROSS=1 CC=$(TARGET_CC) cargo build --target $(CARGO_TARGET) --release
endef

# Install the application into the rootfs file system
define NSL_DUPLEX_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
	$(INSTALL) -D -m 0755 $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/$(CARGO_OUTPUT_DIR)/nsl-duplex-d2-comms-service \
		$(TARGET_DIR)/usr/sbin
		
    echo 'CHECK PROCESS nsl-duplex-d2-comms-service PIDFILE /var/run/nsl-duplex-d2-comms-service.pid' > $(TARGET_DIR)/etc/monit.d/kubos-nsl-duplex.cfg
    echo '    START PROGRAM = "/etc/init.d/S${BR2_KUBOS_NSL_DUPLEX_INIT_LVL}kubos-nsl-duplex start"' >> $(TARGET_DIR)/etc/monit.d/kubos-nsl-duplex.cfg 
    echo '    IF ${BR2_KUBOS_NSL_DUPLEX_RESTART_COUNT} RESTART WITHIN ${BR2_KUBOS_NSL_DUPLEX_RESTART_CYCLES} CYCLES THEN TIMEOUT' \
    >> $(TARGET_DIR)/etc/monit.d/kubos-nsl-duplex.cfg
endef

# Install the init script
define NSL_DUPLEX_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-nsl-duplex/kubos-nsl-duplex \
	    $(TARGET_DIR)/etc/init.d/S$(BR2_KUBOS_NSL_DUPLEX_INIT_LVL)kubos-nsl-duplex
endef

$(eval $(virtual-package))