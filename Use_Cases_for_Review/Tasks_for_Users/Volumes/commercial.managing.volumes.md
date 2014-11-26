---
layout: default
title: "HP Helion OpenStack&#174; Managing Block Storage Volumes"
permalink: /helion/commercial/dashboard/managing/volumes/
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
<p style="font-size: small;"> <a href="/helion/commercial/ga1/install/">&#9664; PREV</a> | <a href="/helion/commercial/ga1/install-overview/">&#9650; UP</a> | <a href="/helion/commercial/ga1/">NEXT &#9654;</a> </p>
-->

# HP Helion OpenStack&#174; Managing Block Storage Volumes

Volumes are block storage devices that allow you to expand the storage capacity of an instance. Volumes may only be attached to one server at a time, and will retain data, even when not attached to an instance.</p>

You can create and configure volumes; create snapshots of volumes; update the metadata associated with a volume, extend volumes, and transfer a volume between users, and attach and detach volumes from instances.</p>

How you interact with these images depends upon your user type, either an administrative user (admin) or a non-administrative user (user). </p>

## Managing volumes as a user ##

As a user, you can work with any volume associated with the active project. </p>

	* <a href="/helion/community/volume/create/">Create, edit and delete a volume</a></li>
	* <a href="/helion/community/volume/edit/">Create and delete a snapshot from a volume</a></li>
	* <a href="/helion/community/volume/extend/">Extend the size of a volume</a></li>
	* <a href="/helion/community/volume/attach/">Attach a volume to a VM instance and detach a volume from VM instance</a></li>

## <h2>Managing volumes as an admin ##

**Note:** The administrative user can perform all of the user tasks in addition to the admin tasks.</p>

	* <a href="#create_volume_type">Creating and deleting a volume type</a></li>

<p><a href="#top" style="padding:14px 0px 14px 0px; text-decoration: none;"> Return to Top &#8593; </a></p>


----
####OpenStack trademark attribution
*The OpenStack Word Mark and OpenStack Logo are either registered trademarks/service marks or trademarks/service marks of the OpenStack Foundation, in the United States and other countries and are used with the OpenStack Foundation's permission. We are not affiliated with, endorsed or sponsored by the OpenStack Foundation, or the OpenStack community.*