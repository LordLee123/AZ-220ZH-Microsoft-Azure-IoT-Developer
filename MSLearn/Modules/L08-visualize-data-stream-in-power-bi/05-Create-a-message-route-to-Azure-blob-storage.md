# Create a Message Route to Azure Blob Storage

In this unit, we'll create and test the logging route.

## Route the logging message to Azure storage

1. In the [Azure Portal](https://portal.azure.com/), ensure the **Overview** page for the IoT Hub you created (**AZ-220-HUB-{YourID}**) is open.

1. In the left-hand menu, under **Messaging**, select **Message routing**.

1. On the **message routing** page, ensure that **Routes** is selected.

1. Click **+ Add** to add the first route.

    The **Add a route** pane is displayed.

1. One the **Add a route** pane, under **Name**, enter **vibrationLoggingRoute**.

1. To the right of **Endpoint**, click **+ Add endpoint**, and select **Storage** from the drop-down list.

    The **Add a storage endpoint** pane is displayed.

1. Under Give the endpoint a descriptive name, such as **vibrationLogEndpoint**.

1. To create storage and select a container, click **Pick a container**.

    A list of the storage accounts already present in the Azure Subscription is listed. at this point you could select an existing storage account and container, however for this lab we will create new ones.

1. To create the storage account, to contain the container, click **+ Storage account**.

    The **Create storage** pane is displayed.

1. On the **Create Storage** pane, under **Name**, enter **vibrationstore** and add your initials and today's date - **vibrationstorecah121119**. 

    > [!NOTE] This field can only contain lower-case letters and numbers, must be between 3 and 24 characters, and must be unique.

1. Under **Account kind**, select **Storage (general purpose V1)**.

1. Under **Performance**, select **Standard**.

    This keeps costs down at the expense of overall performance.

1. Under **Replication**, select **Locally-redundant storage (LRS)**.

    This keeps costs down at the expense of risk mitigation for disaster recovery. In production your solution may require a more robust replication strategy.

1. Under **Location**, choose the location nearest you.

1. To create the resource, click **OK**. Wait until the resource is validated. Validation can take a few minutes.

    Once complete, the **Create storage account** pane will close. The **Storage accounts** screen will now appear. It should have updated and show the storage account that was just created.

1. Search for **vibrationstore**, and select the storage account you just created. 

   The **Containers** pane should appear. As this is a new storage account, there are no containers to list.

1. To create a container, click **+ Container**.

    The **New container** popup is displayed.

1. In the **New container** popup, under **Name**, enter **vibrationcontainer**

   Again, only lower-case letters and numbers are accepted.

1. under **Public access level**, ensure **Private** is selected.

1. To create the container, click **OK**. Wait for your container to be available. 

1. To choose the container for the solution, highlight the container in the list, and click **Select** at the bottom of the page.

    You will return to the **Add a storage endpoint** pane. Note that the **Azure Storage container** has been set to the URL for the storage account and container you just created.

1. Leave the **Batch frequency** and **Chunk size window** to the default values of **100**.

1. Under **Encoding**, note there are two options and that **AVRO** is selected.

    > [!NOTE] By default IoT Hub writes the content in Avro format, which has both a message body property and a message property. The Avro format is not used for any other endpoints. Although the Avro format is great for data and message preservation, it's a challenge to use it to query data. In comparison, JSON or CSV format is much easier for querying data. IoT Hub now supports writing data to Blob storage in JSON as well as AVRO.

1. The final field **File name format** specifies the pattern used to write the data to files in storage. The various tokens are replace with values as the file is created.

1. To create the endpoint, click **Create** at the bottom of the pane. Validation and creation will take a few moments.

    You should now see the **Add a route** pane. 

1. Under **Data source**, ensure **Device Telemetry Messages** is selected.

1. Under **Enable route**, ensure **Enable** is selected.

1. Under **Routing query**, replace **true** with the query below:

    ```sql
    sensorID = "VSLog"
    ```

    This ensures that messages only follow this route if the `sensorID = "VSLog"`.

1. To save this route, click **Save**. Wait for the success message.

    Once completed, the route should be listed on the **Message routing** screen.

1. Verify the displayed route has the following settings:

    * **Name** - vibrationLoggingRoute
    * **Data Source** - DeviceMessages
    * **Routing query** - sensorID = "VSLog"
    * **Endpoint** - vibrationLogEndpoint
    * **Enabled** - true

Before creating the second route, let's verify that the logging route is working. This step requires creating the Stream Analytics job.
