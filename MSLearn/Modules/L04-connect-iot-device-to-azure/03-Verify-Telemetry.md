# Verify Telemetry Stream sent to Azure IoT HUb

In this unit you will use the Azure CLI to verify telemetry sent by the simulated device is being received by Azure IoT Hub.

1. Run the following command in the **Azure Cloud Shell** (or a different command-line window), to view a stream of the event messages being sent to the Azure IoT Hub endpoint by the Simulated Device.

    ```cmd/sh
    az iot hub monitor-events --hub-name {IoTHubName} --device-id SimulatedDevice1
    ```

    _Be sure to replace the **{IoTHubName}** placeholder with the name of your Azure IoT Hub._

    > [!NOTE] If you receive a message stating _"Dependency update required for IoT extension version"_ when running the Azure CLI command, then press `y` to accept the update and press `Enter`. This will allow the command to continue as expected.

    The `--device-id` parameter is optional and allows you to monitor the events from a single device. If the parameters is omitted, the command will monitor all events sent to the specified Azure IoT Hub.

    The `monitor-events` command within the `az iot hub` Azure CLI module offers the capability to monitor device telemetry & messages sent to an Azure IoT Hub from within the command-line / terminal.

2. The `az iot hub monitor-events` Azure CLI command will output a JSON representation of the events that are being sent to the Azure IoT Hub. This command allows you to monitor the events being sent, and verify the device is able to connect to and communicate with the Azure IoT Hub.

    ```cmd/sh
    Starting event monitor, filtering on device: SimulatedDevice1, use ctrl-c to stop...
    {
        "event": {
            "origin": "SimulatedDevice1",
            "payload": "{\"temperature\":25.058683971901743,\"humidity\":67.54816981383979}"
        }
    }
    {
        "event": {
            "origin": "SimulatedDevice1",
            "payload": "{\"temperature\":29.202181296051563,\"humidity\":69.13840303623043}"
        }
    }
    ```

3. When finished, you can press `Ctrl-C` in both windows to stop monitoring telemetry & messages being sent to Azure IoT Hub.
