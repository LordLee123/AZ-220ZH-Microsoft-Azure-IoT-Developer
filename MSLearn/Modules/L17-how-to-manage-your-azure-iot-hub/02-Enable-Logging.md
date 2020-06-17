# Enable Logging

Azure Resource logs are platform logs emitted by Azure resources that describe their internal operation. All resource logs share a common top-level schema with the flexibility for each service to emit unique properties for their own events.

1. Sign in to the **Azure portal** and navigate to your IoT hub.

1. In the left hand navigation, under **Monitoring**, select **Diagnostic settings**.

    > [!NOTE] Diagnostics are disabled by default.

1. At the top of the **Diagnostic settings** page, under **Subscription**, select the subscription you used to create the IoT Hub.

1. Under **Resource group**, select the resource group you used for this lab - "AZ-220-RG".

1. Under **Resource type**, select **IoT Hub**.

1. Under **Resource**, select the IoT Hub you are using for this lab - **AZ-220-HUB-\<INITIALS-DATE\>**.

    Once you select the resource, the page will update with the option to turn on diagnostics, as well as a list of available metrics to monitor.

1. To turn on diagnostics, click **Turn on diagnostics**.

    The **Diagnostic settings** detail pane will be shown.

1. Under **Name**, enter **diags-hub**.

    You can see that there are 3 options available for routing the metrics - you can learn more about each by following the links below:

    * [Archive Azure resource logs to storage account](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs-collect-storage)
    * [Stream Azure monitoring data to an event hub](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/stream-monitoring-data-event-hubs)
    * [Collect Azure resource logs in Log Analytics workspace in Azure Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/resource-logs-collect-workspace)

    In this lab we will use the storage account option.

1. Check **Archive to a storage account** and the **Storage account** configuration section will appear.

1. To specify the storage account to use, click **Configure**.

    The **Select a storage account** pane will appear.

    > [!NOTE] In production, you should not use an existing storage account that has other, non-monitoring data stored in it so that you can better control access to monitoring data. If you are also archiving the Activity log to a storage account though, you may choose to use that same storage account to keep all monitoring data in a central location.

1. On the  **Select a storage account** pane, under **Subscription**, select the subscription you used to create the storage account earlier.

1. Under **Storage account**, select the storage account you created earlier.

1. To complete the storage account selection, click **OK**.

    The **Select a storage account** pane will close and the specified storage account will be displayed under **Storage account**.

1. Under **log**, check **Connections** and **Device Telemetry** and then update the **Retention (days)** value for each to **7**. You can do this by either moving the slider or directly entering **7** into the value textbox.

1. Click **Save** to save the settings.

1. Close the **Diagnostics settings** pane.

    The main **Diagnostics settings** page is displayed - you should see that the list of **Diagnostics settings** has now been updated to show the **diags-hub** setting you just created.

Later, when you look at the diagnostic logs, you'll be able to see the connect and disconnect logging for the device.

## Setup Metrics

Now set up some metrics to watch for when messages are sent to the hub.

1. In the left hand navigation area, under **Monitoring**, click **Metrics**.

    The **Metrics** pane is displayed showing a new, empty, chart.

1. To change the time range and granularity for the chart, at the top-right of the screen, click **Last 24 hours (Automatic)**.

1. In the dropdown that appears, select **Last 4 hours** for **Time Range**, and set **Time Granularity** to **1 minute**, and ensure **Show time as** is set to **local time**.

1. Click **Apply** to save these settings.

1. Under the **Chart Title** and toolbar, you will see a default metric entry.

    We will now add a metric to monitor how many telemetry messages have been sent.

1. Note that the **SCOPE** is already set to the IoT Hub.

1. Under **METRIC NAMESPACE**, note that the **IoT Hub standard metrics** namespace is selected.

    > [!NOTE] By default, there is only one metric namespace available. Namespaces are a way to categorize or group similar metrics together. By using namespaces, you can achieve isolation between groups of metrics that might collect different insights or performance indicators. For example, you might have a namespace called **az220memorymetrics** that tracks memory-use metrics which profile your app. Another namespace called **az220apptransaction** might track all metrics about user transactions in your application. You can learn more about custom metrics and namespaces [here](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/metrics-custom-overview?toc=%2Fazure%2Fazure-monitor%2Ftoc.json#namespace).

1. In the **METRIC** dropdown list, select **Telemetry messages sent**. Notice how many metrics are available!

1. Under **AGGREGATION**, select **Sum**. Notice there are 4 aggregation operations available - *Avg*, *Min*, *Max* and *Sum*.

    We have completed the specification for the first metric. Notice that the chart title has updated to reflect the metric chosen. Now let's add another to monitor the total number of messages used.

1. Under the updated **Chart Title**, in the toolbar, click **Add metric**.

    A new metric will appear. Notice that, again, the **SCOPE** and **METRIC NAMESPACE** values are pre-populated and the **METRIC** dropdown is focused and open.

1. Under **METRIC**, select **Connected devices (preview)**.

1. Under **AGGREGATION**, select **Avg**.

    Your screen now shows the minimized metric for Telemetry messages sent, plus the new metric for avg connected devices. Notice that the chart title has updated to reflect both metrics.

    > [!NOTE]  To edit the chart title, click the **pencil** to the right of the title. 

1. Under the updated **Chart Title**, in the toolbar, click **Pin to dashboard**. Note that you can choose to pin to the current dashboard or choose another. Select the dashboard you created in the first lab - "AZ-220-RG".

    > [!NOTE] In order to retain the chart you have just created, it **must** be pinned to a dashboard.

1. Navigate to the "AZ-220-RG" dashboard and verify the chart is displayed.

    > [!NOTE] You can customize the size and position of the chart by using drag and drop operations.

Now that we have enable logging and setup a chart to monitor metrics, we will set up an alert.