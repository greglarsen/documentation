---
layout: default
title: "HP Helion OpenStack&#174; Edition: VSA Support"
permalink: /helion/openstack/ga/backup.restore/
product: commercial.ga

---
<!--UNDER REVISION-->


<script>

function PageRefresh {
onLoad="window.refresh"
}

PageRefresh();

</script>

<p style="font-size: small;"> <a href="/helion/openstack/install/kvm/">&#9664; PREV</a> | <a href="/helion/openstack/install-overview/">&#9650; UP</a> | <a href="/helion/openstack/install/esx/">NEXT &#9654;</a> </p>


# HP Helion OpenStack&#174; Back Up and Restore

The default HP Helion OpenStack environment consists of a three-node cluster for most of the services and is resilient to individual node failures as well as network split-brain situations.

However, as part of your maintenance of the environment, you should create a back up of each component and be prepared to restore any component, should it become necessary.

**Undercloud.** The undercloud is a critical component that runs the centralized logging, monitoring, and orchestration engine for deployment and configuration automation of the overcloud and also provides DHCP Server for all nodes of the overcloud. 

If the undercloud server fails, it must be rebuilt and restored as quickly as possible.

**Overcloud.** The overcloud includes two overcloud controllers and one overcloud management controller. 

If either of the servers that host the two overcloud controllers fails, the overcloud controller must be rebuilt and reconnected into the cluster as soon as possible.

The management controller is similar to the overcloud controller nodes, but additionally executes various services, including the Compute, Sherpa, Telemetry, Reporting, and Block Storage services. If the server that hosts the overcloud management controller fails, the management controller must be rebuilt and restored as soon as possible.

**Overcloud database** The MySQL database (entire cluster) on the overcloud controllers can become corrupted.  To prevent data loss, backup and restore functionality is provided for the databases. 

The following are instructions for how to back up and restore the seed, undercloud, and overcloud:

