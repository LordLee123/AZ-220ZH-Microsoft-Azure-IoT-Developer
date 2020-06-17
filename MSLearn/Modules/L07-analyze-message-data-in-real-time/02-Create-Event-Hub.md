# Add Azure Event Hub Route and Anomaly Query

In this exercise, we're going to add a query to the Stream Analytics job, and then use Microsoft Power BI to visualize the output from the query. The query searches for spikes and dips in the vibration data, reporting anomalies. We must create the second route, after first creating an instance of an Event Hubs namespace.

## Create an Event Hubs Namespace

In this task, you will use the Azure portal to create an Event Hubs resource.

1. Login to [portal.azure.com](https://portal.azure.com) using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On the portal menu, click **+ Create a resource**.

    The Azure Marketplace is a collection of all the resources you can create in Azure. The marketplace contains resources from both Microsoft and the community.

1. In the Search textbox, type **Event Hubs** and then press Enter.

1. On the search results blade, click **Event Hubs**.

1. To begin the process of creating your new Event Hubs resource, click **Create**.

    The **Create Namespace** blade will be displayed.

1. On the **Create Namespace** blade, under **Name**, enter **vibrationNamespace** plus a unique identifier (your initials and today's date) - i.e. **vibrationNamespaceCAH121219**

    This name must be globally unique.

1. Under **Pricing tier**, select **Standard**.

   >**Note:** Choosing the standard pricing tier enables **Kafka**. The Event Hubs for Kafka feature provides a protocol head on top of Azure Event Hubs that is binary compatible with Kafka versions 1.0 and later for both reading from and writing to Kafka topics. You can learn more about Event Huibs and Apache Kafka [here](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-for-kafka-ecosystem-overview). We will not be using Kafka in this lab.

1. Leave **Make this namespace zone redundant** unchecked.

    > [!NOTE] Checking this option enables enhanced availability by spreading replicas across availability zones within one region at no additional cost - however we don't need this capability for the lab.

1. Under **Subscription**, select the subscription you are using for this lab.

1. Under **Resource group**, select the resource group you are using for this lab - **AZ-220-RG**.

1. Under **Location**, choose the location nearest you.

1. Under **Throughput units**, set the value to 1.

    This lab does not generate sufficient data to warrant increasing the number of units.

1. Leave **Enable Auto-Inflate** unchecked.

    > [!NOTE] Auto-Inflate automatically scales the number of Throughput Units assigned to your Event Hubs Namespace when your traffic exceeds the capacity of the Throughput Units assigned to it. You can specify a limit to which the Namespace will automatically scale. We do not require this feature for this lab.

1. To create the resource, click **Create**, and wait for the resource to be deployed. This can take a few minutes.

Now we have an Event Hubs Namespace, we can create and Event Hubs instance.

## Create an Event Hubs Instance

1. In your [Azure Portal Home page](https://portal.azure.com/#home), search recent resources, or **All Resources**, for the namespace you created in the previous section.

1. Select the namespace - i.e. **vibrationNamespaceCAH121219**.

    The **Overview** blade for the Event Hubs Namespace will be displayed.

1. To create an Event Hubs Instance, click **+ Event Hub**.

    The **Create Event Hub** pane will be displayed.

1. On the **Create Event Hub** pane, under **Name**, enter **vibrationeventhubinstance**.

1. Leave **Partition Count** set to **1**.

    > [!NOTE] Partitions are a data organization mechanism that relates to the downstream parallelism required in consuming applications. The number of partitions in an event hub directly relates to the number of concurrent readers you expect to have. You can increase the number of partitions beyond 32 by contacting the Event Hubs team. The partition count is not changeable, so you should consider long-term scale when setting partition count. In this lab, we only require 1.

1. Leave **Message Retention** values set to **1**.

    > [!NOTE] This is the retention period for events. You can set the retention period between 1 and 7 days. For this lab, we only require the minimum retention.

1. Leave **Capture** values set to **Off**.

    > [!NOTE] Azure Event Hubs Capture enables you to automatically deliver the streaming data in Event Hubs to an Azure Blob storage or Azure Data Lake Store account of your choice, with the added flexibility of specifying a time or size interval. We do not require this feature for the lab.

1. To create the Azure Hubs Instance, click **Create**. Wait for the resource to be deployed.

Now that we have an Event Hubs Namespace and an Event Hubs Instance, we can start to build the route itself.

