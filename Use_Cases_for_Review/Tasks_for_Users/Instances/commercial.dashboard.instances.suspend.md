---
layout: default
title: "HP Helion OpenStack&#174; Suspending Instances"
permalink: /helion/commercial/dashboard/managing/instances/suspend/
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

# HP Helion OpenStack&#174; Suspending and Resuming Instances

When a user <em>suspends</em> an instance, the contents of the instance are stored on disk and the instance is stopped. Suspending an instance is similar to placing a device in hibernation; memory and vCPUs become available to create other instances.</p>

Users can suspend an instance, for example, to free up the resources used by an instance that is used infrequently or to perform system maintenance. </p>

**Note:** Suspending is different from <a href="/helion/community/instances/pause/">pausing an instance</a>. Pausing keeps the instance running, (in a &quot;frozen&quot; state) and stores the content of the instance in memory (RAM).  
</p>

### Suspend an instance ###

To suspend an instance:</p>

1. <a href="/helion/community/dashboard/login/">Launch the HP Helion OpenStack Community web interface.</a></p>

2. Click the <strong>Instances</strong> link on the <strong>Project</strong> dashboard <strong>Compute</strong> panel.</p>

3. In the <strong>Instances</strong> screen, for the instance you want to modify, click <strong>More &gt; Suspend Instance</strong>.</p>

	The status of the instance reports *Suspended*.</p>

### Resume an instance ###

To resume an instance:</p>

1. <a href="/helion/community/dashboard/login/">Launch the HP Helion OpenStack Community web interface.</a></p>

2. Click the <strong>Instances</strong> link on the <strong>Project</strong> dashboard <strong>Compute</strong> panel.</p>

3. In the <strong>Instances</strong> screen, for the instance you want to modify, click <strong>More &gt; Resume Instance</strong>.</p>

	The status of the instance reports *Running*. </p>

<a href="#top" style="padding:14px 0px 14px 0px; text-decoration: none;"> Return to Top &#8593; </a></p>


----
####OpenStack trademark attribution
*The OpenStack Word Mark and OpenStack Logo are either registered trademarks/service marks or trademarks/service marks of the OpenStack Foundation, in the United States and other countries and are used with the OpenStack Foundation's permission. We are not affiliated with, endorsed or sponsored by the OpenStack Foundation, or the OpenStack community.*