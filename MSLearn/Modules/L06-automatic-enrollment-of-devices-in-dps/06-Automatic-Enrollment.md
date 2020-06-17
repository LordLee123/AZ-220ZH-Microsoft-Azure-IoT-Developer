# Automatic Enrollment of Simulated Device

In this unit, you will execute the Simulated Device. When the device is run for the first time it will connect to the Device Provisioning Service (DPS) and automatically be enrolled using the configured Group Enrollment. Once enrolled into the DPS Group Enrollment, the device will be automatically registered within the Azure IoT Hub device registry. Once enrolled and registered, the device will begin communicating with Azure IoT Hub securely using the configured X.509 Certificate Authentication.

1. Using **Visual Studio Code**, open the `/LabFiles` folder containing the **Simulated Device** source code.

1. Within **Visual Studio Code**, click the **View** menu, then select **Terminal** to open the Visual Studio Code Terminal window.

1. Navigate to `/LabFiles` directory within the **Terminal**.

1. Build and execute the **SimulatedDevice** project by running the `dotnet run` command.

    ```cmd/sh
    dotnet run
    ```

    > [!NOTE] When running `dotnet run` for the Simulated Device, if a **ProvisioningTransportException** exception is displayed, the most common cause is an _Invalid certificate_ error. If this happens, ensure the CA Certificate in DPS, and the Device Certificate for the Simulated Device application are configured correctly.
    >
    > ```text
    > localmachine:LabFiles User$ dotnet run
    > Found certificate: AFF851ED016CA5AEB71E5749BCBE3415F8CF4F37 CN=simulated-device1; PrivateKey: True
    > Using certificate AFF851ED016CA5AEB71E5749BCBE3415F8CF4F37 CN=simulated-device1
    > RegistrationID = simulated-device1
    > ProvisioningClient RegisterAsync . . . Unhandled exception. Microsoft.Azure.Devices.Provisioning.Client.ProvisioningTransportException: {"errorCode":401002,"trackingId":"2e298c80-0974-493c-9fd9-6253fb055ade","message":"Invalid certificate.","timestampUtc":"2019-12-13T14:55:40.2764134Z"}
    >   at Microsoft.Azure.Devices.Provisioning.Client.Transport.ProvisioningTransportHandlerAmqp.ValidateOutcome(Outcome outcome)
    >   at Microsoft.Azure.Devices.Provisioning.Client.Transport.ProvisioningTransportHandlerAmqp.RegisterDeviceAsync(AmqpClientConnection client, String correlationId, DeviceRegistration deviceRegistration)
    >   at Microsoft.Azure.Devices.Provisioning.Client.Transport.ProvisioningTransportHandlerAmqp.RegisterAsync(ProvisioningTransportRegisterMessage message, CancellationToken cancellationToken)
    >   at X509CertificateSimulatedDevice.ProvisioningDeviceLogic.RunAsync() in /Users/User/Documents/AZ-220/LabFiles/Program.cs:line 121
    >   at X509CertificateSimulatedDevice.Program.Main(String[] args) in /Users/User/Documents/AZ-220/LabFiles/Program.cs:line 55
    > ...
    > ```

1. When the **Simulated Device** application runs, the **Terminal** will display the Console output from the app. Notice the x.509 certificate was loaded, the device was registered with the Device Provisioning Service, it was assigned to connect to the **AZ-220-HUB-{YOUR-ID}** IoT Hub, and the Device Twin Desired Properties are loaded.

    ```text
    localmachine:LabFiles User$ dotnet run
    Found certificate: AFF851ED016CA5AEB71E5749BCBE3415F8CF4F37 CN=simulated-device1; PrivateKey: True
    Using certificate AFF851ED016CA5AEB71E5749BCBE3415F8CF4F37 CN=simulated-device1
    RegistrationID = simulated-device1
    ProvisioningClient RegisterAsync . . . Device Registration Status: Assigned
    ProvisioningClient AssignedHub: AZ-220-HUB-CP1119.azure-devices.net; DeviceID: simulated-device1
    Creating X509 DeviceClient authentication.
    Simulated Device. Ctrl-C to exit.
    DeviceClient OpenAsync.
    Connecting SetDesiredPropertyUpdateCallbackAsync event handler...
    Loading Device Twin Properties...
    Desired Twin Property Changed:
    {"$version":1}
    Reported Twin Properties:
    {"telemetryDelay":1}
    Start reading and sending device telemetry...
    ```

    To review the source code for the **Simulated Device**, open the `/LabFiles/Program.cs` source code file. Look for several `Console.WriteLine` statements that are used to output the messages seen to the console.

