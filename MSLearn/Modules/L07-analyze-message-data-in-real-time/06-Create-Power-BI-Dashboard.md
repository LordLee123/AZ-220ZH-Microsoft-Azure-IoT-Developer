# Create a Power BI Dashboard

Now let's create a dashboard to visualize the query, using Microsoft Power BI.

1. In your browser, navigate to [outlook.office365.com](https://outlook.office365.com).

   This URL will take you to the mail inbox. You may have to enter your Microsoft Account login information.

1. Click the nine dots icon (top left) to display a drop-down list and select **All apps**.

1. In the list of all apps, scroll down and select **Power BI**.

1. Once Power BI has opened, using the left navigation area, select the workspace you chose above.

    > [!NOTE] At the time of writing a *New Look* is in preview. The steps in this task have been written assuming the *New Look* is **Off**. To turn off the *New Look*, click **...** to the left of the user image in the top right and toggle **New Look** in the dropdown menu.

1. Under **Datasets** verify that **vibrationDataset** is displayed. If not, you might have to wait a short time for this list to populate.

1. At the top right of the page, click **+ Create** and select **Dashboard** from the dropdown list.

1. In the **Create dashboard** popup, under **Dashboard name**, enter **Vibration Dash**.

1. To create the dashboard, click **Create**.

    The new dashboard will be displayed as an essentially blank page.

## Add the Vibration Gauge Tile

1. To add the vibration gauge, at the top of the blank dashboard, click **+ Add tile**.

1. In the **Add tile** pane, under **REAL-TIME DATA**, click **Custom Streaming Data** and then click **Next** at the bottom of the pane.

1. On the **Add a custom streaming data tile** pane, under **YOUR DATASETS**, click **vibrationDatset** and click **Next**.

    The pane will refresh to allow you to choose a visualization type and fields.

1. Under **Visualization Type**, select **Gauge**.

    Notice that changing the visualization type changes the fields below.

1. Under **Value**, click **+ Add value** and select **Vibe** from the dropdown.

    Notice that the gauge appears immediately on the dashboard with a value that begins to update!

1. To move to the tile details, click **Next**.

1. In the **Tile details** pane, under **Title**, enter **Vibration**.

1. Leave the remaining fields as they are and click **Apply**.

    If you see a notification about creating a phone view, you can ignore it and it will disappear shortly (or dismiss it yourself).

1. To reduce the size of the tile, move your mouse over the bottom-right corner of the tile and click-and-drag the resize icon. Make the tile as small as you can.

### Add the SpikeAndDipScore Clustered Bar Chart Tile

1. To add the SpikeAndDipScore Clustered Bar Chart, at the top of the blank dashboard, click **+ Add tile**.

1. In the **Add tile** pane, under **REAL-TIME DATA**, click **Custom Streaming Data** and then click **Next** at the bottom of the pane.

1. On the **Add a custom streaming data tile** pane, under **YOUR DATASETS**, click **vibrationDatset** and click **Next**.

    The pane will refresh to allow you to choose a visualization type and fields.

1. Under **Visualization Type**, select **Clustered bar chart**.

    Notice that changing the visualization type changes the fields below.

1. Skip the **Axis** and **Legend** fields - we don't need them.

1. Under **Value**, click **+ Add value** and select **SpikeAndDipScore** from the dropdown.

    Notice that the chart appears immediately on the dashboard with a value that begins to update!

1. To move to the tile details, click **Next**.

1. This time, we don't need to enter a **Title** as the value label is sufficient.

1. Leave the remaining fields as they are and click **Apply**.

    If you see a notification about creating a phone view, you can ignore it and it will disappear shortly (or dismiss it yourself).

1. Again, reduce the size of the tile by moving your mouse over the bottom-right corner of the tile and click-and-drag the resize icon. Make the tile as small as you can.

## Add the IsSpikeAndDipAnomaly Card Tile

1. To add the IsSpikeAndDipAnomaly Card, at the top of the blank dashboard, click **+ Add tile**.

1. In the **Add tile** pane, under **REAL-TIME DATA**, click **Custom Streaming Data** and then click **Next** at the bottom of the pane.

1. On the **Add a custom streaming data tile** pane, under **YOUR DATASETS**, click **vibrationDatset** and click **Next**.

    The pane will refresh to allow you to choose a visualization type and fields.

1. Under **Visualization Type**, select **Card**.

1. Under **Value**, click **+ Add value** and select **IsSpikeAndDipAnomaly** from the dropdown.

    Notice that the chart appears immediately on the dashboard with a value that begins to update!

1. To move to the tile details, click **Next**.

1. In the **Tile details** pane, under **Title**, enter **Is anomaly?**.

1. Leave the remaining fields as they are and click **Apply**.

    If you see a notification about creating a phone view, you can ignore it and it will disappear shortly (or dismiss it yourself).

1. Again, reduce the size of the tile by moving your mouse over the bottom-right corner of the tile and click-and-drag the resize icon. Make the tile as small as you can.

## Rearrange the Tiles

1. Using drag-and-drop, arrange the tiles on the left of the dashboard in the following order:

    * SpikeAndDipScore
    * Is Anomaly?
    * Vibration

## Add Anomalies Over The Hour Line Chart Tile

Now create a fourth tile, this time a bit more complex.

1. To add the **Anomalies Over The Hour** line chart, at the top of the blank dashboard, click **+ Add tile**.

1. In the **Add tile** pane, under **REAL-TIME DATA**, click **Custom Streaming Data** and then click **Next** at the bottom of the pane.

1. On the **Add a custom streaming data tile** pane, under **YOUR DATASETS**, click **vibrationDatset** and click **Next**.

    The pane will refresh to allow you to choose a visualization type and fields.

1. Under **Visualization Type**, select **Line chart**.

    Notice that changing the visualization type changes the fields below.

1. Under **Axis**, click **+ Add value** and select **time** from the dropdown.

1. Under **Values**, click **+ Add value** and select **IsSpikeAndDipAnomaly** from the dropdown.

    Notice that the chart appears immediately on the dashboard with a value that begins to update!

1. Under **Time window to display**, next to **Last**, select **60** from the dropdown and leave the units set to **Minutes**.

1. To move to the tile details, click **Next**.

1. In the **Tile details** pane, under **Title**, enter **Anomalies over the hour**.

1. Leave the remaining fields as they are and click **Apply**.

    If you see a notification about creating a phone view, you can ignore it and it will disappear shortly (or dismiss it yourself).

1. This time, stretch the tile so its height matches the 3 tiles to the left and its width fits the remaining space of the dashboard.

1. There's a latency with so many routes and connections, but are you now seeing the vibration data coming through?

    > [!NOTE] If no data appears, check you are running the device app and  the analytics job is running.

1. Let the job run for a while, several minutes at least before the ML model will kick in. Compare the console output of the device app, with the Power BI dashboard. Are you able to correlate the forced and increasing vibrations to a run of anomaly detections?

If you're seeing an active Power BI dashboard, you've just  completed this lab. Great work. 

> [!NOTE] Before you go, don't forget to close Visual Studio Code - this will exit the device app if it is still running.