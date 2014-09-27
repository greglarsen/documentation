---
layout: default
title: "HP Helion OpenStack: Updates and Extension"
permalink: /helion/openstack/ga/undercloud/admin/updates-and-extension/
product: commercial.ga.


---
<!--UNDER REVISION-->


<script>

function PageRefresh {
onLoad="window.refresh"
}

PageRefresh();

</script>

<!--
<p style="font-size: small;"> <a href="/helion/openstack/install-beta/prereqs/">&#9664; PREV</a> | <a href="/helion/openstack/install-beta-overview/">&#9650; UP</a> | <a href="/helion/openstack/install-beta/vsa/">NEXT &#9654;</a> </p> --->

#Updates and Extensions

HP provides a simple mechanism to download and install content and updates for the overcloud.

* [Register on the Cloud Distribution Network](#Signup-for-Cloud-Distribution-Network)
* [Configure credentials](#configcre)
* [Import and install](#import-and-install)
* [Download a package](#download-a-package)

##Register for Cloud OS Distribution Network Access<a name="Signup-for-Cloud-Distribution-Network"></a>

You cannot access the updates from the HP Helion Horizon Undercloud Dashboard unless you are a registered user.

To register on the Cloud Distribution Network:

1.  On the HP Helion Horizon Undercloud dashboard, click **Admin** Tab in the left panel.

2.	Click **Updates and Extensions** and then select **Updates and Extensions** to open the Updates and Extensions page.

3.	Click **Configure** displayed at the top right corner of the page to display the Configure dialog box.

4.	Click **Sign up Now** displayed below the description in the Configure dialog box.<br>
The page navigates to HP Helion Product Catalog. Do the following:</br> 
    
5.  Click **Sign In** displayed at the top of the page to open the HP Web ID dialog box.

6. Click **Sign Up for Web ID** to create a login credentials. HP WEB ID dialog box is displayed 
    
7. Enter the required details.
  
8. Select the check box against **I agree to the Terms of Use** to accept the terms and conditions..

9. Click **Submit**.<br>The credentials are authenticated and the account is created.

Once you register yourself on the HP Helion Product Catalog, you are required to configure your 
credentials.

##Configure credentials<a name="configcre"></a>

To configure your credentials:

1.  On the HP Helion Horizon Undercloud dashboard, click **Admin** Tab in the left panel.

2.	Click **Updates and Extensions** and then select **Updates and Extensions** to open the Updates and Extensions page.

3.	Click **Configure** displayed at the top right corner of the page to display the Configure dialog box.

4. In the **User Name** box, enter the email ID that you have created while setting up your account in HP Helion Product Catalog. 

5.	In the **Password** box, enter the password that you have created for your account in the HP Helion Product Catalog.

6.	Click **OK** to save the details.<br>The Updates and Extensions page is displayed with the list of available patches.</br>


	OR

	Click **Cancel** to abort and go to the previous screen.

##Import and install {#import-and-install}

To import a package that is stored on your local system, do the following:

1.  On the HP Helion Horizon Undercloud Dashboard, click **Admin** Tab in the left panel.<br> The tab displays an option in the left panel.

2.	Click **Updates and Extensions** and then select **Updates and Extensions** to open the Updates and Extensions page.

3.	Click **Import** displayed at the top right corner of the page. An import dialog box is displayed.

4.	Click **Browse** to select and import the **.csu** file.<br>The imported file is displayed in the Import dialog box.</br> **Note**: Only CSU file is supported.

5.	Click **Import**.<br>The file is imported to your local cloud and displayed in the Updates and Extensions page.


	OR

	Click **Cancel** to abort and go to the previous screen.

6. Click **Install** to install the imported file. Install dialog box is displayed.

7. Click **Install**.  A message is displayed after successful installation.

8. (Optional) To view progress of the installation, click **More** drop-down list and select **View Progress**.



## Download a package<a name="download-a-package"></a>

Perform the following steps to download the packages:

1. On the HP Helion Horizon Undercloud Dashboard, click **Admin** Tab in the left panel.

2.	Click **Updates and Extensions** and then select **Updates and Extensions** to open the Updates and Extensions page.
3.	Click **More** drop-down list and select **Download** against the package that you want to download on your local system. A Confirm Download Update dialog box is displayed.

4. Click **Download** to download the package. A message is displayed when the .csu file is successfully downloaded.


	OR

	Click **Cancel** to abort and go to the previous screen.

7. (Optional) To view the download status, click **More** drop-down list and select **View Progress**. <br>The View Progress box is displayed, containing the log, updated name, updated version, task type, and the status of the task. 



<a href="#top" style="padding:14px 0px 14px 0px; text-decoration: none;"> Return to Top &#8593; </a>

----
####OpenStack trademark attribution
*The OpenStack Word Mark and OpenStack Logo are either registered trademarks/service marks or trademarks/service marks of the OpenStack Foundation, in the United States and other countries and are used with the OpenStack Foundation's permission. We are not affiliated with, endorsed or sponsored by the OpenStack Foundation, or the OpenStack community.*



