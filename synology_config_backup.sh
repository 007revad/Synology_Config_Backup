#!/usr/bin/env bash
#--------------------------------------------------------------------------
# Backup Synology system configuration and copy backup to another NAS
#      Must be run as root or scheduled to run as root
#
# Tested on: DSM 6.2.4-25556 Update 6 (should work on DSM 7)
#
# Author: 007revad
# Date/Version: 2022-11-05 v5.0
#
# Gist on Github: https://gist.github.com/007revad
# Script verified at https://www.shellcheck.net/
#--------------------------------------------------------------------------

# Set where to save the exported configuration file
TARGET_DIR=


# Set to yes to enable remote backup. Anything else = no
REMOTE_BACKUP=yes

# Where to copy the exported configuration file to
REMOTE_PORT=22
REMOTE_IP=
REMOTE_DIR=

# Local and remote users with SSH key setup
LOCAL_USER=
REMOTE_USER=


#--------------------------------------------------------------------------
#               Nothing below here should need changing
#--------------------------------------------------------------------------

# Set backup filename

# Append date and time to backup file
FILE_NAME="$( hostname )_$( date +%F_%H%M ).dss"


#--------------------------------------------------------------------------
# Check that script is running as root

if [[ $( whoami ) != "root" ]]; then
	echo
	echo ERROR: This script must be run as root!
	echo ERROR: "$( whoami )" is not root. Aborting.
	echo
	# Abort script because it isn't being run by root
	exit 255
fi
#echo "Script running as $( whoami )" #debug


#--------------------------------------------------------------------------
# Export Synology configuration to a Synology directory

echo "Starting backup of Synology configuration on $( hostname )"
echo

if [[ ! -d $TARGET_DIR ]]; then
	echo "Backup path does not exist:"
	echo "${TARGET_DIR}"
	exit 255
fi
#echo "${TARGET_DIR} exists." #debug

cd "${TARGET_DIR}"
/usr/syno/bin/synoconfbkp export --filepath="${TARGET_DIR}/${FILE_NAME}"

# Check exported file exists
if [[ ! -f ${TARGET_DIR}/${FILE_NAME} ]]; then
	echo "Backup file does not exist:"
	echo "${TARGET_DIR}/${FILE_NAME}"
	exit 255
else
	#echo "Synology configuration exported to $FILE_NAME on $( hostname )"
	#echo "Exported Synology configuration on $( hostname )"
	echo "Export successful on $( hostname )"
fi


#--------------------------------------------------------------------------
# Copy backup to remote NAS

# Get remote NAS hostname
REMOTE_HOST=$(nmblookup -A $REMOTE_IP | sed -n 2p | cut -d ' ' -f1)
REMOTE_HOST="${REMOTE_HOST:1}"

if [[ $REMOTE_BACKUP == "yes" ]]; then
	#echo "Copying backup to other device"
	if [[ $REMOTE_HOST ]]; then
		echo
		echo "Copying backup to ${REMOTE_HOST}"
	else
		echo
		echo "Copying backup to ${REMOTE_IP}"
	fi
	# Push backup to other device (safer for other device to pull backup from read only share)
	sudo -u "${LOCAL_USER}" scp -P "${REMOTE_PORT}" "${TARGET_DIR}/${FILE_NAME}" "${REMOTE_USER}@${REMOTE_IP}:${REMOTE_DIR}/"
fi


#--------------------------------------------------------------------------
# Finished

echo
#echo "Settings backup completed."
echo "Synology configuration backup complete"

exit

