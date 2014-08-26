---
layout: default
title: "HP Helion OpenStack&#174; Orchestration Service Overview"
permalink: /helion/openstack/ga/services/orchestration/overview/
product: commercial

---
<!--UNDER REVISION-->

<script>

function PageRefresh {
onLoad="window.refresh"
}

PageRefresh();

</script>


<p style="font-size: small;"> <a href="/helion/openstack/services/object/overview/">&#9664; PREV</a> | <a href="/helion/openstack/services/overview/">&#9650; UP</a> | <a href="/helion/openstack/services/reporting/overview/"> NEXT &#9654</a> </p>

# HP Helion OpenStack&#174; Orchestration Service Overview#

<!-- modeled after HP Cloud Networking Getting Started (network.getting.started.md) -->

Leveraging OpenStack Heat, the HP Helion OpenStack Orchestration service provides a template-based orchestration for describing a cloud application by executing OpenStack API calls to generate running cloud applications.  

## Working with the Orchestration Service

To [perform tasks using the Orchestration service](#howto), you can use the dashboard, API or CLI.

### Using the dashboards {#UI}

You can use the [HP Helion OpenStack Dashboard](/helion/openstack/dashboard/how-works/) to work with the Orchestration service.

###Using the API### {#API}
 
You can use a low-level, raw REST API access to the Orchestration service. See the [OpenStack Orchestration API v1 Reference](http://developer.openstack.org/api-ref-orchestration-v1.html).

###Using the CLI### {#cli}

You can use any of several command-line interface software to access the Orchestration service. See the [OpenStack Command Line Interface Reference](http://docs.openstack.org/cli-reference/content/heatclient_commands.html).

For more information on installing the CLI, see [Install the OpenStack command-line clients](http://docs.openstack.org/user-guide/content/install_clients.html).


## How To's with the HP Helion Orchestration Service ## {#howto}

<!-- Taken from http://docs.openstack.org/user-guide/content/heatclient_commands.html -->

The following lists of tasks can be performed by a user or administrator through the [HP Helion OpenStack Dashboard](/helion/openstack/dashboard/how-works/), the OpenStack [CLI](http://docs.openstack.org/cli-reference/content/heatclient_commands.html) or OpenStack [API](http://developer.openstack.org/api-ref-orchestration-v1.html).

### Working with stacks ###

The Orchestration service allows users to work with stacks, which are a mechanism of using built-in stack definitions for specific resource types. This option allows you to perform the following functions:

- **Create and delete stacks** -- Create or delete stacks.
- **Resume a stack** -- Resume the operation of stacks.
- **Suspend A stack** -- Suspend the operation of stacks.
- **List a user's stacks** -- View a list of stacks for a specific user.
- **Describe a stack** -- View information on stacks.
- **List events for a stack** -- List system events for stacks.
- **Update a stack** -- Configure stacks.
- **Get the template for the specified stack** -- View the template used to create a stack.
- **Validate a template with parameters** -- Validate a stack template.
- **Show list of resources belonging to a stack** -- List infrastructure resources associated with a stack.
- **List resource metadata** -- Show a list of meta data associated with infrastructure resources.
- **Describe the resource** -- Show details of an infrastructure resource.

## For more information ##

For information on how to operate your cloud we suggest you read the [OpenStack Operations Guide](http://docs.openstack.org/ops/). The *Architecture* section contains useful information about how an OpenStack Cloud is put together. However, the HP Helion OpenStack takes care of these details for you. The *Operations* section contains information on how to manage the system.

 <a href="#top" style="padding:14px 0px 14px 0px; text-decoration: none;"> Return to Top &#8593; </a>

----
####OpenStack trademark attribution
*The OpenStack Word Mark and OpenStack Logo are either registered trademarks/service marks or trademarks/service marks of the OpenStack Foundation, in the United States and other countries and are used with the OpenStack Foundation's permission. We are not affiliated with, endorsed or sponsored by the OpenStack Foundation, or the OpenStack community.*
