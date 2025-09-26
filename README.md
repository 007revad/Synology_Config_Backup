# Synology Config Backup
 Backup and export your Synology DSM configuration.

<a href="https://github.com/007revad/Synology_Config_Backup/releases"><img src="https://img.shields.io/github/release/007revad/Synology_Config_Backup.svg"></a>
![Badge](https://hitscounter.dev/api/hit?url=https%3A%2F%2Fgithub.com%2F007revad%2FSynology_Config_Backup&label=Visitors&icon=github&color=%23198754&message=&style=flat&tz=Australia%2FSydney)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/paypalme/007revad)
[![](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/007revad)
[![committers.top badge](https://user-badge.committers.top/australia/007revad.svg)](https://user-badge.committers.top/australia/007revad)

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

</br>

<p align="left">Viewing the result in "Task Scheduler > select task > Action > View Result > view details"</p>
<p align="left"><img src="/images/result.png"></p>

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

If you set REMOTE2_BACKUP=yes you also need to set the REMOTE2_PORT, REMOTE2_IP, REMOTE2_DIR, LOCAL2_USER and REMOTE2_USER to suit your setup.

**For example:**

```YAML
REMOTE2_PORT=22
REMOTE2_IP=192.168.0.111
REMOTE2_DIR="/volume1/Backups/NAS_System_Backups/DiskStation"
LOCAL2_USER=Bob
REMOTE2_USER=Ted
```

### Requirements

If you want to schedule the script to run unattended, and have the script copy the backup to another server you need to have SSH keys setup so SCP can access the remote server without you entering the user's password.

See https://github.com/007revad/Synology_SSH_key_setup for steps on setting up SSH key authentication.

**Note:** Due to some of the commands used **this script needs to be run as root, or be scheduled to run as root**.

### Download the script

1. Download the latest version _Source code (zip)_ from https://github.com/007revad/Synology_Config_Backup/releases
2. Save the download zip file to a folder on the Synology.
3. Unzip the zip file.

### Scheduling the script in Synology's Task Scheduler

See <a href=how_to_schedule.md/>How to schedule a script in Synology Task Scheduler</a>

### Running the script via SSH

[How to enable SSH and login to DSM via SSH](https://kb.synology.com/en-global/DSM/tutorial/How_to_login_to_DSM_with_root_permission_via_SSH_Telnet)

You run the script in a shell with sudo -s or as root.

```YAML
sudo -s /path-to-script/synology_config_backup.sh
```

**Note:** Replace /path-to-script/ with the actual path to the script on your Synology.
