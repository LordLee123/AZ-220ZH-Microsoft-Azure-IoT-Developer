---
lab:
    title: 'Lab 13: Develop, Deploy and debug a custom module on Azure IoT Edge with VS Code'
    module: 'Module 7: Azure IoT Edge Modules'
---

# Develop, Deploy and debug a custom module on Azure IoT Edge with VS Code

## Lab Scenario

Contoso's warehouse moves inventory that is ready to be packed for delivery on a conveyor belt.

In order to make sure the correct amount of products have been packed, you will add a simple module to count objects detected on the belt by another object detection module (simulated) on the same IoT Edge device. We will show how to create a custom module that does object counting.

This lab includes the following prerequisites for the development machine (lab host environment - VM or PC):

* Visual Studio Code with the following extensions installed:
  * [Azure IoT Tools](https://marketplace.visualstudio.com/items?itemName=vsciot-vscode.azure-iot-tools) by Microsoft
  * [C#](https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp) by Microsoft
  * [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
* Docker Community Edition installed on development machine
  * [Download Docker Desktop for Mac and Windows](https://www.docker.com/products/docker-desktop)


## In This Lab

IoT Edge solution development in VS Code

* Verify Lab Prerequisites
* Create Container Registry
* Create and customize an Edge module
* Deploy modules to Edge device



## Exercise 1: Verify Lab Prerequisites



## Exercise 2: Install Azure IoT EdgeHub Dev Tool

In this exercise, you will will install the Azure IoT EdgeHub Dev Tool.

1. To develop Azure IoT Edge modules with C#, you will need to install the Azure IoT EdgeHub Dev Tool. This tool required Python 2.7, 3.6, or 3.7 to be installed.

    > [!NOTE] Currently, the Azure IoT EdgeHub Dev Tool uses a docker-py library that is not compatible with Python 3.8.

1. To install Python, navigate to [https://www.python.org/downloads/](https://www.python.org/downloads/), then download and install Python.

1. Pip is required to install the Azure IoT EdgeHub Dev Tool on your development machine. With Python already installed, run the following commands to install Pip:

    ```cmd/sh
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python get-pip.py
    ```

    > [!NOTE] If you have issues installing Pip, please reference the official Pip installation instructions here: [https://pip.pypa.io/en/stable/installing/](https://pip.pypa.io/en/stable/installing/).

1. Run the following command to install [Azure IoT EdgeHub Dev Tool](https://pypi.org/project/iotedgehubdev/)

    ```cmd/sh
    pip install iotedgehubdev
    ```

    > [!NOTE] If you have multiple Python including pre-installed Python 2.7 (for example, on Ubuntu or macOS), make sure you are using the correct `pip` or `pip3` to install `iotedgehubdev`.

Now we have configured the python environment and installed these tools, we are now ready to create an Azure Container Registry which will be used to store our custom IoT Edge Module.

## Exercise 3: Create Azure Container Registry

Azure Container Registry provides storage of private Docker images for container deployments. The service is a managed, private Docker registry service based on the open-source Docker Registry 2.0. Azure Container Registry is used to store and manage your private Docker container images.

In this exercise, you will use the Azure portal to create a new Azure Container Registry resource.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. In the Azure Portal, click **Create a resource** open the Azure Marketplace.

1. On the **New** blade, in the **Search the Marketplace** box, type in and search for **Container Registry**.

1. In the search results, select the **Container Registry** item.

1. On the **Container Registry** item, click **Create**.

1. On the **Create container registry** blade, enter a globally unique name in the **Registry name** field.

    To provide a globally unique name, enter **AZ220ACR{YOUR-ID}**.

    For example: **AZ220ACRCP120419**

    The name of your Azure Container Registry must be globally unique because it is a publicly accessible resource that you must be able to access from any IP connected device.

    Consider the following when you specify a unique name for your new Azure Container Registry:

    * The value that you apply to _Registry name_ must be unique across all of Azure. This is true because the value assigned to the name will be used in the domain name assigned to the service. Since Azure enables you to connect from anywhere in the world to your registry, it makes sense that all container registries must be accessible from the Internet using the resulting domain name.

    * The value that you assign to _Registry name_ cannot be changed once the Azure Container Registry has been created. If you do need to change the name, you'll need to create a new Container Registry, re-deploy your containers, and delete your old Container Registry.

    * The _Registry name_ field is a required field.

    > [!NOTE] Azure will ensure that the name you enter is unique. If the name that you enter is not unique, Azure will display an asterisk at the end of the name field as a warning. You can append the name suggested above with '**01**' or '**02**' as necessary to achieve a globally unique name.

1. In the **Resource group** dropdown, select the **AZ-220-RG** resource group.

1. In the **Location** dropdown, choose the same Azure region that was used for the resource group.

1. On the **Admin user** option, select **Enable**. This option will enable you to Docker login to the Azure Container Registry service using the registry name as the username and admin user access key as the password.

1. In the **SKU** dropdown, choose **Standard**.

    Azure Container Registry is available in multiple service tiers, known as SKUs. These SKUs provide predictable pricing and several options for aligning to the capacity and usage patterns of your private Docker registry in Azure.

1. Click **Create**.

1. Once created, navigate to the **AZ220ACR{YOUR-ID}** resource.

1. In order to determine the admin username and password, under **Settings**, click **Access keys**.

    Make a note of the following values:

    * **Login server**
    * **Username** - this is the admin username and will match the ACR name - **AZ220ACR{YOUR-ID}**
    * **password** - this is the admin password

Now that we have created the Azure Container Registry, we can create a custom IoT Edge Module container that will be store in the registry.

## Exercise 4: Create Custom Edge Module in C#

In this exercise, you will create an Azure IoT Edge Solution that contains a custom Azure IoT Edge Module written in C#.

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

## Exercise 5: Debug in Attach Mode with IoT Edge Simulator

In this exercise, you will build and run a custom IoT Edge Module solution using the IoT Edge Simulator from within Visual Studio Code.

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

## Exercise 6: Deploy IoT Edge Solution

In this exercise, you will build and publish the custom IoT Edge Module into the Azure Container Registry (ACR) service. Once published to ACR, the custom module will then be made available to be deployed to any IoT Edge Device.

1. Ensure `.env` credentials for the Azure Container Registry have been set. Do this by opening the `.env` file located in the root directory of the IoT Edge Solution.

    When set correctly the `CONTAINER_REGISTRY_USERNAME_<acr-name>` key will have it's value set to the Azure Container Registry service name, and the `CONTAINER_REGISTRY_PASSWORD_<acr-name>` key will have it's value set to the **Password** for the Azure Container Registry service. Keep in mind, the `<acr-name>` placeholders in the keys will be set to the ACR service name (is all lowercase) automatically when the IoT Edge Solution was created.

    The resulting `.env` file contents will look similar to the following:

    ```text
    CONTAINER_REGISTRY_USERNAME_az220acrcp1119=AZ220ACRCP1119
    CONTAINER_REGISTRY_PASSWORD_az220acrcp1119=Q8YErJFCtqSe9C7BWdHOKEXk+C6uKSuK
    ```

1. Right-click `deployment.template.json`, and select **Build and Push IoT Edge Solutions**.

1. The status of the **Build and Push IoT Edge Solution** operation is displayed within the Visual Studio Code **Terminal**. Once the process completed, the custom `ObjectCounterModule` IoT Edge Module will be built and then the Docker image for the IoT Edge Module will be published to the Azure Container Registry service.

1. Open the **Azure portal**. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On your Resource group tile, click **AZ220ACR{YOUR-ID}** to navigate to the Azure Container Registry (ACR) service.

1. Click on the **Repositories** link under the **Services** section.

1. On the **Repositories** pane, notice that the `objectcountermodule` repository now exists within the ACR service. This was created when the custom `ObjectCounterModule` IoT Edge Module was published from within Visual Studio Code.

1. Click on the **objectcountermodule** repository navigate to the repository details.

1. On the **Repository** details pane for the **objectcountermodule** repository, notice in the list of tags there is a tag named `0.0.1-amd64`

1. Click on the `0.0.1-amd64` tag to open up the details pane for this Tag within the `objectcountermodule` repository.

    Notice the properties listed, including _Tag creation date_,  _Tag last updated date_, and other properties displaying information about the Tag.

1. Copy the **Repository** name and the **Tag** for use later on.

    The Repository and Tag names will be used to pull down this specific version of the Docker image for the custom IoT Edge Module to run in an IoT Edge Device.

    The format of the Docker image Repository and Tag names combined will be in the following format:

    ```text
    <repository-name>:<tag>
    ```

    Here's an example of a full Docker image name for the `objectcountermodule` IoT Edge Module:

    ```text
    objectcountermodule:0.0.1-amd64
    ```

1. Navigate to the Azure IoT Hub (`AZ-220-HUB-{YOUR-ID}`) resource. With the custom `objectcountermodule` IoT Edge Module published to Azure Container Registry (ACR), the next step is to create a new IoT Edge Device within IoT Hub and configure it to run the new custom IoT Edge Module.

1. On the **IoT Hub** blade, click on the **IoT Edge** link under the **Automatic Device Management** section.

1. On the IoT Hub **IoT Edge** pane, click the **Add an IoT Edge device** button at the top.

1. On the **Create a device** pane, enter `objectcounterdevice` into the **Device ID** field.

1. Under **Authentication type**, select the **Symmetric key** option, and check the **Auto-generate keys** checkbox.

    For this unit, we'll keep the IoT Edge Module registration simple by choosing _Symmetric key_ authentication. With the _Auto-generate keys_ option selected, the IoT Hub with automatically generate authentication keys for this device.

1. Click **Save**.

1. On the **IoT Edge** pane, click on the **objectcounterdevice** IoT Edge Device in the list of IoT Edge devices to open the details view for the device.

1. On the `objectcounterdevice` IoT Edge Device details pane, click on the **Set Modules** button at the top.

1. On the **Set modules** pane, within the **Container Registry Settings** section of the _Add Modules_ tab, enter the following values:

    - **Name**: Enter the **Registry name** of the Azure Container Registry
    - **Address**: Enter the **Login server** (or DNS name) of the Azure Container Registry service (ex: `az220acrcp1119.azurecr.io`)
    - **User Name**: Enter the **Username** for the Azure Container Registry service
    - **Password**: Enter the **Password** for the Azure Container Registry service

    > [!NOTE] The Azure Container Registry (ACR) service _Registry name_, _Login server_, _Username_, and _Password_ can be found on the **Access keys** pane for the service.

1. On the **Set modules** pane, within the **Deployment Modules** section of the _Add Modules_ tab, click the **Add** button and select **IoT Edge Module**.

1. On the **IoT Edge Custom Modules** pane, enter `objectcountermodule` into the **Name** field

    - **Image URI**: Enter the name of the Docker image for the custom IoT Edge Module that was copied previously. (ex: `objectcountermodule:0.0.1-amd64`)

1. Enter the full URI for the `objectcountermodule` IoT Edge Module hosted within Azure Container Registry into the **Image URI** field.

    The full URI for the Docker image within Azure Container Registry needs to be in the following format:

    ```text
    <container-registry-login-server>/<repository-name>:<tag>
    ```

    Be sure to replace the placeholders within the above **Image URI** format with the appropriate values:

    - `<container-registry-login-server>` - The **Login server**, or DNS name, for the Azure Container Registry service.
    - `<repository-name>` - The **Repository name** for the Custom IoT Edge Module's Docker image, that was copied previously.
    - `<tag>` - The **Tag** for the Custom IoT Edge Module's Docker image, that was copied previously.

    The resulting **Image URI** to be entered into the field will be similar to the following:

    ```text
    az220acr1119.azurecr.io/objectcountermodule:0.0.1-amd64
    ```

1. Click **Add**.

1. On the **Set modules** pane, click **Next: Routes**.

1. Within the **Specify Routes**, the editor will display the configured default route for the IoT Edge Device. At this time, it should be configured with a route that sends all messages from all modules to Azure IoT Hub:

    - Name: **route**
    - Value: `FROM /messages/* INTO $upstream`

    Delete this route by clicking the trasj icon to the right of the route and then add the two following routes:

    | Name | VALUE |
    | :--- | :--- |
    | AllMessagesToObjectCounterModule | FROM /* INTO BrokeredEndpoint(\"/modules/objectcountermodule/inputs/input1\") |
    | ObjectCounterModuleToIoTHub | FROM /messages/modules/objectcountermodule/outputs/* INTO $upstream |

1. Notice the IoT Hub message routing query specified for the **AllMessagesToObjectCounterModule** route.

    This route specifies the **Source** value of `/*`. This applies the route to all device-to-cloud messages or twin change notifications from any module or leaf device.

    This route specifies the **Destination** value of `BrokeredEndpoint(\"/modules/objectcountermodule/inputs/input1\")`. This sends all messages from the Source of this route to the `objectcountermodule` IoT Edge Module's input.

1. Notice the IoT Hub message routing query specified for the  **ObjectCounterModuleToIoTHub** route.

    This route specifies the **Source** value of `/messages/modules/objectcountermodule/outputs/*`. This applies the route to all messages output from the `objectcountermodule` IoT Edge Module.

    This route specifies the **Destination** value of `$upstream`. This sends all messages from the Source of this route to the Azure IoT Hub service within Microsoft Azure.

    > [!NOTE] For more information on the configuration of Message Routing with Azure IoT Hub and IoT Edge Module, reference the following links:
    > - [Learn how to deploy modules and establish routes in IoT Edge](https://docs.microsoft.com/en-us/azure/iot-edge/module-composition)
    > - [IoT Hub message routing query syntax](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-routing-query-syntax)

1. Click **Next: Review + create**.

1. On the **Review Deployment** step, click **Create**.

This completes the development of a sample custom IoT Edge Module - `objectcountermodule`. Now that an IoT Edge Device is register, the modules specified and the routes configured, the `objectcountermodule` is ready to be deployed once the associated IoT Edge Device is connected to the Azure IoT Hub as shown in previous labs.
