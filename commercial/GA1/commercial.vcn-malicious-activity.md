---
layout: default
title: "HP Helion OpenStack&#174; Documentation Home"
permalink: /helion/openstack/ga/maskedIP
product: commercial

---
<!--UNDER REVISION-->


<script>

function PageRefresh {
onLoad="window.refresh"
}

PageRefresh();

</script>
# Tracking masked IP addresses when using network address translation (NAT)

Network Address Translation (NAT), also known as floating IP addresses, is a way malicious users mask their originating IP address.  If a malicious user does this, he could perform a masked attack using resources in your Helion OpenStack&#174; cloud.  As a result, you might receive notification of abuse from a masked IP address that is part of your IP address range. Once you have detected such malicious activity, we have a process you can use to track the malicious user.

Since tracking down malicious users can be tricky, if you know the user’s NAT address you can identify his actual IP address using one of the following methods. These methods allow lookup of the Nova VM associated with the source of the abusive network traffic. 


## Method 1


1. Log in to the HP Helion OpenStack Commercial dashboards as cloud admin.

2. Select the project you want to work with.

3. Click the **Access & Security** link on the **Project** dashboard **Compute** panel.

	The **Access & Security** page is displayed with four tabs, **Security Groups**, **Key Pairs**, **Floating IPs**, and **API Access**. 

4. Click the **Floating IPs** tab to activate that tab.

5. In the list of floating IPs, locate the IP you know to be malicious and note the instance the IP is assigned to.

6. Click the name of the instance in the list.

	The **Instance Details** page displays.

	Using this information, you can now see all the details of the malicious instance.  You can choose to shut it down, or contact the instance owner to investigate further. 

## Method 2

1. Login to Network Controller node

2. For each tenant, run the command:   (Assuming 16.103.148.249 as malicious IP address)

        neutron floatingip-list | grep "16.103.148.249" 

    Producing output similar to the following:

        | dc56c9ce-b126-4553-85f4-9a92fd7e8c43 | 192.168.4.4      | 16.103.148.249      | 262e4206-9713-4088-a6e9-928de30afa82 |

3. Capture the fixed-IP (in the second column) (eg.. 192.168.4.4) and tenant id

4. Login to Nova controller node.

5. Run nova list for the captured tenant id and fixed-ip address using the command:

        nova --os-tenant-id=<tenant-id> list | grep "192.168.4.4"
    
    Producing output similar to the following:

        | 47c06647-375e-4bd6-8714-d6841840bd56 | test1 | ACTIVE | None       | Running     | n1=192.168.4.4, 16.103.148.249 |

6. Capture the nova id and get the details of the VM using the command:

        nova  --os-tenant-id=<tenant-id> show 47c06647-375e-4bd6-8714-d6841840bd56

    Producing output similar to the following:

	    +--------------------------------------+-------------------------------+
	    | Property                             | Value                         |
	    +--------------------------------------+-------------------------------+
	    | status                               | ACTIVE                        |
	    | updated                              | 2014-06-26T01:41:05Z          |
	    | OS-EXT-STS:task_state                | None                          |
	    | OS-EXT-SRV-ATTR:host                 | icehousecompute               |
	    | key_name                             | None                          |
	    | image                                | tty-linux (503cd8f1-ae6c …)   |
	    | hostId                               | 091ce2ae798d669b1ec9cc53 …    |
	    | OS-EXT-STS:vm_state                  | active                        |
	    | OS-EXT-SRV-ATTR:instance_name        | instance-0000000f             |
	    | OS-SRV-USG:launched_at               | 2014-06-26T01:41:22.000000    |
	    | OS-EXT-SRV-ATTR:hypervisor_hostname  | icehousecompute.example.com   |
	    | flavor                               | m1.tiny (1)                   |
	    | id                                   | 47c06647-375e-4bd6-8714 …     |
	    | security_groups                      | [{u'name': u'default'}]       |
	    | OS-SRV-USG:terminated_at             | None                          |
	    | user_id                              | e888a6ffca9249bf810f73 …      |
	    | name                                 | test1                         |
	    | created                              | 2014-06-26T01:40:59Z          |
	    | tenant_id                            | 408806a339b340e88d1b1 …       |
	      (etc)
	    | n1 network                           | 192.168.4.4, 16.103.148.249   |
	    | config_drive                         |                               |
	    +--------------------------------------+-------------------------------+
 
 	Using this information, you can now see all the details of the malicious instance.  You can choose to shut it down, or contact the instance owner to investigate further. 
 
## Method 3
1. Login to Network service node

2. Run the command:

        ip netns | grep "qrouter"

    Producing output similar to the following:

        qrouter-0fa45f02-6e89-4707-89f3-0f7c31cf03bf

3. Assuming 16.103.148.249 as malicious ip address, then for each qrouter, run the command:

        ip netns exec qrouter-0fa45f02-6e89-4707-89f3-0f7c31cf03bf iptables –L –v –t nat | grep “16.103.148.249”

    Producing output similar to the following:

        0 0 DNAT  all -- any  any anywhere     16.103.148.249  to:192.168.4.2
        0 0 DNAT  all -- any  any anywhere     16.103.148.24   to:192.168.4.2
        0 0 SNAT  all -- any  any 192.168.4.2  anywhere        to:16.103.148.249
 
4. If the command returns any results, capture the fixed ip address which is 192.168.4.2 in the above example (Look in the “to: “ field of DNAT rows)

5. Login to Nova controller node

6. For each tenant/project, run the following command to search on fixed IP and floating IP:

        nova list | grep "192.168.4.2" | grep "16.103.148.249"

    Producing output similar to the following:

        | 2edf0570-8ed7-4cc4-a836-f4095d64534e | test2 | ACTIVE | None       | Running     | n1=192.168.4.2, 16.103.148.249 |

7. Get the details of the above instance using the command:

        nova show 2edf0570-8ed7-4cc4-a836-f4095d64534e

    Producing output similar to the output in Step 6 of Method 2.

 	Using this information, you can now see all the details of the malicious instance.  You can choose to shut it down, or contact the instance owner to investigate further. 


 <a href="#top" style="padding:14px 0px 14px 0px; text-decoration: none;"> Return to Top &#8593; </a>

----
####OpenStack trademark attribution
*The OpenStack Word Mark and OpenStack Logo are either registered trademarks/service marks or trademarks/service marks of the OpenStack Foundation, in the United States and other countries and are used with the OpenStack Foundation's permission. We are not affiliated with, endorsed or sponsored by the OpenStack Foundation, or the OpenStack community.*