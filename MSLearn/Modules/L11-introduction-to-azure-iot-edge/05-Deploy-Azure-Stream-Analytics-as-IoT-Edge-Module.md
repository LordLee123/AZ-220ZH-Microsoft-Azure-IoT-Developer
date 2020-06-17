# Deploy Azure Stream Analytics as IoT Edge Module

Now that the tempSensor module is deployed and running on the IoT Edge device, we can add a Stream Analytics module that can process messages on the IoT Edge device before sending them on to the IoT Hub.

## Create Azure Storage Account

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. In the Azure Portal, click **Create a resource** to open the Azure Marketplace.

1. On the **New** blade, select the **Storage** category under **Azure Marketplace**, then click on **Storage account**.

1. On the **Create storage account**, select the existing `AZ-220-RG` group in the **Resource group** field.

1. Set the **Storage account name** field to something unique. This needs to be a globally unique name for the Azure Storage Account.

    To provide a globally unique name, enter **az220store{your-id}** - i.e. followed by your initials and the current date. 

    > [!NOTE] Your initials must be in lower-case for this resource and no dashes.

1. Set the **Location** to the same Azure Region used for Azure IoT Hub.

1. Click **Review + create**.

1. Once validation has passed, click **Create** to deploy the Storage Account.

    This will take a few moments to complete - you can continue creating the Stream Analytics resource while this is being created.

## Create Azure Stream Analytics

1. In the Azure Portal, click **Create a resource** to open the Azure Marketplace.

1. On the **New** blade, select the **Internet of Things** category under **Azure Marketplace**, then click on **Stream Analytics job**.

1. On the **New Stream Analytics job** blade, enter **AZ-220-ASA-{YOUR-ID}** into the **Job name** field followed by your initials and the current date to make sure it's a unique name.

1. In the **Resource group** field, select the existing **AZ-220-RG** group in the **Resource group** field.

1. Set the **Location** to the same Azure Region used for the Storage Account and Azure IoT Hub.

1. Set the **Hosting environment** to **Edge**. This determines that the Stream Analytics job will deployed to an on-premises IoT Gateway Edge device.

1. Click **Create**.

    It will take a few moments to for this resource to be completed.

## Configure Azure Stream Analytics Job

1. Once the **Stream Analytics job** has provisioned, navigate to the resource.

1. In the left side navigation, click on **Inputs** under the **Job topology** section.

1. On the **Inputs** pane, click **Add stream input**, then select **Edge Hub**.

1. On the **New Input** pane, enter `temperature` in the **Input alias** field.

1. In the **Event serialization format** dropdown, select **JSON**. Stream Analytics needs to understand the message format. JSON is the standard format.

1. In the **Encoding** dropdown, select **UTF-8**.

    > [!NOTE] UTF-8 is the only JSON encoding supported at the time of writing.

1. In the **Event compression type** dropdown, select **None**.

    For this lab, compression will not be used. GZip and Deflate formats are also supported by the service.

1. Click **Save**.

1. In the left side navigation, click on **Outputs** under the **Job topology** section.

1. On the **Outputs** pane, click **Add**, then select **Edge Hub**.

1. On the **New output** pane, enter `alert` in the **Output alias** field.

1. In the **Event serialization format** dropdown, select **JSON**. Stream Analytics needs to understand the message format. JSON is the standard format, but CSV is also supported by the service.

1. In the **Format** dropdown, select **Line separated**.

1. In the **Encoding** dropdown, select **UTF-8**.

    > [!NOTE] UTF-8 is the only JSON encoding supported at the time of writing.

1. Click **Save**.

1. In the left side navigation, click on **Query** under the **Job topology** section.

1. In the **Query** pane, replace the Default query with the following:

    ```sql
    SELECT  
        'reset' AS command
    INTO
        alert
    FROM
        temperature TIMESTAMP BY timeCreated
    GROUP BY TumblingWindow(second,15)
    HAVING Avg(machine.temperature) > 500
    ```

    This query looks at the events coming into the `temperature` Input, and groups by a Tumbling Windows of 15 seconds, then it checks if the average temperature value within that grouping is greater than 25. If the average is greater than 25, then it sends an event with the `command` property set to the value of `reset` to the `alert` Output.

    For more information about the `TumblingWindow` functions, reference this link: <https://docs.microsoft.com/en-us/stream-analytics-query/tumbling-window-azure-stream-analytics>

