#!/bin/sh
# Enable the Pumpkin stack's WDT gate, so that the MBM2 is
# also rebooted when the watchdog is starved
#
# GPIO46 -> GPIO1_14

# Wait 10 seconds to make sure the supervisor is completely
# initialized
sleep 10

# Set the gating pin as an output
echo 46 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio46/direction

# Toggle it a few times to get the supervisor's attention
echo 1 > /sys/class/gpio/gpio46/value
echo 0 > /sys/class/gpio/gpio46/value
echo 1 > /sys/class/gpio/gpio46/value
echo 0 > /sys/class/gpio/gpio46/value
echo 1 > /sys/class/gpio/gpio46/value
echo 0 > /sys/class/gpio/gpio46/value

# Leave the signal high
echo 1 > /sys/class/gpio/gpio46/value

exit 0
