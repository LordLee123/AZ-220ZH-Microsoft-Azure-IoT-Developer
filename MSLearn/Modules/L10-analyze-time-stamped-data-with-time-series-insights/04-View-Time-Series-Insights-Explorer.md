# View Time Series Insights Explorer

In this unit, you will be introduced to working with time series data using the Time Series Insights (TSI) Explorer.

1. Login to [portal.azure.com](https://portal.azure.com) using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On your Resource group tile, click the **AZ-220-TSI** Time Series Insights (TSI) resource.

1. On the **Time Series Insights environment** blade, click the **Go to Environment** button at the top.

1. This will open the **Time Series Insights Explorer** in a new browser tab.

1. On the **Analyze** view within TSI Explorer, locate the **MEASURE** dropdown within the box for creating new queries, and select the `temperature` value.

1. Within the **SPLIT BY** dropdown, select the `iothub-connection-device-id` value. This will split the graph to show the telemetry from each of the IoT Devices separately on the graph.

1. Click **Add**.

1. At the top of the **Time Series Insights Explorer**, click the toggle to enable **Auto Refresh**.

    When **Auto refresh** is enabled, the display will be updated every _30 seconds_ to display the latest data. This only applies to the last 1 hour of available data.

1. Notice the graph now displays the **temperature** sensor event data from the IoT Devices within Azure IoT Hub in a _Line Chart_.

1. You can see the list of **Device IDs** to the left of the graph. Hovering the mouse over a specific Device ID will highlight it's data on the graph display.

1. As you watch the graph data auto-refresh as telemetry is streaming into the system from the simulated devices, notice that the spikes in **temperature** of the **ContainerDevice** correlate with the temperature spikes of the **TruckDevice**. This gives you an indication that the ContainerDevice is being transported by Truck at those times.

1. Add another new query, by setting the **MEASURE** dropdown to `humidity`, the **SPLIT BY** dropdown to `iothub-connection-device-id`, and click **Add**.

1. Notice that there are now two graphs displayed; a graph for each of the **temperature** and **humidity** telemetry.

1. Notice that when you hover the mouse cursor over the graph, a popup will display when you hover over the data on the graph. This popup will display the minimum (**min**), average (**avg**), and maximum (**max**) values for the data points in the graph.

    When hovering over the **temperature** graph, the popup will display the **min**, **avg**, and **max** values for the data point under the mouse cursor.

1. Notice you can adjust the time span selection interface bar above the graphs to adjust the time series selection of data to view in the graphs.

Once you have completed exploring the data, don't forget to stop the device simulator app by pressing **CTRL+C** in the terminal.
