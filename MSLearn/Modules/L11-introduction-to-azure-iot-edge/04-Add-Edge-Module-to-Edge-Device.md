# Add Edge Module to Edge Device

In this unit you will add a Simulated Temperature Sensor as a custom IoT Edge Module, and deploy it to run on the IoT Edge Device.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On your Resource group tile, click **AZ-220-HUB-{YOUR-ID}** to navigate to the Azure IoT Hub.

1. Under **Automatic Device Management**, click on **IoT Edge**.

1. Within the list of IoT Edge Devices, click on the `myEdgeDevice` Device ID for the Edge device that was created previously.

1. On the Device summary pane for the **myEdgeDevice** IoT Edge Device, notice the **Modules** tab displays a list of the modules currently configured for the device. Currently, the IoT Edge device is configured to only run the Edge Agent (`$edgeAgent`) and Edge Hub (`$edgeHub`) modules that are part of the IoT Edge Runtime.

1. On the IoT Edge Device blade, click on the **Set Modules** button at the top.

1. On the **Set modules** blade, locate the **IoT Edge Modules** sections, and click the **Add** button, then select **IoT Edge Module**.

1. On the **IoT Edge Custom Modules** pane, enter the following values to add a custom module named `tempsensor` using the Image URI for a simulated temperature sensor module.

    - IOT Edge Module Name: `tempsensor`
    - Image URI: `asaedgedockerhubtest/asa-edge-test-module:simulated-temperature-sensor`

1. Select the **Module Twin Settings** tab.

1. Enter the following JSON for the module twin's desired properties:

    ```json
    {
        "EnableProtobufSerializer": false,
        "EventGeneratingSettings": {
            "IntervalMilliSec": 500,
            "PercentageChange": 2,
            "SpikeFactor": 2,
            "StartValue": 20,
            "SpikeFrequency": 20
        }
    }
    ```

    This JSON configures the Edge Module by setting the **Desired** properties of its module twin.

1. Click **Add**.

1. On **Modules** step, of the **Set modules on device** pane, click **Next: Routes >**.

1. On the **Specify Routes** step, notice the default route is already configured that will send all messages from all modules on the IoT Edge Device to IoT Hub.

    - Name: **route**

    - Value: `FROM /messages/* INTO $upstream`

1. Click **Next: Review + create >**.

1. On the **Review Deployment** step, notice the JSON displayed in this pane. This is JSON is the **Deployment Manifest** for the IoT Edge Device.

    Under the `properties.desired` section is the `modules` section that declares the IoT Edge Modules that will be deployed to the IoT Edge Device. This includes the Image URIs of all the modules, including any container registry credentials.

    ```json
    {
        "modulesContent": {
            "$edgeAgent": {
                "properties.desired": {
                    "modules": {
                        "tempsensor": {
                            "settings": {
                                "image": "asaedgedockerhubtest/asa-edge-test-module:simulated-temperature-sensor",
                                "createOptions": ""
                            },
                            "type": "docker",
                            "version": "1.0",
                            "status": "running",
                            "restartPolicy": "always"
                        },
    ```

    Lower in the JSON is the **$edgeHub** section that contains the desired properties for the Edge Hub. This section also includes the routing configuration for routing events between modules, and to IoT Hub.

    ```json
        "$edgeHub": {
            "properties.desired": {
                "routes": {
                  "route": "FROM /messages/* INTO $upstream"
                },
                "schemaVersion": "1.0",
                "storeAndForwardConfiguration": {
                    "timeToLiveSecs": 7200
                }
            }
        },
    ```

    Lower in the JSON is a section for the **tempsensor** module, where the `properties.desired` section contains the desired properties for the configuration of the edge module.

    ```json
                },
                "tempsensor": {
                    "properties.desired": {
                        "EnableProtobufSerializer": false,
                        "EventGeneratingSettings": {
                            "IntervalMilliSec": 500,
                            "PercentageChange": 2,
                            "SpikeFactor": 2,
                            "StartValue": 20,
                            "SpikeFrequency": 20
                        }
                    }
                }
            }
        }
    ```

1. Click **Create** to finish setting the modules on the device.

1. Notice on the IoT Edge Device blade for the `myEdgeDevice` device, the list of **Modules** now includes the newly added `tempsensor` module.

    > [!NOTE] You may have to click **Refresh** to see the module listed for the first time.

1. After a moment, click **Refresh** to update the current state of the Edge Device.

1. Notice the `tempsensor` module is now updated, displaying the **Runtime Status** as **running**.

1. Open a **Cloud Shell** session and connect to the `AZ-220-VM-EDGE` virtual machine using **SSH**.

1. Within Cloud Shell, run the following command to list out all the modules currently running on the IoT Edge Device.

    ```cmd/sh
    iotedge list
    ```

1. The output of the command look similar to the following. Notice `tempsensor` at the bottom of the list.

    ```cmd/sh
    demouser@AZ-220-VM-EDGE:~$ iotedge list
    NAME             STATUS           DESCRIPTION      CONFIG
    tempsensor       running          Up 34 seconds    asaedgedockerhubtest/asa-edge-test-module:simulated-temperature-sensor
    edgeAgent        running          Up 26 minutes    mcr.microsoft.com/azureiotedge-agent:1.0
    edgeHub          running          Up a minute      mcr.microsoft.com/azureiotedge-hub:1.0
    ```

1. The `iotedge logs` command can be used to view the module logs for the `tempsensor` module. Run the following command to view the module logs:

    ```cmd/sh
    iotedge logs tempsensor
    ```

    The output of the command looks similar to the following:

    ```cmd/sh
    demouser@AZ-220-VM-EDGE:~$ iotedge logs tempsensor
    11/14/2019 18:05:02 - Send Json Event : {"machine":{"temperature":41.199999999999925,"pressure":1.0182182583425192},"ambient":{"temperature":21.460937846433808,"humidity":25},"timeCreated":"2019-11-14T18:05:02.8765526Z"}
    11/14/2019 18:05:03 - Send Json Event : {"machine":{"temperature":41.599999999999923,"pressure":1.0185790159334602},"ambient":{"temperature":20.51992724976499,"humidity":26},"timeCreated":"2019-11-14T18:05:03.3789786Z"}
    11/14/2019 18:05:03 - Send Json Event : {"machine":{"temperature":41.999999999999922,"pressure":1.0189397735244012},"ambient":{"temperature":20.715225311096397,"humidity":26},"timeCreated":"2019-11-14T18:05:03.8811372Z"}
    ```

1. The Simulated Temperature Sensor Module will stop after it sends 500 messages. It can be restarted by running the following command:

    ```cmd/sh
    iotedge restart tempsensor
    ```

    You do not need to restart the module now, but if you find it stops sending telemetry later, then go back into the **Azure Cloud Shell** and run this command to reset it. Once reset, the module will start sending telemetry again.