1. Once the **Simulated Device** starts executing, it will begin sending simulated sensor telemetry messages to Azure IoT Hub. Notice the output to the console that displays the JSON of the sensor readings that are being sent to Azure IoT Hub.

    Also, notice the delay, as defined by the `telemetryDelay` Device Twin Property, between each message sent to IoT Hub is currently delaying **1 second** between sending sensor telemetry messages.

    ```text
    Start reading and sending device telemetry...
    12/9/2019 5:47:00 PM > Sending message: {"temperature":24.047539159212047,"humidity":67.00504162675004,"pressure":1018.8478924248358,"latitude":40.129349260196875,"longitude":-98.42877188146265}
    12/9/2019 5:47:01 PM > Sending message: {"temperature":26.628804161040485,"humidity":68.09610794675355,"pressure":1014.6454375411363,"latitude":40.093269544242695,"longitude":-98.22227128174003}
    ```

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On your Resource group tile, click **AZ-220-HUB-{YOUR-ID}** to navigate to the Azure IoT Hub.

1. On the **IoT Hub** blade, click the **IoT devices** link under the **Explorers** section.

1. On the **IoT devices** pane, the `simulated-devices` **Device ID** will now display in the list of devices registered within the Azure IoT Hub. This registration was created by the automatic enrollment of the Device Provisioning Service (DPS) when the Simulated Device connected the first time.

1. Click on the **simulated-devices** Device ID in the list.

1. On the device details pane, click the **Device Twin** button at the top.

1. The **Device twin** pane displays the JSON for the Device Twin state for the **simulated-devices** Device ID.

1. Locate the `properties.desired` node within the Device Twin JSON. Add, or update if it already exists, the `telemetryDelay` property to have the value of `"2"`. This will update the `telemetryDelay` of the Simulated Device to send sensor telemetry every **2 seconds**.

    The resulting JSON for this section of the Device Twin Desired Properties will look similar to the following:

    ```json
    "properties": {
        "desired": {
          "telemetryDelay": "2",
          "$metadata": {
            "$lastUpdated": "2019-12-09T22:48:05.9703541Z",
            "$lastUpdatedVersion": 2,
            "telemetryDelay": {
              "$lastUpdated": "2019-12-09T22:48:05.9703541Z",
              "$lastUpdatedVersion": 2
            }
          },
          "$version": 2
        },
    ```

    Leave the `$metadata` and `$version` value of the `properties.desired` node within the JSON. You should only update the `telemetryDelay` value to set the new Device Twin Desired Property value.

1. Click **Save** to set the new Device Twin Desired Properties for the device. Once saved, the updated **Device Twin Desired Properties** will automatically be sent to the **Simulated Device**.

1. Go back to the **Visual Studio Code Terminal** window, where the Simulated Device is running, and notice the application has been notified of the updated Device Twin `telemetryDelay` Desired Property setting.

    The application outputs to the Console some messages that display that the new **Device Twin Desired Properties** have been loaded, and the changes have been set and reported back to the Azure IoT Hub.

    ```text
    Desired Twin Property Changed:
    {"telemetryDelay":2,"$version":2}
    Reported Twin Properties:
    {"telemetryDelay":2}
    ```

1. Notice the simulated device sensor telemetry messages are now being sent to Azure IoT Hub every **2 seconds**, now that the updated **Device Twin Desired Properties** have been sent to the device and the device has updated it's internal state accordingly.

    ```text
    12/9/2019 5:48:06 PM > Sending message: {"temperature":33.89822140284731,"humidity":78.34939097908763,"pressure":1024.9467544610131,"latitude":40.020042418755764,"longitude":-98.41923808825841}
    12/9/2019 5:48:09 PM > Sending message: {"temperature":27.475786026323114,"humidity":64.4175510594703,"pressure":1020.6866468579678,"latitude":40.2089999240047,"longitude":-98.26223221770334}
    12/9/2019 5:48:11 PM > Sending message: {"temperature":34.63600901637041,"humidity":60.95207713588703,"pressure":1013.6262313688063,"latitude":40.25499096898331,"longitude":-98.51199886959347}
    ```

1. To exit the **Simulated Device** app within the Terminal window, press **Ctrl + C**.
