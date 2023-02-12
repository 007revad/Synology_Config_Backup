#!/usr/bin/env bash
#--------------------------------------------------------------------------
# Backup Synology system configuration and copy backup to another NAS
#         Must be run as root or scheduled to run as root
#
# Works on DMS 7 and DSM 6
#
# Author: 007revad
# Date/Version: 2023-02-12 v1.0.3
#
# Github: https://github.com/007revad/Synology_Config_Backup
# Script verified at https://www.shellcheck.net/
#--------------------------------------------------------------------------

# Required Setting:

# Set where to save the exported configuration file
Target_DIR=


# Optional Remote Backup Settings:

# Set to yes to enable remote backup. Anything else = no
Remote_Backup=

# Where to copy the exported configuration file to
Remote_Port=22
Remote_IP=
Remote_DIR=

# Local and remote users with SSH key setup
Local_User=
Remote_User=


#--------------------------------------------------------------------------
#                 Nothing below here should need changing
#--------------------------------------------------------------------------

# Set backup filename

# Append date and time to backup file
File_Name="$( hostname )_$( date +%F_%H%M ).dss"


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

if [[ ! -d $Target_DIR ]]; then
	echo -e "\nBackup path does not exist:\n${Target_DIR}"
	exit 255
fi

cd "${Target_DIR}" || exit 255
/usr/syno/bin/synoconfbkp export --filepath="${Target_DIR}/${File_Name}"

# Check exported file exists
if [[ ! -f ${Target_DIR}/${File_Name} ]]; then
	echo -e "ERROR: Backup file not created:\n${Target_DIR}/${File_Name}"
	exit 255
else
	#echo "Synology configuration exported to $File_Name on $( hostname )"
	#echo "Exported Synology configuration on $( hostname )"
	echo "Export successful on $( hostname )"
fi


#--------------------------------------------------------------------------
# Check if running on DSM 7 and target is is DSM 6

# Get local DSM major version
if [[ -f /etc/synoinfo.conf ]]; then Dsm_Local="$(get_key_value /etc.defaults/VERSION majorversion)"; fi

# Get remote DSM major version
ssh "${Remote_User}@${Remote_IP}" -p "$Remote_Port" "sudo Dsm_Remote=$(get_key_value /etc.defaults/VERSION majorversion)"


#--------------------------------------------------------------------------
# Copy backup to remote NAS

# Get remote NAS hostname
Remote_Host=$(nmblookup -A $Remote_IP | sed -n 2p | cut -d ' ' -f1)
Remote_Host="${Remote_Host:1}"

# Get local DSM major version
Dsm_Local=$(get_key_value /etc.defaults/VERSION majorversion)

if [[ $Remote_Backup == "yes" ]]; then
	#echo "Copying backup to other device"
	if [[ $Remote_Host ]]; then
		echo -e "\nCopying backup to ${Remote_Host}"
	else
		echo -e "\nCopying backup to ${Remote_IP}"
	fi
	# Push backup to other device (safer for other device to pull backup from read only share)
    if [[ $Dsm_Local == 7 ]]; then
        # -O flag is required if DSM7 is the source or SCP defaults to SFTP
        sudo -u "${Local_User}" scp -O -P "${Remote_Port}" "${Target_DIR}/${File_Name}" "${Remote_User}@${Remote_IP}:${Remote_DIR}/"
    else
        sudo -u "${Local_User}" scp -P "${Remote_Port}" "${Target_DIR}/${File_Name}" "${Remote_User}@${Remote_IP}:${Remote_DIR}/"
    fi
fi


#--------------------------------------------------------------------------
# Finished

echo -e "\nSynology configuration backup complete"

exit
