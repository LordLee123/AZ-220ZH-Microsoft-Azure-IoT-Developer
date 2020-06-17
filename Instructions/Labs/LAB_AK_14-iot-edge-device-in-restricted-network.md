---
lab:
    title: 'Lab 14: Run an IoT Edge device in restricted network and offline'
    module: 'Module 7: Azure IoT Edge Module'
---

# Run an IoT Edge device in restricted network and offline

## Lab Scenario

The conveyor belt system monitors vibrations, telemetry, and counts objects. We want our system to be resilient to network outages and also optimize the bulk upload of telemetry data at specific times in the day (load balancing network usage). We will configure IoT Edge to support offline in case network drops and we will look into storing telemetry from sensors locally and configure for regular syncs at given times.

You will learn the different scenarios where IoT Edge device is on an enterprise network (needs proxy settings) or needs extended offline capabilities. 

## In this Lab

In this lab, you will:

* Verify Lab Prerequisites
* Create an IoT Hub and Device ID
* Deploy Azure IoT Edge Enabled Linux VM
* Setup IoT Edge Parent with Child IoT Devices
* Configure IoT Edge Device as Gateway
* Open IoT Edge Gateway Device Inbound Ports using Azure CLI
* Configure IoT Edge Device Time-to-Live and Message Storage
* Connect Child IoT Device to IoT Edge Gateway
* Test Device Connectivity and Offline Support
 

## Exercise 1: Verify Lab Prerequisites

This lab assumes the following resources are available:

| Resource Type | Resource Name |
| :-- | :-- |
| Resource Group | AZ-220-RG |
| IoT Hub | AZ-220-HUB-{YOUR-ID} |
| IoT Device | SimulatedThermostat |

If the resources are unavailable, please execute the **lab-setup.azcli** script before starting the lab.

>**Note:** You will need the **SimulatedDevice** connection string. You can obtain that by running the following command in the Azure Cloud Shell"
> 
> ```bash
> az iot hub device-identity show-connection-string --hub-name AZ-220-HUB-{YOUR-ID} --device-id SimulatedThermostat -o tsv
> ```

## Execute Setup Script

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Open the Azure Cloud Shell by clicking the **Terminal** icon within the top header bar of the Azure portal, and select the **Bash** shell option.

1. Before the Azure CLI can be used with commands for working with Azure IoT Hub, the **Azure IoT Extensions** need to be installed. To install the extension, run the following command:

    ```sh
    az extension add --name azure-cli-iot-ext
    ```

1. To upload the setup script, in the Azure Cloud Shell toolbar, click **Upload/Download files** (fourth button from the right).

1. In the dropdown, select **Upload** and in the file selection dialog, navigate to the **lab-setup.azcli** file for this lab. Select the file and click **Open** to upload it.

    A notification will appear when the file upload has completed.

1. You can verify that the file has uploaded by listing the content of the current directory by entering the `ls` command.

1. To create a directory for this lab, move **lab-setup.azcli** into that directory, and make that the current working directory, enter the following commands:

    ```bash
    mkdir lab14
    mv lab-setup.azcli lab14
    cd lab14
    ```

1. To ensure the **lab-setup.azcli** has the execute permission, enter the following commands:

    ```bash
    chmod +x lab-setup.azcli
    ```

1. To edit the **lab-setup.azcli** file, click **{ }** (Open Editor) in the toolbar (second button from the right). In the **Files** list, select **lab14** to expand it and then select **lab-setup.azcli**.

    The editor will now show the contents of the **lab-setup.azcli** file.

1. In the editor, update the values of the `{YOUR-ID}` and `Location` variables. Set `{YOUR-ID}` to the Unique ID you created at the start of this course - i.e. **CP123019**, and set `Location` to the location that makes sense for your resources.

    > [!NOTE] The `Location` variable should be set to the short name for the location. You can see a list of the available locations and their short-names (the **Name** column) by entering this command:
    >
    > ```bash
    > az account list-locations -o Table
    > ```
    >
    > ```text
    > DisplayName           Latitude    Longitude    Name
    > --------------------  ----------  -----------  ------------------
    > East Asia             22.267      114.188      eastasia
    > Southeast Asia        1.283       103.833      southeastasia
    > Central US            41.5908     -93.6208     centralus
    > East US               37.3719     -79.8164     eastus
    > East US 2             36.6681     -78.3889     eastus2
    > ```

1. To save the changes made to the file and close the editor, click **...** in the top-right of the editor window and select **Close Editor**.

    If prompted to save, click **Save** and the editor will close.

    > [!NOTE] You can use **CTRL+S** to save at any time and **CTRL+Q** to close the editor.

1. To create a resource group named **AZ-220-RG**, create an IoT Hub named **AZ-220-HUB-{YourID}**, add a device with a Device ID of **SimulatedThermostat**, and display the device connection string, enter the following command:

    ```bash
    ./lab-setup.azcli
    ```

    This will take a few minutes to run. You will see JSON output as each step completes.

1. Once complete, the connection string for the device, starting with "HostName=", is displayed. Copy this connection string into a text document and note that it is for the **SimulatedThermostat** device.

## Exercise 2: Deploy Azure IoT Edge enabled Linux VM

