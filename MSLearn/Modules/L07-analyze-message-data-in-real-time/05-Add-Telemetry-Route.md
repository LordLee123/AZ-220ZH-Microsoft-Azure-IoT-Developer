# Add Telemetry Route

With this new IoT Hub route in place, we need to update our Stream Analytics job to handle the telemetry stream.

## Add a New Input to the Job

1. In your [Azure Portal Home page](https://portal.azure.com/#home), search recent resources, or **All Resources**, for the **vibrationJob** you created in an earlier section.

1. In your Azure portal, select **vibrationJob** from your list of resources.

    The **Stream Analytics Job** blade will open displaying the **Overview** pane.

1. In the left hand navigation, under **Job topology**, click **Inputs**.

1. On the **Inputs** pane, click **+ Add stream input** and then select **Event Hub**.

1. On the **New input** pane, under **Input alias**, enter **vibrationEventInput**

1. Ensure **Select Event Hub from your subscriptions** is selected.

1. Under **Subscription**, select the subscription you have been using for this lab.

1. Under **Event Hub namespace**, select the namespace you entered in the previous section.

1. Under **Event Hub name**, ensure **Use existing** is selected and then select the Event Hub instance you created in the previous section - **vibrationeventhubinstance**.

1. Under **Event Hub policy name**, ensure **RootManageSharedAccessKey** is selected.

    > [!NOTE] The **Event Hub policy key** is populated and read-only.

1. Under **Event Hub Consumer group**, leave it blank - this will use the **$Default** Consumer group.

1. Under **Event serialization format**, ensure **JSON** is selected.

1. Under **Encoding**, ensure **UTF-8** is selected.

1. Under **Event compression type**, ensure **None** is selected.

1. To save the new input, click **Save**. Wait for the input to be created.

    The **Inputs** list should be updated to show the new input.

## Add a new Output

1. To create an output, in the left hand navigation, under **Job topology**, click **Outputs**.

    The **Outputs** pane is displayed.

1. On the **Outputs** pane, click **+ Add**, and select **PowerBI** from the dropdown list.

    The **New output** pane is displayed.

1. Authorize the connection using the PowerBI account you created earlier (or an existing account).

1. On the **New output** pane, under **Output alias**, enter **vibrationBI**.

1. Under **Group workspace**, select the workspace you wish to use.

1. Under **Dataset name**, enter **vibrationDataset**.

1. Under **Table name**, enter **vibrationTable**.

1. Under **Authentication mode**, select **User token**.

1. To create the output, click **Save**. Wait for the output to be created.

    The **Outputs** list will be updated with the new output.

## Update the SQL query for the Job

1. In the left hand navigation, click **Query**.

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

    * Inputs
      * vibrationEventInput
      * vibrationInput
    * Outputs
      * vibrationBI
      * vibrationOutput

    If you see more than 2 of each then you likely have a typo in your query or in the name you used for the input or output - correct the issue before moving on.

1. To save the query, click **Save**.

1. In the left navigation area, to navigate back to the home page of the job, click **Overview**.

1. To start the job again, click **Start** and then click **Start** again.

In order for a human operator to make much sense of the output from this query, we need to visualize the data in a friendly way. One way of doing this visualization is to create a Power BI dashboard.
