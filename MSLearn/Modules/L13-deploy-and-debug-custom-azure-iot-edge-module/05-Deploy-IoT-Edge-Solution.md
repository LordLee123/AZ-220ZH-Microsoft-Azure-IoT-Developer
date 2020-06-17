# Deploy IoT Edge Solution

In this unit, you will build and publish the custom IoT Edge Module into the Azure Container Registry (ACR) service. Once published to ACR, the custom module will then be made available to be deployed to any IoT Edge Device.

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
