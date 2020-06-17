# Create Custom Edge Module in C#

In this unit, you will create an Azure IoT Edge Solution that contains a custom Azure IoT Edge Module written in C#.

1. Open Visual Studio Code

1. To open the **Command Palette**, click on the **View** menu, then click on **Command Palette**.

1. In the Command Palette, enter and run the command `Azure IoT Edge: New IoT Edge Solution`.

1. Browse to the folder where you want to create the new solutions, then click **Select folder**.

1. Enter the name for the solution, such as `EdgeSolution`. This will be the directory name for the new **IoT Edge Solution** that will be created.

1. Select the **C# Solution** module template. This will define `C#` as the development language for the custom IoT Edge Module added to the solution.

1. Enter a name for the custom IoT Edge Module, such as `ObjectCountingModule`. This will be the name of the new IoT Edge Module that is being created.

1. Provide the name of the Docker image repository for the module. This will be the Docker repository where the IoT Edge Module docker image will be published. Replace the `localhost:5000` part of the default `localhost:5000/objectcountermodule` repository location with the name of the Azure Container Registry server - similar to `az220acr{your-id}.azurecr.io

    The Docker image repository location will be in the following format:

    ```text
    <acr-name>.azurecr.io/<module-name>
    ```

    Be sure to replace the placeholders with the appropriate values:

    - `<acr-name>`: Replace with the name fo the Azure Container Registry service.
    - `<module-name>`: Replace with the name of the custom Azure IoT Edge Module that's being created.

    > [!NOTE] The default Docker image repository in Visual Studio Code is set to `localhost:5000/<your module name>`. If you were to use a local Docker registry for testing, then **localhost** is fine.

1. Once the new **IoT Edge Solution** has been created, Visual Studio Code will open the solution. In the **Explorer** pane, notice the files and directories that were created as part of the new IoT Edge Solution.

1. Open the `.env` file within the root directory of the IoT Edge Solution. This file is where the **username** and **password** are configured for accessing your Docker registry.

    The username and password are stored in this file using the following format:

    ```text
    CONTAINER_REGISTRY_USERNAME_<registry-name>=<registry-username>
    CONTAINER_REGISTRY_PASSWORD_<registry-name>=<registry-password>
    ```

    The placeholders in the above values are defined as follows:

    - `<registry-name>`: The name of your Docker registry.
    - `<registry-username>`: The username to use for accessing your Docker registry.
    - `<registry-password>`: The password to use for accessing your Docker registry.

    Within the `.env` file, notice that the `<registry-name>` has already been added to the configuration values within the file. The value added will match the name of the Docker registry specified when creating the IoT Edge Solution.

1. Within the `.env` file, replace the `<registry-username>` placeholder with the **Registry name** (_aka Username_) of the Azure Container Registry that was previously created, and replace the `<registry-password>` placeholder with the **password** for the Azure Container Registry.

    > [!NOTE] The Azure Container Registry **Username** and **password** values can be found by accessing the **Access keys** pane for the **Azure Container Registry** service within the Azure portal.

1. Open the `deployment.template.json` file within the root IoT Edge Solution directory. This file is the **deployment manifest** for the IoT Edge Solution. The deployment manifest tells an IoT Edge device (or a group of devices) which modules to install and how to configure them. The deployment manifest includes the _desired properties_ for each module twin. IoT edge devices report back the _reported properties_ for each module.

    Two modules are required in every deployment manifest; the _\$edgeAgent_, and _\$edgeHub_. These modules are part of the IoT Edge runtime that manages the IoT Edge devices and the modules running on it.

1. Scroll through the `deployment.template.json` deployment manifest file, and notice the following sections within the `properties.desired` section of the `$edgeAgent` element:

    - `systemModules` - This defines Docker images to use for the `$edgeAgent` and `$edgeHub` system modules that are part of the IoT Edge runtime.

    - `modules` - This defines the various modules that will be deployed and run on the IoT Edge device (or a group of devices).

1. Notice that within the `modules` section for the `$edgeAgent`, there are two modules defines.

    - `ObjectCounterModule`: This is the custom IoT Edge Module that is being created as part of this new IoT Edge Solution.

    - `SimulatedTemperatureSensor`: This defines the Simulated Temperature Sensor module to be deployed to the IoT Edge device.

1. Notice the `$edgeHub` section of the deployment manifest JSON. This section defines the desired properties (via `properties.desired` element) that includes the message routes for communicating messages between the IoT Edge Modules and finally to Azure IoT Hub service.

    ```json
        "$edgeHub": {
          "properties.desired": {
            "schemaVersion": "1.0",
            "routes": {
              "ObjectCounterModuleToIoTHub": "FROM /messages/modules/ObjectCounterModule/outputs/* INTO $upstream",
              "sensorToObjectCounterModule": "FROM /messages/modules/SimulatedTemperatureSensor/outputs/temperatureOutput INTO BrokeredEndpoint(\"/modules/ObjectCounterModule/inputs/input1\")"
            },
            ...
          }
        }
    ```

    The `sensorToObjectCounterModule` routes is configured to route messages from the Simulated Temperature Sensor (via `/messages/modules/SimulatedTemplaratureSensor/outputs/temperatureOutput`) module to the custom **OutputCounterModule** module (via `BrokeredEndpoint(\"/modules/ObjectCounterModule/inputs/input1\")"`).

    The `ObjectCounterModuleToIoTHub` route is configured to route messages that are sent out from the custom **OutputCounterModule** module (via `/messages/modules/SimulatedTemperatureSensor/outputs/temperatureOutput`) to the Azure IoT Hub service (via `$upstream`).

1. In Visual Studio Code, open the **Command Palette**, then search for the **Azure IoT Edge: Set Default Target Platform for Edge Solution** and select it.

1. Select the **amd64** target platform for the IoT Edge Solution. This target platform needs to be set to the hardware platform architecture of the IoT Edge Device.

    Since you are using the **IoT Edge on Ubuntu** Linux VM, the **amd64** option is the appropriate choice. For a Windows VM, use "_windows-amd64_", and choose the "_arm32v7_" option for modules that will be running on an ARM CPU architecture.

1. Expand the `/modules/ObjectCounterModule` directory within the solution. Notice this directory contains the source code files for the new IoT Edge Module being developed.

1. Open the `/modules/ObjectCounterModule/Program.cs` file. This file contains the template source code for the newly created custom IoT Edge Module. This code provides a starting point for creating custom IoT Edge Modules.

1. Locate the `static async Task Init()` method. This method initializes the ModuleClient for handling messages sent to the module, and sets up the callback to receive messages. Read the code comments within the code for this method and notice what each section of code does.

1. Locate the `static async Task<MessageResponse> PipeMessage(` method. This method is called whenever the module is sent a message from the EdgeHub. The current state of the source code within this method receives messages sent to this module and pipes them out to the module output; without any change. Read through the code within this method and notice what it does.

1. Also, within the `PipeMessage` method, notice the following lines of code and what they do, as follows:

    The following line of code within the method increments a counter that counts the number of messages sent to the module:

    ```csharp
    int counterValue = Interlocked.Increment(ref counter);
    ```

    The following lines of code within the method write out to the Console for the Module a message that contains the total number of messages received by the Module, along with the current messages body as JSON.

    ```csharp
    byte[] messageBytes = message.GetBytes();
    string messageString = Encoding.UTF8.GetString(messageBytes);
    Console.WriteLine($"Received message: {counterValue}, Body: [{messageString}]");
    ```

We have now created and configured a sample custom module. Next, we will debug it in the IoT Edge Simulator.
