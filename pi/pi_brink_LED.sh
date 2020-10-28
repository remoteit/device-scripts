#!/bin/bash

VERSION="1.0.0"
MODIFIED="Oct 28, 2020"
TOOL_DIR="/usr/bin"

if [ -e "$TOOL_DIR"/task_notify.sh ]; then
    NOTIFIERSCRIPT=task_notify.sh
    PACKAGE=weavedconnectd
    . "$TOOL_DIR"/weavedlibrary
    platformDetection
elif [ -e "$TOOL_DIR"/connectd_task_notify ]; then
    NOTIFIERSCRIPT=connectd_task_notify
    PACKAGE=connectd
    . "$TOOL_DIR"/connectd_library
fi

# Clear all status columns A-E in remote.it portal
ret=$(${TOOL_DIR}/${NOTIFIERSCRIPT} a $1 $2 "")
ret=$(${TOOL_DIR}/${NOTIFIERSCRIPT} b $1 $2 "")
ret=$(${TOOL_DIR}/${NOTIFIERSCRIPT} c $1 $2 "")
ret=$(${TOOL_DIR}/${NOTIFIERSCRIPT} d $1 $2 "")
ret=$(${TOOL_DIR}/${NOTIFIERSCRIPT} e $1 $2 "")

#-------------------------------------------------
# Update status column A (StatusA) in remote.it portal
#-------------------------------------------------
# Blink the green LED every second for 10 seconds
echo timer > /sys/class/leds/led0/trigger
# send to status column A in remote.it portal
ret=$(${TOOL_DIR}/${NOTIFIERSCRIPT} a $1 $2 "Green LED is blinking")
sleep 10

# Stop the blinking
echo mmc0 > /sys/class/leds/led0/trigger
# Clear status columns A in remote.it portal
ret=$(${TOOL_DIR}/${NOTIFIERSCRIPT} a $1 $2 "")
# send to status column A in remote.it portal
ret=$(${TOOL_DIR}/${NOTIFIERSCRIPT} a $1 $2 "Blinking was stopped")

# Lastly finalize job, no updates allowed after this
ret=$(${TOOL_DIR}/${NOTIFIERSCRIPT} 1 $1 $2 "Job complete")

