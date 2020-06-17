# Create Azure IoT Hub Device ID using Azure CLI

The `iot` Azure CLI modules includes several commands for managing IoT Devices within Azure IoT Hub under the `az iot hub device-identity` command group. These commands can be used to manage IoT Devices within scripts or directly from the command-line / terminal.

In this unit you will create a new Device ID within Azure IoT Hub using the Azure CLI.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. At the top of the Azure Portal click on the **Cloud Shell** icon to open up the **Azure Cloud Shell** within the Azure Portal. 

2. If you are prompted about setting up storage for Cloud Shell, accept the defaults. 

4. When the pane opens, choose the option for the **Bash** terminal within the Cloud Shell.

3. Within the Cloud Shell, run the following command to ensure the Cloud Shell has the IoT extension installed.

``` sh
az extension add --name azure-cli-iot-ext
```

5. Still within the Cloud Shell, run the following Azure CLI command to create **Device Identity** in Azure IoT Hub that will be used for a Simulated Device.

    ```sh
    az iot hub device-identity create --hub-name {IoTHubName} --device-id SimulatedDevice1
    ```

    > [!NOTE] Be sure to replace the _{IoTHubName}_ placeholder with the name of your Azure IoT Hub. If you have forgotten your IoT Hub name, you can enter the following command:
    >
    >```sh
    >az iot hub list -o table
    >```

6. Within the Cloud Shell, run the following Azure CLI command to get _device connection string_ for the Device ID that was just added to the IoT Hub. This connection string will be used to connect the Simulated Device to the Azure IoT Hub.

    ```cmd/sh
    az iot hub device-identity show-connection-string --hub-name {IoTHUbName} --device-id SimulatedDevice1 --output table
    ```

7. Make note of the **Device Connection String** that was output from the previous command. You will need to save this for use later.

    The connection string will be in the following format:

    ```text
    HostName={IoTHubName}.azure-devices.net;DeviceId=SimulatedDevice1;SharedAccessKey={SharedAccessKey}
    ```
