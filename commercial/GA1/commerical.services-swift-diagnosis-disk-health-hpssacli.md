---
layout: default
title: "HP Helion OpenStack&#174; Object Operations Service Overview"
permalink: /helion/openstack/ga/services/swift/diagnosis-disk-health/hpssacli/
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
<p style="font-size: small;"> <a href=" /helion/openstack/ga/services/object/overview/scale-out-swift/">&#9664; PREV</a> | <a href="/helion/openstack/services/overview/">&#9650; UP</a> | <a href="/helion/openstack/services/overview/"> NEXT &#9654</a> </p>-->

#Diagnosis of disk health using hpssacli utility for HP servers

The health of the disk  of the HP servers can be diagnosed using hpsacli utility.


##HP Smart Storage Administrator CLI 2.0.22.0(HPSSACLI)

The HP Smart Storage Administrator CLI (HPSSACLI) is a commandline-based disk configuration program for Smart Array Controllers.

##Deployment of utility on servers

The hpssacli utility is deployed onto the servers wherever the disks are to be monitored. For example: Swift, VSA, and Compute nodes. This page explains about the collection of diagnostic report of disks in the servers where the utility is loaded.

###Download the hpssacli utility into the KVM host

TBD

Where should the user login??




###Copy the utility to seed and to the servers where the disks has to be monitored

Use `scp` to copy the utility package on to the servers and install it.

1. Copy the package from KVM host to SEED.

		scp hpssacli.tar.gz root@1<IP address of Seed>

2. Copy the package from SEED to machine where the disks to be monitored.

		scp hpssacli.tar.gz heat-admin@<IP address of machine>

3. Login to the server where the utility is copied and install the package.

		ssh heat-admin@<IP address of machine>

4. Change the directory

		cd /home/heat-admin/
		
5. List the files

		ls
	All the files present in that directory will be displayed.

6. Search `tar -xvf hpssacli.tar.gz`

7. Extract the tar file. 

		 tar -xvf hpssacli.tar.gz

	The extracted binary file will be available in `/home/heat-admin/hp/hpssacli/bld`

8. Execute the binary file.

	 	 ./hpssacli help
 
	**Note**: The diagnostics can be done in the server or from SEED through ssh.

9. You can collect the diagnostic report of the controller either in server or through SEED using ssh.


**To collect the diagnostic report of the controllers in the server**

1. Login to the server

		ssh heat-admin@<IP address of machine>
2. Change the directory

		/home/heat-admin/hp/hpssacli/bld

3. To know the controller slot
		
		./hpssacli ctrl all show status
 
The slot details appear as shown in the following example:
		Smart Array P420i in Slot 0 (Embedded)
		
		   Controller Status: OK
		
		   Cache Status: OK
		
		   Battery/Capacitor Status: OK

4.To generate the diagnostic report of the particular slot

		./hpssacli ctrl slot=0 diag file=<filenmae.zip>

or 
 To generate the diagnostic report for all slots

		./hpssacli ctrl all diag file=<filename.zip>


The file will be in location you mentioned.

5.Copy the generated file to the desired location

6. Extract the file

7. Open the ADUReport.htm file in the browser.




 
<a href="#top" style="padding:14px 0px 14px 0px; text-decoration: none;"> Return to Top &#8593; </a>


*The OpenStack Word Mark and OpenStack Logo are either registered trademarks/service marks or trademarks/service marks of the OpenStack Foundation, in the United States and other countries and are used with the OpenStack Foundation's permission. We are not affiliated with, endorsed or sponsored by the OpenStack Foundation, or the OpenStack community.*