1. Click **Save query**.

## Configure Storage Account Settings

To prepare the Stream Analytics job to be deployed to an IoT Edge Device, it needs to be associated with an Azure Blob Storage container. When the job is deployed, the job definition is exported to the storage container.

1. On the **Stream Analytics job** blade, in the left side navigation, click **Storage account settings** under the **Configure** section.

1. Click **Add storage account**.

1. Select the **Select storage account from your subscription** option.

1. In the **Storage account** dropdown, select the **az220store{your-id}** storage account that was created previously.

1. Under **Container**, select **Create new**, then enter `jobdefinition` as the name of the container.

1. Click **Save**.

## Deploy the Stream Analytics Job

1. In the Azure Portal, navigate to the **AZ-220-HUB-{YOUR-ID}** Azure IoT Hub resource.

1. In the left side navigation, click **IoT Edge** under the **Automatic Device Management** section.

1. Click on the **myEdgeDevice** IoT Edge device within the list of devices.

1. On the **Device Details** pane, click the **Set Modules** button at the top.

1. On the **Add Modules** step, locate the **IoT Edge Modules** section, then click **Add** and select **Azure Stream Analytics Module**.

1. In the **Edge job** dropdown, select the **Steam Analytics job** that was created previously.

    > [!NOTE] The job may already be selected, yet the **Save** button is disabled - just open the **Edge job** dropdown again and select the **AZ-220-ASA-{YOUR-ID}** job again. The **Save** button should then become enabled.

1. Click **Save**. Deployment may take a few moments.

1. Under the **IoT Edge Modules** section, click on the **Steam Analytics Module** that was just added.

1. Notice the **Image URI** points to a standard Azure Stream Analytics image. This is the same image used for every job that gets deployed to an IoT Edge Device.

    ```text
    mcr.microsoft.com/azure-stream-analytics/azureiotedge:1.0.5
    ```

    > [!NOTE] The version number at the end of the **Image URI** that is configured will reflect the current latest version when you created the Stream Analytics Module. At the time or writing this unit, the version was `1.0.5`.

1. Leave all values as their defaults, and close the **IoT Edge Custom Modules** pane.

1. Click **Next: Routes >**.

1. On the **Specify Routes** step, notice the existing routing is displayed.

1. Replace the default routes defined with the following three routes:

    - Route 1
        - Name: **telemetryToCloud**
        - Value: `FROM /messages/modules/tempsensor/* INTO $upstream`
    - Route 2
        - Name: **alertsToReset**
        - Value: `FROM /messages/modules/AZ-220-ASA-{YOUR-ID}/* INTO BrokeredEndpoint(\"/modules/tempsensor/inputs/control\")`
    - Route 3
        - Name: **telemetryToAsa**
        - Value: `FROM /messages/modules/tempsensor/* INTO BrokeredEndpoint(\"/modules/AZ-220-ASA-{YOUR-ID}/inputs/temperature\")`

    Be sure to replace the `AZ-220-ASA-{YOUR-ID}` placeholder with the name of your Azure Stream Analytics job module. You can click **Previous** to view the list of modules and their names, then click **Next** to come back to this step.

    The routes being defined are as follows:

    - The **telemetryToCloud** route sends the all messages from the `tempsensor` module output to Azure IoT Hub.
    - The **alertsToReset** route sends all alert messages from the Stream Analytics Module output to the input of the **tempsensor** module.
    - The **telemetryToAsa** route sends all messages from the `tempsensor` module output to the Stream Analytics Module input.

1. Click **Next: Review + create >**.

1. On the **Review + create** tab, notice the **Deployment Manifest** JSON is now updated with the Stream Analytics module and the routing definition that was just configured.

1. Notice the JSON configuration for the `tempsensor` Simulated Temperature Sensor module:

    ```json
    "tempsensor": {
        "settings": {
            "image": "asaedgedockerhubtest/asa-edge-test-module:simulated-temperature-sensor",
            "createOptions": ""
        },
        "type": "docker",
        "version": "1.0",
        "status": "running",
        "restartPolicy": "always"
    },
    ```

