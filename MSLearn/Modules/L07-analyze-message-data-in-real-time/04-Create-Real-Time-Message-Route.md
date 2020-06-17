# Create Real-Time Message Route

Now that we have an Event Hubs Namespace, an Event Hubs Instance, and access to PowerBI, we can start to build the route itself.

## Create a Route to an Event Hub

In this task we will add a message route to our IoT Hub that will send telemetry messages to the Event Hub Instance we just created.

1. In your [Azure Portal Home page](https://portal.azure.com/#home), search recent resources, or **All Resources**, for the Azure IoT Hub you created in an earlier section.

1. Select the IoT Hub - i.e. **AZ-220-HUB-CAH121119**.

    The **Overview** blade for the IoT Hub will be displayed.

1. On the **Overview** blade, in the left hand navigation, select **Message routing**.

1. On the **Message routing** pane, to add a new message route, click **+ Add**.

1. On the **Add route** blade, under **Name**, enter **vibrationTelemetryRoute**.

1. Adjacent to **Endpoint**, click **+ Add endpoint**. This time, select **Event hubs** for the type of endpoint.

1. On the **Add an event hub endpoint** blade, under **Endpoint name**, enter **vibrationTelemetryEndpoint**.

1. Under **Event hub namespace**, select the namespace you created earlier - i.e. **vibrationNamespaceCAH121219**.

1. Under **Event hub instance**, select the namespace you created earlier - i.e. **vibrationeventhubinstance**.

1. To create the endpoint, click **Create**, and wait for the success message.

    You will be returned to the **Add a route** blade and the **Endpoint** value has been updated.

1. Under **Data source**, ensure **Device Telemetry Messages** is selected.

1. Under **Enable route**, ensure **Enable** is selected.

1. Under **Routing query**, replace the existing query with the following:

    ```sql
    sensorID = "VSTel"
    ```

    You may recall that the earlier sent "VSLog" messages to the logging storage. This message route will be sending "VSTel" (the telemetry) to the Event Hubs Instance.

1. To create the message route, click **Save**.

1. Once the **Message routing** blade is displayed, verify you have two routes that match the following:

    | Name | Data Source | Routing Query | Endpoint | Enabled |
    |:-----|:------------|:--------------|:---------|:--------|
    |vibrationLoggingRoute|DeviceMessages|sensorID = "VSLog"|vibrationLogEndpoint|true|
    |vibrationTelemetryRoute|DeviceMessages|sensorID = "VSTel"|vibrationTelemetryEndpoint|true|

We are now ready to update the stream analytics job to hand the real-time device telemetry.