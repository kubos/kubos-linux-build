###############################################
#
# Kubos NSL Duplex Comms Service
#
###############################################

KUBOS_NSL_DUPLEX_DEPENDENCIES = kubos

KUBOS_NSL_DUPLEX_POST_BUILD_HOOKS += NSL_DUPLEX_BUILD_CMDS
KUBOS_NSL_DUPLEX_INSTALL_STAGING = YES
KUBOS_NSL_DUPLEX_POST_INSTALL_STAGING_HOOKS += NSL_DUPLEX_INSTALL_STAGING_CMDS
KUBOS_NSL_DUPLEX_POST_INSTALL_TARGET_HOOKS += NSL_DUPLEX_INSTALL_TARGET_CMDS
KUBOS_NSL_DUPLEX_POST_INSTALL_TARGET_HOOKS += NSL_DUPLEX_INSTALL_INIT_SYSV

define NSL_DUPLEX_BUILD_CMDS
	cd $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/services/nsl-duplex-d2-comms-service && \
	PATH=$(PATH):~/.cargo/bin:/usr/bin/iobc_toolchain/usr/bin && \
	PKG_CONFIG_ALLOW_CROSS=1 CC=$(TARGET_CC) cargo build --package nsl-duplex-d2-comms-service --target $(CARGO_TARGET) --release
endef

# Generate the config settings for the service and add them to a fragment file
define NSL_DUPLEX_INSTALL_STAGING_CMDS
	echo '[nsl-duplex-comms-service.addr]' > $(KUBOS_CONFIG_FRAGMENT_DIR)/nsl-duplex-d2-comms-service
	echo 'ip = ${BR2_KUBOS_NSL_DUPLEX_IP}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/nsl-duplex-d2-comms-service
	echo -e 'port = ${BR2_KUBOS_NSL_DUPLEX_PORT}\n' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/nsl-duplex-d2-comms-service
	echo '[nsl-duplex-comms-service.comms]' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/nsl-duplex-d2-comms-service
	echo 'ip = ${BR2_KUBOS_NSL_DUPLEX_COMMS_IP}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/nsl-duplex-d2-comms-service
	echo 'max_num_handlers = ${BR2_KUBOS_NSL_DUPLEX_HANDLERS}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/nsl-duplex-d2-comms-service
	# KConfig doesn't have a list type, so we're just going to take a string (ex. "[1, 2, 3]") and strip the quotes
	echo 'downlink_ports = $(patsubst "%",%,${BR2_KUBOS_NSL_DUPLEX_DOWNLINK_PORTS})' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/nsl-duplex-d2-comms-service
	echo -e 'timeout = ${BR2_KUBOS_NSL_DUPLEX_TIMEOUT}\n' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/nsl-duplex-d2-comms-service
	echo '[nsl-duplex-comms-service]' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/nsl-duplex-d2-comms-service
	echo 'bus = ${BR2_KUBOS_NSL_DUPLEX_BUS}' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/nsl-duplex-d2-comms-service
	echo -e 'ping_freq = ${BR2_KUBOS_NSL_DUPLEX_PING}\n' >> $(KUBOS_CONFIG_FRAGMENT_DIR)/nsl-duplex-d2-comms-service
endef

# Install the application into the rootfs file system
define NSL_DUPLEX_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
	PATH=$(PATH):~/.cargo/bin:$(HOST_DIR)/usr/bin && \
	arm-linux-strip $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/$(CARGO_OUTPUT_DIR)/nsl-duplex-d2-comms-service
	$(INSTALL) -D -m 0755 $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/$(CARGO_OUTPUT_DIR)/nsl-duplex-d2-comms-service \
		$(TARGET_DIR)/usr/sbin
		
	echo 'CHECK PROCESS nsl-duplex-d2-comms-service PIDFILE /var/run/nsl-duplex-d2-comms-service.pid' > $(TARGET_DIR)/etc/monit.d/kubos-nsl-duplex.cfg
	echo '	START PROGRAM = "/etc/init.d/S${BR2_KUBOS_NSL_DUPLEX_INIT_LVL}kubos-nsl-duplex start"' >> $(TARGET_DIR)/etc/monit.d/kubos-nsl-duplex.cfg 
	echo '	IF ${BR2_KUBOS_NSL_DUPLEX_RESTART_COUNT} RESTART WITHIN ${BR2_KUBOS_NSL_DUPLEX_RESTART_CYCLES} CYCLES THEN TIMEOUT' \
	>> $(TARGET_DIR)/etc/monit.d/kubos-nsl-duplex.cfg
endef

# Install the init script
define NSL_DUPLEX_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-nsl-duplex/kubos-nsl-duplex \
		$(TARGET_DIR)/etc/init.d/S$(BR2_KUBOS_NSL_DUPLEX_INIT_LVL)kubos-nsl-duplex
endef

$(eval $(virtual-package))