- [Create a configuration file for restoring the seed VM and undercloud](#config)
- [Back up and restore the seed VM](#seed)
- [Back up and restore the overcloud](#overcloud)
- [Back up and restore the undercloud](#undercloud)
- [Back up and restore script help](#help)

You execute scripts in the KVM Server, where:

- the seed VM is installed
- the installation files are located

## Create a configuration file for restoring the seed VM and undercloud<a name="config"></a>

A configuration file is required to complete the restore process for the seed VM and undercloud. The configuration file contains parameters created and exported during the installation.

Use the following steps to back up the seed VM:

1. Log in to the seed VM. 

2. Create a configuration file that contains all of the following information:

		export BRIDGE_INTERFACE=<interface>
		export OVERCLOUD_NTP_SERVER=<ntp.server.ip>
		export UNDERCLOUD_NTP_SERVER=<ntp.server.ip>
		export OVERCLOUD_CODN_HTTP_PROXY=http://<proxy.server.ip>
		export OVERCLOUD_CODN_HTTPS_PROXY=http://<proxy.server.ip>
		export UNDERCLOUD_CODN_HTTP_PROXY=http://<proxy.server.ip>
		export UNDERCLOUD_CODN_HTTPS_PROXY=http://<proxy.server.ip>

	Where:
	- BRIDGE_INTERFACE is the name of the device connected to the private network that connects all baremetal nodes. By default `eth0`.
	- OVERCLOUD_NTP_SERVER is the IP address of the NTP server for the overcloud.
	- UNDERCLOUD_NTP_SERVER is the IP address of the NTP server for the overcloud.
	- OVERCLOUD_CODN_HTTP_PROXY is the
	- OVERCLOUD_CODN_HTTPS_PROXY is the
	- UNDERCLOUD_CODN_HTTP_PROXY is the
	- UNDERCLOUD_CODN_HTTPS_PROXY is the
	**QUESTION** What are these fields?


## Back up and restore the seed VM<a name="seed"></a>

The following sections describe how and when to [back up](#seedback) and [restore](#seedrest) the seed VM.

### Backing up the seed VM<a name="seedback"></a> 

You should create a backup from seed VM when any of the events below happen:

- As soon as the whole initial installation is finished (seed/undercloud/overcloud)
- When any change is made in the undercloud from the seed server
- When an undercloud restore process is executed (a new seed will be created)
 
Use the following steps to back up the seed VM:

1. Log in to the seed VM. 

2. Change to the `/root/work/tripleo/tripleo-incubator/scripts/` directory.

		cd /root/work/tripleo/tripleo-incubator/scripts/

3.	Execute the following script:

		./hp_ced_backup.sh --seed -f /root/backup

	A message similar to the following displays:

		HP Helion Community Edition Version Backup Procedure
 
		Destination Host Folder: /root/backup/
		Starting backup procedure for Seed...
		Backup files stored at /root/backup/backup_14-09-02-15-25/seed
		Backup spec file now
		Backup seed.qcow2 now
		Backup ssh keys now
		Backup Seed Finished.
		Backup Procedure Completed

All required files are backed-up to the specified folder:
	`/<destination folder>/backup_YY-MM-DD-HH-MM/seed` 


### Restoring the seed VM<a name="seedrest"></a>

You should restore the seed node when there is any problem with the node, for example:

- The KVM host where the VM was located crashed (hardware/software problem)
- There is any problem with the VM
- There is any problem in the OS level
- There is any problem with the installation that is not fixable

**Important:**

- During the restore process the original seed VM will be deleted from the KVM Host.
- During the backup process, the Seed VM won’t be affected.

Use the following steps to restore the seed VM:

1.	Log in the seed VM. 

2. Create a [configuration file](#config) with all the parameters exported during the installation of the Seed VM (for example: /root/export.prop).

3. Change to the `/root/work/tripleo/tripleo-incubator/scripts/` directory.

		cd /root/work/tripleo/tripleo-incubator/scripts/

3.	Execute the following script:

		./hp_ced_restore.sh --seed -f <location of the backup files>

	When the process is complete, a message similar to the following displays:

		Restore Seed Finished.
		Restore Procedure Completed

	**Example**

	If you enter the command:

		root@kvmhost:~/work/tripleo/tripleo-incubator/scripts# ./hp_ced_restore.sh --seed -f /root/backup/backup_14-09-02-12-32

	The seed VM will respond as follows:


		HP Helion Community Edition Version Restore Procedure

		Source Host Folder: /root/backup/backup_14-09-02-12-32
		Backup from local host. Local Backup Folder is set to: /root/backup/backup_14-09-02-12-32
		Starting restore procedure for Seed...
		Restore spec file from /root/backup/backup_14-09-02-12-32/seed
		…
		…
		Seed VM created with MAC AB:CD:EF:GH:IJ:LM
		…
		…
		Wait for seed up
		…
		…
		Restore Seed Finished.
		Restore Procedure Completed

<a href="#top" style="padding:14px 0px 14px 0px; text-decoration: none;"> Return to Top &#8593; </a>

## Back up and restore the undercloud<a name="under"></a>

The following sections describe how and when to [back up](#underback) and [restore](#underrest) the undercloud.

### Backing up the undercloud<a name="underback"></a>

You should create a backup from undercloud when any of the events below happen:

- The undercloud backup should be done as soon as overcloud is deployed and configured the first time.
- Also when any change is make in the overcloud from the undercloud server

Use the following steps to back up the seed VM:

1.Log in the KVM server.

2. Change to the `/root/work/tripleo/tripleo-incubator/scripts/` directory.

		cd /root/work/tripleo/tripleo-incubator/scripts/

3. Execute the following script: 

		`./hp_ced_backup.sh --undercloud -f <destination folder>`

	When the process is complete, a message similar to the following displays:

		Backup UnderCloud Finished.
		Backup Procedure Completed

**Example**

If you enter the following command:

		root@kvmhost:~/work/tripleo/tripleo-incubator/scripts# ./hp_ced_backup.sh --undercloud -f /root/backup/

The seed VM will respond as follows:
 
		HP Helion Community Edition Version (unknown) Backup Procedure
 
		Destination Host Folder: /root/backup/
		Starting of Backup procedure for Undercloud...
		The backup will be written to /root/backup//backup_14-09-03-12-17
		Temporary folder: /tmp/backup_14-09-03-12-17
		Backing up Seed Files...
		…
		…
		Deleting temporary Undercloud Backup files...
		Warning: Permanently added '192.0.2.2' (ECDSA) to the list of known hosts.
		Backup UnderCloud Finished.
		Backup Procedure Completed

All required files are backed-up to the specified folder:

	/<destination folder>/backup_YY-MM-DD-HH-MM/uc
 
### Restoring the undercloud<a name="underrest"></a>

Use the following steps to restore the seed VM:

- The server where the node was located crashed (hardware/software problem)
- There is any problem in the OS level
- There is any problem with the installation that is not fixable

**Important:**

- During the restore of the undercloud the Seed VM will be deployed again, so it is highly recommend to create a new backup from seed after this procedure.
- During the backup process the undercloud server will be unavailable.
- If the admin user password was changed from the original password created during the installation process, see [Undercloud password issues](#underpass).

Use the following steps to restore the seed VM:

1. Log in the KVM server.

2. Create a [configuration file](#config) with all the parameters that was exported during before the installation of the undercloud node (for example: `/root/export.prop`).

3. Change to the `/root/work/tripleo/tripleo-incubator/scripts/` directory.

		cd /root/work/tripleo/tripleo-incubator/scripts/

4. Create a file called `baremetal.csv` and save to the same location where the script is located.

5. Edit the `baremetal.csv file` and add the line of the physical server that will be used to restore the undercloud.

6. Execute the following script:

		./hp_ced_restore.sh --undercloud -f <source folder> -c <config file>

	When the process is complete, a message similar to the following displays:

		“Restore UnderCloud Finished.”
		“Restore Procedure Completed”

<a href="#top" style="padding:14px 0px 14px 0px; text-decoration: none;"> Return to Top &#8593; </a>

## Back up and restore the overcloud<a name="over"></a>

The following sections describe how and when to back up and restore the overcloud.

You can [back up](#sherpaback) and [restore](#sherparest) the Sherpa overcloud or [back up](#databack) and [restore](#datarest) the overcloud database.

### Backing up the Sherpa overcloud<a name="sherpaback"></a> 

You should create a backup from the overcloud if the event below happens:

- When any Update and Extension is download to the system.

Use the following steps to back up the overcloud:

1. Log in the KVM server.

2. Change to the `/root/work/tripleo/tripleo-incubator/scripts/` directory.

		cd /root/work/tripleo/tripleo-incubator/scripts/

3. Execute the following script: 

		./hp_ced_backup.sh --overcloud -f <destination folder>

	When the process is complete, a message similar to the following displays:

		Backup OverCloud Finished.
		Backup Procedure Completed

	**Example**

		./hp_ced_backup.sh --overcloud -f /root/backup/
 
		HP Helion Community Edition Version Backup Procedure

		Destination Host Folder: /root/backup/
		Starting of Backup procedure for Overcloud...
		The backup will be written to /root/backup/backup_14-09-03-12-30
		…
		…
		Deleting temporary Overcloud Backup files...
		Backup OverCloud Finished.
		Backup Procedure Completed

All required files are backed-up to the specified folder:

	/<destination folder>/backup_YY-MM-DD-HH-MM/oc

### Restoring the Sherpa overcloud<a name="sherparest"></a>

Use the following steps to restore the seed VM:

1. Log in the KVM server

2. CD to “/root/work/tripleo/tripleo-incubator/scripts/” directory

3. Execute the script “./hp_ced_restore.sh --overcloud -f <location of the backup files>”

	When the process is complete, a message similar to the following displays:

		Restore OverCloud Finished.
		Restore Procedure Completed

	**Example**

		./hp_ced_restore.sh --overcloud -f /root/backup/backup_14-09-03-12-30

		HP Helion Community Edition Version Restore Procedure

		Source Host Folder: /root/backup/backup_14-09-03-12-30
		Backup from local host. Local Backup Folder is set to: /root/backup/backup_14-09-03-12-30
		Starting restore procedure for Overcloud...
		Restore source folder: /root/backup/backup_14-09-03-12-30
		Restore name: backup_14-09-03-12-30
		…
		…
		Restore OverCloud Finished.
		Restore Procedure Completed

<a href="#top" style="padding:14px 0px 14px 0px; text-decoration: none;"> Return to Top &#8593; </a>

### Backing up the overcloud database<a name="sherpaback"></a> 

You should create a backup from the overcloud database on a regular basis as determined by the administrator or your organization's policies.

Use the following steps to back up the overcloud:

1. Log in the KVM server.

2. Change to the `/root/work/tripleo/tripleo-incubator/scripts/` directory.

		cd /root/work/tripleo/tripleo-incubator/scripts/

3. Execute the following script: 

		./hp_ced_backup.sh --database -f <destination folder>

	When the process is complete, a message similar to the following displays:

		Backup OverCloud Database Finished.
		Backup Procedure Completed

	**Example**

		./hp_ced_backup.sh --database -f /root/backup/
 
		HP Helion Community Edition Version Backup Procedure
 
		Destination Host Folder: /root/backup/
		Starting of Backup procedure for Overcloud Database...
		The backup will be written to /root/backup/backup_14-09-03-12-46 temporary folder /tmp/backup_14-09-03-12-46
		…
		…
		Deleting temporary Overcloud Database Backup files...
		Backup OverCloud Database Finished.
		Backup Procedure Completed

All required files are backed-up to the specified folder:

		/<destination folder>/backup_YY-MM-DD-HH-MM/db

 

### Restoring the overcloud database<a name="sherparest"></a>

You should restore the overcloud database when there is any problem with the node, for example:

- The whole overcloud crashed (hardware/software problem)
- The database got corrupted for any reason
- An old database need to be recovered for any reason


**Important:**

- During the backup process, the overcloud database server won’t be affected.
- Every time that the overcloud database restore procedure is executed a backup of the current database will be created inside each node and will be located at `/mnt/state/var/lib/mysql_YY-MM-DD-HH-MM`.
- If any problem happens during the restore, the operator can go and manually bring the MySQL cluster back and execute `os-refresh-config` in all the nodes

 
Use the following steps to restore the overcloud database:

1. Log in the KVM server

2. Change to the `/root/work/tripleo/tripleo-incubator/scripts/` directory.

		cd /root/work/tripleo/tripleo-incubator/scripts/

3. Execute the following script: 

		./hp_ced_restore.sh --overcloud -f <location of the backup files>

	When the process is complete, a message similar to the following displays:

		Restore OverCloud Database Finished.
		Restore Procedure Completed

	**Example**

		./hp_ced_restore.sh --database -f /root/backup/backup_14-09-03-12-46
 
		HP Helion Community Edition Version Restore Procedure
 
		Source Host Folder: /root/backup/backup_14-09-03-12-46
		Backup from local host. Local Backup Folder is set to: /root/backup/backup_14-09-03-12-46
		Starting restore procedure for Overcloud Database...
		…
		…
		INFO:os-refresh-config:Completed phase migration
		Restore Procedure Completed


<a href="#top" style="padding:14px 0px 14px 0px; text-decoration: none;"> Return to Top &#8593; </a>

## Back up and restore help<a name="help"></a>

Use the following sections as needed.

## Backup command options ##

The following lists all of the command options for the backup script, `hp_ced_backup.sh`.

		root@kvmhost:~/work/tripleo/tripleo-incubator/scripts# ./hp_ced_backup.sh --help
		HP Helion Community Edition Version Backup Procedure
		Usage: hp_ced_backup.sh [options]
		The Backup tool can back up the following:
			1. Seed
			2. Undercloud
			3. Overcloud
			4. Overcloud Database
		 
		Options:
			[Required]
			-S|--seed       - backups seed
			-U|--undercloud     - backs up undercloud
			-O|--overcloud      - backs up overcloud
			-D|--database       - backs up overcloud database
			-f|--dest-host-folder   - folder path to which to backup
			[Optional]
			-H|--dest-host-ip       - ip of host to which to backup
			-u|--dest-host-user     - username of host to which to backup
			-i|--identity-file      - selects a file from which the identity (private key) for public key authentication is read

## Restore command options ##

The following lists all of the command options for the backup script, `hp_ced_restore.sh`.

		root@kvmhost:~/work/tripleo/tripleo-incubator/scripts# ./hp_ced_restore.sh --help
 
		HP Helion Community Edition Version Restore Procedure
 
		Usage: hp_ced_restore.sh [options]
 
		The Restore tool can restore the following from a previous restore
			1. Seed
			2. UnderCloud
			3. OverCloud
			4. OverCloud Database
 
		Options:
		[Required]
			-S|--seed       - restores seed
			-U|--undercloud     - restores undercloud
			-O|--overcloud      - restores overcloud
			-D|--database       - restores overcloud database
			-f|--source-host-folder     - folder path from which to restore
		[Optional]
			-H|--source-host-ip     - ip of host from which to restore
			-u|--source-host-user   - username of host from which to restore
			-i|--identity-file      - selects a file from which the identity (private key) for public key authentication is read
			-c|--config-file        - Installer will source this config file on the host (and on the seed in case undercloud is being restored)

Other optional options that can be used during the backup/restore process, as:

- Backup/Restore the files in/from a remote server (using option H)
- Backup Seed + Undercloud + … all at once using all the parameters at the same time (--seed, --undercloud --overcloud)

### Undercloud password issues ### {#underpass}

If the admin user password was changed from the original password created during the installation process, before performing the undercloud backup or restore process, you need to update the password in some files. If this process has been done and the files contain the correct password, you do not need to edit the files.

1. Log in the KVM server.
2. SSH to the Seed VM
3. Open the `/root/tripleo/tripleo-undercloud-passwords` file.
4. Update the `UNDERCLOUD_ADMIN_PASSWORD=` line with the new password and save the file.
5. Open the file `/root/tripleo/ce_env.json`. 
6. Update the `undercloud` line with the new password and save the file.
7. SSH to the undercloud server.
8. Open the `/root/stackrc` file.
9. Update the `OS_PASSWORD=` line with the new password and save the file.

<a href="#top" style="padding:14px 0px 14px 0px; text-decoration: none;"> Return to Top &#8593; </a>


----
####OpenStack trademark attribution
*The OpenStack Word Mark and OpenStack Logo are either registered trademarks/service marks or trademarks/service marks of the OpenStack Foundation, in the United States and other countries and are used with the OpenStack Foundation's permission. We are not affiliated with, endorsed or sponsored by the OpenStack Foundation, or the OpenStack community.*