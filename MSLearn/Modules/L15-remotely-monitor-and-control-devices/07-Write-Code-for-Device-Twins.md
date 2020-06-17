# Write Code for Device Twins

In this unit, we'll add some code to both the device app and back-end service app, to show device twin synchronization in operation.

## Add Code To Use Device Twins To Synchronize Device Properties

1. Return to the Visual Studio Code instance that is running the **cheesecaveoperator** app.

1. If the app is still running, place input focus on the terminal and press **CTRL+C** to exit the app.

1. In the editor, ensure **Program.cs** is open.

1. Add the following code to the end of the **ReadDeviceToCloudMessages** class:

    ```csharp
    // Device twins section.
    private static RegistryManager registryManager;

    private static async Task SetTwinProperties()
    {
        var twin = await registryManager.GetTwinAsync("CheeseCaveID");
        var patch =
            @"{
                tags: {
                    customerID: 'Customer1',
                    cellar: 'Cellar1'
                },
                properties: {
                    desired: {
                        patchId: 'set values',
                        temperature: '50',
                        humidity: '85'
                    }
                }
        }";
        await registryManager.UpdateTwinAsync(twin.DeviceId, patch, twin.ETag);

        var query = registryManager.CreateQuery(
          "SELECT * FROM devices WHERE tags.cellar = 'Cellar1'", 100);
        var twinsInCellar1 = await query.GetNextAsTwinAsync();
        Console.WriteLine("Devices in Cellar1: {0}",
          string.Join(", ", twinsInCellar1.Select(t => t.DeviceId)));

    }
    ```

    > [!NOTE] The **SetTwinProperties** method creates a piece of JSON that defines tags and properties that will be added to the device twin, and then updates thew twin. The next part of the method demonstrates how a query can be performed to list the devices where the **cellar** tag is set to "Cellar1".

1. Now, add the following lines to the **Main** method, before the lines creating a service client.

    ```csharp
    // A registry manager is used to access the digital twins.
    registryManager = RegistryManager.CreateFromConnectionString(s_serviceConnectionString);
    SetTwinProperties().Wait();
    ```

    > [!NOTE] Read the comments in this section of code.

1. Save the **Program.cs** file.

## Add Code to Synchronize Device Twin Settings for the Device

1. Return to the Visual Studio Code instance that is running the **cheesecavedevice** app.

1. If the app is still running, place input focus on the terminal and press **CTRL+C** to exit the app.

1. In the editor, ensure **Program.cs** is open.

1. Add the following code at the end of the **SimulatedDevice** class:

    ```csharp
    private static async Task OnDesiredPropertyChanged(TwinCollection desiredProperties, object userContext)
    {
        try
        {
            desiredHumidity = desiredProperties["humidity"];
            desiredTemperature = desiredProperties["temperature"];
            greenMessage("Setting desired humidity to " + desiredProperties["humidity"]);
            greenMessage("Setting desired temperature to " + desiredProperties["temperature"]);

            // Report the properties back to the IoT Hub.
            var reportedProperties = new TwinCollection();
            reportedProperties["fanstate"] = fanState.ToString();
            reportedProperties["humidity"] = desiredHumidity;
            reportedProperties["temperature"] = desiredTemperature;
            await s_deviceClient.UpdateReportedPropertiesAsync(reportedProperties);

            greenMessage("\nTwin state reported: " + reportedProperties.ToJson());
        }
        catch
        {
            redMessage("Failed to update device twin");
        }
    }
    ```

    > [!NOTE] This code defines handler invoked when a desired property changes in the device twin. Notice that new values are then reported back to the IoT Hub to confirm the change.

1. To register the desired property changed handler, add the following lines after the statements creating a handler for the direct method:

    ```csharp
    // Get the device twin to report the initial desired properties.
    Twin deviceTwin = s_deviceClient.GetTwinAsync().GetAwaiter().GetResult();
    greenMessage("Initial twin desired properties: " + deviceTwin.Properties.Desired.ToJson());

    // Set the device twin update callback.
    s_deviceClient.SetDesiredPropertyUpdateCallbackAsync(OnDesiredPropertyChanged, null).Wait();
    ```

1. Save the **Program.cs** file.

> [!NOTE] Now you have added device twins to your app, you can reconsider having explicit variables such as **desiredHumidity**. Instead, you can use the variables in the device twin object.

## Test the Device Twins

To test the method, start the apps in the correct order. 

1. Start the **cheesecavedevice** device app. It will begin writing to the terminal, and telemetry will appear.

1. Start the **cheesecaveoperator** back-end app. 

1. Now check the console output for the **cheesecavedevice** device app, confirming the device twin synchronized correctly.

    ![Console Output](../../Linked_Image_Files/M99-L15-cheesecave-device-twin-received.png)

1. If we let the fan do its work, we should eventually get rid of those red alerts!

    ![Console Output](../../Linked_Image_Files/M99-L15-cheesecave-device-twin-success.png)

The code given in this module isn't industrial quality. It does show how to use direct methods, and device twins. However, the messages are sent only when the back-end service app is first run. Typically, a back-end service app would require a browser interface, for an operator to send direct methods, or set device twin properties, when required.

> [!NOTE] Before you go, don't forget to close both instances of Visual Studio Code - this will exit the apps if they are still running.
