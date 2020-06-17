# Configure Simulated Device

In this unit you will configure a Simulated Device written in C# to connect to Azure IoT using the Individual Enrollment created in the previous unit. You will also add code to the Simulated Device that will read and update device configuration based on the Device Twin within Azure IoT Hub.

The simulated device created in this unit is for a an asset tracking solution that will have Iot Device with sensors located within a transport box to track shipments in transit. The sensor telemetry from the device sent to Azure IoT Hub includes Temperature, Humidity, Pressure, and Latitude/Longitude coordinates of the transport box.

1. On the **Device Provisioning Service** blade, navigate to the **Overview** pane.

1. Within the Overview pane, copy the **ID Scope** for the **Device Provisioning Service**, and save it for reference later.

1. Using **Visual Studio Code**, open the `/LabFiles` folder.

1. Open the `Program.cs` file.

1. Locate the `dpsIdScope` variable, and replace the value with the **ID Scope** of the Device Provisioning Service.

    > [!NOTE]
    > The **ID Scope** for the **Device Provisioning Service** can be retrieved from within the Azure portal, by navigating to the DPS resource, then copying the **ID Scope** value on the **Overview** pane.

1. Locate the `registrationId` variable, and replace the value with the **Registration ID** of `DPSSimulatedDevice1` for the individual enrollment that was created in the Device Provisioning Service.

1. Locate the `individualEnrollmentPrimaryKey` and `individualEnrollmentSecondaryKey` variables, and replace their values with the **Primary Key** and **Secondary Key** values that were copied from the Enrollment Details for the Individual Enrollment for the device that was created in the Device Enrollment Service.

1. Review the source code for the simulated device, and take notice of the following items:

    - The `ProvisioningDeviceLogic` class contains the logic for reading from the simulated device sensors.
    - The `ProvisioningDeviceLogic.SendDeviceToCloudMessagesAsync` method contains the logic for generating the simulated sensor readings for Temperature, Humidity, Pressure, Latitude, and Longitude. This method also sends the telemetry as Device-to-Cloud messages to Azure IoT Hub.

1. Notice at the bottom of the `ProvisioningDeviceLogic.SendDeviceToCloudMessagesAsync` method, there is a `Task.Delay` call to pause the `while` loop for a period of time before reading the simulated sensors again and sending the telemetry. This code uses the `_telemetryDelay` variable that defines how many seconds to wait before sending telemetry again.

1. Locate the `_telemetryDelay` variable declaration towards the top of the `ProvisioningDeviceLogic` class. Notice the delay is defaulted to `1` second in the code.

1. To get started configuring the simulated device to set the `_telemetryDelay` based on configuration of the **Device Twin** within Azure IoT Hub, you need to add code to read the Device Twin desired state, and report back the current state.

1. Locate the `// TODO 1: Setup OnDesiredPropertyChanged Event Handling` comment. To setup the simulated device to be notified of Device Twin state changes, you need to use the `DeviceClient.SetDesiredPropertyUpdateCallbackAsync` method to wire up an event handler for the `OnDesiredPropertyChanged` event.

    Replace the `// TODO 1` comment with the following code that sets up the event handler on the DeviceClient:

    ```csharp
    Console.WriteLine("Connecting SetDesiredPropertyUpdateCallbackAsync event handler...");
    await iotClient.SetDesiredPropertyUpdateCallbackAsync(OnDesiredPropertyChanged, null).ConfigureAwait(false);
    ```

1. To complete setting up the event handler, the `OnDesiredPropertyChanged` method needs to be added to the `ProvisioningDeviceLogic` class. Add the following method code to the class, that also includes code to read the Device Twin Desired Properties, configures the `_telemetryDelay` variable, and then reports back the Reported Properties back to the Device Twin to tell Azure IoT Hub what the current state of the simulated device is configured to.

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

1. Locate the `//TODO 2: Load Device Twin Properties` comment. To setup the simulated device to read the current Device Twin property desired state, and configure the device to match on device startup, add the following code in place of this comment:

    ```csharp
    Console.WriteLine("Loading Device Twin Properties...");
    var twin = await iotClient.GetTwinAsync().ConfigureAwait(false);
    await OnDesiredPropertyChanged(twin.Properties.Desired, null);
    ```

    This code calls the `DeviceTwin.GetTwinAsync` method to retrieve the Device Twin for the simulated device. It then accesses the `Properties.Desired` property object to retrieve the current Desired State for the device, and passes that to the `OnDesiredPropertyChanged` method that will configure the simulated devices `_telemetryDelay` variable.

    Notice, this code reuses the `OnDesiredPropertyChanged` method that was already created for handling _OnDesiredPropertyChanged_ events. This helps keep the code that reads the Device Twin desired state properties and configures the device at startup in a single place. The result is the code is simpler and easier to maintain.

1. Now the simulated device is all setup to be configured by the Device Twin within Azure IoT Hub.

    > [!NOTE]
    > If you need help with pasting code in the `Program.cs` file, please refer to the `/LabFiles-Completed` folder for the full source code for the Simulated Device with the Device Twin configuration code. When using this completed code sample, be sure to configure the ID Scope, Registration ID, and Individual Enrollment Keys.
