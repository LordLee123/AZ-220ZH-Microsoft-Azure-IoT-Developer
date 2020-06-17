---
lab:
    title: 'Lab 08: Visualize a Data Stream in Power BI'
    module: 'Module 4: Message Processing and Analytics'
---

# Visualize a Data Stream in Power BI

> [!NOTE] This lab is a continuation of Lab 7 - Device Message Routing. 

> [!IMPORTANT] This lab has several service prerequisites that are not related to the Azure subscription you were given for the course:
> 1. The ability to sign in to a "Work or School Account" (Azure Active Directory account)
> 2. You must know your account sign-in name, which may not match your e-mail address.
> 3. Access to Power BI, which could be through:
    1. An existing Power BI account
    2. The ability to sign up for Power BI - some organizations block this.
>
> The first lab exercise will validate your ability to access Power BI.  If you are not successful in the first exercise, you will not be able to complete the lab, as there is no quick workaround to this.

## Lab Scenario

You have developed a device simulator that generates vibration data and other telemetry outputs for a conveyor belt system that takes packages and drops them off in mailing bins. You have built and tested a logging route that sends dat to Azure Blob storage.

The second route will be to an Event Hub, because an Event Hub is a convenient input to Stream Analytics. And Stream Analytics is a convenient way of handling anomaly detection, like the excessive vibration we're looking for in our scenario.

This route will be created for the IoT Hub, then added as an input to the Azure Stream Analytics job.

We need to update the job to handle two inputs and two outputs, and a more complex query.

The process of creating the second route follows a similar process to the first, though it diverges at the creation of an endpoint. An Event Hub is chosen as the endpoint for the telemetry route.

In this exercise, you will create an Event Hubs *namespace*. You then have to create an *instance* of the namespace to complete the setting up of an Event Hub. You can then use this instance as the destination for the new message route.

After the route is created, we move on to updating the query.

### Make a Call to a Built-in ML Model

The built-in function we're going to call is `AnomalyDetection_SpikeAndDip`.

The `AnomalyDetection_SpikeAndDip` function takes a sliding window of data, and examines it for anomalies. The sliding window could be, say, the most recent two minutes of telemetry data. This sliding window keeps up with the flow of telemetry in close to real time. If the size of the sliding window is increased, generally the accuracy of anomaly detection will increase too. As will the latency.

As the flow of data continues, the algorithm establishes a normal range of values, then compares new values against those norms. The result is a score for each value, a percentage that determines the confidence level that the given value is anomalous. Low confidence levels are ignored, the question is what percentage confidence value is acceptable? In our query, we're going to set this tipping point at 95%.

There are always complications, like when there are gaps in the data (the conveyor belt stops for a while, perhaps). The algorithm handles voids in the data by imputing values.

Spikes and dips in telemetry data are temporary anomalies. However, as we're dealing with sine waves for vibration, we can expect a short period of "normal" values follow a high or low value that triggers an anomaly alert. The operator is looking for a cluster of anomalies occurring in a short time span. Such a cluster indicates something is wrong.

There are other built-in ML models, such as a model for detecting trends. We don't include these models as part of this module, but the student is encouraged to investigate further.

### Visualize data using Power BI

Visualizing numerical data, especially volumes of it, is a challenge in itself. How can we alert a human operator of the sequence of anomalies that infer something is wrong?

The solution we use in this module is to use some built-in functionality of Power BI. And the ability of Azure Stream Analytics to send data in a real-time format that Power BI can ingest.

We use the dashboard feature of Power BI to create a number of tiles. One tile contains the actual vibration measurement. Another tile is a gauge, showing from 0.0 to 1.0 the confidence level that the value is an anomaly. A third tile indicates if the 95% confidence level is reached. The main tile though shows the number of anomalies detected over the past hour. This tile makes it clear if a clutch of anomalies were detected in short succession.

The fourth tile includes time as the x-axis. This tile allows you to compare the anomalies with the red text in the telemetry console window. Is there a cluster of anomalies being detected when forced, or increasing, or both, vibrations are in action?

Let's create the Event Hub, create the second route, update the SQL query, create a Power BI dashboard, and let it all run!












## In This Lab

This lab includes:

* Sign-up for Power BI
* Verify Lab Prerequisites
* Analyze Telemetry in Real-Time
* Create EventHub
* Create Real-time Message Route
* Add Telemetry Route
* Create a dashboard to visualize data anomalies, using Power BI

## Exercise 1: Sign Up For PowerBI