In this unit you will deploy an Ubuntu Server VM with Azure IoT Edge runtime support from the Azure Marketplace. In previous labs you have created the VM using the Azure Portal. This time around, we will create the VM using the Azure CLI.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Open the Azure Cloud Shell by clicking the **Terminal** icon within the top header bar of the Azure portal, and select the **Bash** shell option.

1. To create a resource group for the Azure IoT Edge enabled VM, enter the following command:

    ```bash 
    az group create --name AZ-220-IoTEdge-RG --location {YOUR-LOCATION}
    ```

    Remember to replace `{YOUR-LOCATION}` with a location close to you.

1. To create a Linux VM, enter the following commands:

    ```bash
    az vm image terms accept --urn microsoft_iot_edge:iot_edge_vm_ubuntu:ubuntu_1604_edgeruntimeonly:latest
    az vm create --resource-group AZ-220-IoTEdge-RG --name AZ220EdgeVM{YOUR-ID} --image microsoft_iot_edge:iot_edge_vm_ubuntu:ubuntu_1604_edgeruntimeonly:latest --admin-username vmadmin --admin-password {YOUR-PASSWORD-HERE} --authentication-type password
    ```

    The first command above accepts the terms and conditions of use for VM image. The second command  actually creates the VM within the resource group specified above. Remember to update `AZ220EdgeVM{YOUR-ID}` with your unique id and replace `{YOUR-PASSWORD-HERE}` with a suitably secure password.

    >**Note**: In production, you may elect to generate SSH keys rather than use the username/password approach. You can learn more about Linux VMs and SSH here: [https://docs.microsoft.com/en-us/azure/virtual-machines/linux/create-ssh-keys-detailed](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/create-ssh-keys-detailed).

    > [!NOTE] Deployment will take approximately 5 minutes to complete. You can continue on to the next unit while it is deploying.

## Exercise 3: Setup IoT Edge Parent with Child IoT Devices

In this exercise, you will register an IoT Edge Device within Azure IoT Hub, and an IoT Device that is configured in a child relationship. This will enable the scenario to the the child IoT Device send messages through the IoT Edge Device as a gateway before communicating to the Azure IoT Hub in the cloud.

The use of Parent / Child relationships including an IoT Edge Gateway (the parent) and other IoT Devices (the child or leaf devices) enables the use of Offline capabilities within an Azure IoT solution.

The following diagram shows the relationship between the Azure IoT Edge Device as the parent, and a child device:

![IoT Edge Parent with Child Device Diagram](images/IoTEdge-Parent-Child-Relationship.jpg "IoT Edge Parent with Child Device Diagram")

In this scenario, the child device connects to, and authenticate against the parent IoT Edge Device using their Azure IoT Hub credentials. Once authenticated, the child IoT Device sends messages to the Edge Hub (`$edgeHub`) on the IoT Edge Device. Once messages reach the parent IoT Edge Device, the IoT Edge Modules and Routing will handle the messages as configured; including sending the messages to the Azure IoT Hub when connected.

When the parent IoT Edge Device is disconnected (or loses connection to the Azure IoT Hub) it will automatically store all device messages to the IoT Edge Device. Once the connection is restored, the IoT Edge Device will resume connectivity and send any stored messages to Azure IoT Hub. Messages stored on the IoT Edge Device may expire according to the Time-to-Live (TTL) configurations for the device; which defaults to store messages for up to `7200` seconds (two hours).

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. At the top of the Azure Portal click on the **Cloud Shell** icon to open up the **Azure Cloud Shell** within the Azure Portal. When the pane opens, choose the option for the **Bash** terminal within the Cloud Shell.

1. First the IoT Edge Device Identity needs to be created. This will be the **IoT Edge Gateway**, or the Parent IoT Device. Run the following command to create a new **IoT Edge Device Identity** within Azure IoT Hub:

    ```sh
    az iot hub device-identity create --edge-enabled --hub-name AZ-220-HUB-{YOUR_ID} --auth-method shared_private_key --device-id IoTEdgeGateway
    ```

    > [!NOTE] Be sure to replace the **AZ-220-HUB-{YOUR-ID}** IoT Hub name with the name of your Azure IoT Hub.

    Notice the `az iot hub device-identity create` command is called by passing in several parameters:

    - `--hub-name`: This required parameter is used to specify the name of the **Azure IoT Hub** to add the new device to.

    - `--device-id`: This required parameter is used to specify the **Device ID** of the IoT Device being created.

    - `--edge-enabled`: This specifies the IoT Device being created is an **IoT Edge Device** and it will be enabled for IoT Edge.

    - `--auth-method`: This specifies the authentication method used for the IoT device. The value of `shared_private_key` specifies to use Symmetric Key Encryption. Other options available are `x509_ca` and `x509_thumbprint`.

1. Notice when the command completes, there is a blog of JSON returned to the terminal. This JSON includes a few details for the configuration of the **IoT Edge Device** that was just created. Among the device details is the **symmetric keys** that were auto-generated by the service for the device.

    ```json
        {
          "authentication": {
            "symmetricKey": {
              "primaryKey": "gOAYooDeRrinZzyo0yWZNEkvc0wZaF9/4qaXv7s7olw=",
              "secondaryKey": "MzE5VtKJzOO6HGnNkI4kyn+MCziUYXZ/MSJCKxHIHa0="
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
          "deviceId": "IoTEdgeGateway",
          "deviceScope": "ms-azure-iot-edge://IoTEdgeGateway-637121074930370650",
          "etag": "Nzk1MjE0NjM2",
          "generationId": "637121074930370650",
          "lastActivityTime": "0001-01-01T00:00:00",
          "status": "enabled",
          "statusReason": null,
          "statusUpdatedTime": "0001-01-01T00:00:00"
        }
    ```

1. Run the following command to retrieve the **Connection String** from IoT Hub for the **IoTEdgeGateway** Device, and **copy** the connection string value for reference later:

    ```cmd/sh
    az iot hub device-identity show-connection-string --hub-name AZ-220-HUB-{YOUR-ID} --device-id IoTEdgeGateway -o tsv
    ```

    > [!NOTE] Be sure to replace the **AZ-220-HUB-{YOUR-ID}** IoT Hub name with the name of your Azure IoT Hub.

    Notice the `az iot hub device-identity show-connection-string` command is called by passing in several parameters:

    - `--hub-name`: This required parameter is used to specify the name of the **Azure IoT Hub** to add the new device to.

    - `--device-id`: This required parameter is used to specify the **Device ID** of the IoT Device being created.

    The IoT Hub connection string output from the **IoTEdgeGateway** device will be in the following format:

    ```text
    HostName={iot-hub-name}.azure-devices.net;DeviceId=IoTEdgeGateway;SharedAccessKey={shared-access-key}
    ```

1. The next step is to create the Child IoT Device. These will be **IoT Devices** registered with the Azure IoT Hub, and will connect directly to the Parent IoT Device for communications with the cloud.

1. To create the first child device, run the following command:

    ```sh
    az iot hub device-identity create -n AZ-220-HUB-{YOUR-ID} --device-id ChildDevice1 --pd IoTEdgeGateway
    ```

    > [!NOTE] Be sure to replace the **AZ-220-HUB-{YOUR-ID}** IoT Hub name with the name of your Azure IoT Hub.

    This command is passed the following parameters:

    - `-n`: This required parameter is the shorthand for `--hub-name` and is used to specify the name of the **Azure IoT Hub** to add the new device to.

    - `--device-id`: This required parameter is used to specify the **Device ID** of the IoT Device being created.

    - `--pd`: This parameter specifies the **Parent Device** for the IoT Device being created. The value passed in must be the **Device ID** of the **Parent Device** to assign this **Child Device** to.

    Notice that this command is not passing in the `--auth-method`. By omitting this parameter, the default value of `shared_private_key` will be used.

1. Notice when the command completes, there is a blog of JSON returned to the terminal. This JSON includes a few details for the configuration of the **IoT Device** that was just created. Notice the `symmetricKey` node that contains the Symmetric Keys that can be used to authenticate the device with Azure IoT Hub, or when the child device connects to the parent IoT Edge Gateway.

    Copy the **primaryKey** for this IoT Device so it can be used later.

    ```json
        {
          "authentication": {
            "symmetricKey": {
              "primaryKey": "uMhYoXK/WRoXrIATh25aijyEbA401PKDxy4KCS488U4=",
              "secondaryKey": "9tOPmSkmoqRd2KEP1JFyQQ6y2JdA5HPO7qnckFrBVm4="
            },
            "type": "sas",
            "x509Thumbprint": {
              "primaryThumbprint": null,
              "secondaryThumbprint": null
            }
          },
          "capabilities": {
            "iotEdge": false
          },
          "cloudToDeviceMessageCount": 0,
          "connectionState": "Disconnected",
          "connectionStateUpdatedTime": "0001-01-01T00:00:00",
          "deviceId": "ChildDevice1",
          "deviceScope": "ms-azure-iot-edge://IoTEdgeGateway-637121074930370650",
          "etag": "MTgxNjg1MjE0",
          "generationId": "637121169262975883",
          "lastActivityTime": "0001-01-01T00:00:00",
          "status": "enabled",
          "statusReason": null,
          "statusUpdatedTime": "0001-01-01T00:00:00"
        }
    ```

1. Run the following command to retrieve the **Connection String** from IoT Hub for the **IoTEdgeGateway** Device, and **copy** the connection string value for reference later:

    ```cmd/sh
    az iot hub device-identity show-connection-string --hub-name AZ-220-HUB-{YOUR-ID} --device-id ChildDevice1 -o tsv
    ```

    > [!NOTE] Be sure to replace the **AZ-220-HUB-{YOUR-ID}** IoT Hub name with the name of your Azure IoT Hub.

1. Now you have an IoT Edge Device and a Child IoT Device registered within Azure IoT Hub. The **IoT Device** is configured with the **IoT Edge Device** as its parent. This configuration will enable the Child IoT Device to connect to and communicate with the Parent IoT Edge Device; instead of connecting directly with Azure IoT Hub. Configuring the IoT device topology this way enables Offline capable scenarios where the IoT Device and IoT Edge Device can keep working even when connectivity to Azure IoT Hub is broken.

## Exercise 4: Configure IoT Edge Device as Gateway

In this exercise, you will configure the Azure IoT Edge on Ubuntu virtual machine that was created previously to be an IoT Edge Transparent Gateway device. The configuration will be handled by a helper script that is part of this unit to make the process quicker.

1. Locate the labfiles for this lab, and open the `setup-iot-edge-gateway.sh` helper script within **Visual Studio Code**.

1. Edit the `setup-iot-edge-gateway.sh` script to replace the following variable placeholders with the necessary values so the **IoT Edge on Ubuntu VM** can be configured as an **IoT Edge Transparent Gateway**:

    | Placeholder | Value to replace with |
    | :--- | :--- |
    | `{iot-edge-device-connection-string}` | Paste in the **Connection String** for the `IoTEdgeGateway` device that was created within Azure IoT Hub.
    | `{iot-edge-device-hostname}` | Paste in the **Public IP Address** of the **IoT Edge on Ubuntu VM**. This is the DNS Hostname that the Client IoT Device will use to connect to the IoT Edge Transparent Gateway.

    The variables these placeholders are associated with are located at the top of the `setup-iot-edg-gateway.sh` script, and are similar to the following before the placeholders are replaced:

    ```sh
    connectionstring="{iot-edge-device-connection-string}"
    hostname="{iot-edge-device-hostname}"
    ```

1. Save the file.

1. Locate the labfiles for this lab, and open the `setup-remote-iot-edge-gateway.sh` helper script within **Visual Studio Code**.

1. Edit the `setup-remote-iot-edge-gateway.sh` script to replace the following variable placeholders with the necessary values so the **IoT Edge on Ubuntu VM** can be configured as an **IoT Edge Transparent Gateway**:

    | Placeholder | Value to replace with |
    | :--- | :--- |
    | `{iot-edge-username}` | Enter the admin **username** to connect to the **IoT Edge on Ubuntu VM**. This is used to connect tot he VM via SSH.
    | `{iot-edge-ipaddress}` | Enter the **Public IP Address** for the **IoT Edge on Ubuntu VM**. This is used to connect to the VM via SSH.

    The variables these placeholders are associated with are located at the top of the `setup-remote-iot-edg-gateway.sh` script, and are similar to the following before the placeholders are replaced:

    ```sh
    username="{iot-edge-username}"
    ipaddress="{iot-edge-ipaddress}"
    ```

1. Save the file.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Open the Azure Cloud Shell by clicking the **Terminal** icon within the top header bar of the Azure portal, and select the **Bash** shell option.

1. To upload the setup scripts, in the Azure Cloud Shell toolbar, click **Upload/Download files** (fourth button from the right).

1. In the dropdown, select **Upload** and in the file selection dialog, navigate to the directory for this lab. Select the following _bash_ scripts and click **Open** to upload them.

    - `setup-iot-edge-gateway.sh`
    - `setup-remote-iot-edge-gateway.sh`

    A notification will appear when the file upload has completed.

    > [!NOTE] These two scripts are helper scripts that will assist in setting up the Azure IoT Edge on Ubuntu VM to be a Transparent Gateway device. These scripts are meant to be used for development purposes in this lab, and are not meant for production use.

1. You can verify that the files have been uploaded by listing the content of the current directory by entering the `ls` command.

    **Make sure both scripts have been uploaded to Azure Cloud Shell before continuing.**

1. Run the following command within the **Azure Cloud Shell** to make sure the `setup-remote-iot-edge-gateway.sh` script is executable:

    ```sh
    chmod 700 setup-remote-iot-edge-gateway.sh
    ```

1. To setup the **IoT Edge on Ubuntu VM** as an **IoT Edge Transparent Gateway**, run the `setup-remote-iot-edge-gateway.sh` script using the following command within the **Azure Cloud Shell**:

    ```sh
    ./setup-remote-iot-edge-gateway.sh
    ```

    Enter the **password** for the **IoT Edge on Ubuntu VM** when prompted. There will be a total of 3 prompts to enter the password. These prompts are due to the `ssh` and `scp` commands used to upload the `setup-iot-edge-gateway.sh` helper script to the VM, run the script, and then download the x.509 certificate that will be used later to authenticate the Child IoT Device to the IoT Edge Transparent Gateway.

1. Once the helper script has finished configuring the IoT Edge on Ubuntu VM to be an IoT Edge Transparent Gateway, the **Azure Cloud Shell** will download the `azure-iot-test-only.root.ca.cert.pem` x.509 certificate.

    If the x.509 certificate isn't downloaded automatically within the web browser, then run the following command within the **Azure Cloud Shell** to manually download the file:

    ```sh
    download azure-iot-test-only.root.ca.cert.pem
    ```

1. Save the x.509 certificate that was downloaded to the `downloads` folder for your web browser. This will be used to configure the Child IoT Device authentication.

This unit used the helper scripts to setup and configure the IoT Edge on Ubuntu VM as an IoT Edge Transparent Gateway Device. This is done to keep the labs focus on the Restricted Network and Offline capabilities of Azure IoT Edge.

_Please reference the **Setup an IoT Edge Gateway** lab for the specific steps and instruction on setting up an **IoT Edge Gateway Device**._

## Exercise 5: Open IoT Edge Gateway Device Inbound Ports using Azure CLI

In this exercise, you will use the Azure CLI to configure the Network Security Group (NSG) that secures access to the Azure IoT Edge Gateway from the Internet. The necessary ports for MQTT, AMQP, and HTTPS communications need to be opened so the downstream IoT device(s) can communicate with the gateway.

For the Azure IoT Edge Gateway to communicate with Child IoT Devices, the TCP/IP port for the devices protocol must be open for **Inbound** communication. The device could use one of three supported protocols to communicate with the IoT Gateway.

These are the TCP/IP port numbers for the supported protocols:

| Protocol | Port Number |
| --- | --- |
| MQTT | 8883 |
| AMQP | 5671 |
| HTTPS<br/>MQTT + WS (Websocket)<br/>AMQP + WS (Websocket) | 443 |

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Within the **Azure portal**, navigate to the **IoTEdgeGateway** resource group.

1. Make note of the resource name of the **Network security group** (NSG) that was created for the **IoTEdgeGateway** virtual machine.

    The name of the NSG should match the format of `{vm-name}-nsg`.

1. Open the Azure Cloud Shell by clicking the **Terminal** icon within the top header bar of the Azure portal, and select the **Bash** shell option.

1. Within the **Azure Cloud Shell**, to find the name of the Network Security Group (NSG) in use by the Azure ioT Edge Gateway VM, enter the following command:

    ```bash
    az network nsg list --resource-group AZ-220-IoTEdgeResources -o table

    Location    Name                     ProvisioningState    ResourceGroup            ResourceGuid
    ----------  -----------------------  -------------------  -----------------------  ------------------------------------
    westus2     AZ220EdgeVM{YOUR-ID}NSG  Succeeded            AZ-220-IoTEdgeResources  <GUID> 
    ```

1. Within the **Azure Cloud Shell**, run the following commands to add **Inbound rules** to the NSG for MQTT, AMQP, and HTTPS communication protocols:

    ```cmd/sh
    az network nsg rule create --name MQTT --nsg-name AZ220EdgeVM{YOUR-ID}NSG --resource-group AZ-220-IoTEdgeResources --destination-port-ranges 8883 --priority 101
    az network nsg rule create --name AMQP --nsg-name AZ220EdgeVM{YOUR-ID}NSG --resource-group AZ-220-IoTEdgeResources --destination-port-ranges 5671 --priority 102
    az network nsg rule create --name HTTPS --nsg-name AZ220EdgeVM{YOUR-ID}NSG --resource-group AZ-220-IoTEdgeResources --destination-port-ranges 443 --priority 103
    ```

    Be sure to replace the placeholders with the appropriate values before running the commands:

    | Placeholder | Value to replace |
    | :--- | :--- |
    | `{nsg-name}` | Enter the name of the **Network Security Group**.
    | `{resource-group}` | Enter the name of the **Resource group** for the virtual machine.

    > [!NOTE] In production, it's best practice to only open inbound communication to the communication protocol(s) in use by your IoT devices. If your devices only use MQTT, then only open inbound communication for that port. This will help limit the surface attack area of open ports that could be exploited.

1. With the **Inbound rules** added to the **Network Security Group** (NSG), the Child IoT Device will be allowed to communicate with the IoT Edge Gateway virtual machine.

## Exercise 6: Configure IoT Edge Device Time-to-Live and Message Storage

In this exercise, you will configure the message Time-to-Live (TTL) of the Edge Hub module on the Azure IoT Edge Gateway device to be longer than the default. You will also configure the storage location on the IoT Edge Device where the messages are to be stored.

The default value of `7200` (2 hours) is not long enough for a device or solution that may need to function in Offline mode for extended periods of time. For the device and solution to operate for more extended periods of being disconnected, you will configure the Time-to-Live (TTL) property of the IoT Edge Hub module to the value of 1,209,600 seconds, for a 2 week TTL period.

The Module Twin for the IoT Edge Hub is called `$edgeHub` and is used to coordinate communications between the IoT Edge Hub running on the device and the Azure IoT Hub service. Within the Desired Properties for the Module Twin, the `storeAndForwardConfiguration.timeToLiveSecs` property specifies the time in seconds that IoT Edge Hub keeps messages when in a state disconnected from routing endpoints, like Azure IoT Hub.

The `timeToLiveSecs` property for the Edge Hub can be specified in the Deployment Manifest on a specific device as part of a single-device or at-scale deployment. In this unit, you will use the Azure Portal user interface for Azure IoT Hub to modify the `timeToLiveSecs` property for the Edge Hub (`$edgeHub`) module on the single IoT Edge Gateway device.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On your Resource group tile, click **AZ-220-HUB-{YOUR-ID}** to navigate to the Azure IoT Hub.

1. On the IoT Hub summary blade, click **IoT Edge** under the Automatic Device Management section. This section of the IoT Hub blade allows you to manage the IoT Edge devices connected to the IoT Hub.

1. In the list of **Device IDs**, click on the **IoTEdgeGateway** device.

1. In the list of **Modules**, click on the **$edgeHub** module. This is the Module Twin for the **Edge Hub** module configured for the **IoT Edge Device**.

1. On the **IoT Edge Module Details** pane, click the **Module Identity Twin** to view the Module Twin JSON.

  You will note that the `"desired"` properties are essentially empty for this new device.

1. Close the **Module Identity Twin** pane. 

1. Go back to the **IoT Edge Device** pane displaying the **IoTEdgeGateway** IoT Edge device.

1. Click the **Set Modules** button at the top. This will open up an interface that allows you to set and configure the IoT Edge Modules deployed to this IoT Edge Device.

1. On the **Set modules** pane, click the the **Runtime Settings** button under the **Iot Edge Modules** section.

1. On the **Runtime Settings** pane, locate the **Store and forward configuration - time to live (seconds)** field for the **Edge Hub** module, then change the value to `1209600`. This specifies a message time to live of 2 weeks on the IoT Edge Device.

    > [!NOTE] There are several considerations to make when configuring the **Message Time-to-Live** (TTL) for the Edge Hub (`$edgeHub`) module. When the IoT Edge Device is disconnected, the messages are stored on the local device. You need to calculate how much data will be stored during the TTL period, and make sure there is enough storage on the device for that much data. The amount of storage and TTL configured will need to meet the solutions requirements so that important data is not lost; if possible.
    >
    >If the device does not have enough storage, then you need to configure a shorter TTL. Once the age of a message reaches the TTL time limit, it will be deleted if it has not yet been sent to Azure IoT Hub.

1. The IoT Edge Device will automatically be able to store messages when in a disconnected / offline state. However, this location can be overridden by configuring a `HostConfig.Binds` setting.

1. On the **Runtime Settings** pane, beneath **Edge Hub**, within the **Create Options** box, add the following `Binds` property to the `HostConfig` object in the JSON.

    ```json
    "Binds": [
        "/etc/iotedge/storage/:/iotedge/storage/"
    ]
    ```

    This `Binds` value configures the `/iotedge/storage/` directory in the Docker container for the Edge Hub Module to be mapped to the `/etc/iotedge/storage/` host system directory on the physical IoT Edge Device.

    The value is in the format of `<HostStoragePath>:<ModuleStoragePath>`. The `<HostStoragePath>` value is the host directory location on the IoT Edge Device. The `<ModuleStoragePath>` is the module storage path made available within the container. Both of these values must be an absolute path.

1. The resulting JSON in the **Create Options** box should look similar to the following:

    ```json
        {
          "HostConfig": {
            "PortBindings": {
              "443/tcp": [
                {
                  "HostPort": "443"
                }
              ],
              "5671/tcp": [
                {
                  "HostPort": "5671"
                }
              ],
              "8883/tcp": [
                {
                  "HostPort": "8883"
                }
              ]
            },
            "Binds": [
              "/etc/iotedge/storage/:/iotedge/storage/"
            ]
          }
        }
    ```

1. To finish the update for the change in message storage location, add a new environment variable named **storageFolder** with the value of `/iotedge/storage/` within the **Environment Variables** section.

1. Click **Save**.

1. On the **Set modules** pane, click **Review + create**.

1. On the **Review + create** step, notice changes made are reflected within the JSON displayed, then click **Create**.

1. Once this change is saved, the **IoT Edge Device** will be notified of the change to the Module configuration and the new settings will be reconfigured on the device accordingly.

  Once the changes have been passed to the Azure IoT Edge device, it will restart the **edgeHub** module with the new configuration.

## Update Directory Permissions

 Before continuing, it is essential to ensure that the user profile for the IoT Edge Hub module has the required read, write, and execute permissions to the **/etc/iotedge/storage/** directory.

1. Navigate to the **AZ220EdgeVM{YOUR-ID}** IoT Edge virtual machine within the Azure Portal.

1. On the **Overview** pane of the **Virtual machine** blade, click the **Connect** button at the top.

1. Within the **Connect to virtual machine** pane, select the **SSH** option, then copy the **Login using VM local account** value.

    This is a sample SSH command that will be used to connect to the virtual machine that contains the IP Address for the VM and the Administrator username. The command is formatted similar to `ssh username@52.170.205.79`.

1. At the top of the Azure Portal click on the **Cloud Shell** icon to open up the **Azure Cloud Shell** within the Azure Portal. When the pane opens, choose the option for the **Bash** terminal within the Cloud Shell.

1. Within the Cloud Shell, paste in the `ssh` command that was copied, and press **Enter**.

1. When prompted with **Are you sure you want to continue connecting?**, type `yes` and press Enter. This prompt is a security confirmation since the certificate used to secure the connection to the VM is self-signed. The answer to this prompt will be remembered for subsequent connections, and is only prompted on the first connection.

1. When prompted to enter the password, enter the Administrator password that was entered when the VM was provisioned.

1. Once connected, the terminal will change to show the name of the Linux VM, similar to the following. This tells you which VM you are connected to.

    ```cmd/sh
    username@AZ220EdgeVM{YOUR-ID}:~$
    ```

1. To view the running IoT Edge modules, enter the following command:

    ```bash
    iotedge list
    ```

    Notice that the *edgeHub* has failed to start:

    ```text
    NAME             STATUS           DESCRIPTION                 CONFIG
    edgeAgent        running          Up 4 seconds                mcr.microsoft.com/azureiotedge-agent:1.0
    edgeHub          failed           Failed (139) 0 seconds ago  mcr.microsoft.com/azureiotedge-hub:1.0
    ```

    This is due to the fact that the *edgeHub* process does not have permission to write to the **/etc/iotedge/storage/** directory.

1. To confirm the issue with the directory permission, enter the following command:

    ```bash
    iotedge logs edgeHub
    ```

    The terminal will output the current log - if you scroll through the log you will see the relevant entry:

    ```text
    Unhandled Exception: System.AggregateException: One or more errors occurred. (Access to the path '/iotedge/storage/edgeHub' is denied.) ---> System.UnauthorizedAccessException: Access to the path '/iotedge/storage/edgeHub' is denied. ---> System.IO.IOException: Permission denied
    ```
  
1. To update the directory permissions, enter the following commands:

    ```sh
    sudo chown $( whoami ):iotedge /etc/iotedge/storage/
    sudo chmod 775 /etc/iotedge/storage/
    ```

    The first command sets the owner of the directory to the current user and the owning user group to **iotedge**. The second command enables full access to both the current user and members of the **iotedge** group. This will ensure that the *edgeHub* module is able to create directories and files within the **/etc/iotedge/storage/** directory.

1. To restart the *edgeHub* module and verify it started, enter the following commands:

    ```bash
    iotedge restart edgeHub
    iotedge list
    ```

    You should see that the *edgeHub* module is now running:

    ```text
    NAME             STATUS           DESCRIPTION      CONFIG
    edgeAgent        running          Up 13 minutes    mcr.microsoft.com/azureiotedge-agent:1.0
    edgeHub          running          Up 6 seconds     mcr.microsoft.com/azureiotedge-hub:1.0
    ```

We are now ready to connect a device to this IoT Edge Gateway device.

## Exercise 7: Connect Child IoT Device to IoT Edge Gateway

In this exercise, you will configure the downstream, child IoT Devices to connect to IoT Hub using their configured Symmetric Keys. The devices will be configured to connect to IoT Hub and the parent IoT Edge Device using a Connection String that contains the Symmetric Key; in addition to the Gateway Hostname for the Parent IoT Edge Device.

The process to authenticate regular IoT devices to IoT Hub with symmetric keys also applies to downstream (or child / leaf) devices. The only difference is that you need to add a pointer to the Gateway Device to route the connection or, in offline scenarios, to handle the authentication on behalf of IoT Hub.

In a previous unit, you created the IoT Device Identities in Azure IoT Hub. You copied the **Connection String** for the IoT Device. Alternatively, the Connection String can be accessed with the Azure portal for the Device ID of the device within Azure IoT Hub.

1. Copy the `azure-iot-test-only.root.ca.cert.pem` x.509 certificate file that was downloaded previously (when the IoT Edge Gateway was configured) to the `/LabFiles/ChildIoTDevice` directory where the source code for the Child IoT Device is located.

1. Open the `/LabFiles/ChildIoTDevice` directory within **Visual studio Code**.

1. Open the **ChildIoTDevice.cs** source code file.

1. Locate the declaration for the `s_connectionString` variable and replace the value placeholder with the **IoT Hub Connection String** for the **ChildDevice1** IoT Device.

1. Modify the **IoT Hub Connection String** to include the `GatewayHostName` property with the value set to the **Hostname** for the IoT Edge Gateway (`IoTEdgeGateway`) virtual machine.

    The Connection String will match the following format:

    ```text
    HostName=<iot-hub-name>.azure-devices.net;DeviceId=DownstreamDevice1;SharedAccessKey=<iot-device-key>;GatewayHostName=<iot-edge-gateway-hostname>
    ```

    Be sure to replace the placeholders with the appropriate values:

    - `<iot-hub-name>`: The **Name** of the **Azure IoT Hub**.
    - `<iot-device-key>`: The Primary or Secondary **Key** for the **ChildDevice1** IoT Device in IoT Hub.
    - `<iot-edge-gateway-hostname>`: Enter the **IP Address** for the **IoTEdgeGateway** virtual machine.

1. Save the file.

1. Open the **Terminal** window within Visual Studio Code.

1. Navigate the **Terminal** to the location of the `/LabFiles/ChildIoTDevice` directory.

1. Run the following command to build the code for the **ChildIoTDevice** simulated device, and execute it to start sending device telemetry:

    ```cmd/sh
    dotnet run
    ```

1. When the app installed the **x.509 certificate** on the local machine so it can use it to authenticate with the IoT Edge Gateway, it may prompt asking if you would like to install the certificate. Click **Yes** to allow it and continue.

1. Once the simulated device is running, the console output will display the events being sent to the Azure IoT Edge Gateway.

    The terminal output will look similar to the following:

    ```cmd/sh
    IoT Hub Quickstarts #1 - Simulated device. Ctrl-C to exit.

    User configured CA certificate path: azure-iot-test-only.root.ca.cert.pem
    Attempting to install CA certificate: azure-iot-test-only.root.ca.cert.pem
    Successfully added certificate: azure-iot-test-only.root.ca.cert.pem
    11/27/2019 4:18:26 AM > Sending message: {"temperature":21.768769073192388,"humidity":79.89793652663843}
    11/27/2019 4:18:27 AM > Sending message: {"temperature":28.317862208149332,"humidity":73.60970909409677}
    11/27/2019 4:18:28 AM > Sending message: {"temperature":25.552859350830715,"humidity":72.7897707153064}
    11/27/2019 4:18:29 AM > Sending message: {"temperature":32.81164186439088,"humidity":72.6606041624493}
    ```

1. Leave the simulated device running while you move on to the next unit.

## Exercise 8: Test Device Connectivity and Offline Support

In this exercise, you will monitor events from the **ChildIoTDevice** are being sent to Azure IoT Hub through the **IoTEdgeGateway** IoT Edge Transparent Gateway. You will then interrupt connectivity between the **IoTEdgeGateway** and Azure IoT Hub to see that telemetry is still sent from the child IoT Device to the IoT Edge Gateway. After this, you will resume connectivity with Azure IoT Hub and monitor that the IoT Edge Gateway resumes sending telemetry to Azure IoT Hub.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Open the Azure Cloud Shell by clicking the **Terminal** icon within the top header bar of the Azure portal, and select the **Bash** shell option.

1. Run the following command within the **Azure Cloud Shell** to start monitoring the Events being received by the Azure IoT Hub:

    ```cmd/sh
    az iot hub monitor-events --hub-name AZ-220-HUB-{Your-ID}
    ```

    Be sure to replace the `{Your-ID}` placeholder with your unique suffix for our Azure IoT Hub instance.

1. The `az iot hub monitor-events` command will start outputting the telemetry from the **ChildDevice1** that is getting sent to Azure IoT Hub.

    Keep in mind that the **ChildDevice1** simulated device application is configured to send telemetry to the **IoTEdgeGateway** IoT Edge Transparent Gateway virtual machine, which then is sending the telemetry on to Azure IoT Hub.

    ```text
    Starting event monitor, use ctrl-c to stop...
    {
        "event": {
            "origin": "ChildDevice1",
            "payload": "{\"temperature\":20.30307372114764,\"humidity\":72.6844747889249}"
        }
    }
    {
        "event": {
            "origin": "ChildDevice1",
            "payload": "{\"temperature\":31.73955729079412,\"humidity\":78.56052768349673}"
        }
    }
    ```

1. The next step to test the **Offline** capabilities is to make the **IoTEdgeGateway** device go offline. Since this is a Virtual Machine running in Azure, this can be simulated by adding an **Outbound rule** to the **Network security group** for the VM.

1. Within the **Azure portal**, navigate to the **AZ-220-IoTEdgeResources** resource group.

1. In the list of resources, to open the **Network Security Group**   for the **AZ220EdgeVM{YOUR-ID}** virtual machine, click **AZ220EdgeVM{YOUR_ID}NSG**.

1. On the **Network security group** blade, click on the **Outbound security rules** link under the **Settings** section.

1. Click the **+Add** button at the top.

1. On the **Add outbound security rule** pane, set the following field values:

    - Destination port ranges: **\***
    - Action: **Deny**
    - Name: **DenyAll**

    A **Destination port range** of "**\***" will apply the rule to all ports.

1. Click **Add**.

1. Go back to the **Azure Cloud Shell**. If the **az iot hub monitor-events` command is still running, end it by pressing **Ctrl + C**.

1. Within the **Azure Cloud Shell** connect to the **IoTEdgeGateway** VM using `ssh` with the following command:

    ```sh
    ssh <username>@<ipaddress>
    ```

    Be sure to replace the placeholders with the required values for the `ssh` command:

    | Placeholder | Value to replace |
    | :--- | :--- |
    | `<username>` | The admin **Username** for the **IoTEdgeGateaway** virtual machine.
    | `<ipaddress>` | The **Public IP Address** for the **IoTEdgeGateway** virtual machine.

    Enter the **Password** for the **IoTEdgeGateway** username when prompted.

1. Once connected to the **IoTEdgeGateway** VM via `ssh`, run the following command to reset the IoT Edge Runtime.

    ```sh
    sudo systemctl restart iotedge
    ```

    This will force the IoT Edge Runtime to disconnect from the Azure IoT Hub service, and then attempt to reconnect.

1. Within the **IoTEdgeGateway**, run the `exit` command to end the `ssh` session.

    ```cmd/sh
    exit
    ```

1. Run the `az iot hub monitor-events` command again within the **Azure Cloud Shell** to start monitoring the Events being received by the Azure IoT Hub:

    ```cmd/sh
    az iot hub monitor-events --hub-name AZ-220-HUB-{Your-ID}
    ```

    Be sure to replace the `{Your-ID}` placeholder with your unique suffix for our Azure IoT Hub instance.

1. Notice there are no longer any events being received by the **Azure IoT Hub**.

1. Go look at the **Terminal** where the **ChildIoTDevice** simulated device application is running, and notice that it's still sending device telemetry to the **IoTEdgeGateway**.

1. At this point the **IoTEdgeGateway** is disconnected from the Azure IoT Hub. It will continue to authenticate connections by the **ChildIoTDevice**, and receiving device telemetry from child device(s). During this time, the IoT Edge Gateway will be storing the event telemetry from the child devices on the IoT Edge Gateway device storage as configured.

1. In the **Azure portal**, navigate back to the **Network security group** blade for the **IoTEdgeGateway**, and click on **Outbound security rules** under the **Settings** section.

1. On the **Outbound security rules** pane, click on the **DenyAll** rule at the top of the list.

1. On the **DenyAll** rule pane, click the **Delete** button to remove this deny rule from the NSG.

1. On the **Delete security rule** prompt, click **Yes**.

1. Once the **IoTEdgeGateway** IoT Edge Transparent Gateway is able to resume connectivity with Azure IoT Hub, it will sync the event telemetry from all connected child devices. This includes the saved telemetry that couldn't be sent while disconnected, and all telemetry still being sent to the gateway.

    > [!NOTE] The IoT Edge Gateway device will take a couple minutes to reconnect to Azure IoT Hub and resume sending telemetry. After waiting a couple minutes, you will see events showing up in the `az iot hub monitor-events` command output again.

In this lab we have demonstrated that an Azure IoT Edge Gateway can utilize local storage to retain messages that can't be sent due to an interruption in the connection to the IoT Hub. Once connection is reestablished, we saw that messages are then sent.

> [!NOTE] Once you have finished with the lab, ensure you exit the device simulation application by pressing **CTRL+C** in the terminal.
