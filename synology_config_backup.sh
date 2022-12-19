#!/usr/bin/env bash
#--------------------------------------------------------------------------
# Backup Synology system configuration and copy backup to another NAS
#         Must be run as root or scheduled to run as root
#
# Works on DMS 7 and DSM 6
#
# Author: 007revad
# Date/Version: 2022-12-19 v1.0.1
#
# Github: https://github.com/007revad/Synology_Config_Backup
# Script verified at https://www.shellcheck.net/
#--------------------------------------------------------------------------

# Required Setting:

# Set where to save the exported configuration file
TARGET_DIR=


# Optional Remote Backup Settings:

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
#                 Nothing below here should need changing
#--------------------------------------------------------------------------

# Set backup filename

# Append date and time to backup file
FILE_NAME="$( hostname )_$( date +%F_%H%M ).dss"


#--------------------------------------------------------------------------
# Check that script is running as root

if [[ $( whoami ) != "root" ]]; then
	echo -e "\nERROR: This script must be run as root!\nERROR: $( whoami ) is not root. Aborting.\n"
	# Abort script because it isn't being run by root
	exit 255
fi


#--------------------------------------------------------------------------
# Export Synology configuration to a Synology directory

echo -e "Starting backup of Synology configuration on $( hostname )\n"

if [[ ! -d $TARGET_DIR ]]; then
	echo -e "\nBackup path does not exist:\n${TARGET_DIR}"
	exit 255
fi

cd "${TARGET_DIR}" || exit 255
/usr/syno/bin/synoconfbkp export --filepath="${TARGET_DIR}/${FILE_NAME}"

# Check exported file exists
if [[ ! -f ${TARGET_DIR}/${FILE_NAME} ]]; then
	echo -e "ERROR: Backup file not created:\n${TARGET_DIR}/${FILE_NAME}"
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
		echo -e "\nCopying backup to ${REMOTE_HOST}"
	else
		echo -e "\nCopying backup to ${REMOTE_IP}"
	fi
	# Push backup to other device (safer for other device to pull backup from read only share)
	sudo -u "${LOCAL_USER}" scp -P "${REMOTE_PORT}" "${TARGET_DIR}/${FILE_NAME}" "${REMOTE_USER}@${REMOTE_IP}:${REMOTE_DIR}/"
fi


#--------------------------------------------------------------------------
# Finished

echo -e "\nSynology configuration backup complete"

exit
