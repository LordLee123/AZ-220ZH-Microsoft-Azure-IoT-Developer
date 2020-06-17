# Debug in Attach Mode with IoT Edge Simulator

In this unit, you will build and run a custom IoT Edge Module solution using the IoT Edge Simulator from within Visual Studio Code.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On your Resource group tile, click **AZ-220-HUB-{YOUR-ID}** to navigate to the Azure IoT Hub.

1. In the left hand navigation area, under **Settings**, click **Shared access policies**.

1. In the list of policies, click **iothubowner**.

1. In the **iothubowner** detail pane, copy the value for **Connection string--primary key**.

    Paste this value into a text file using notebook - you will need it below.

1. On the IoT Hub summary blade, click **IoT Edge** under the Automatic Device Management section. This section of the IoT Hub blade allows you to manage the IoT Edge devices connected to the IoT Hub.

1. Click the **Add an IoT Edge device** button to begin adding a new IoT Edge Device to the IoT Hub.

1. On the **Create a device** blade, enter `SimulatedDevice` into the **Device ID** field. This is the device identity used for authentication and access control.

1. Select **Symmetric key** for the **Authentication type**, and leave the **Auto-generate keys** box checked. This will have IoT Hub automatically generate the Symmetric keys for authenticating the device.

1. Click **Save**.

1. Open the **IoT Edge Solution** for the custom IoT Edge Module with **Visual Studio Code**.

1. Within the **Explorer** pane, right-click the `deployment.debug.manifest.json` debugging deployment manifest file in the root directory of the IoT Edge Solution.

1. Select the **Build and Run IoT Edge Solution in Simulator** option.

1. When a prompted with a dialog that says, "_Please setup iotedgehubdev first before starting simulator_", click **Setup**.

1. When prompted for the **IoT Hub Connection String**, enter the **Connection string--primary key** you noted earlier.

1. When prompted to "_Select an IoT Edge Device_", select the **SimulatedDevice**.

1. Within the **Terminal** window inside **Visual Studio Code**, you will be prompted for your Admin password on your local machine. Enter your password at the prompt and press Enter.

    The reason it's asking for your password is that the setup command for `iotedgehubdev` is being run using `sudo` as it requires elevated privileges.

1. Once the **IoT Edge Simulator** is setup, a "_Setup IoT Edge Simulator successfully_" message will be displayed in the **Terminal**.

1. Now that the **IoT Edge Simulator** has been setup, right-click the `deployment.debug.manifest.json` debugging deployment manifest file in the root directory of the IoT Edge Solution, and select the **Build and Run IoT Edge Solution in Simulator** option.

1. Notice that once the **IoT Edge Simulator** is running, the **Terminal** window in **Visual Studio Code** will display the console output from the Modules that are running in the solution.

    ```text
    SimulatedTemperatureSensor    |         12/09/2019 15:05:08> Sending message: 4, Body: [{"machine":{"temperature":23.023276334173641,"pressure":1.2304998355387693},"ambient":{"temperature":20.56235126408858,"humidity":24},"timeCreated":"2019-12-09T15:05:08.4596891Z"}]
    ObjectCounterModule           | Received message: 4, Body: [{"machine":{"temperature":23.023276334173641,"pressure":1.2304998355387693},"ambient":{"temperature":20.56235126408858,"humidity":24},"timeCreated":"2019-12-09T15:05:08.4596891Z"}]
    ObjectCounterModule           | Received message sent
    SimulatedTemperatureSensor    |         12/09/2019 15:05:13> Sending message: 5, Body: [{"machine":{"temperature":23.925331861560853,"pressure":1.3332656551145274},"ambient":{"temperature":20.69443827876562,"humidity":24},"timeCreated":"2019-12-09T15:05:13.4856557Z"}]
    ObjectCounterModule           | Received message: 5, Body: [{"machine":{"temperature":23.925331861560853,"pressure":1.3332656551145274},"ambient":{"temperature":20.69443827876562,"humidity":24},"timeCreated":"2019-12-09T15:05:13.4856557Z"}]
    ObjectCounterModule           | Received message sent
    ```

    Notice the output from the **ObjectCounterModule** contains the text `Received message: #` where `#` is the total message count that has been received by the custom **ObjectCounterModule** IoT Edge Module that was created.

1. With the IoT Edge Simulator still running, open the Azure portal, then open the **Cloud Shell** by clicking the Cloud Shell icon at to top of the Azure portal.

1. Run the following command within the **Azure Cloud Shell** to monitor the messages being sent to Azure IoT Hub from the _SimulatedDevice_ running in the IoT Edge Simulator on your local machine:

    ```cmd/sh
    az iot hub monitor-events --hub-name "AZ-220-HUB-{YOUR-ID}"
    ```

    Be sure to replace the `AZ-220-HUB-{YOUR-ID}` value in the above command with the name of your **Azure IoT Hub** service.

1. With everything still running, notice the output of the previous command in the **Cloud Shell** will display a JSON representation of the messages being received by the Azure IoT Hub.

    The output should look similar to the following:

    ```json
    {
        "event": {
            "origin": "SimulatedDevice",
            "payload": "{\"machine\":{\"temperature\":88.003809452058647,\"pressure\":8.6333453806142764},\"ambient\":{\"temperature\":21.090260561364826,\"humidity\":24},\"timeCreated\":\"2019-12-09T15:16:32.402965Z\"}"
        }
    }
    {
        "event": {
            "origin": "SimulatedDevice",
            "payload": "{\"machine\":{\"temperature\":88.564600328362815,\"pressure\":8.6972329488008278},\"ambient\":{\"temperature\":20.942187817041848,\"humidity\":25},\"timeCreated\":\"2019-12-09T15:16:37.4355705Z\"}"
        }
    }
    ```

1. Notice that even though there are 2 IoT Edge Modules running on the IoT Edge Device, there is still only a single copy of each message getting sent to Azure IoT Hub. The IoT Edge Device has a message pipeline defined where messages from the _SimulatedTemperatureSensor_ are piped to the _ObjectCounterModule_ which then sends messages out piped out to the Azure IoT Hub.

1. To stop monitoring Azure IoT Hub events, press **Ctrl + C** within the **Azure Cloud Shell**.

1. Navigate to the **Visual Studio Code** Debug view, by clicking on the **Debug** icon on the left-side of the window.

1. On the dropdown at the top of the **Debug** pane, select the **ObjectCounterModule Remote Debug (.NET Core)** option.

1. Select **Start Debugging** or press **F5**

1. When prompted to **Select the process to attach to**, select the **dotnet ObjectCounterModule.dll** process.

1. Open the `/modules/ObjectCounterModule/Program.cs` source code file within the solution.

1. Locate the `static async Task<MessageResponse> PipeMessage(` method, and set a **Breakpoint** within this method.

1. Notice that execution stops at the breakpoint that is set, and the editor highlights that specific line of code.

1. Open the Visual Studio Code **Debug** view, and notice the variables in the left panel.

1. To resume execution, click the **Continue** button, or press **F5**.

1. Notice that each time the breakpoint it hit, execution stops.

1. To stop debugging, click the **Disconnect** button, or press **Shift + F5**.

1. To stop the IoT Edge Simulator, open the **Command Palette**, then select the **Azure IoT Edge: Stop IoT Edge Simulator** option.

Now that the module has been created and tested in the IoT Edge simulator, it is time to deploy it to the cloud.
