# Create IoT Edge Device Identity in IoT Hub using Azure CLI

In this unit you will create a new IoT Edge Device Identity within Azure IoT Hub using the Azure CLI.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Open the Azure Cloud Shell by clicking the **Terminal** icon within the top header bar of the Azure portal, and select the **Bash** shell option.

1. Run the following Azure CLI command to create an **IoT Edge Device Identity** in Azure IoT Hub with the **Device ID** set to `myEdgeDevice`.

    ```cmd/sh
    az iot hub device-identity create --hub-name {IoTHubName} --device-id myEdgeDevice --edge-enabled
    ```

    Be sure to replace the `{IoTHubName}` placeholder with the name of the Azure IoT Hub in your subscription.

    > [!NOTE] The IoT Edge Device Identity can also be created using the Azure Portal by navigating to **IoT Hub** -> **IoT Edge** -> **Add an IoT Edge device**.

1. Notice the output of the command contains information about the **Device Identity** that was created for the IoT Edge device. For example, you can see it defaults to `symmetricKey` authentication with auto-generated keys, and the `iotEdge` capability is set to `true` as indicated by the `--edge-enabled` parameter that was specified.

    ```json
        {
          "authentication": {
            "symmetricKey": {
              "primaryKey": "jftBfeefPsXgrd87UcotVKJ88kBl5Zjk1oWmMwwxlME=",
              "secondaryKey": "vbegAag/mTJReQjNvuEM9HEe1zpGPnGI2j6DJ7nECxo="
            },
            "type": "sas",
            "x509Thumbprint": {
              "primaryThumbprint": null,
              "secondaryThumbprint": null
            }
          },
          "capabilities": {
            "iotEdge": true
          },
          "cloudToDeviceMessageCount": 0,
          "connectionState": "Disconnected",
          "connectionStateUpdatedTime": "0001-01-01T00:00:00",
          "deviceId": "myEdgeDevice",
          "deviceScope": "ms-azure-iot-edge://myEdgeDevice-637093398936580016",
          "etag": "OTg0MjI1NzE1",
          "generationId": "637093398936580016",
          "lastActivityTime": "0001-01-01T00:00:00",
          "status": "enabled",
          "statusReason": null,
          "statusUpdatedTime": "0001-01-01T00:00:00"
        }
    ```

1. Once the IoT Edge Device Identity has been created, you can access the **Connection String** for the device by running the following Azure CLI command.

    ```cmd/sh
    az iot hub device-identity show-connection-string --device-id myEdgeDevice --hub-name {IoTHubName}
    ```

    Replace the `{IoTHubName}` placeholder with the name of the Azure IoT Hub in your subscription.

1. Copy the value of the `connectionString` from the JSON output of the command, and save it for reference later. This connection string will be used to configure the IoT Edge device to connect to IoT Hub.

    ```json
        {
          "connectionString": "HostName={IoTHubName}.azure-devices.net;DeviceId=myEdgeDevice;SharedAccessKey=jftBfeefPsXgrd87UcotVKJ88kBl5Zjk1oWmMwwxlME="
        }
    ```

    > [!NOTE] The IoT Edge Device Connection String can also be accessed within the Azure Portal, by navigating to **IoT Hub** -> **IoT Edge** -> **Your Edge Device** -> **Connection String (primary key)**
