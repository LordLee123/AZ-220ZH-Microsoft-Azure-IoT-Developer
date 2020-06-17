# Create an Device Provisioning Service using the Azure portal

The Azure IoT Hub Device Provisioning Service is a helper service for IoT Hub that enables zero-touch, just-in-time provisioning to the right IoT hub without requiring human intervention. The Device Provisioning Service provides the following:

* Zero-touch provisioning to a single IoT solution without hardcoding IoT Hub connection information at the factory (initial setup)
* Load balancing devices across multiple hubs
* Connecting devices to their owner’s IoT solution based on sales transaction data (multitenancy)
* Connecting devices to a particular IoT solution depending on use-case (solution isolation)
* Connecting a device to the IoT hub with the lowest latency (geo-sharding)
* Reprovisioning based on a change in the device
* Rolling the keys used by the device to connect to IoT Hub (when not using X.509 certificates to connect)

There are several methods that you can use to create an instance of the IoT Hub Device Provisioning Service. For example, you can use the Azure portal, which is what you will do in ths task. But you can also create a DPS instance using Azure CLI or an Azure Resource Manager Template.

In this task, you will use the Azure portal to create an instance of the IoT Hub Device Provisioning Service.

1. Login to [portal.azure.com](https://portal.azure.com) using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Notice that the AZ-220 dashboard that you created in the previous task has been loaded.

    You will be adding resources to your dashboard as the course continues.

1. On the portal menu, click **+ Create a resource**.

    The Azure Marketplace is a collection of all the resources you can create in Azure. The marketplace contains resources from both Microsoft and the community.

1. In the Search textbox, type **Device Provisioning Service** and then press Enter.

1. On the search results blade, click **IoT Hub Device Provisioning Service**.

    Notice the list of _Useful Links_ displayed on this blade.

1. In the list of links, click **Documentation**.

    The IoT Hub Device Provisioning Service Documentation page is the root page for DPS. You can use this page to explore current documentation and find tutorials and other resources that will help you to explore activities that are outside the scope of this course. We will refer you to the docs.microsoft.com site throughout this course for additional reading on specific topics.

1. Use your browser to navigate back to the Azure portal tab.

1. To begin the process of creating your new DPS instance, click **Create**.

    Next, you need to specify information about the Hub and your subscription. The following steps walk you through the settings, explaining each of the fields as you fill them in.

1. Under **Name**, enter a unique name for your Device Provisioning Service.

    To provide a unique name, enter **AZ-220-DPS-_{YOUR-ID}_**.

    For example: **AZ-220-DPS-CAH191216**

1. On the _IoT Hub Device Provisioning Service_ blade, ensure that the Azure **Subscription** that you intend to use for this course is selected.

2. Under **Resource Group**, open the **Select existing** dropdown, and then click **AZ-220-RG**

    This is the resource group that you created in the previous lab. We will be grouping the resources that we create for this course together in the same resource group. This should help you to clean up your resources when you have completed the course.

3. Under **Location**, open the drop-down list and select the same region as your resource group.
   
    As we saw previously, Azure is supported by a series of datacenters that are placed in regions all around the world. When you create something in Azure, you deploy it to one of these datacenter locations.

    > [!NOTE] When picking a datacenter to host your app, keep in mind that picking a datacenter close to your end users will decrease load/response times. If you are on the other side of the world from your end users, you should not be picking the datacenter nearest you.

4.  At the bottom of the blade, click **Create**.

    Deployment can take a minute or more to complete. You can open the Azure portal Notification pane to monitor progress.

5.  Notice that after a couple of minutes you receive a notification stating that your IoT Hub Device Provisioning Service instance was successfully deployed to your **AZ-220-RG** resource group.

6.  On the portal menu, click **Dashboard**, and then click **Refresh**.

    You should see that your resource group tile lists your new IoT Hub Device Provisioning Service.
