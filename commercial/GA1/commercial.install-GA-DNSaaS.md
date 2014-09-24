---
layout: default
title: "HP Helion OpenStack&#174;: DNSaaS Installation and Configuration"
permalink: /helion/openstack/ga/install/dnsaas/
product: commercial.ga

---
<!--UNDER REVISION-->


<script>

function PageRefresh {
onLoad="window.refresh"
}

PageRefresh();

</script>

<p style="font-size: small;"> <a href="/helion/openstack/install/ovsvapp/">&#9664; PREV</a> | <a href="/helion/openstack/install-overview/">&#9650; UP</a> | <a href="/helion/openstack/related-links/">NEXT &#9654;</a> </p>

# HP Helion OpenStack&#174;: DNSaaS Installation and Configuration


This page explains how to install and configure DNS as a service (DNSaaS) for HP Helion OpenStack. It is important to read through this page before starting your installation. Our managed DNS service, based on the OpenStack Designate project, is engineered to help you create, publish, and manage your DNS zones and records securely and efficiently to either a public or private DNS server network. This service can supports any hypervisor.


- [Prerequisites](#preq)
- [Creating Prerequisite Credentials](#credentials)
- [Sherpa CSU "Publication" and Booting the Installer VM](#publication)
- [Installing and configuring DNSaaS](#configure)
- [Configure the Overcloud Load Balancer for DNSaaS](#configovercloud)
- [Registering the service with Keystone](#keyreg)
- [More information](#moreinfo)


##Prerequisite {#preq}

* HP Helion Openstack Installation
* DNSaaS Installer Image
* Obtained credentials of the user+tenant where the service is to be deployed ("Target Credentials"):
	* This user should have the "admin" and  "&#095;member_" (or member) roles.
		* This user should have the "admin" and "member" (or member) roles. (The "admin" role should not be required, but, for some reason, HP Helion OpenStack Heat fails to delete the users it creates without this.)
	* Username
	* Password
	* Tenant/Project Name

* Obtained credentials for the user+tenant used to validate end user tokens ("Service Credentials"):
	* This user should be in the "service" tenant, and have the "admin" and "member" (or member) roles, and be called "designate""
	* Username
	* Password
	* Tenant/Project Name
* A generated SSH Key for accessing the Service VMs
* A chosen backend driver and its prerequisites:
	* PowerDNS (self hosted) 
    
		A domain name for the nameservers ("Namsever FQDNs"). For example, if your nameservers are to be ns1.mycompany.com., you will need the "mycompany.com." domain.

* Microsoft DNS (self hosted)
	* At least one Microsoft DNS server installed and configured
	* Knowledge of the FQDNs for all MS DNS servers to be used ("Namsever FQDNs")

* DynECT (3rd Party)

	* An active service contract with DynECT
	* Knowledge of the FQDNs for all DynECT nameservers allocated to your account ("Namsever FQDNs")
		* For  "helion-qa" Dynect account:
			* ns1.p13.dynect.net.
			* ns2.p13.dynect.net.
			* ns3.p13.dynect.net.
			* ns4.p13.dynect.net.
	* API credentials for DynEXT
		* Customer Name
		* Username
		* Password


* Akamai (3rd Party)
	* An active service contract with Akamai
	* Knowledge of the FQDNs for all Akamai nameservers allocated to your account ("Namsever FQDNs")
		* For "helion-qa" Akamai account
	* API credentials for Akamai
		* Username
		* Password


<!--
## Uploading script to Sherpa (do we need to upload the DNaaS script to sherpa) ??
-->
## Creating Prerequisite Credentials <a name="credentials"></a>


You must create Target and Service credentials.

For Target credentials, you should create tenant and username.


* Create tenant
		
		$ keystone tenant-create --name dnsaas --description "DNSaaS Service" 

* Create username

		$ keystone user-create --name dnsaas --tenant dnsaas --email dnsaas@example.com --pass password

* Add role (this role is added for user)

		$ keystone user-role-add --user dnsaas --tenant dnsaas --role admin

Once Target credentials are successfully created you can create service credentials.

* Create Service credentials

		$ keystone user-create --name designate --tenant service --email designate@example.com --pass password

 
## Sherpa CSU "Publication" and Booting the Installer VM<a name="publication"></a>

Before proceeding with DNaaS installation ensure that you have met all the perquisites, which includes gathering the required information, creating the necessary users/projects and ensuring the users/projects have the appropriate roles. Failure to do so will result in a failed install.

###Publish CSU contents

1. Login to the Overcloud's Horzon using **Target Credentials**. 
2. Click **Admin** Tab in the left panel.<br> The tab displays an option in the left panel.
3. Click **Updates and Extensions** and then select **Updates and Extensions** to open the Updates and Extensions page.
3. Select the appropriate build from the list  and click **Install**. Install dialog box is displayed.
4. Click **Install**. It will take several minutes for the status of the Build to proceed from Installing to Installed.


###Boot the installer VM

1. Login to OverCloud Horizon using **Target Credentials**.
2. Click **Project**. The tab displays an option in the left panel.
3. Click **Compute**  and then select **Images** to open the Image page.
4. Select the image file from the list and click **Launch**. For example: select  **dnsaas-installer_0.1.0b12** to launch this image. 

	A Launch Instance dialog box displays with five tabs: Details Tab, Access & Security Tab, Networking Tab, Post-Creation Tab and Advance Options. By default, Details is the active tab.

5. On the Details Tab, do the following:

   	a. In the **Instance Name**  (Virtual Machine (VM))box enter the name of the instance. For example :**dnsaas-installer**.

  	 b.From the **Flavor** drop-down list and select the flavor. For example: **m1.small**

6. On the **Access and Security** Tab, do the following:

 	a. From the **Keypair** drop-down list, select an appropriate SSH keypair.
	
7. On the **Networking** Tab, select the **default-net** network, if it is not populated automatically.

8. Click **Launch** to launch the Instance. You are taken to the Instances page with the progress bar displaying the completion progress.

9. Select the launched instance in the Instance table.
10. Click **More** against the instance to display the drop-down list and select **Associate Floating IP**. Manage Floating IP Associations box is displayed.

11. Perform the following steps in the Manage Floating IP Associations:

   	a. From the **IP Address** drop-dwon list, select the Floating IP address. Ensure that you remember the selected IP address.
	
   	b. From the **Port to be associated** drop-down list, select the  port.

  	c. Click **Associate**.

12. Click **Access and Security**. Access & Security page is displayed.
13. Select the appropriate security group from the list and click **Manage Rules**. For example: select **default** as a security group. The page navigates to Manage Security Group Rules: <name of security> page.

14. Click **Add Rule**. Add Rule dialog box is displayed.

15. In the **Port** box, enter the port value as **22**.

16. (Optionally) Restrict the CIDR from which SSH connections should be allowed. (**how do we restrict CIDR? do we need to enter any value or select any value in the CIDR box??**)

17.Click **Add**.  The rule is added for the instance.(**What message is displayed after you click add??)**

##Installing and configuring DNSaaS<a name="configure"></a>

1. SSH to install VM

		$ ssh debian@<Floating IP Address associated with the Installer Instance above>

**Note**: Before you begin the installation, you must create a configuration file. You can do this by modifying the sample configuration file included with the DNSaaS installer files.
 
2. Copy the sample configuration file to your home directory:

        $ cp /etc/dnsaas-installer/dnsaas-installer.conf.sample ~/dnsaas-installer.conf

2. Edit your copy of the configuration file with the required changes:
 
        $ nano dnsaas-installer.conf
		
	 A. DEFAULT section:
    * auth&#095;url &mdash; Keystone auth URL
    * target&#095;project&#095;name &mdash; Project name where the service is installed
    * target&#095;username &mdash; Username used to deploy and run the service
    * target&#095;region&#095;name &mdash; Region name to deploy the service in
    
    B. Designate section:
    * ssh&#095;public&#095;key &mdash; The SSH public key to be installed on the instances for management access
    * ntp&#095;server &mdash; An IP or DNS name for an NTP server to sync time with
    * database&#095;root&#095;password &mdash; Password for the database root user
    * database&#095;designate&#095;password &mdash; Password for the database designate user
    * database&#095;powerdns&#095;password &mdash; Password for the database powerdns user
    * messaging&#095;root&#095;password &mdash; Password for the messaging root user
    * messaging&#095;designate&#095;password &mdash; Password for the messaging designate user
    * keystone&#095;host &mdash; Hostname or IP address of Keystone endpoint.
    * service&#095;project &mdash; Project name for a user with permission to validate Keystone tokens
    * service&#095;user &mdash; Username for a user with permission to validate Keystone tokens
    * service&#095;password &mdash; Password for a user with permission to validate Keystone tokens
    * backend&#095;driver &mdash; Backend driver to use (powerdns, dynect)

   	C. If you select MSDNS (Microsoft DNS Server) you must set the following options in the designate section:

	* msdns&#095;servers: A comma separated list of the Microsoft DNS servers short hostnames
	* messaging&#095;access&#095;cidr: A CIDR to allow inbound access from the Microsoft DNS servers


	D. If you select DynECT you must set the following options in the designate section:

    * dynext&#095;customer&#095;name &mdash; Customer name provided by Dyn
    	
	*  dynext&#095;username &mdash; Username provided by Dyn
    
	* dynext&#095;password &mdash; Password provided by Dyn


	E. If you select Akamai you must set the following options in the designate section:
	
	* dynext_customer_name: Customer name provided by Dyn
	
	* dynext_username: Username provided by Dyn
	
	* dynect_password: Password provided by Dyn



3. Run the installer validation command to verify the configuration file

      $ dnsaas-installer --target-password <Target User Password> validate

After you validate the configuration file, run the DNSaaS installer:

       $ dnsaas-installer --target-password <Target User Password> install

4.Once the installation in completed, verify that the API and Nameservers are online using the endpoints supplied by the installer. From the installer VM, execute the following commands:

	$ curl http://<API ENDPOINT>:9001/
	{
	  "versions": [
	    {
	      "id": "v1",
	      "status": "CURRENT"
	    }
	  ]
	}
	 
	$ dig @<NAMESERVER ENDPOINT> example.com | grep status
	;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 37351


##Configure the Overcloud Load Balancer for DNSaaS<a name="configovercloud"></a>

 You must configure HAProxy before you configure the OverCloud Load Balance for DNaaS.

* To configure HAProxy use the following command: 

	$ dnsaas-installer --target-password <Target User Password> haproxy

The HA Proxy configuration file will be displayed as the sample below:
	
	2014-09-17 23:31:05.670       INFO HAProxy configuration
	### START HAPROXY CONFIG
	listen designate
	  bind 0.0.0.0:9001
	  mode tcp
	  balance source
	  option tcpka
	  option tcplog
	   
	  server 10.22.171.32 10.22.171.32 check inter 2000 rise 2 fall 5
	  server 10.22.171.22 10.22.171.22 check inter 2000 rise 2 fall 5
	  server 10.22.171.21 10.22.171.21 check inter 2000 rise 2 fall 5
	### END HAPROXY CONFIG


After the configuration of  HAProxy, SSH to all three Overcloud controller. 

Perform the following steps on each controller node:

1. SSH OverCloud as root

		ssh root@<IP address of Overcloud>

2. vi `paas.cfg` to edit the configuration file 

 		/etc/haproxy/manual/paas.cfg

3. Paste the HA Proxy configuration file, which is generated in step 1, at the end of the `pass.cfg` file

4. Save the `pass.cfg` file.

		:wq!

5. Reload HA Proxy

		service haproxy reload 

6. Open the Designate API port in the firewall and run the following command:

   	a. Run `iptables -I INPUT 1 -p tcp -m tcp --dport 9001 -j ACCEPT`

   	b. Run `iptables-save > /etc/iptables/iptables` 


## Registering the service with Keystone<a name="keyreg"></a>

You  can register the DNS service and endpoint as a user or an admin. 

You do not have to immediately register the DNS service in Keystone; however, if you choose to register the DNS service and endpoint execute the following command:
 
* Admin

		$ dnsaas-installer --admin-password <Admin User Password> --target-password <Target User Password> keystone-registration
 
* User
 
		dnsaas-installer --target-password <Target User Password> keystone-registration

##Initial Service Configuration

You must perform an initial configuration step to communicate the names of the servers that serve DNS to Designate. Please ensure you have a valid set of admin credentials in the standard OS_* environment variables before proceeding.

For the "Nameserver FQDNs" gathered during the [prerequisites](#preq) step, issue a `server-create` command for each name to add the server:
 
	$ designate server-create --name ns1.example.com.

For example :

For the HP Helion QA DynECT account:

	designate server-create --name ns1.p13.dynect.net.

##Additional backend install

If you are using Microsoft DNS Server you should perform the following additional steps:

1. Download Designate Microsoft DNS Agent installer.
2. Execute the installer on each of the Microsoft DNS servers.
3. Edit `msdnsagent.conf` files 

		C:\Program Files (x86)\Designate\designate-msdnsagent.conf

4. Restart the `designate-msdnsagent` service using the windows Services GUI. (**are users aware of the window services GUI?? if no how do we direct that to user??)**

##Post-install cleanup

Now the installer VM is not required. Please archive the configuration file used and optionally delete the dnsaas-installer instance.

##Uninstall

To uninstall the DNaaS:

1. Enter the following command to list the DNaaS Stack ID:

	`$ heat stack-list`


2. Delete the Stack ID

		$ heat stack-delete <stack ID>

**Note**: Installer VM can also be deleted, if it is not deleted already.

The Keystone service and endpoints will not be deleted, if you want to remove these services, please refer to the Keystone documentation (here we point to Openstack documentation).

##For more information<a name="moreinfo"></a>
For more information, see:

* [HP Helion Public Cloud DNS API Specifications](https://docs.hpcloud.com/api/dns/)
* [Designate DNSaaS services for OpenStack](https://wiki.openstack.org/wiki/Designate)

<a href="#top" style="padding:14px 0px 14px 0px; text-decoration: none;"> Return to Top &#8593; </a>

----
####OpenStack trademark attribution
*The OpenStack Word Mark and OpenStack Logo are either registered trademarks/service marks or trademarks/service marks of the OpenStack Foundation, in the United States and other countries and are used with the OpenStack Foundation's permission. We are not affiliated with, endorsed or sponsored by the OpenStack Foundation, or the OpenStack community.*

