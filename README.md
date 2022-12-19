# Synology_Config_Backup
 Backup and export your Synology DSM configuration.

<a href="https://github.com/007revad/Synology_Config_Backup/releases"><img src="https://img.shields.io/github/release/007revad/Synology_Config_Backup.svg"></a>
<a href="https://hits.seeyoufarm.com"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2F007revad%2FSynology_Config_Backup&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false"/></a>

### Description

This is a bash script to backup a Synology's System Config, and optionally copy it via SCP to another server.

Works on DSM 7 and DSM 6

#### What the script does:

* Gets your Synology's hostname and the date for use in the backup filename.
  * The Synology's hostname is included in the backup's filename in case you have multiple Synology's.
* Checks that the script is running as root.
* Checks that your specified backup location exists.
* Exports the system config to your specified folder.
* If REMOTE_BACKUP=yes copies the backup to the specified remote server.

**Example of the backup's auto-generated filename:** DISKSTATION_2022-11-07_0600.dss

### Settings

You need to set **TARGET_DIR=** near the top of the script (below the header). Set it to the location where you want the backup saved to. 

You also need to set **REMOTE_BACKUP=** to yes if you want to copy the backup to a remote server.

**For example:**

```YAML
TARGET_DIR="/volume1/Backups/NAS_System_Backups/DiskStation"
REMOTE_BACKUP=yes
```

#### Extra settings for copying the backup to a remote server

If you set REMOTE_BACKUP=yes you also need to set the REMOTE_PORT, REMOTE_IP, REMOTE_DIR, LOCAL_USER and REMOTE_USER to suit your setup.

**For example:**

```YAML
REMOTE_PORT=22
REMOTE_IP=192.168.0.100
REMOTE_DIR="/volume1/Backups/NAS_System_Backups/DiskStation"
LOCAL_USER=Bob
REMOTE_USER=Bob
```

### Requirements

If you want to schedule the script to run unattended, and have the script copy the backup to another server you need to have SSH keys setup so SCP can access the remote server without you entering the user's password.

**Note:** Due to some of the commands used **this script needs to be run as root, or be scheduled to run as root**.
