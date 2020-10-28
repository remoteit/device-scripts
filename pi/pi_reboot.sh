#!/bin/bash

VERSION="1.0.0"
MODIFIED="Oct 28, 2020"
TOOL_DIR="/usr/bin"

NOTIFIERSCRIPT=connectd_task_notify
. "$TOOL_DIR"/connectd_library

# Clear all status columns A-E in remote.it portal
ret=$(${TOOL_DIR}/${NOTIFIERSCRIPT} a $1 $2 "")
ret=$(${TOOL_DIR}/${NOTIFIERSCRIPT} b $1 $2 "")
ret=$(${TOOL_DIR}/${NOTIFIERSCRIPT} c $1 $2 "")
ret=$(${TOOL_DIR}/${NOTIFIERSCRIPT} d $1 $2 "")
ret=$(${TOOL_DIR}/${NOTIFIERSCRIPT} e $1 $2 "")

###############################################################
# Prepare a folder to store the pi_reboot.sh file in which the
# reboot command is saved.
prepare_and_reboot()
{
if [ ! -d "/root/.remoteit_pi_reboot" ]; then
mkdir "/root/.remoteit_pi_reboot"
fi

# Create the pi_reboot.sh in which reboot command is saved.
# Create the disable bs_r3it_pi_reboot.service to report that the reboot occurred after reboot.
# disable bs_r3it_pi_reboot.service is temporary unit file for systemd.
REBOOTFILE=/root/.remoteit_pi_reboot/pi_reboot.sh
SERVICEFILE=/lib/systemd/system/bs_r3it_pi_reboot.service

echo "#!/bin/bash" > "$REBOOTFILE"
echo "# REBOOT DEVICE" >> "$REBOOTFILE"
echo "sleep 15" >> "$REBOOTFILE"
# say Pi has rebooted
echo "/usr/bin/connectd_task_notify a $1 $2 'Rebooted.'" >> $REBOOTFILE
echo "/usr/bin/connectd_task_notify 1 $1 $2 'Job Complete'" >> $REBOOTFILE
echo "systemctl disable bs_r3it_pi_reboot.service" >> $REBOOTFILE
echo "rm $SERVICEFILE" >> $REBOOTFILE
echo "rm -Rf /root/.remoteit_pi_reboot" >> $REBOOTFILE
chmod +x $REBOOTFILE

echo "[Unit]" > "$SERVICEFILE"
echo "Description=remot3.it Bulk script for reboot" >> "$SERVICEFILE"
echo "After=network.target rc-local.service" >> "$SERVICEFILE"
echo "[Service]" >> "$SERVICEFILE"
echo "Type=simple" >> "$SERVICEFILE"
echo "ExecStart=$REBOOTFILE" >> "$SERVICEFILE"
echo "[Install]" >> "$SERVICEFILE"
echo "WantedBy=multi-user.target" >> "$SERVICEFILE"

sync
sleep 2
systemctl enable bs_r3it_pi_reboot.service
/sbin/reboot
}

echo "--- Reboot Pi ---" > /tmp/"$0".txt

# say rebooting
ret=$(${TOOL_DIR}/connectd_task_notify a $1 $2 "Rebooting... by remote.it Bulk script")

#
prepare_and_reboot $1 $2

