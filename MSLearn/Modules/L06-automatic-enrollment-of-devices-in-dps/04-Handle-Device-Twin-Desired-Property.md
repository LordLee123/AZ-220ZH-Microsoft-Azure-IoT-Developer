# Handle Device Twin Desired Property Changes

In this unit, you will modify the Simulated Device source code to include an event handler to update device configurations based on Device Twin Desired Properties changes sent to the device from Azure IoT Hub.

Device Twins are JSON documents that store device state information including metadata, configurations, and conditions. Azure IoT Hub maintains a device twin for each device that you connect to IoT Hub.

The Device Provisioning Service (DPS) contains the initial Device Twin Desired Properties for devices that are registered using Group Enrollment. Once the devices are registered they are created within IoT Hub using this initial Device Twin configuration from DPS. After registration, the Azure IoT Hub maintains a Device Twin (and it's properties) for each device within the IoT Hub Device Registry.

When the Device Twin Desired Properties are updated for a device within Azure IoT Hub, the desired changes are sent to the IoT Device using the `DesiredPropertyUpdateCallback` event using the C# SDK. Handling this event within device code enables the devices configuration and properties to be updated as desired by easily managing the Device Twin state for the device within Azure IoT Hub.

1. Using **Visual Studio Code**, open the `/LabFiles` folder.

1. Open the `Program.cs` file.

1. Locate the `RunAsync` method. This is the method that connects the Simulate Device to **Azure IoT Hub** using a **DeviceClient** object. You will be adding code immediately after the device connects to Azure IoT Hub that integrates an `DesiredPropertyUpdateCallback` event handler for the device to receive to Device Twin Desired Property changes.

1. Locate the `// TODO 1` comment within the **RunAsync** method, and paste in the following code that calls the `SetDesiredPropertyUpdateCallbackAsync` method to setup the `DesiredPropertyUpdateCallback` event handler to receive Device Twin Desired Property changes.

    ```csharp
    // TODO 1: Setup OnDesiredPropertyChanged Event Handling to receive Desired Properties changes
    Console.WriteLine("Connecting SetDesiredPropertyUpdateCallbackAsync event handler...");
    await iotClient.SetDesiredPropertyUpdateCallbackAsync(OnDesiredPropertyChanged, null).ConfigureAwait(false);
    ```

    Notice this code is configuring the **DeviceClient** to call a method named `OnDesiredPropertyChanged` when Device Twin Property Change events are received.

1. Now that the `SetDesiredPropertyUpdateCallbackAsync` method was used to setup the event handler, the method named `OnDesiredPropertyChanged` that it's configured to call needs to be defined.

    To define the `OnDesiredPropertyChanged` method, paste in the following code to the **ProvisioningDeviceLogic** class below the `RunAsync` method:

    ```csharp
        private async Task OnDesiredPropertyChanged(TwinCollection desiredProperties, object userContext)
        {
            Console.WriteLine("Desired Twin Property Changed:");
            Console.WriteLine($"{desiredProperties.ToJson()}");

            // Read the desired Twin Properties
            if (desiredProperties.Contains("telemetryDelay"))
            {
                string desiredTelemetryDelay = desiredProperties["telemetryDelay"];
                if (desiredTelemetryDelay != null)
                {
                    this._telemetryDelay = int.Parse(desiredTelemetryDelay);
                }
                // if desired telemetryDelay is null or unspecified, don't change it
            }


            // Report Twin Properties
            var reportedProperties = new TwinCollection();
            reportedProperties["telemetryDelay"] = this._telemetryDelay;
            await iotClient.UpdateReportedPropertiesAsync(reportedProperties).ConfigureAwait(false);
            Console.WriteLine("Reported Twin Properties:");
            Console.WriteLine($"{reportedProperties.ToJson()}");
        }
    ```

    Notice, the first block of code within the `OnDesiredPropertyChanged` event handler method that reads the `telemetryDelay` property value from the Device Twin Desired Properties. This code also take the value specified and modifies the `this._telemetryDelay` variable with the desired value to reconfigure the delay time between sending simulated sensor readings to Azure IoT Hub. Remember, this `this._telemetryDelay` variable is used within the `Task.Delay` call inside the `while` loop of the `SendDeviceToCloudMessagesAsync` method.

    Notice, the second block of the code within the `OnDesiredPropertyChanged` event handler method that reports the current state of the device to Azure IoT Hub. This code calls the `DeviceClient.UpdateReportedPropertiesAsync` method and passes it a **TwinCollection** method that contains the current state of the device properties. This code is how the device reports back to IoT Hub that it received the Device Twin Desired Properties changed event, and has now updates it's configurations accordingly. It also reports what the properties are now set to, in case they would be different than the desired state received, so that IoT Hub can maintain an accurate Device Twin that reflects the state of the device.

1. Now that the device can receive updates to the Device Twin Desired Properties from Azure IoT Hub, it also needs to be coded to configure it's initial setup when the simulated device begins execution. To do this the device will need to load the current Device Twin Desired Properties from Azure IoT Hub, and configure itself accordingly.

1. Locate the `// TODO 2` comment within the `RunAsync` method. Paste in the following code that loads the current Device Twin Desired Properties from Azure IoT Hub for the device, and then uses the same `OnDesiredPropertyChanged` method defined previously to configure the device accordingly.

    ```csharp
    // TODO 2: Load Device Twin Properties since device is just starting up
    Console.WriteLine("Loading Device Twin Properties...");
    var twin = await iotClient.GetTwinAsync().ConfigureAwait(false);
    // Use OnDesiredPropertyChanged event handler to set the loaded Device Twin Properties (re-use!)
    await OnDesiredPropertyChanged(twin.Properties.Desired, null);
    ```

    Notice the call to the `DeviceClient.GetTwinAsync` method. This method can be used by the device to retrieve the current Device Twin state at any time. It's used in this case so the device can configure itself to match the Device Twin Desired Properties when the device first starts execution.

    In this case, the `OnDesiredPropertyChanged` event handler method is being reused to keep the configuration of the `telemetryDelay` property based on the Device Twin Desired Properties to a single place. This will help make the code easier to maintain over time.
