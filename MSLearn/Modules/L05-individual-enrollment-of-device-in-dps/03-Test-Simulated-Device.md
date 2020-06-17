# Test the Simulated Device

In this unit you will run the Simulated Device and verify it's sending sensor telemetry to Azure IoT Hub. You will also update the delay at which telemetry is sent to Azure IoT Hub by updating the Device Twin for the simulated device within Azure IoT Hub.

1. In Visual Studio Code, click on the **View** menu, then click **Terminal** to open the _Terminal_ pane.

1. Run the following command within the **Terminal** to build and run the Simulated Device application. Be sure the terminal location is set to the `/LabFiles` directory with the `Program.cs` file.

    ```cmd/sh
    dotnet run
    ```

1. When the Simulated Device application runs, it will first output some details about it's status. Notice the JSON output that follows the `Desired Twin Property Changed:` line contains the desired value for the `telemetryDelay` for the device.

    ```text
    RegistrationID = DPSSimulatedDevice1
    ProvisioningClient RegisterAsync . . . Device Registration Status: Assigned
    ProvisioningClient AssignedHub: AZ-220-HUB-CP1019.azure-devices.net; DeviceID: DPSSimulatedDevice1
    Creating Symmetric Key DeviceClient authentication
    Simulated Device. Ctrl-C to exit.
    DeviceClient OpenAsync.
    Connecting SetDesiredPropertyUpdateCallbackAsync event handler...
    Loading Device Twin Properties...
    Desired Twin Property Changed:
    {"telemetryDelay":"2","$version":1}
    Reported Twin Properties:
    {"telemetryDelay":2}
    Start reading and sending device telemetry...
    ```

1. The Simulated Device application will be sending telemetry events to the Azure IoT Hub that includes the `temperature`, `humidity`, `pressure`, `latitude`, and `longitude` values.

    The terminal output will look similar to the following:

    ```text
    11/6/2019 6:38:55 PM > Sending message: {"temperature":25.59094770373355,"humidity":71.17629229611545,"pressure":1019.9274696347665,"latitude":39.82133964767944,"longitude":-98.18181981142438}
    11/6/2019 6:38:57 PM > Sending message: {"temperature":24.68789062681044,"humidity":71.52098010830628,"pressure":1022.6521258267584,"latitude":40.05846882452387,"longitude":-98.08765031156229}
    11/6/2019 6:38:59 PM > Sending message: {"temperature":28.087463226675737,"humidity":74.76071353757787,"pressure":1017.614206096327,"latitude":40.269273772972454,"longitude":-98.28354453319591}
    11/6/2019 6:39:01 PM > Sending message: {"temperature":23.575667940813894,"humidity":77.66409506912534,"pressure":1017.0118147748344,"latitude":40.21020096551372,"longitude":-98.48636739129239}
    ```

    Notice the timestamp differences between telemetry readings. The telemetry delay the simulated device is running at should be `2` seconds as configured through the Device Twin; instead of the default of `1` second in the source code.

1. Verify the simulated device telemetry is being sent to Azure IoT Hub by running the following Azure CLI command in the Azure Cloud Shell (or a different command-line window).

    ```cmd/sh
    az iot hub monitor-events --hub-name {IoTHubName} --device-id DPSSimulatedDevice1
    ```

    _Be sure to replace the **{IoTHubName}** placeholder with the name of your Azure IoT Hub._

1. With the Simulated Device running, the `telemetryDelay` configuration can be updated by editing the Device Twin Desired State within Azure IoT Hub. This can be done by configuring the Device in the Azure IoT Hub within the Azure portal.

1. Open the **Azure Portal**, and navigate to the **Azure IoT Hub** service.

1. On the IoT Hub blade, click on **IoT devices** under the **Explorers** section on the left side of the blade.

1. Within the list of IoT devices, click on the **Device ID** (DPSSimulatedDevice1) for the Simulated Device.

1. On the blade for the Simulate Device, click the **Device Twin** button at the top of the blade.

1. Within the **Device twin** blade, there is an editor with the full JSON for the Device Twin. This enables you to view and/or edit the Device Twin state directly within the Azure portal.

1. Locate the JSON for the `properties.desired` object. This contains the Desired State for the Device Twin. Notice the `telemetryDelay` property already exists, and is set to `"2"` as configured when the device was provisioned based on the Individual Enrollment in DPS.

1. Modify the `telemetryDelay` value to `"5"` to configure the Device Twin to set the Desired State to have the simulated device wait 5 seconds between telemetry readings.

1. Click **Save**

1. The `OnDesiredPropertyChanged` event will be triggered automatically within the code for the Simulated Device, and the device will update its configuration to reflect the changes to the Device Twin Desired state.

1. In Visual Studio Code, the Terminal output for the Simulated Device Application will show a message that the `Desired Twin Property Changed` along with the JSON for the new desired`telemetryDelay` property value. Once the device picks up the new configuration of Device Twin Desired state, it will automatically update to start sending sensor telemetry every 5 seconds as now configured.

    ```text
    Desired Twin Property Changed:
    {"telemetryDelay":"5","$version":2}
    Reported Twin Properties:
    {"telemetryDelay":5}
    11/6/2019 7:29:55 PM > Sending message: {"temperature":33.01780830277959,"humidity":68.52464504936927,"pressure":1023.0929576073974,"latitude":39.97641877038439,"longitude":-98.49544472071804}
    11/6/2019 7:30:00 PM > Sending message: {"temperature":33.95490410689027,"humidity":71.57070464062072,"pressure":1013.3468084112261,"latitude":40.01604868659767,"longitude":-98.51051877869526}
    11/6/2019 7:30:05 PM > Sending message: {"temperature":22.055266337494956,"humidity":67.50505594886144,"pressure":1018.1765662249767,"latitude":40.22292566031555,"longitude":-98.4367936214764}
    ```

1. The command-line window with the `az iot hub monitor-events` Azure CLI command running will also display the telemetry events sent to Azure IoT Hub being received at the new interval of 5 seconds.
