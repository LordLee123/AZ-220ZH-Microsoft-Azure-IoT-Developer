# Setup Time Series Insights

Azure Time Series Insights (TSI) is an end-to-end platform-as-a-service (PaaS) offering used to collect, process, store, analyze, and query data from Internet of Things (IoT) solutions at scale. TSI is designed for ad hoc data exploration and operational analysis of data that's highly contextualized and optimized for time series.

In this unit, you will setup Time Series Insights (TSI) integration with Azure IoT Hub.

1. Login to [portal.azure.com](https://portal.azure.com) using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. In the Azure Portal, click **+Create a resource** to open the Azure Marketplace.

1. On the **New** blade, in the **Search the Marketplace** box, type in and search for **Time Series Insights**.

1. In the search results, select the **Time Series Insights** item.

1. On the **Time Series Insights** item, click **Create**.

1. On the **Create Time Series Insights** blade, enter `AZ-220-TSI` in the **Environment name** field

1. On the **Resource group** dropdown, select the **AZ-220-RG** resource group.

1. On the **Location** dropdown, select the Azure region used by the Resource group.

1. On the **Tier** field, select the **S1** pricing tier, and leave the **Capacity** at the default of `1`.

1. Click **Next: Event Source**.

1. In the **EVENT SOURCE DETAILS** section, select **Yes** on the **Create an event source?** option.

1. Enter `AZ-220-HUB-{YOUR-ID}` in the **Name** field to specify a unique name for this Event Source.


1. In the **Source type** dropdown, select **IoT Hub**.

1. In the **Select a hub** dropdown, select the **Select existing** option. This will allow you to select an existing IoT Hub that's already been provisioned.

1. In the **IoT Hub name** dropdown, select the `AZ-220-HUB-{YOUR-ID}` Azure IoT Hub service that's already been provisioned.

1. In the **IoT Hub access policy name** dropdown, select the **iothubowner** option.

    In a production environment, it's best practice to create a new _Access Policy_ within Azure IoT Hub to use for configuring Time Series Insights (TSI) access. This will enable the security of TSI to be managed independently of any other services connected to the same Azure IoT Hub.

1. Under the **CONSUMER GROUP** section, click the **New** button next to the **IoT Hub consumer group** dropdown.

1. Enter `tsievents` into the **IoT Hub consumer group** box, and click **Add**.

    This will add a new _Consumer Group_ to use for this Event Source. The Consumer Group needs to be used exclusively for this Event Source, as there can only be a single active reader from a given Consumer Group at a time.

1. Click the **Review + create** button.

1. Click the **Create** button.

    > [!NOTE] Deployment of Time Series Insights (TSI) will take a couple minutes to complete.

1. Once **Time Series Insights** is deployed, navigate to the **AZ-220-TSI** resource.

1. On the **Time Series Insights environment** blade, click on the **Event Sources** link under the **Settings** section.

1. On the **Event Sources**, notice the **AZ-220-HUB-{YOUR-ID}** Event Source in the list. This is the Event Source that was configured when the TSI resource was created.

1. Click the **AZ-220-HUB-{YOUR-ID}** Event Source in the list to view the Event Source details.

1. Notice the configuration of the **Event Source** matches what was set when the Time Series Insights resource was created.