1. Notice the JSON configuration for the routes that were previously configured, and how they are configured in the JSON Deployment definition:

    ```json
    "$edgeHub": {
        "properties.desired": {
            "routes": {
                "telemetryToCloud": "FROM /messages/modules/tempsensor/* INTO $upstream",
                "alertsToReset": "FROM /messages/modules/AZ-220-ASA-CP122619/* INTO BrokeredEndpoint(\\\"/modules/tempsensor/inputs/control\\\")",
                "telemetryToAsa": "FROM /messages/modules/tempsensor/* INTO BrokeredEndpoint(\\\"/modules/AZ-220-ASA-CP122619/inputs/temperature\\\")"
            },
            "schemaVersion": "1.0",
            "storeAndForwardConfiguration": {
                "timeToLiveSecs": 7200
            }
        }
    },
    ```

1. Click **Create**.

## View Data

1. Go back to the **Cloud Shell** session where you're connected to the **IoT Edge Device** over **SSH**.

1. Run the following command to view a list of the modules deployed to the device:

    ```cmd/sh
    iotedge list
    ```

    It can take a minute for the new Stream Analytics module to be deployed to the IoT Edge Device. Once it's there, you will see it in the list output by this command.

    ```cmd/sh
    demouser@AZ-220-VM-EDGE:~$ iotedge list
    NAME               STATUS           DESCRIPTION      CONFIG
    AZ-220-ASA-CP1119  running          Up a minute      mcr.microsoft.com/azure-stream-analytics/azureiotedge:1.0.5
    edgeAgent          running          Up 6 hours       mcr.microsoft.com/azureiotedge-agent:1.0
    edgeHub            running          Up 4 hours       mcr.microsoft.com/azureiotedge-hub:1.0
    tempsensor         running          Up 4 hours       asaedgedockerhubtest/asa-edge-test-module:simulated-temperature-sensor
    ```

    > [!NOTE] If the Stream Analytics module does not show up in the list, wait a minute or two, then try again. It can take a minute for the module deployment to be updated on the IoT Edge Device.

1. Run the `iotedge log` command within the Azure Cloud Shell SSH session on the **IoT Edge Device** to watch the telemetry being sent by the `tempsensor` Simulated Temperature Sensor module:

    ```cmd/sh
    iotedge logs tempsensor
    ```

1. Notice that while watching the temperature telemetry being sent by **tempsensor**, you will see the **reset** command sent by the Stream Analytics job when the `machine.temperature` reaches an average above `500` as configured in the Stream Analytics job query.

    Output of this event will look similar to the following:

    ```cmd/sh
    11/14/2019 22:26:44 - Send Json Event : {"machine":{"temperature":231.599999999999959,"pressure":1.0095600761599359},"ambient":{"temperature":21.430643635304012,"humidity":24},"timeCreated":"2019-11-14T22:26:44.7904425Z"}
    11/14/2019 22:26:45 - Send Json Event : {"machine":{"temperature":531.999999999999957,"pressure":1.0099208337508767},"ambient":{"temperature":20.569532965342297,"humidity":25},"timeCreated":"2019-11-14T22:26:45.2901801Z"}
    Received message
    Received message Body: [{"command":"reset"}]
    Received message MetaData: {"MessageId":null,"To":null,"ExpiryTimeUtc":"0001-01-01T00:00:00","CorrelationId":null,"SequenceNumber":0,"LockToken":"e0e778b5-60ff-4e5d-93a4-ba5295b995941","EnqueuedTimeUtc":"0001-01-01T00:00:00","DeliveryCount":0,"UserId":null,"MessageSchema":null,"CreationTimeUtc":"0001-01-01T00:00:00","ContentType":"application/json","InputName":"control","ConnectionDeviceId":"myEdgeDevice","ConnectionModuleId":"AZ-220-ASA-CP1119","ContentEncoding":"utf-8","Properties":{},"BodyStream":{"CanRead":true,"CanSeek":false,"CanWrite":false,"CanTimeout":false}}
    Resetting temperature sensor..
    11/14/2019 22:26:45 - Send Json Event : {"machine":{"temperature":320.4,"pressure":0.99945886361358849},"ambient":{"temperature":20.940019742324957,"humidity":26},"timeCreated":"2019-11-14T22:26:45.7931201Z"}
    ```

Once you have finished this lab, keep the resources around - you will need them for the next lab.