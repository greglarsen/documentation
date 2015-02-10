---
layout: default
title: "HP Helion OpenStack&#174; Edition: HP Helion Ceph"
permalink: /helion/openstack/ceph-manual-install/
product: commercial

---
<!--UNDER REVISION-->


<script>

function PageRefresh {
onLoad="window.refresh" 
}

PageRefresh();

</script>
<!--
<p style="font-size: small;"> <a href="/helion/openstack/install-beta/kvm/">&#9664; PREV</a> | <a href="/helion/openstack/install-beta-overview/">&#9650; UP</a> | <a href="/helion/openstack/install-beta/esx/">NEXT &#9654;</a> </p>--->


##Manually Installing Ceph in a HP Helion OpenStack 1.1 Environment

The Ceph cluster requires at least one monitor, and at least three, or as many OSDs as there are copies of an object stored on the cluster - whichever is greater. For more details, refer to http://docs.ceph.com/docs/master/install/manual-deployment/.

This section includes the following topics:

* [Setting up the Monitor Node](#setting-up-monitor-nodes)
* [Adding OSDs](#adding-osd)
* [File System Tuning](#file-system-tunning)
* [Setting up additional Monitor nodes](#setting-up-additional-nodes)

###Assumptions and Dependencies

* These instructions apply to the manual installation and deployment of Ceph Firefly 0.80.7.

* The operating system on Ceph nodes is hlinux 3.14.6-2-amd64-hlinux.

####Setting up the Monitor Node {#setting-up-monitor-nodes}

Bootstrap the initial monitor(s) to deploying a Ceph Storage cluster by performing the following steps:

1. Log into monitor node as a root.

2. Execute `apt-get install ceph`.

3. To generate a unique **fsid**, enter: 

	`uuidgen`

4. Create the  `ceph.conf` file in the `/etc/ceph` directory as shown in the following example:
		[global]
		
		fsid = 498afec5-57f0-4e48-9cf7-c8a5b89c1c80
		
		mon_initial_members = ceph-mon1 - monitor host name
		
		mon_host = 192.x.x.x - monitor IP
		
		auth_cluster_required = cephx
		
		auth_service_required = cephx
		
		auth_client_required = cephx
		
		filestore_xattr_use_omap = true
		
		osd journal size = 1024

5. Create a keyring for the cluster and generate a secret key for the monitor by entering.

		ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'
		
		ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'

6. Create an admin keyring, an admin user, and add the user to the keyring by entering.

		ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --set-uid=0 --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow'
		
		ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --set-uid=0 --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow'

7.  Add the `cleint.admin` key to the `ceph.mon.keyring` by entering:

		ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring
		
		ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring
		
8. Generate a monitor map using the monitor hostname, IP and fsid and save it as `/tmp/monmap` by entering:
		
		monmaptool --create --add {hostname} {ip-address} --fsid {uuid} /tmp/monmap
		monmaptool --create --add ceph-mon1 192.x.x.x --fsid 498afec5-57f0-4e48-9cf7-c8a5b89c1c80 /tmp/monmap

9.  Create a default data directory by entering:

		sudo mkdir /var/lib/ceph/mon/{cluster-name}-{hostname}
		mkdir /var/lib/ceph/mon/ceph-ceph-mon1

10. Populate the monitor daemon with the monitor map and keyring by entering.

		ceph-mon --mkfs -i {hostname} --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring
		ceph-mon --mkfs -i mon1 --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring

11. Touch the completed file by entering.

		sudo touch /var/lib/ceph/mon/{cluster-name}-{hostname}/upstart
		
		touch /var/lib/ceph/mon/ceph-ceph-mon1/done

12. Verify that the monitor daemon is running and verifying output by entering:

		ps aux | grep ceph

13. Update the `ceph.conf` file as shown below:

		[mon.ceph-mon1]
		
		host = ceph-mon1
		
		mon addr = 192.x.x.x

14. Start monitor daemon by entering:

		sudo /etc/init.d/ceph start mon.node1
		
		/etc/init.d/ceph start mon.ceph-mon1

15. Restart the monitor daemon by entering:

		/etc/init.d/ceph restart mon.ceph-mon1

16. Verify that the Ceph default pools are created as shown below:

		ceph osd lspools
		0 data, 1 metadata, 2rbd,

17. Verify that the monitor is running by entering:

		ceph -s

		root@ceph-mon1gw1:/var/lib/ceph/mon# ceph -s
		cluster e0f2ad6b-588f-432c-99c1-d81f0f71cb77
		health HEALTH_ERR 192 pgs stuck inactive; 192 pgs stuck unclean; no osds
		monmap e1: 1 mons at {ceph-mon1gw1=192.168.116.54:6789/0}, election epoch 2, quorum 0
		ceph-mon1gw1
		osdmap e1: 0 osds: 0 up, 0 in
		pgmap v2: 192 pgs, 3 pools, 0 bytes data, 0 objects
			0 kB used, 0 kB / 0 kB avail
			192 creating

###Adding Object Storage Daemons (OSDs) {#adding-osd}

Once you have your initial monitor(s) running, you must add OSDs. To make a cluster reach an active and clean state, you must have enough OSDs to handle the number of copies of an object (for example, osd pool default size = 4 requires at least four OSDs).  It is recommend to have  a minimum of three OSD nodes in a production environment. After bootstrapping your monitor, your cluster has a default CRUSH map. However, the CRUSH map does not have any Ceph OSD Daemons mapped to a Ceph Node. For more details, refer to [http://ceph.com/docs/maste/install/manual-deployment/](http://ceph.com/docs/master/install/manual-deployment/)

####Pre-requisites

* Ceph cluster OS - hlinux 3.14.6-2 kernel version

* Ceph cluster and client nodes - Ceph version 0.80.7

* 3 OSD nodes with individual drives other than OS drive on each of the nodes.

* For performance reasons it is recommended to have **SSD** drive for Journal partition on the OSD nodes. 

####Setting up the OSD Node

To create an OSD and add it to cluster and CRUSH map perform the following steps.

1. Log into the OSD host as root. Connect to the OSD node by entering:

		ssh [node-name]

2. Create the OSD by entering: 

		ceph osd create

 	Note the OSD number. 

	For multiple physical drives, execute  `ceph OSD create` command the as many times as the  number of OSDs.

3. Consider the output of the OSD number from the previous step and create a default directory by executing entering:

		mkdir /var/lib/ceph/osd/ceph-{osd-number}

	For example: `mkdir /var/lib/ceph/osd/ceph-0`

	The following example displays the commands ran in the script to create 13 directories matching the `osd` deamon

		#!/bin/bash
		
		mkdir /var/lib/ceph/osd/ceph-0
		mkdir /var/lib/ceph/osd/ceph-1
		mkdir /var/lib/ceph/osd/ceph-2
		mkdir /var/lib/ceph/osd/ceph-3
		mkdir /var/lib/ceph/osd/ceph-4
		mkdir /var/lib/ceph/osd/ceph-5
		mkdir /var/lib/ceph/osd/ceph-6
		mkdir /var/lib/ceph/osd/ceph-7
		mkdir /var/lib/ceph/osd/ceph-8
		mkdir /var/lib/ceph/osd/ceph-9
		mkdir /var/lib/ceph/osd/ceph-10
		mkdir /var/lib/ceph/osd/ceph-11
		mkdir /var/lib/ceph/osd/ceph-12

If you have SSD drives on your OSD node, you can use them for Journal partitioning. You can have Raid1 with two SSD drives. 

Follow the server-specific specifications to configure RAIDs.

**Creating journal partitions on an SSD drive. You can follow this for any non-SSD drive if you do not have SSD drives in your setup.**
	
The following example explains the creation of journal partitions on a 200G SSD drive to match the OSD deamon counts.

1. Log into OSD and enter:

		/etc/ceph# fdisk /dev/sda
		Command (m for help): p
		Disk /dev/sda: 200.0 GB, 199992852480 bytes
		255 heads, 63 sectors/track, 24314 cylinders, total 390611040 sectors
		Units = sectors of 1 * 512 = 512 bytes
		Sector size (logical/physical): 512 bytes / 512 bytes
		I/O size (minimum/optimal): 262144 bytes / 524288 bytes
		Disk identifier: 0x000007d0
		
		Device Boot 	Start 	End Blocks 	Id 	System
		Command (m for help): n
		
		Partition type:
		p primary (0 primary, 0 extended, 4 free)
		e extended
		Select (default p): e
		Partition number (1-4, default 1): 1
		First sector (2048-390611039, default 2048):
		Using default value 2048
		Last sector, +sectors or +size{K,M,G} (2048-390611039, default 390611039):
		Using default value 390611039
		
		Command (m for help): p
		Disk /dev/sda: 200.0 GB, 199992852480 bytes
		255 heads, 63 sectors/track, 24314 cylinders, total 390611040 sectors
		Units = sectors of 1 * 512 = 512 bytes
		Sector size (logical/physical): 512 bytes / 512 bytes
		I/O size (minimum/optimal): 262144 bytes / 524288 bytes
		Disk identifier: 0x000007d0
		
		Device Boot   Start   End    Blocks 	Id 	System
		
		/dev/sda1 	  2048 390611039 195304496 5 Extended
	

2. To create the second partition on the same disk, enter:
	
		Command (m for help): n
		Partition type:
		p primary (0 primary, 1 extended, 3 free)
		l logical (numbered from 5)
		Select (default p): l
		Adding logical partition 5
		First sector (4096-390611039, default 4096):
		Using default value 4096
		Last sector, +sectors or +size{K,M,G} (4096-390611039, default 390611039): +15750M
		
		Command (m for help): p
		
		Disk /dev/sda: 200.0 GB, 199992852480 bytes
		255 heads, 63 sectors/track, 24314 cylinders, total 390611040 sectors
		Units = sectors of 1 * 512 = 512 bytes
		Sector size (logical/physical): 512 bytes / 512 bytes
		I/O size (minimum/optimal): 262144 bytes / 524288 bytes
		Disk identifier: 0x000007d0
		
		Device Boot    Start    End   Blocks Id   System
		
		/dev/sda1      2048 390611039 195304496 5 Extended
		
		/dev/sda5      4096 32260095 16128000 83 Linux
	
3. To create the third partition on the same disk, enter:
	
		Command (m for help): n
		Partition type:
		p primary (0 primary, 1 extended, 3 free)
		l logical (numbered from 5)
		Select (default p): l
		Adding logical partition 6
		First sector (32262144-390611039, default 32262144):
		Using default value 32262144
		Last sector, +sectors or +size{K,M,G} (32262144-390611039, default 390611039): +15750M
		
		Command (m for help): p
		Disk /dev/sda: 200.0 GB, 199992852480 bytes
		255 heads, 63 sectors/track, 24314 cylinders, total 390611040 sectors
		Units = sectors of 1 * 512 = 512 bytes
		Sector size (logical/physical): 512 bytes / 512 bytes
		I/O size (minimum/optimal): 262144 bytes / 524288 bytes
		Disk identifier: 0x000007d0
		
		Device Boot    Start   End   Blocks  Id  System
		
		/dev/sda1      2048390611039 195304496 5 Extended
		
		/dev/sda5      409632260095 16128000 83 Linux
		
		/dev/sda6      32262144 64518143 16128000 83 Linux

4. Repeat this command for rest of the partition.

**If the OSD is for a drive other than the OS drive, prepare it for use with Ceph, and mount it to the directory you just created**:
	
		mkfs -t {fstype} /dev/{hdd}
		[fs-type can be {ext4|xfs|btrfs}]
	
For better performance, use **xfs**. 

	
####Running the script to create an XFS file system on partitioned disks
	
The following example uses 13 drives in the system to create an XFS file system.
	
	#!/bin/bash
	mkfs.xfs -l logdev=/dev/sda5,size=2136997888 -f -i size=2048 /dev/sdb1
	mkfs.xfs -l logdev=/dev/sda6,size=2136997888 -f -i size=2048 /dev/sdc1
	mkfs.xfs -l logdev=/dev/sda7,size=2136997888 -f -i size=2048 /dev/sdd1
	mkfs.xfs -l logdev=/dev/sda8,size=2136997888 -f -i size=2048 /dev/sde1
	mkfs.xfs -l logdev=/dev/sda9,size=2136997888 -f -i size=2048 /dev/sdf1
	mkfs.xfs -l logdev=/dev/sda10,size=2136997888 -f -i size=2048 /dev/sdg1
	mkfs.xfs -l logdev=/dev/sda11,size=2136997888 -f -i size=2048 /dev/sdh1
	mkfs.xfs -l logdev=/dev/sda12,size=2136997888 -f -i size=2048 /dev/sdi1
	mkfs.xfs -l logdev=/dev/sda13,size=2136997888 -f -i size=2048 /dev/sdj1
	mkfs.xfs -l logdev=/dev/sda14,size=2136997888 -f -i size=2048 /dev/sdk1
	mkfs.xfs -l logdev=/dev/sda15,size=2136997888 -f -i size=2048 /dev/sdl1
	mkfs.xfs -l logdev=/dev/sda16,size=2136997888 -f -i size=2048 /dev/sdm1
	mkfs.xfs -l logdev=/dev/sda17,size=2136997888 -f -i size=2048 /dev/sdn1
	mount -o user_xattr /dev/{hdd} /var/lib/ceph/osd/ceph-{osd-number}
	

The following example mounts 13 drives to journal partitions.
	
	#!/bin/bash
	mount -t xfs -o logdev=/dev/sda5 /dev/sdb1 /var/lib/ceph/osd/ceph-0/
	mount -t xfs -o logdev=/dev/sda6 /dev/sdc1 /var/lib/ceph/osd/ceph-1/
	mount -t xfs -o logdev=/dev/sda7 /dev/sdd1 /var/lib/ceph/osd/ceph-2/
	mount -t xfs -o logdev=/dev/sda8 /dev/sde1 /var/lib/ceph/osd/ceph-3/
	mount -t xfs -o logdev=/dev/sda9 /dev/sdf1 /var/lib/ceph/osd/ceph-4/
	mount -t xfs -o logdev=/dev/sda10 /dev/sdg1 /var/lib/ceph/osd/ceph-5/
	mount -t xfs -o logdev=/dev/sda11 /dev/sdh1 /var/lib/ceph/osd/ceph-6/
	mount -t xfs -o logdev=/dev/sda12 /dev/sdi1 /var/lib/ceph/osd/ceph-7/
	mount -t xfs -o logdev=/dev/sda13 /dev/sdj1 /var/lib/ceph/osd/ceph-8/
	mount -t xfs -o logdev=/dev/sda14 /dev/sdk1 /var/lib/ceph/osd/ceph-9/
	mount -t xfs -o logdev=/dev/sda15 /dev/sdl1 /var/lib/ceph/osd/ceph-10/
	mount -t xfs -o logdev=/dev/sda16 /dev/sdm1 /var/lib/ceph/osd/ceph-11/
	mount -t xfs -o logdev=/dev/sda17 /dev/sdn1 /var/lib/ceph/osd/ceph-12/

5. To initialize the OSD data directory, enter: [[check step numbering -  should be 5]]


	ceph-osd -i {osd-num} --mkfs -mkkey
	
The following example initializes 13 data directories.
	
	#!/bin/bash
	ceph-osd -i 0 --mkfs --mkkey
	ceph-osd -i 1 --mkfs --mkkey
	ceph-osd -i 2 --mkfs --mkkey
	ceph-osd -i 3 --mkfs --mkkey
	ceph-osd -i 4 --mkfs --mkkey
	ceph-osd -i 5 --mkfs --mkkey
	ceph-osd -i 6 --mkfs --mkkey
	ceph-osd -i 7 --mkfs --mkkey
	ceph-osd -i 8 --mkfs --mkkey
	ceph-osd -i 9 --mkfs --mkkey
	ceph-osd -i 10 --mkfs --mkkey
	ceph-osd -i 11 --mkfs --mkkey
	ceph-osd -i 12 --mkfs --mkkey

6.To register the OSD authentication key, enter:

	ceph auth add osd.{osd-num} osd 'allow *' mon 'allow profile osd' -i /var/lib/ceph/osd/ceph-{osd-num}/keyring
	
The following example registers 13 OSD authentication keys.
	
	#!/bin/bash
	
	ceph auth add osd.0 osd 'allow *' mon 'allow profile osd' -i /var/lib/ceph/osd/ceph-0/keyring
	ceph auth add osd.1 osd 'allow *' mon 'allow profile osd' -i /var/lib/ceph/osd/ceph-1/keyring
	ceph auth add osd.2 osd 'allow *' mon 'allow profile osd' -i /var/lib/ceph/osd/ceph-2/keyring
	ceph auth add osd.3 osd 'allow *' mon 'allow profile osd' -i /var/lib/ceph/osd/ceph-3/keyring
	ceph auth add osd.4 osd 'allow *' mon 'allow profile osd' -i /var/lib/ceph/osd/ceph-4/keyring
	ceph auth add osd.5 osd 'allow *' mon 'allow profile osd' -i /var/lib/ceph/osd/ceph-5/keyring
	ceph auth add osd.6 osd 'allow *' mon 'allow profile osd' -i /var/lib/ceph/osd/ceph-6/keyring
	ceph auth add osd.7 osd 'allow *' mon 'allow profile osd' -i /var/lib/ceph/osd/ceph-7/keyring
	ceph auth add osd.8 osd 'allow *' mon 'allow profile osd' -i /var/lib/ceph/osd/ceph-8/keyring
	ceph auth add osd.9 osd 'allow *' mon 'allow profile osd' -i /var/lib/ceph/osd/ceph-9/keyring
	ceph auth add osd.10 osd 'allow *' mon 'allow profile osd' -i /var/lib/ceph/osd/ceph-10/keyring
	ceph auth add osd.11 osd 'allow *' mon 'allow profile osd' -i /var/lib/ceph/osd/ceph-11/keyring
	ceph auth add osd.12 osd 'allow *' mon 'allow profile osd' -i /var/lib/ceph/osd/ceph-12/keyring

7.Add OSD node to CRUSH map by entering:

	ceph osd crush add-bucket {hostname} host

8.Place the OSD node under root by default by entering:

	ceph osd crush move {hostname} root=default

9.Add the OSD node to the CRUSH map for receiving data by entering:

	ceph osd crush add {id-or-name} {weight} [{bucket-type}={bucket-name} ...]
	ceph osd crush add osd.0 1.0 host=ceph-osd1

The following example adds 13 OSDs to the CRUSH map.

	#!/bin/bash
	
	ceph osd crush add osd.0 1.0 host=ceph-osd1
	ceph osd crush add osd.1 1.0 host=ceph-osd1
	ceph osd crush add osd.2 1.0 host=ceph-osd1
	ceph osd crush add osd.3 1.0 host=ceph-osd1
	ceph osd crush add osd.4 1.0 host=ceph-osd1
	ceph osd crush add osd.5 1.0 host=ceph-osd1
	ceph osd crush add osd.6 1.0 host=ceph-osd1
	ceph osd crush add osd.7 1.0 host=ceph-osd1
	ceph osd crush add osd.8 1.0 host=ceph-osd1
	ceph osd crush add osd.9 1.0 host=ceph-osd1
	ceph osd crush add osd.10 1.0 host=ceph-osd1
	ceph osd crush add osd.11 1.0 host=ceph-osd1
	ceph osd crush add osd.12 1.0 host=ceph-osd1

10.Update the `ceph.conf` file as shown below for each of the OSD nodes. Also add the [global] section in `ceph.conf` files with file parameter `tunable` as listed in the [tunable](#ceph-tunning).

	[osd.0]
	host = ceph-osd1
	
	[osd.1]
	host = ceph-osd1
	
	[osd.2]
	host = ceph-osd1

11.Start the OSD daemon by entering:

	/etc/init.d/ceph start osd.0
	
	Ensure OSD created is up and in by verifying output of following:
	
	ceph -w


#####Setting up Additional OSD Nodes

 
A healthy Ceph cluster needs at least 3 OSD nodes. (Follow steps similar to previous section to add additional nodes to form the quorum.) Update the `ceph.conf` file like that shown below before proceding.

	
	
	
	
	[osd.0]
	host = ceph-osd1
	[osd.1]
	host = ceph-osd1
	
	..
	
	[osd.3]
	host = ceph-osd3
	[osd.4]
	host = ceph-osd4
	
	..
	
	
Ensure Ceph health and status is OK by entering:
	
	ceph health
	HEALTH_OK
	

	ceph status
	
	root@ceph-mon1:/home/ceph# ceph -s
	
	cluster 6a710689-5b19-4ba3-b2c5-c23ddd26dce9
	
	health HEALTH_OK
	
	monmap e1: 1 mons at {ceph-mon1=192.168.116.54:6789/0}, election epoch 1, quorum 0 ceph-mon1
	
	osdmap e336: 39 osds: 39 up, 39 in
	
	pgmap v106607: 11456 pgs, 17 pools, 7878 MB data, 1319 kobjects
	
	83315 MB used, 99199 GB / 99280 GB avail
	
	11456 active+clean

Repeat the above steps for each OSD node.

##File System Tuning {#file-system-tunning}

XFS Journal Partitions best reside on SSDs, with a discrete path and a Controller Cache. Additionally, specify One partition per data, and JBOD for the SSDs, with a ratio of one SSD to every four Data Partitions. Each XFS Data partition should be configured with rw, noatime, attr2, inode64, noquota. Additionally, you should also consider: nobarrier, logbsize=256k, logbufs=8, allocsize=4m.

For long running Ceph Clusters, XFS fragmentation is useful to monitor and correct.

	Fragmentation on /dev/sdb1 - osd3
	actual 22722, ideal 22557, fragmentation factor 0.73%
	Example - checks the fragmentation on 13 osd deamons
	
	#!/bin/sh
	echo "Fragmentation on /dev/sdb1 - osd1"
	xfs_db -c frag -r /dev/sdb1
	echo "Fragmentation on /dev/sdc1 - osd1"
	xfs_db -c frag -r /dev/sdc1
	echo "Fragmentation on /dev/sdd1 - osd1"
	xfs_db -c frag -r /dev/sdd1
	echo "Fragmentation on /dev/sde1 - osd1"
	xfs_db -c frag -r /dev/sde1
	echo "Fragmentation on /dev/sdf1 - osd1"
	xfs_db -c frag -r /dev/sdf1
	echo "Fragmentation on /dev/sdg1 - osd1"
	xfs_db -c frag -r /dev/sdg1
	echo "Fragmentation on /dev/sdh1 - osd1"
	xfs_db -c frag -r /dev/sdh1
	echo "Fragmentation on /dev/sdi1 - osd1"
	xfs_db -c frag -r /dev/sdi1
	echo "Fragmentation on /dev/sdj1 - osd1"
	xfs_db -c frag -r /dev/sdj1
	echo "Fragmentation on /dev/sdk1 - osd1"
	xfs_db -c frag -r /dev/sdk1
	echo "Fragmentation on /dev/sdl1 - osd1"
	xfs_db -c frag -r /dev/sdl1
	echo "Fragmentation on /dev/sdm1 - osd1"
	xfs_db -c frag -r /dev/sdm1
	echo "Fragmentation on /dev/sdn1 - osd1"
	xfs_db -c frag -r /dev/sdn1

##Ceph Tuning {#ceph-tunning}

Ceph configuration file is shown below:

	[global]
	
	fsid = xxxxxxxxxx
	
	mon_initial_members = ceph-mon1
	mon_host = xxxx
	auth_cluster_required = cephx
	auth_service_required = cephx
	auth_client_required = cephx
	filestore_xattr_use_omap = true
	#osd journal size = 2048
	osd pool default size = 3
	osd pool default min size = 2
	#osd pool default pg num = 333
	#osd pool default pgp num = 333
	#osd crush chooseleaf type = 1
	

	#Added for perf tuning
	
	osd_op_threads = 8
	filestore_queue_max_bytes = 536870912
	filestore_queue_max_ops = 2000
	filestore_queue_committing_max_ops = 2000
	filestore_queue_committing_max_bytes = 536870912
	
	[mon.ceph-mon1]
	host = ceph-mon1
	mon addr = xxxx
	
	[client.admin]
	keyring = /etc/ceph/ceph.client.admin.keyring
	
	[client.glance]
	keyring = /etc/ceph/ceph.client.glance.keyring
	
	[client.cinder]
	keyring = /etc/ceph/ceph.client.cinder.keyring
	
	[client.nova]
	keyring = /etc/ceph/ceph.client.nova.keyring
	
	[client.radosgw.ceph-admin]
	host = ceph-admin
	keyring = /etc/ceph/ceph.client.radosgw.keyring
	rgw socket path = /var/run/ceph/ceph.radosgw.gateway.fastcgi.sock
	log file = /var/log/ceph/client.radosgw.gateway.log
	rgw dns name = ceph-admin
	rgw print continue = false
	
	[client.radosgw.ceph-gateway2]
	host = ceph-gateway2
	keyring = /etc/ceph/ceph.client.radosgw.keyring
	rgw socket path = /var/run/ceph/ceph.radosgw.gateway.fastcgi.sock
	log file = /var/log/ceph/client.radosgw.gateway.log
	rgw dns name = ceph-gateway2
	rgw print continue = false
	
	[osd.0]
	host = ceph-osd1
	
	[osd.1]
	host = ceph-osd1
	
	[osd.2]
	host = ceph-osd1
	
	[osd.3]
	host = ceph-osd1
	
	...osd.4-37...
	[osd.38]
	host = ceph-osd3

**Relevant tuning parameters**

Following are the relevant tuning parameters:

	osd op threads = 8
	osd max backfills = 1
	osd recovery max active = 1
	filestore max sync interval = 100
	filestore min sync interval = 50
	filestore queue max ops = 2000
	filestore queue max bytes = 536870912
	filestore queue committing max ops = 2000
	filestore queue committing max bytes = 536870912


##Setting up additional Monitor Nodes {#setting-up-additional-nodes}

Ceph monitors are light-weight processes that maintains a master copy of the cluster map. For production clusters, we recommend at least 3 monitors and always advisable to run with odd number of monitors. And odd-number of monitors has a higher resiliency to failures than the even number monitors.

On a 2 monitor deployment, no failures can be tolerated to maintain a quirum but with 3 monitors, one failure  can be tolerated and with 5 monitors, two failures can be tolerated. Since, monitors are light-weight, it is possible to run on same host but it is recommended to run them on separate hosts because fsync issues with kernel may impair performance. Deploy your hardware and install all the required software. Follow the similar steps as how other Ceph cluster nodes are deployed.

For more details refer to [http://docs.ceph.com/docs/master/rados/operations/add-or-rm-mons/](http://docs.ceph.com/docs/master/rados/operations/add-or-rm-mons/)


###Adding a monitor (manual)

The following steps create a `ceph-mon` data directory, retrieves the monitor keyring and monmap, and adds a `ceph-mon` daemon to your cluster. You can add more monitors by repeating these steps to achieve a quorum.


1. Create a default directory on the second monitor machine

		ssh {new-mon-host}
		sudo mkdir /var/lib/ceph/mon/ceph-{mon-id}

	For example:

		# mkdir /var/lib/ceph/mon/ceph-ftcceph1-mon2

2. Create a temporary directory {temp} to keep files need during the process. This directory is different from the monitor's default directory.

		mkdir {tmp}

	For example:

		mkdir tmp

3. Retrieve the keyring for your monitor.

		ceph auth get mon. -o {tmp}/{key-filename}
		{tmp} ->is the path to the keyring
		{key-filename} is the name of the file that has monitor key.

	For example:

		ceph auth get mon. -o tmp/mon2keyring

	Expected output

		exported keyring for mon.

4.	Retrieve the monitor map. 
		ceph mon getmap -o {tmp}/{map-filename}
		{tmp} is the path to the monitor map
		{map-filename} is the name of the file containing the monitor map
	For example: 
		ceph mon getmap -o tmp/mon2monmap

	Expected output

		got monmap epoch 1


5.	Prepare the monitor's data directory created earlier. 


		sudo ceph-mon -i {mon-id} --mkfs --monmap {tmp}/{map-filename} --keyring {tmp}/{key-filename}
	For example:

		ceph-mon -i ftcceph1-mon2 --mkfs --monmap tmp/mon2monmap --keyring tmp/mon2keyring

	Expected output

		ceph-mon: set fsid to 328d1702-67e7-4dfa-a0a9-77f0b96be57f
		ceph-mon: created monfs at /var/lib/ceph/mon/ceph-ftcceph1-mon2 for mon.ftcceph1-mon2

6.	Update `/etc/ceph/ceph.conf` file with the new monitor node details and push the updated ceph.conf file to all the nodes in the ceph cluster.
		[mon.mon-id]
		host = new-mon-host
		addr = ip-addr:6789

	Sample

		[mon.ftcceph1-mon2]
		host = ftcceph1-mon2
		mon addr = 192.168.51.52:6789

7.	Add the new monitor to the list of monitors and this will enable other nodes to use this monitor during startup. This command is run from the new added monitor.

		ceph mon add <mon-id> <ip>[:<port>]

	sample
	
		ceph mon add ftcceph1-mon2 192.168.51.52:6789
		added mon.ftcceph1-mon2 at 192.168.51.52:6789/0

8.	Start the new monitor so it will automatically join the cluster. 

		ceph-mon -i {mon-id} --public-addr {ip:port}
	
	sample

		 ceph-mon -i ftcceph1-mon2 --public-addr 192.168.51.52:6789


Follow the above steps for the 3rd monitor. Once the 3rd monitor is added to the cluster, run `ceph-w` and check the status of health state as "OK". A `HEALTH_WARN` clock skew message appears if the time is not in sync across all the Ceph cluster. It is always good to set NTP setup on all the ceph nodes so that the time is in sync.

The following is the sample output of `HEALTH_WARN` clock skew warns

	root@ftcceph1-mon3:/home/ceph# ceph -w
	cluster 328d1702-67e7-4dfa-a0a9-77f0b96be57f
	health HEALTH_WARN clock skew detected on mon.ftcceph1-mon2, mon.ftcceph1-mon3
	monmap e3: 3 mons at {ftcceph1-mon1=192.168.51.51:6789/0,ftcceph1-mon2=192.168.51.52:6789/0,ftcceph1-mon3=192.168.51.53:6789/0}, election epoch 6, quorum 0,1,2 ftcceph1-mon1,ftcceph1-mon2,ftcceph1-mon3
	osdmap e122: 21 osds: 21 up, 21 in
	pgmap v2845: 3256 pgs, 17 pools, 3783 bytes data, 69 objects
	22389 MB used, 5844 GB / 5866 GB avail
	3256 active+clean


####Steps to setup NTP server

1. Install NTP package. This package is a part of the image deployment.
2. Update `/etc/ntp.conf` file with your local NTP server across all the nodes in the Ceph cluster.
3. Once `ntp.conf` file is updated, restart ntp service by running `/etc/init.d/ntp restart6`
4. Run `ntpq -p` to see the ntp server is listed.


		ntpq -p
		remote refid st t when poll reach delay offset jitter
		=================================================
		192.168.51.21 .INIT. 16 u - 64 0 0.000 0.000 0.000




Sample `ntp.conf` file

[commented out server and added local ntp server and restrict under cryptographically authenticated section]

	==========================================
	# /etc/ntp.conf, configuration for ntpd; see ntp.conf(5) for help
	driftfile /var/lib/ntp/ntp.drift
	# Enable this if you want statistics to be logged.
	#statsdir /var/log/ntpstats/
	statistics loopstats peerstats clockstats
	filegen loopstats file loopstats type day enable
	filegen peerstats file peerstats type day enable
	filegen clockstats file clockstats type day enable
	# You do need to talk to an NTP server or two (or three).
	#server ntp.your-provider.example
	# pool.ntp.org maps to about 1000 low-stratum NTP servers. Your server will
	# pick a different set every time it starts up. Please consider joining the
	# pool: <http://www.pool.ntp.org/join.html>
	#server 0.debian.pool.ntp.org iburst
	#server 1.debian.pool.ntp.org iburst
	#server 2.debian.pool.ntp.org iburst
	#server 3.debian.pool.ntp.org iburst
	server 192.168.51.21
	# Access control configuration; see /usr/share/doc/ntp-doc/html/accopt.html for
	# details. The web page <http://support.ntp.org/bin/view/Support/AccessRestrictions>
	67
	# might also be helpful.
	#
	# Note that "restrict" applies to both servers and clients, so a configuration
	# that might be intended to block requests from certain clients could also end
	# up blocking replies from your own upstream servers.
	# By default, exchange time with everybody, but don't allow configuration.
	restrict -4 default kod notrap nomodify nopeer noquery
	restrict -6 default kod notrap nomodify nopeer noquery
	# Local users may interrogate the ntp server more closely.
	restrict 127.0.0.1
	restrict ::1
	# Clients from this (example!) subnet have unlimited access, but only if
	# cryptographically authenticated.
	#restrict 192.168.123.0 mask 255.255.255.0 notrust
	restrict 192.168.51.0 mask 255.255.255.0 notrust
	# If you want to provide time to your local subnet, change the next line.
	# (Again, the address is an example only.)
	#broadcast 192.168.123.255
	# If you want to listen to time broadcasts on your local subnet, de-comment the
	# next lines. Please do this only if you trust everybody on the network!
	==========================================================
	

Once the ntp server is configured and after the time is in sync across all the servers, the Ceph health will be in "OK" state.


	ceph -w
	cluster 328d1702-67e7-4dfa-a0a9-77f0b96be57f
	health HEALTH_OK
	monmap e3: 3 mons at {ftcceph1-mon1=192.168.51.51:6789/0,ftcceph1-mon2=192.168.51.52:6789/0,ftcceph1-mon3=192.168.51.53:6789/0}, election epoch 12, quorum 0,1,2 ftcceph1-mon1,ftcceph1-mon2,ftcceph1-mon3
	osdmap e122: 21 osds: 21 up, 21 in
	pgmap v3238: 3256 pgs, 17 pools, 3783 bytes data, 69 objects
	22384 MB used, 5844 GB / 5866 GB avail
	3256 active+clean



## Next Steps

[Ceph Authentication]( /helion/openstack/ceph-authentications/).


<a href="#top" style="padding:14px 0px 14px 0px; text-decoration: none;"> Return to Top &#8593; </a>
 