Power BI can be your personal data analysis and visualization tool, and can also serve as the analytics and decision engine behind group projects, divisions, or entire corporations. Later on in this lab, you will visualize data using PowerBI. This article explains how to sign up for Power BI as an individual.

>**Note:** If you already have a PowerBI subscription, you can skip to the next step.

### Task 1: Understand Supported Email Addresses

Before you start the sign-up process, it's important to learn which types of email addresses that you can use to sign-up for Power BI:

* Power BI requires that you use a work or school email address to sign up. You can't sign up using email addresses provided by consumer email services or telecommunication providers. This includes outlook.com, hotmail.com, gmail.com, and others.

* After you sign up, you can [invite guest users](https://docs.microsoft.com/azure/active-directory/active-directory-b2b-what-is-azure-ad-b2b) to see your Power BI content with any email address, including personal accounts.

* You can sign-up for Power BI with .gov or .mil addresses, but this requires a different process. For more info, see [Enroll your US Government organization in the Power BI service](https://docs.microsoft.com/en-us/power-bi/service-govus-signup).

### Task 2: Sign up for a Power BI Account

Follow these steps to sign up for a Power BI account. Once you complete this process you will have a Power BI (free) license which you can use to try Power BI on your own using My Workspace, consume content from a Power BI workspace assigned to a Power BI Premium capacity or initiate an individual Power BI Pro Trial. 

1. In your browser, navigate to the [sign-up page](https://signup.microsoft.com/signup?sku=a403ebcc-fae0-4ca2-8c8c-7a907fd6c235).

1. On the **Get started** page, enter a supported email address.

1. If you see a message requesting you prove you are not a robot, choose either **Text me** or **Call me** and supply the relevant information to receive a verification code, then continue to the next step in this procedure.

    ![Are you a robot](../../Linked_Image_Files/M99-L07b-prove-robot.png)

    If, instead, you are informed that you already have an account, continue to sign-in and you are ready to use PowerBI.

    ![Are you a robot](../../Linked_Image_Files/M99-L07b-existing-account.png)

1. Check your phone texts or wait for the call, then enter the code that you received, then click **Sign up**.

    ![Sign Up](../../Linked_Image_Files/M99-L07b-sign-up.png)

1. Check your email for a message like this one.

    ![Sign Up](../../Linked_Image_Files/M99-L07b-email-verification.png)

1. On the next screen, enter your information and the verification code from the email. Select a region, review the policies that are linked from this screen, then select Start.

    ![Sign Up](../../Linked_Image_Files/M99-L07b-create-account.png)

1. You're then taken to [Power BI sign in page](https://powerbi.microsoft.com/landing/signin/), and you can begin using Power BI.

Now you have access to Power BI, you are ready to route real-time telemetry data to a Power BI dashboard.

## Exercise 2: Verify Lab Prerequisites

As we need some real-time telemetry, you need to ensure the Device Simulator app from the previous lab is running.

1. In Visual Studio Code, to run the app in the terminal, enter the following command:

    ```bash
    dotnet run
    ```

   This command will run the **Program.cs** file in the current folder.

1. You should quickly see console output, similar to the following:

    ![Console Output](../../Linked_Image_Files/M99-L07-vibration-telemetry.png)

    > [!NOTE] Green text is used to show things are working as they should and red text when bad stuff is happening. If you don't get a screen similar to this image, start by checking your device connection string.

1. Watch the telemetry for a short while, checking that it is giving vibrations in the expected ranges.

1. You can leave this app running, as it's needed for the next section.

## Exercise 3: Add Azure Event Hub Route and Anomaly Query

In this exercise, we're going to add a query to the Stream Analytics job, and then use Microsoft Power BI to visualize the output from the query. The query searches for spikes and dips in the vibration data, reporting anomalies. We must create the second route, after first creating an instance of an Event Hubs namespace.

### Task 1: Create an Event Hubs Namespace

In this task, you will use the Azure portal to create an Event Hubs resource.

1. Login to [portal.azure.com](https://portal.azure.com) using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On the portal menu, click **+ Create a resource**.

    The Azure Marketplace is a collection of all the resources you can create in Azure. The marketplace contains resources from both Microsoft and the community.

2. In the Search textbox, type **Event Hubs** and press **Enter**.

3. On the search results panel under the textbox, click **Event Hubs**.

4. To begin the process of creating your new Event Hubs resource, click **Create event hubs namespace**.

    The **Create Namespace** blade will be displayed.

5. On the **Create Namespace** blade, under **Name**, enter **vibrationNamespace** plus a unique identifier (your initials and today's date) - i.e. **vibrationNamespaceCAH191212**

    This name must be globally unique.

6. Under **Pricing tier**, select **Standard**.

   > [!NOTE] Choosing the standard pricing tier enables _Kafka_. The Event Hubs for Kafka feature provides a protocol head on top of Azure Event Hubs that is binary compatible with Kafka versions 1.0 and later for both reading from and writing to Kafka topics. You can learn more about Event Huibs and Apache Kafka [here](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-for-kafka-ecosystem-overview). We will not be using Kafka in this lab.

7. Leave **Make this namespace zone redundant** unchecked.

    > [!NOTE] Checking this option enables enhanced availability by spreading replicas across availability zones within one region at no additional cost - however we don't need this capability for the lab.

8. Under **Subscription**, select the subscription you are using for this lab.

9. Under **Resource group**, select the resource group you are using for this lab - **AZ-220-RG**.

10. Under **Location**, choose the region you are using for all lab work.

11. Under **Throughput units**, set the value to 1.

    This lab does not generate sufficient data to warrant increasing the number of units.

12. Leave **Enable Auto-Inflate** unchecked.

    > [!NOTE] Auto-Inflate automatically scales the number of Throughput Units assigned to your Event Hubs Namespace when your traffic exceeds the capacity of the Throughput Units assigned to it. You can specify a limit to which the Namespace will automatically scale. We do not require this feature for this lab.

13. To create the resource, click **Create**, and wait for the resource to be deployed. This can take a few minutes.

Now we have an Event Hubs Namespace, we can create and Event Hubs instance.

### Task 2: Create an Event Hubs Instance

1. Navigate back to the Azure Portal home page.

1. In your resource group tile, select your Event Hub namespace, e. g. **vibrationNamespaceCAH191212**.  (If it is not visible, refresh the tile.)

    The **Overview** pane of the **Event Hubs Namespace** blade will be displayed.

2. To create an Event Hubs Instance, at the top of the pane, click **+ Event Hub**.

    The **Create Event Hub** blade will be displayed.

3. On the **Create Event Hub** blade, under **Name**, enter **vibrationeventhubinstance**.

4. Leave **Partition Count** set to **1**.

    > [!NOTE] Partitions are a data organization mechanism that relates to the downstream parallelism required in consuming applications. The number of partitions in an event hub directly relates to the number of concurrent readers you expect to have. You can increase the number of partitions beyond 32 by contacting the Event Hubs team. The partition count is not changeable, so you should consider long-term scale when setting partition count. In this lab, we only require 1.

5. Leave **Message Retention** set to **1**.

    > [!NOTE] This is the retention period for events. You can set the retention period between 1 and 7 days. For this lab, we only require the minimum retention.

6. Leave **Capture** set to **Off**.

    > [!NOTE] Azure Event Hubs Capture enables you to automatically deliver the streaming data in Event Hubs to an Azure Blob storage or Azure Data Lake Store account of your choice, with the added flexibility of specifying a time or size interval. We do not require this feature for the lab.

7. To create the Azure Hubs Instance, click **Create**. Wait for the resource to be deployed.

## Exercise 4: Create Real-Time Message Route

Now that we have an Event Hubs Namespace and an Event Hub, we can start to build the route itself.

## Create a Route to an Event Hub

In this task we will add a message route to our IoT Hub that will send telemetry messages to the Event Hub Instance we just created.

1. Navigate to your Azure Portal dashboard, and select your IoT Hub **AZ-220-HUB-*{YOURID}***) from the resource group tile.

    The **Overview** blade for the IoT Hub will be displayed.

1. On the **Overview** blade, in the left hand navigation, under **Messaging**, select **Message routing**.

1. On the **Message routing** pane, to add a new message route, click **+ Add**.

1. On the **Add a route** blade, under **Name**, enter **vibrationTelemetryRoute**.

2. To the right of the **Endpoint** dropdown, click **+ Add endpoint**. This time, select **Event hubs** for the type of endpoint.

3. On the **Add an event hub endpoint** blade, under **Endpoint name**, enter **vibrationTelemetryEndpoint**.

4. Under **Event hub namespace**, select the namespace you created earlier - i.e. **vibrationNamespaceCAH191212**.

5. Under **Event hub instance**, select the namespace you created earlier - i.e. **vibrationeventhubinstance**.

6. To create the endpoint, click **Create**, and wait for the success message.

    You will be returned to the **Add a route** blade and the **Endpoint** value will have been updated.

7. Under **Data source**, ensure **Device Telemetry Messages** is selected.

8. Under **Enable route**, ensure **Enable** is selected.

9. Under **Routing query**, replace the existing query with the following:

    ```sql
    sensorID = "VSTel"
    ```

    You may recall that the earlier sent "VSLog" messages to the logging storage. This message route will be sending "VSTel" (the telemetry) to the Event Hubs Instance.

10. To create the message route, click **Save**.

11. Once the **Message routing** blade is displayed, verify you have two routes that match the following:

    | Name | Data Source | Routing Query | Endpoint | Enabled |
    |:-----|:------------|:--------------|:---------|:--------|
    |`vibrationLoggingRoute`|`DeviceMessages`|`sensorID = "VSLog"`|`vibrationLogEndpoint`|`true`|
    |`vibrationTelemetryRoute`|`DeviceMessages`|`sensorID = "VSTel"`|`vibrationTelemetryEndpoint`|`true`|

We are now ready to update the Azure Stream Analytics job to hand the real-time device telemetry.

## Exercise 5: Add Telemetry Route

With this new IoT Hub route in place, we need to update our Stream Analytics job to handle the telemetry stream.

### Task 1: Add a New Input to the Job

1. Return to your Azure Portal dashboard, and click on the **vibrationJob** you created in an earlier section.

    The **Stream Analytics Job** blade will open displaying the **Overview** pane.

1. In the left hand navigation, under **Job topology**, click **Inputs**.

1. On the **Inputs** pane, click **+ Add stream input** and then select **Event Hub**.

1. On the **Event Hub** pane, under **Input alias**, enter **vibrationEventInput**

1. Ensure **Select Event Hub from your subscriptions** is selected.

1. Under **Subscription**, select the subscription you have been using for this lab.

1. Under **Event Hub namespace**, select the namespace you entered in the previous section.

1. Under **Event Hub name**, ensure **Use existing** is selected and then select the Event Hub instance you created in the previous section - **vibrationeventhubinstance**.

1. Under **Event Hub policy name**, ensure **RootManageSharedAccessKey** is selected.

    > [!NOTE] The **Event Hub policy key** is populated and read-only.

1. Under **Event Hub Consumer group**, leave it blank - this will use the `$Default` Consumer group.

1. Under **Event serialization format**, ensure **JSON** is selected.

1. Under **Encoding**, ensure **UTF-8** is selected.

1. Under **Event compression type**, ensure **None** is selected.

1. To save the new input, click **Save**. Wait for the input to be created.

    The **Inputs** list should be updated to show the new input.

### Task 2: Add a New Output

1. To create an output, in the left hand navigation, under **Job topology**, click **Outputs**.

    The **Outputs** pane is displayed.

1. On the **Outputs** pane, click **+ Add**, and select **Power BI** from the dropdown list.

    The **Power BI** pane is displayed.

1. Authorize the connection using the Power BI account you created earlier (or an existing account).

1. On the **New output** pane, under **Output alias**, enter **vibrationBI**.

1. Under **Group workspace**, select the workspace you wish to use.  If this is a brand new account, this dropdown will be greyed out.  If you have an existing account, choose an appropriate workspace, or ask your instructor for assistance.

1. Under **Dataset name**, enter **vibrationDataset**.

1. Under **Table name**, enter **vibrationTable**.

1. Under **Authentication mode**, select **User token**, and read the note that appears about revoking access.

1. To create the output, click **Save**. Wait for the output to be created.

    The **Outputs** list will be updated with the new output.

## Update the SQL query for the Job

1. In the left hand navigation, under **Job topology**, click **Query**.

1. Copy and paste the following SQL query, *before* the existing short query.

    ```sql
    WITH AnomalyDetectionStep AS
    (
        SELECT
            EVENTENQUEUEDUTCTIME AS time,
            CAST(vibration AS float) AS vibe,
            AnomalyDetection_SpikeAndDip(CAST(vibration AS float), 95, 120, 'spikesanddips')
                OVER(LIMIT DURATION(second, 120)) AS SpikeAndDipScores
        FROM vibrationEventInput
    )
    SELECT
        time,
        vibe,
        CAST(GetRecordPropertyValue(SpikeAndDipScores, 'Score') AS float) AS
        SpikeAndDipScore,
        CAST(GetRecordPropertyValue(SpikeAndDipScores, 'IsAnomaly') AS bigint) AS
        IsSpikeAndDipAnomaly
    INTO vibrationBI
    FROM AnomalyDetectionStep
    ```

    > [!NOTE] This first section of this query takes the vibration data, and examines the previous 120 seconds worth. The `AnomalyDetection_SpikeAndDip` function will return a `Score` parameter, and an `IsAnomaly` parameter. The score is how certain the ML model is that the given value is an anomaly, specified as a percentage. If the score exceeds 95%, the `IsAnomaly` parameter has a value of 1, otherwise `IsAnomaly` has a value of 0. Notice the 120 and 95 parameters in the first section of the query. The second section of the query sends the time, vibration, and anomaly parameters to `vibrationBI`.

1. Verify that the query editor on lists 2 Inputs and Outputs:

    * `Inputs`
      * `vibrationEventInput`
      * `vibrationInput`
    * `Outputs`
      * `vibrationBI`
      * `vibrationOutput`

    If you see more than 2 of each then you likely have a typo in your query or in the name you used for the input or output - correct the issue before moving on.

1. To save the query, click **Save query**.

1. In the left navigation area, to navigate back to the home page of the job, click **Overview**.

2. To start the job again, click **Start** and then, at the bottom of the **Start job** pane, click **Start**.

In order for a human operator to make much sense of the output from this query, we need to visualize the data in a friendly way. One way of doing this visualization is to create a Power BI dashboard.

## Exercise 6: Create a Power BI Dashboard

Now let's create a dashboard to visualize the query, using Microsoft Power BI.

1. In your browser, navigate to https://app.powerbi.com/.

1. Once Power BI has opened, using the left navigation area, select the workspace you chose above.

    > [!NOTE] At the time of writing a *New Look* is in preview. The steps in this task have been written assuming the *New Look* is **Off**. To turn off the *New Look*, at the top right of the screen, ensure the toggle reads **New look off**.

1. Under **Datasets** verify that `vibrationDataset` is displayed. If not, you might have to wait a short time for this list to populate.

1. At the top right of the page, click **+ Create** and select **Dashboard** from the dropdown list.

1. In the **Create dashboard** popup, under **Dashboard name**, enter **Vibration Dash**.

1. To create the dashboard, click **Create**.

    The new dashboard will be displayed as an essentially blank page.

## Add the Vibration Gauge Tile

1. To add the vibration gauge, at the top of the blank dashboard, click **+ Add tile**.

1. In the **Add tile** pane, under **REAL-TIME DATA**, click **Custom Streaming Data** and then click **Next** at the bottom of the pane.

1. On the **Add a custom streaming data tile** pane, under **YOUR DATASETS**, click **vibrationDataset** and click **Next**.

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

1. On the **Add a custom streaming data tile** pane, under **YOUR DATASETS**, click **vibrationDataset** and click **Next**.

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

Now create a fourth tile, the `Anomalies Over the Hour` line chart.  This one is a bit more complex.

1. At the top of the blank dashboard, click **+ Add tile**.

2. In the **Add tile** pane, under **REAL-TIME DATA**, click **Custom Streaming Data** and then click **Next** at the bottom of the pane.

3. On the **Add a custom streaming data tile** pane, under **YOUR DATASETS**, click **vibrationDataset** and click **Next**.

    The pane will refresh to allow you to choose a visualization type and fields.

4. Under **Visualization Type**, select **Line chart**.

    Notice that changing the visualization type changes the fields below.

5. Under **Axis**, click **+ Add value** and select **time** from the dropdown.

6. Under **Values**, click **+ Add value** and select **IsSpikeAndDipAnomaly** from the dropdown.

    Notice that the chart appears immediately on the dashboard with a value that begins to update!

7. Under **Time window to display**, next to **Last**, select **60** from the dropdown and leave the units set to **Minutes**.

8. To move to the tile details, click **Next**.

9. In the **Tile details** pane, under **Title**, enter **Anomalies over the hour**.

10. Leave the remaining fields as they are and click **Apply**.

    If you see a notification about creating a phone view, you can ignore it and it will disappear shortly (or dismiss it yourself).

11. This time, stretch the tile so its height matches the 3 tiles to the left and its width fits the remaining space of the dashboard.

12. There's a latency with so many routes and connections, but are you now seeing the vibration data coming through?

    > [!NOTE] If no data appears, check you are running the device app and  the analytics job is running.

13. Let the job run for a while, several minutes at least before the ML model will kick in. Compare the console output of the device app, with the Power BI dashboard. Are you able to correlate the forced and increasing vibrations to a run of anomaly detections?

If you're seeing an active Power BI dashboard, you've just  completed this lab. Great work. 

> [!NOTE] Before you go, don't forget to close Visual Studio Code - this will exit the device app if it is still running.

