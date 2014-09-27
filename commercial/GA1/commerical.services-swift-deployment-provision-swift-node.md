---
layout: default
title: "HP Helion OpenStack&#174; Object Operations Service Overview"
permalink: /helion/openstack/ga/services/swift/provision-nodes/
product: commercial.ga

---
<!--UNDER REVISION-->

<script>

function PageRefresh {
onLoad="window.refresh"
}

PageRefresh();

</script>

<!--
<p style="font-size: small;"> <a href="/helion/openstack/ga/services/object/overview/">&#9664; PREV</a> | <a href="/helion/openstack/services/overview/">&#9650; UP</a> | <a href=" /helion/openstack/ga/services/swift/deployment/"> NEXT &#9654</a> </p>-->


#Provision Swift Node(s) 

This page describes the procedure to provision scale-out Swift nodes. All type of Swift nodes (object, proxy) will be provisioned similarly. But you cannot provision both the type of the nodes together.


* [Prerequisite](#Preq)
* [Adding physical server for scale-out Swift](#adding-physical-server-for-scale-out-Swift) 
* [Provision Swift node](#provision-swift-node)
* [Verify Swift node deployment](#verify-Swift-node-deployment)

##Prerequisite {#Preq}

* HP Helion Cloud is deployed
* Starter swift is functional which by default gets deployed as part of deployment of cloud

Before provisioning swift node(s) ensure that the all nodes are **ACTIVE** and  **Running**.
You can view the status of the nodes using the following command:

	#nova list

##Adding physical server for scale-out Swift {#adding-physical-server-for-scale-out-Swift}

You must add a server to the cloud inventory so that you can scale-out Swift nodes. 

Perform the following steps to add  a physical server for scale-out Swift:

1. Get the server details:

	 a. User name

	b. Password
	
	c. RAM
	
	d. CPU
	
	e. Disk capacity
	
	f. MAC address

	**Note**: For HP server you can use iLO to gather the above details.

2. Login to Seed 

		#ssh root@<Seed IP address> 

3. When prompted for host authentication, type `yes` to allow the ssh connection to proceed.

4. Add server details in the `baremetal.csv` configuration file  in the following format and upload the file to `/root`.

		<mac_address>,<ipmi_user>,<ipmi_password>,<ipmi_address>,<no_of_cpus>,<memory_MB>,<diskspace_GB>

	**Notes**: 

	- There must be one entry in this file for each baremetal system you intend to install.
	- The first entry is used for the undercloud.
	- The second entry is the node with the lowest-specifications (CPU/RAM/Disk size) node in the overcloud.

	For example, your file should look similar to the following:

		E8:39:35:2B:FB:3E,Administrator,gone2far,10.1.192.33,12,73728,70
		E4:11:5B:B7:AD:CE,Administrator,gone2far,10.1.192.34,12,73728,70

5. Login to Undercloud 

		#ssh heat-admin@<Undercloud IP address> 

6. Add server details to ironic database using the following ironic command:

 		ironic node-create -d pxe_ipmitool <-p cpus=<value> -p memory_mb=<value> -p local_gb=<value> -p cpu_arch=<value> -i ipmi_address=<IP address> -i ipmi_username=<admin user name> -i ipmi_password=<password> 

	For example:

 		# ironic node-create -d pxe_ipmitool -p cpus=12 -p memory_mb=73728 -p local_gb=70 -p cpu_arch=amd64 -i ipmi_address=10.1.192.33 -i ipmi_username=Administrator -i ipmi_password=gone2far
		+--------------+-----------------------------------------------------------------------+
		| Property     | Value                                                                 |
		+--------------+-----------------------------------------------------------------------+
		| uuid         | 08623d52-31cc-4d47-bb29-ecf34a59019b                                  |
		| driver_info  | {u'ipmi_address': u'10.1.192.33', u'ipmi_username': u'Administrator', |
		|              | u'ipmi_password': u'gone2far'}                                        |
		| extra        | {}                                                                    |
		| driver       | pxe_ipmitool                                                          |
		| chassis_uuid | None                                                                  |
		| properties   | {u'memory_mb': u'73728', u'cpu_arch': u'amd64', u'local_gb': u'70',   |
		|              | u'cpus': u'12'}                                                       |
		+--------------+-----------------------------------------------------------------------+
7.Create port, enter MAC address and Node ID  using the following ironic command: 
 	
 		 #ironic create-port -a $MAC -n $NODE_ID

	For example:
		
		# ironic port-create -a E8:39:35:2B:FB:3E -n 08623d52-31cc-4d47-bb29-ecf34a59019b
		+-----------+--------------------------------------+
		| Property  | Value                                |
		+-----------+--------------------------------------+
		| node_uuid | 08623d52-31cc-4d47-bb29-ecf34a59019b |
		| extra     | {}                                   |
		| uuid      | 1c5c5c54-bb3e-4883-8ebe-ba24e7f3d159 |
		| address   | e8:39:35:2b:fb:3e                    |
		+-----------+--------------------------------------+	

 
8.Verify the successful registration of a new physical server

	#ironic node-list

##Provision Swift node {#provision-swift-node}

**Caution**: Do not provision proxy and scale-out object nodes together. The requirements are different for proxy nodes and scale-out object node. It is recommended to use HP DL380 or HP SL230 servers for proxy nodes and SL4540 servers for scale-out object storage nodes. 


Perform the following steps to provision Swift node:

1. Login to seed

		#ssh root@<Seed IP address>

2. Copy `ee-config.json` to root home directory

		 #cp /root/tripleo/tripleo-incubator/scripts/ee-config.json /root/overcloud-config.json

3. Edit `overcloud-config.json` file to configure the following values as per your requirement:
 
 
	 "so_swift_storage_scale": <number of object servers> , 
	
	 "so_swift_proxy_scale": <number of proxy servers> ,

**Note**: While deploying scale-out proxy node "so&#095;swift&#095;storage&#095;scale" must be set to 0 and while deploying scale-out object node "so&#095;swift&#095;proxy&#095;scale" must be set to 0.
 
4.Enter the following command to source the `overcloud_config.json`  for the new values

		#source /root/tripleo/tripleo-incubator/scripts/hp_ced_load_config.sh /root/overcloud-config.json

5.Run the installer script to update the cloud

		#bash -x tripleo/tripleo-incubator/scripts/hp_ced_installer.sh --update-overcloud |& tee update_cloud.log

	The cloud updates with the new nodes on successful operation

##Verify Swift node deployment {#verify Swift node deployment}

Ensure the deployment of Swift node using the following commands:

1. Login to underloud

		#ssh heat-admin@<Undercloud IP address> 

2. List the available Swift nodes

		#nova list

It displays available Swift nodes including the newly added node.


<a href="#top" style="padding:14px 0px 14px 0px; text-decoration: none;"> Return to Top &#8593; </a>





*The OpenStack Word Mark and OpenStack Logo are either registered trademarks/service marks or trademarks/service marks of the OpenStack Foundation, in the United States and other countries and are used with the OpenStack Foundation's permission. We are not affiliated with, endorsed or sponsored by the OpenStack Foundation, or the OpenStack community.*