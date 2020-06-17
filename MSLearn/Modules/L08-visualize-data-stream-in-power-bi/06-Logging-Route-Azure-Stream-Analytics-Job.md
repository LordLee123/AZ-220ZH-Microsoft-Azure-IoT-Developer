# Logging Route Azure Stream Analytics Job

In the following steps you will create a Stream Analytics job that routes logging messages to Blob storage.

## Create the Stream Analytics Job

1. In the [Azure portal Home page](https://portal.azure.com/#home), select **Create a resource**. 

1. Search for and select **Stream Analytics job**. Click **Create**.

    The **New Stream Analytics** pane is displayed.

1. On the **New Stream Analytics** pane, under **Name**, enter **vibrationJob**.

1. Under **Subscription**, choose the subscription you are using for the lab.

1. Under **Resource group**, select **AZ-220-RG**.

1. Under **Location**, select the location nearest you.

1. Under **Hosting environment**, select **Cloud**.

1. Under **Streaming units**, reduce the number from **3** to **1**.

    This lab does not require 3 units and this will reduce costs.

1. To create the streaming analytics job, click **Create**. Wait for the Deployment succeeded message. Open the new resource.

    > **Tip:** If you miss the message to go to the new resource, or need to find a resource at any time, select **Home/All resources**. Enter enough of the resource name for it to appear in the list of resources.

    You'll now see the empty job, no inputs or outputs, and a skeleton query. The next step is to populate these entries.

1. To create an input, in the left hand navigation, under **Job topology**, click **Inputs**.

    The **Inputs** pane is displayed.

1. On the **Inputs** pane, click **+ Add stream input**, and select **IoT Hub** from the dropdown list.

    The **New Input** pane will be displayed.

1. On the **New Input** pane, under **Input alias**, enter **vibrationInput**.

1. Ensure **Select IoT Hub from your subscriptions** is selected.

1. Under **Subscription**, ensure the subscription you used to create the IoT Hub earlier is selected.

1. Under **IoT Hub**, select the IoT Hub you created at the beginning of the lab - **AZ-220-HUB-{YourID}**.

1. Under **Endpoint**, ensure **Messaging** is selected.

1. Under **Shared access policy name**, ensure **iothubowner** is selected.

    > [!NOTE] The **Shared access policy key** is populated and read-only.

1. Under **Consumer group**, ensure **$Default** is selected.

1. Under **Event serialization format**, ensure **JSON** is selected.

1. Under **Encoding**, ensure **UTF-8** is selected.

1. Under **Event compression type**, ensure **None** is selected.

1. To save the new input, click **Save**. Wait for the input to be created.

    The **Inputs** list should be updated to show the new input.

1. To create an output, in the left hand navigation, under **Job topology**, click **Outputs**.

    The **Outputs** pane is displayed.

1. On the **Outputs** pane, click **+ Add**, and select **Blob storage/Data Lake Storage Gen2** from the dropdown list.

    The **New output** pane is displayed.

1. On the **New output** pane, under **Output alias**, enter **vibrationOutput**.

1. Ensure **Select storage from your subscriptions** is selected.

1. Under **Subscription**, choose the subscription you are using for this lab.

1. Under **Storage account**, choose the storage account you created earlier - **vibrationstore** plus your initials and date.

    > [!NOTE] The **Storage account key** is automatically populated and read-only.

1. Under **Container**, ensure **Use existing** is selected and select **vibrationcontainer** from the dropdown list.

1. Leave **Path pattern** blank.

1. Under **Event serialization format**, ensure **JSON** is selected.

1. Under **Encoding**, ensure **UTF-8** is selected.

1. Under **Format**, ensure **Line separated**.

    > [!NOTE] This setting stores each record as a JSON object on each line and, taken as a whole, results in a file that is an invalid JSON record. The other option, **Array**, ensures that the entire document is formatted as a JSON array where each record is an item in the array. This allows the entire file to be parsed as valid JSON.

1. Leave **Minimum rows** blank.

1. Leave **Minimum time Hours** and **Minutes** blank.

1. Under **Authentication mode**, ensure **Connection string** is selected.

1. To create the output, click **Save**. Wait for the output to be created.

    The **Outputs** list will be updated with the new output.

1. To edit the query, in the left hand navigation, under **Job topology**, click **Query**.

1. In the query edit pane, replace the existing query with the query below:

    ```sql
    SELECT
        *
    INTO
        vibrationOutput
    FROM
        vibrationInput
    ```

1. Above the edit pane, in the toolbar, click **Save Query**.

1. In the left hand navigation, click **Overview**.

## Test the Logging Route

Now for the fun part. Does the telemetry your device app is pumping out work its way along the route, and into the storage container?

1. Ensure the device app you create in Visual Studio Code is still running. If not, run it in the Visual Studio Code terminal using `dotnet run`.

1. In the **vibrationJob** page, click **Start**. Then again in the **Start job** box.

    It will take a few moments for the job to start.

1. Return to the [Azure Portal Home page](https://portal.azure.com/#home).

1. If the **vibrationstore** (plus your initials and date) resource isn't available in the **Recent resources** list, then search for it under **Navigate** and click **All resources**.

1. Select **vibrationstore** (plus your initials and date) and the **Storage Account** overview will open.

1. On the **Overview** page, scroll down until you can see the **Monitoring** section.

1. Under **Monitoring**, adjacent to **Show data for last**, change the time range to **1 hour**. You should see activity in the charts.

1. For added reassurance that all the data is getting to the account, open the storage in **Storage Explorer**. You can find links to **Storage Explorer** in multiple locations, the easiest to find is probably in the left hand navigation area.

    > [!NOTE] The Storage Explorer is currently in preview mode, so its exact mode of operation may change.

1. In **Storage Explorer**, under **BLOB CONTAINERS**, select **vibrationcontainer**.

1. To view the data, you will need to navigate down a hierarchy of folders. The first folder will be named for the IoT Hub, the next will be a partition, then year, month, day and finally hour. Within the hour folder, you will see files named for the minute they were generated.

1. To stop the Azure Streaming Analytics job, return to the **All resources** view and select **vibrationJob**.

1. On the **Stream Analytics Job** page, click **Stop** and click **Yes** in the confirmation popup.

You've traced the activity from the device app, to the hub, down the route, and to the storage container. Great progress!

## Next Steps

The final part of this scenario requires that the telemetry data is sent to an EventHub for real-time analysis in PowerBI. We will cover this second part in the next lab, after you have learnt more about data visualization.

You may wish to exit the device simulator app by pressing **CTRL-C** in the terminal.

>**Important:** Do not remove these resources until you have completed the Data Visualization Aspect.
