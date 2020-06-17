---
lab:
    title: 'Lab 12: Setup an IoT Edge Gateway'
    module: 'Module 6: Azure IoT Edge Deployment Process'
---

# Setup an IoT Edge Gateway

## Lab Scenario

This lab is theoretical and will walk you through how an IoT Edge device can be used as a gateway.

There are three patterns for using an IoT Edge device as a gateway: transparent, protocol translation, and identity translation:

**Transparent** – Devices that theoretically could connect to IoT Hub can connect to a gateway device instead. The downstream devices have their own IoT Hub identities and are using any of the MQTT, AMQP, or HTTP protocols. The gateway simply passes communications between the devices and IoT Hub. The devices are unaware that they are communicating with the cloud via a gateway, and a user interacting with the devices in IoT Hub is unaware of the intermediate gateway device. Thus, the gateway is transparent. Refer to Create a transparent gateway for specifics on using an IoT Edge device as a transparent gateway.

**Protocol translation** – Also known as an opaque gateway pattern, devices that do not support MQTT, AMQP, or HTTP can use a gateway device to send data to IoT Hub on their behalf. The gateway understands the protocol used by the downstream devices, and is the only device that has an identity in IoT Hub. All information looks like it is coming from one device, the gateway. Downstream devices must embed additional identifying information in their messages if cloud applications want to analyze the data on a per-device basis. Additionally, IoT Hub primitives like twins and methods are only available for the gateway device, not downstream devices.

**Identity translation** - Devices that cannot connect to IoT Hub can connect to a gateway device, instead. The gateway provides IoT Hub identity and protocol translation on behalf of the downstream devices. The gateway is smart enough to understand the protocol used by the downstream devices, provide them identity, and translate IoT Hub primitives. Downstream devices appear in IoT Hub as first-class devices with twins and methods. A user can interact with the devices in IoT Hub and is unaware of the intermediate gateway device.

## In This Lab

In this lab, you will:

* Verify Lab Prerequisites
* Deploy Azure IoT Edge Enabled Linux VM as an IoT Edge Device
* Generate and Configure IoT Edge Device CA Certificates
* Create IoT Edge Device Identity in IoT Hub using Azure Portal
* Setup IoT Edge Gateway Hostname
* Connect IoT Edge Gateway Device to IoT Hub
* Open IoT Edge Gateway Device Ports for Communication
* Create Downstream Device Identity in IoT Hub
* Connect Downstream Device to IoT Edge Gateway
* Verify Event Flow


## Exercise 1: Verify Lab Prerequisites



## Exercise 2: Deploy Azure IoT Edge enabled Linux VM

In this exercise, you will deploy an Ubuntu Server VM with Azure IoT Edge runtime support from the Azure Marketplace.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. In the Azure Portal, click **Create a resource** open the Azure Marketplace.

1. On the **New** blade, in the **Search the Marketplace** box, type in and search for **Azure IoT Edge on Ubuntu**.

1. In the search results, select the **Azure IoT Edge on Ubuntu** item.

1. On the **Azure IoT Edge on Ubuntu** item, click **Create**.

1. On the **Create a virtual machine** blade, select your Azure Subscription and use the **Create new** Resource group option to create a new Resource Group for the VM named `AZ-220-GWVM-RG`.

1. In the **Virtual machine name** box, enter `AZ-220-VM-EDGEGW-{YOUR-ID}` for the name of the Virtual Machine.

1. In the **Region** dropdown, select the Azure Region closest to you, or the region where your Azure IoT Hub is provisioned.

1. Notice the **Image** dropdown has the **Ubuntu Server 16.04 LTS + Azure IoT Edge runtime** image selected.

1. Under **Size**, click **Change size**. In the displayed list of sizes, select **DS1_v2** and click **Select**.

    > [!NOTE] Not all VM sizes are available in all regions. If, in a later step, you are unable to select the VM size, try a different region. For example, if **West US** doesn't have the sizes available, try **West US 2**.

1. Under **Administrator account**, select the **Password** option for **Authentication type**.

1. Enter an Administrator **Username** and **Password** for the VM.

1. Notice the **Inbound port rules** is configured to enable inbound **SSH** access to the VM. This will be used to remote into the VM to configure/manage it.

1. Click **Review + create** to create the IoT Edge on Ubuntu virtual machine.

1. Once validation passes, click **Create** to begin deploying the virtual machine.

    > [!NOTE] Deployment will take approximately 5 minutes to complete. You can continue on to the next unit while it is deploying.

## Exercise 3: Generate and Configure IoT Edge Device CA Certificates

In this exercise, you will generate test certificates using Linux. You will do this on the `AZ-220-VM-EDGEGW-{YOUR-ID}` Virtual Machine using a helper script contained within the `Azure/IoTEdge` GitHub project.

1. Navigate to the `AZ-220-VM-EDGEGW-{YOUR-ID}` IoT Edge virtual machine within the Azure Portal.

1. On the **Overview** pane of the **Virtual machine** blade, click the **Connect** button at the top.

1. Within the **Connect to virtual machine** pane, select the **SSH** option, then copy the **Login using VM local account** value.

    This is a sample SSH command that will be used to connect to the virtual machine that contains the IP Address for the VM and the Administrator username. The command is formatted similar to `ssh username@52.170.205.79`.

1. At the top of the Azure Portal click on the **Cloud Shell** icon to open up the **Azure Cloud Shell** within the Azure Portal. When the pane opens, choose the option for the **Bash** terminal within the Cloud Shell.

1. Within the Cloud Shell, paste in the `ssh` command that was copied, and press **Enter**.

1. When prompted with **Are you sure you want to continue connecting?**, type `yes` and press Enter. This prompt is a security confirmation since the certificate used to secure the connection to the VM is self-signed. The answer to this prompt will be remembered for subsequent connections, and is only prompted on the first connection.

1. When prompted to enter the password, enter the Administrator password that was entered when the VM was provisioned.

1. Once connected, the terminal will change to show the name of the Linux VM, similar to the following. This tells you which VM you are connected to.

    ```cmd/sh
    username@AZ-220-VM-EDGEGW-{YOUR-ID}:~$
    ```

1. The `Azure/IoTEdge` GitHub project contains scripts to generate non-production certificates. These scripts will help you create the necessary scripts to set up a Transparent IoT Edge Gateway. Run the following command:

    ```cmd/sh
    git clone https://github.com/Azure/iotedge.git
    ```

    > [!NOTE] The [Azure/iotedge](https://github.com/Azure/iotedge) open source project is the official open source project for Azure IoT Edge. This project contains source code for the Edge Agent, Edge Hub, and IoT Edge Security Daemon; in addition to the helper script used in this unit.

1. Run the following commands to create a working directory named `~/certificates` that will be used for generating the certificates, then move to that directory:

    ```cmd/sh
    mkdir certificates
    cd certificates
    ```

1. To generate the certificates, the helper scripts need to be copied to the working directory. To do this, run the following commands:

    ```cmd/sh
    cp ../iotedge/tools/CACertificates/*.cnf .
    cp ../iotedge/tools/CACertificates/certGen.sh .
    ```

    These commands will copy just the necessary files for running the helper script for generating test CA certificates. The rest of the source files within the Azure/iotedge repository are not needed for this unit.

1. Within the working directory, run the following command to verify the helper script files have been copied correctly.

    ```cmd/sh
    ls
    ```

    This command should output there are 2 files within the directory. The `certGen.sh` is the helper bash script, and the `openssl_root_ca.cnf` file is the configuration file needed for generating the certificates with the helper script using OpenSSL.

    ```text
    username@AZ-220-VM-EDGEGW:~/certificates$ ls
    certGen.sh  openssl_root_ca.cnf
    ```

    Make note that the directory where you're running the script is located at `~/certificates`. This maps to the `/home/<username>/certificates` directory, where `<username>` is the user your logged into SSH with. You will need to use this directory location later when configuring Azure IoT Edge to use the generated certificates.

1. The `certGen.sh` helper script is run with the `create_root_and_intermediate` parameter to generate the root CA certificate and one intermediate certificate. Run the following command to do this:

    ```cmd/sh
    ./certGen.sh create_root_and_intermediate
    ```

    The script created several certificate and key files. Make note of the following **root CA certificate** file that will be referred to later:

    ```text
    # Root CA certificate
    ~/certificates/certs/azure-iot-test-only.root.ca.cert.pem
    ```

1. Now that the root CA has been generated, the IoT Edge device CA certificate and private key need to be generated. Run the following command to generate the IoT Edge device CA certificate, and uses `MyEdgeDeviceCA` as the name for the CA certificate that is generated.

    ```cmd/sh
    ./certGen.sh create_edge_device_ca_certificate "MyEdgeDeviceCA"
    ```

    The generated certificates are created with the name specified to this command. If a name other than `MyEdgeDeviceCA` is used, then the generated certificates will reflect that name.

    This script created several certificate and key files. Make note of the following files that will be referred to later:

    ```text
    # Device CA certificate
    ~/certificates/certs/iot-edge-device-ca-MyEdgeDeviceCA-full-chain.cert.pem
    # Device CA private key
    ~/certificates/private/iot-edge-device-ca-MyEdgeDeviceCA.key.pem
    ```

    > [!NOTE] Now that the IoT Edge Device CA certificate has been generated, do not re-run the previous command that generates the root CA certificate. Doing so will overwrite the existing certificate with a new one that will no longer match the `MyEdgeDeviceCA` IoT Edge Device CA certificate that was just generated.

1. To confirm that the Azure IoT Edge Runtime is installed on the VM, run the following command:

    ```cmd/sh
    iotedge version
    ```

    This command will output the version of the Azure IoT Edge Runtime that is currently installed on the virtual machine.

    The version output will be similar to the following:

    ```sh
    username@AZ-220-VM-EDGEGW:~/certificates$ iotedge version
    iotedge 1.0.8 (208b2204fd30e856d00b280112422130c104b9f0)
    ```

1. To configure Azure IoT Edge, the `/etc/iotedge/config.yaml` configuration file needs to be modified to contain the full path to the certificate and key files on the IoT Edge Device. Before the file can be edited, you must be sure the `config.yaml` file is not read-only. Run the following command to set the file to be writable:

    ```cmd/sh
    sudo chmod a+w /etc/iotedge/config.yaml
    ```

1. Run the following command to open the `config.yaml` file within the vi/vim editor:

    ```cmd/sh
    sudo vi /etc/iotedge/config.yaml
    ```

1. Locate the **Certificate settings** section within the file, remove the leading `#` character before the certificate properties to uncomment those lines, then edit the certificate settings to contain the correct certificate and key paths. After changes are made, save the file and exit the editor.

    After the x.509 certificate settings changes made to the `config.yaml` file, this section of the file will look like the following:

    ```yaml
        certificates:
          device_ca_cert: "/home/<username>/certificates/certs/iot-edge-device-ca-MyEdgeDeviceCA-full-chain.cert.pem"
          device_ca_pk: "/home/<username>/certificates/private/iot-edge-device-ca-MyEdgeDeviceCA.key.pem"
          trusted_ca_certs: "/home/<username>/certificates/certs/azure-iot-test-only.root.ca.cert.pem"
    ```

    Be sure to replace the `<username>` placeholder within the file locations with the **Username** of the user your connected to SSH with.

    The x.509 certificates configured in this section are used for the following purposes:

    | Setting | Purpose |
    | :--- | :--- |
    | `device_ca_cert` | This is the Device CA Certificate for the IoT Edge Device. |
    | `device_ca_pk` | This is the Device CA Private Key for the IoT Edge Device. |
    | `trusted_ca_certs` | This is the Root CA Certificate. This certificate must contain all the trusted CA certificates required for Edge module communications.|

    > [!NOTE] Here are some tips for using **vi** when editing the `config.yaml` file:
    > - Press the `i` key to put the editor into Insert mode, then you will be able to make changes.
    > - Press `Esc` to go stop Insert mode and return to Normal mode.
    > - To Save and Quit, type `:x`, and press `Enter`.
    > - Save the file, type `:w`, and press `Enter`.
    > - To quit vi, type `:quit` and press `Enter`.

1. The `MyEdgeDeviceCA` certificate needs to be downloaded from the `AZ-220-VM-EDGEGW` virtual machine so it can be used to configure the IoT Edge device enrollment within Azure IoT Hub Device Provisioning Service. Type `exit` in the **Azure Cloud Shell** to end the SSH session.

    ```sh
    exit
    ```

1. Within the **Cloud Shell** run the following commands to download the `~/certificates` directory and its contents from the **AZ-220-VM-EDGEGW** virtual machine to the **Cloud Shell** storage:

    ```cmd/sh
    mkdir certificates
    scp -r -p <username>@<ipaddress>:~/certificates .
    ```

    Replace the `<username>` placeholder with the username of the admin user for the VM, and replace the `<ipaddress>` placeholder with the IP Address fo the VM.

    When executing the command, enter the Admin password for the VM when prompted.

1. Once the command has executed, it will have downloaded a copy of the `~/certificates` directory with the certificate and key files over SSH to the Cloud Shell storage. You can verify the file has been downloaded by running the `ls` command within the `~/certificates` directory to view its contents.

    ```cmd/sh
    chris@Azure:~$ cd certificates
    chris@Azure:~/certificates$ ls
    certGen.sh  csr        index.txt.attr      index.txt.old  openssl_root_ca.cnf  serial
    certs       index.txt  index.txt.attr.old  newcerts       private              serial.old
    ```

    Once the files are copied to the **Azure Cloud Shell** storage, from the **AZ-220-VM-EDGEGW** virtual machine, you will be able to easily download any of the IoT Edge Device certificate and key files to your local machine as necessary. Files can be downloaded from the Azure Cloud Shell using the `download <filename>` command.

## Exercise 4: Create IoT Edge Device Identity in IoT Hub using Azure Portal

In this exercise, you will create a new IoT Edge Device identity in Azure IoT Hub for the IoT Edge Transparent Gateway.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On your Resource group tile, click **AZ-220-HUB-{YOUR-ID}** to navigate to the Azure IoT Hub.

1. On the IoT Hub summary blade, click **IoT Edge** under the Automatic Device Management section. This section of the IoT Hub blade allows you to manage the IoT Edge devices connected to the IoT Hub.

1. Click the **Add an IoT Edge device** button to begin adding a new IoT Edge Device to the IoT Hub.

1. On the **Create a device** blade, enter `AZ-220-VM-EDGEGW-{YOUR-ID}` into the **Device ID** field. This is the device identity used for authentication and access control.

1. Select **Symmetric key** for the **Authentication type**, and leave the **Auto-generate keys** box checked. This will have IoT Hub automatically generate the Symmetric keys for authenticating the device.

1. Click **Save**.

1. Once the IoT Edge Device is added, click on the **Device ID** in the list of IoT Edge devices.

1. On the IoT Edge Device summary blade, copy the **Primary Connection String** and save it for later.

1. Notice the list of **Modules** configured for the IoT Edge Device contains the **\$edgeAgent** and **\$edgeHub** modules.

    The IoT Edge Agent (`$edgeAgent`) and IoT Edge Hub (`$edgeHub`) modules are a part of the IoT Edge Runtime. The Edge Hub is responsible for communication, and the Edge Agent deploys and monitors the modules on the device.

1. Click the **Set Modules** button at the top of the IoT Edge Device summary blade. This is used to add additional modules to the IoT Edge Device. At this time, you'll use this to ensure the message routing is configured correctly for the IoT Edge Gateway device.

1. Leave all fields as they are in the **Modules** step, and click **Next: Routes >**.

1. Within the **Specify Routes**, the editor will display the configured default route for the IoT Edge Device. At this time, it should be configured with a route that sends all messages from all modules to Azure IoT Hub. If the route configuration doesn't match this, then update it to match the following route:

    - Name: **route**
    - Value: `FROM /* INTO $upstream`

    The `FROM /*` part of the message route will match all device-to-cloud messages or twin change notifications from any module or leaf device. Then, the `INTO $upstream` tells the route to send those messages to the Azure IoT Hub.

    > [!NOTE] To learn more about configuring message routing within Azure IoT Edge, reference the [Learn how to deploy modules and establish routes in IoT Edge](https://docs.microsoft.com/azure/iot-edge/module-composition#declare-routes#declare-routes) documentation article.

1. Click the **Next: Review + create >** button.

1. On the **Review + create** step, click the **Create** button.

## Exercise 5: Setup IoT Edge Gateway Hostname

In this exercise, you will configure the DNS name for Public IP Address of the **AZ-220-VM-EDGEGW-{YOUR-ID}**, and configure that DNS name as the `hostname` of the IoT Edge Gateway device.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Navigate to the `AZ-220-VM-EDGEGW-{YOUR-ID}` IoT Edge virtual machine within the Azure Portal.

1. On the **Overview** pane of the **Virtual machine** blade, click the **Configure** link next to **DNS name**.

1. On the **Public IP Address** Configuration blade for the AZ-220-VM-EDGEGW-{YOUR-ID} virtual machine, enter `az-220-vm-edgegw-{your-id}` into the **DNS name label** field (the label must be globally unique, and only lowercase letters, numbers and hyphens).

1. Click **Save**.

1. Note the full DNS name for the Public IP Address of the **AZ-220-VM-EDGEGW-{YOUR-ID}** virtual machine, and save it for reference later.

    The full DNS name is comprised of the `AZ-220-VM-EDGEGW-{YOUR-ID}` value suffixed by the text below the **DNS name label** field.

    For example, the full DNS name will be:

    ```text
    az-220-vm-edgegw-cah123019.eastus.cloudapp.azure.com
    ```

    All Public IP Address DNS names will be at the **.cloudapp.azure.com** domain name. This example is for the VM being hosted in the **eastus** Azure region. This part fo the DNS name will vary depending on what Azure region the VM is hosted within.

    Setting the DNS name for the Public IP Address of the **AZ-220-VM-EDGEGW** will give it a FQDN (Fully Qualified Domain Name) for the downstream device(s) to use as the **GatewayHostName** to connect to it. Since the VM, in this case, is accessible across the Internet an Internet DNS name is needed. If the Azure IoT Edge Gateway were hosted in a Private or Hybrid network, then the machine name would meet the requirements of a **GatewayHostName** for on-premises downstream devices to connect.

1. Navigate to the **AZ-220-VM-EDGEGW** IoT Edge virtual machine within the Azure Portal.

1. On the **Overview** pane of the **Virtual machine** blade, click the **Connect** button at the top.

1. Within the **Connect to virtual machine** pane, select the **SSH** option, then copy the **Login using VM local account** value.

    This is a sample SSH command that will be used to connect to the virtual machine that contains the IP Address for the VM and the Administrator username. Now that the DNS name label has been configured, the command is formatted similar to `ssh demouser@AZ-220-VM-EDGEGW.eastus.cloudapp.azure.com`.

    > [!NOTE] If a "_Host key verification failed_" messages displays, then use the VM's **IP Address** with the `ssh` command to connect tot he virtual machine.

1. At the top of the Azure Portal click on the **Cloud Shell** icon to open up the **Azure Cloud Shell** within the Azure Portal. When the pane opens, choose the option for the **Bash** terminal within the Cloud Shell.

1. Within the Cloud Shell, paste in the `ssh` command that was copied, and press **Enter**.

1. When prompted to enter the password, enter the Administrator password that was entered when the VM was provisioned.

1. Run the following command to open the `config.yaml` file within the vi/vim editor:

    ```cmd/sh
    sudo vi /etc/iotedge/config.yaml
    ```

1. Locate the **Edge device hostname** section within the file. Update the **hostname** value to be set to the **DNS name** set previously for the Public IP Address of the **AZ-220-VM-EDGEGW-{YOUR-ID}** virtual machine.

    The resulting value will look similar to the following:

    ```yaml
    hostname: "az-220-vm-edgegw-{your-id}.eastus.cloudapp.azure.com"
    ```

    The `hostname` setting configures the Edge Hub server hostname. Regardless of the case used for this setting, a lowercase value is used to configure the Edge Hub server. This is also the hostname that downstream IoT devices will need to use when connecting to the IoT Edge Gateway for the encrypted communication to work properly.

    > [!NOTE] Here are some tips for using **vi** when editing the `config.yaml` file:
    > - Press `Esc` and enter `/` followed by a search string, then press enter to search
    >   - Pressing `n` will cycle through matches.
    > - Press the `i` key to put the editor into Insert mode, then you will be able to make changes.
    > - Press `Esc` to go stop Insert mode and return to Normal mode.
    > - To Save and Quit, type `:x`, and press `Enter`.
    > - Save the file, type `:w`, and press `Enter`.
    > - To quit vi, type `:quit` and press `Enter`.

1. Save the file and exit vi/vim.

## Exercise 6: Connect IoT Edge Gateway Device to IoT Hub

In this exercise, you will connect the IoT Edge Device to Azure IoT Hub.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Navigate to the `AZ-220-VM-EDGEGW-{YOUR-ID}` IoT Edge virtual machine within the Azure Portal.

1. On the **Overview** pane of the **Virtual machine** blade, click the **Connect** button at the top.

1. Within the **Connect to virtual machine** pane, select the **SSH** option, then copy the **Login using VM local account** value.

    This is a sample SSH command that will be used to connect to the virtual machine that contains the IP Address for the VM and the Administrator username. The command is formatted similar to `ssh demouser@52.170.205.79`.

1. At the top of the Azure Portal click on the **Cloud Shell** icon to open up the **Azure Cloud Shell** within the Azure Portal. When the pane opens, choose the option for the **Bash** terminal within the Cloud Shell.

1. Within the Cloud Shell, paste in the `ssh` command that was copied, and press **Enter**.

1. When prompted with **Are you sure you want to continue connecting?**, type `yes` and press Enter. This prompt is a security confirmation since the certificate used to secure the connection to the VM is self-signed. The answer to this prompt will be remembered for subsequent connections, and is only prompted on the first connection.

1. When prompted to enter the password, enter the Administrator password that was entered when the VM was provisioned.

1. Once connected, the terminal will change to show the name of the Linux VM, similar to the following. This tells you which VM you are connected to.

    ```cmd/sh
    demouser@AZ-220-VM-EDGEGW-{YOUR-ID}:~$
    ```

1. You will need to run the command to configure the Edge device to connect to IoT Hub as Administrator. Run the following `sudo` command to elevate the terminal to run as Administrator:

    ```cmd/sh
    sudo su -
    ```

1. The `/etc/iotedge/configedge.sh` script is used to configure the Edge device with the Connection String necessary to connect it to Azure IoT Hub. This script is installed as part of the Azure IoT Edge Runtime.

1. To configure the Edge device with the Connection String for Azure IoT Hub, run the following command:

    ```cmd/sh
    /etc/iotedge/configedge.sh "{iot-edge-device-connection-string}"
    ```

    Be sure to replace the `{iot-edge-device-connection-string}` placeholder with the Connection String you copied previously for your IoT Edge Device.

1. Once this command completes, the IoT Edge Device will be configured to connect to Azure IoT Hub using the Connection String that was entered.

1. After a moment, run the following command that will list out all the **IoT Edge Modules** currently running on the IoT Edge Device.

    ```sh
    iotedge list
    ```

    After a moment, this command will show the `edgeAgent` and `edgeHub` modules are running. The output will look similar to the following:

    ```text
    root@AZ-220-VM-EDGEGW:~# iotedge list
    NAME             STATUS           DESCRIPTION      CONFIG
    edgeHub          running          Up 15 seconds    mcr.microsoft.com/azureiotedge-hub:1.0
    edgeAgent        running          Up 18 seconds    mcr.microsoft.com/azureiotedge-agent:1.0
    ```

    If an error is reported, then you'll need to double check the configurations are set correctly. For troubleshooting, the `iotedge check --verbose` command can be run to see if there are any errors.

## Exercise 7: Open IoT Edge Gateway Device Ports for Communication

In this exercise, you will configure the Network Security Group (NSG) that secures access to the Azure IoT Edge Gateway from the Internet. The necessary ports for MQTT, AMQP, and HTTPS communications need to be opened so the downstream IoT device(s) can communicate with the gateway.

For the Azure IoT Edge Gateway to function, at least one of the IoT Edge hub's supported protocols must be open for inbound traffic from downstream devices. The supported protocols are MQTT, AMQP, and HTTPS.

The IoT communication protocols supported by Azure IoT Edge have the following port mappings:

| Protocol | Port Number |
| --- | --- |
| MQTT | 8883 |
| AMQP | 5671 |
| HTTPS<br/>MQTT + WS (Websocket)<br/>AMQP + WS (Websocket) | 443 |

The IoT communication protocol chosen for your devices will need to have the corresponding port opened for the firewall that secures the IoT Edge Gateway device. In the case of this lab, an Azure Network Security Group (NSG) is used to secure the IoT Edge Gateway, so Inbound security rules for the NSG will be opened on these ports.

In a production scenario, you will only want to open the minimum number of ports for your devices to communicate. If you are using MQTT, then only open port 8883 for inbound communications. Opening additional ports will introduce addition security attack vectors that attackers could take exploit. It is a security best practice to only open the minimum number of ports necessary for your solution.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Navigate to the Resource Group that contains the  **AZ-220-VM-EDGEGW-{YOUR-ID}** VM.

1. On the Resource Group blade, click on the **AZ-220-VM-EDGEGW-{YOUR-ID}-nsg** Network Security Group (NSG) resource.

1. On the Network security group blade, click on **Inbound security rules** under the Settings section.

1. On the **Inbound security rules** pane, click the **Add** button.

1. On the **Add inbound security rule** pane, change the **Destination port ranges** to `8883` and set the **Name** to `MQTT`. This will define an inbound security rule that will allow communication for the MQTT protocol to the IoT Edge Gateway.

1. Click **Add** to save the new security rule.

1. To open ports for **AMQP** and **HTTPS** communication protocols, add two more rules with the following values:

    | Destination port ranges | Name |
    | :--- | :--- |
    | 5671 | AMQP |
    | 443 | HTTPS |

1. With these three ports open on the Network Security Group (NSG), the downstream devices will be able to connect to the IoT Edge Gateway using either MQTT, AMQP, or HTTPS protocols.

## Exercise 8: Create Downstream Device Identity in IoT Hub

In this exercise, you will create a new IoT Device identity in Azure IoT Hub for the downstream IoT device. This device identity will be configured so that the Azure IoT Edge Gateway is a parent device for this downstream device.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On your Resource group tile, click **AZ-220-HUB-{YOUR-ID}** to navigate to the Azure IoT Hub.

1. On the IoT Hub summary blade, click **IoT devices** under the Explorers section. This section of the IoT Hub blade allows you to manage the IoT Devices connected to the IoT Hub.

1. Click the **New** button to begin adding a new IoT Device Identity to the IoT Hub.

1. On the **Create a device** blade, enter `DownstreamDevice1` into the **Device ID** field. This is the device identity used for authentication and access control.

1. Select **Symmetric key** for the **Authentication type**, and leave the **Auto-generate keys** box checked. This will have IoT Hub automatically generate the Symmetric keys for authenticating the device.

1. Under **Parent device** click the **Set a parent device** link to begin configuring this downstream device to communicate with IoT Hub through the IoT Edge Gateway.

1. On the **Set an Edge device as a parent device** blade, select the `AZ-220-VM-EDGEGW-{YOUR-ID}` Device ID in the list of IoT Edge Devices.

1. Click **OK** to select the parent device.

1. Click **Save** to create the IoT Device identity for the downstream device.

1. Once the `DownstreamDevice1` IoT Device Identity is created, click on the Device ID in the list. This will open the details view for this device.

1. On the IoT Device summary pane, copy the **Primary Connection String** for the `DownstreamDevice1` IoT Device, and save it for reference later.

## Exercise 9: Connect Downstream Device to IoT Edge Gateway

In this exercise, you will configure a pre-built Downstream Device to connect to the IoT Edge Gateway.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. At the top of the Azure Portal click on the **Cloud Shell** icon to open up the **Azure Cloud Shell** within the Azure Portal. When the pane opens, choose the option for the **Bash** terminal within the Cloud Shell.

1. Within the **Cloud Shell**, run the following command to download the **root CA** x.509 certificate for the Azure IoT Edge Gateway (`AZ-220-VM-EDGEGW-{YOUR-ID}`) virtual machine.

    ```cmd/sh
    download certificates/certs/azure-iot-test-only.root.ca.cert.pem
    ```

    The Azure IoT Edge Gateway was configured (within the `/etc/iotedge/config.yaml` file) previously to use this **root CA** x.509 certificate for encrypting communications with any downstream devices connecting to the gateway. This x.509 certificate will need to be copied to the downstream devices so they can use it to encrypt communications with the gateway.

1. Copy the `azure-iot-test-only.root.ca.cert.pem` x.509 certificate file to the `/LabFiles/DownstreamDevice` directory where the source code for the downstream IoT device is located.

1. Open the `/LabFiles/DownstreamDevice` directory within **Visual studio Code**.

1. Open the **SimulatedDevice.cs** source code file.

1. Locate the declaration for the `s_connectionString` variable and replace the value placeholder with the **IoT Hub Connection String** for the **DownstreamDevice1** IoT Device.

1. Modify the **IoT Hub Connection String** to include the `GatewayHostName` property with the value set to the full **DNS name** for the IoT Edge Gateway Device (`AZ-220-VM-EDGEGW`).

    The Connection String will match the following format:

    ```text
    HostName=<IoT-Hub-Name>.azure-devices.net;DeviceId=DownstreamDevice1;SharedAccessKey=<IoT-Device-Primary-Key>;GatewayHostName=<IoT-Edge-Device-DNS-Name>
    ```

    Be sure to replace the placeholders with the appropriate values:

    - `<IoT-Hub-Name>`: The Name of the Azure IoT Hub.
    - `<IoT-Device-Primary-Key>`: The Primary Key for the **DownstreamDevice1** IoT Device in Azure IoT Hub.
    - `<IoT-Edge-DNS-Name>`: The DNS name set for the **AZ-220-VM-EDGEGW**.

    The `s_connectionString` variable with the Connection String value will look similar to the following:

    ```csharp
    private readonly static string s_connectionString = "HostName=AZ-220-HUB-1119.azure-devices.net;DeviceId=DownstreamDevice1;SharedAccessKey=ygNT/WqWs2d8AbVD9NAlxcoSS2rr628fI7YLPzmBdgE=;GatewayHostName=AZ-220-VM-EDGEGW.eastus.cloudapp.azure.com";
    ```

1. Save the file.

1. Locate the **Main** method. This method contains the code that instantiates the `DeviceClient` using the configured Connection String, and specifies **MQTT** as the transport protocol to use for communicating with the Azure IoT Edge Gateway.

    ```csharps_deviceClient = DeviceClient.CreateFromConnectionString(s_connectionString, TransportType.Mqtt);
    SendDeviceToCloudMessagesAsync();
    ```

    This method also executes the **InstallCACert** method which has some code to automatically install the **root CA** x.509 certiifcate to the local machine. And it executes the **SendDeviceToCloudMessagesAsync** method that sends event telemetry from the simulated device.

1. Locate the **SendDeviceToCloudMessagesAsync** method. This method contains the code that generates the simulated device telemetry, and sends the events to the IoT Edge Gateway.

1. Locate the **InstallCACert** and browse the code that installed the **root CA** x.509 certificate to the local machine certificate store.

1. Open a command-prompt / terminal and navigate to the location of the `/LabFiles/DownstreamDevice` directory.

1. Run the following command to build the code for the **DownstreamDevice1** simulated device, and execute it to start sending device telemetry:

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

## Exercise 10: Verify Event Flow

In this exercise, you will use the Azure CLI to monitor the events being sent to Azure IoT Hub from the downstream IoT Device through the IoT Edge Gateway. This will validate that everything is working correctly.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. At the top of the Azure Portal click on the **Cloud Shell** icon to open up the **Azure Cloud Shell** within the Azure Portal. When the pane opens, choose the option for the **Bash** terminal within the Cloud Shell.

1. Within the **Cloud Shell**, run the following command to monitor the stream of events flowing to the Azure IoT Hub. This will verify that events from the simulate device, being sent to the IoT Edge Gateway, are being received by the Azure IoT Hub.

    ```cmd/sh
    az iot hub monitor-events -n <IoT-Hub-Name>
    ```

    Be sure to replace the `<IoT-Hub-Name>` placeholder for the `-n` parameter with the name of your Azure IoT Hub.

    The `az iot hub monitor-events` command enables you to monitor device telemetry & messages sent to an Azure IoT Hub.

1. With everything working correctly, the output from the `az iot hub monitor-events` command will look similar to the following:

    ```cmd/sh
    chris@Azure:~$ az iot hub monitor-events -n AZ-220-HUB-1119
    Starting event monitor, use ctrl-c to stop...
    {
        "event": {
            "origin": "DownstreamDevice1",
            "payload": "{\"temperature\":30.931512529929872,\"humidity\":78.70672198883571}"
        }
    }
    {
        "event": {
            "origin": "DownstreamDevice1",
            "payload": "{\"temperature\":30.699204018199445,\"humidity\":78.04910910224966}"
        }
    }
    ```

Once you have completed this lab and verified the event flow, exit the console application by pressing **CTRL+C**.



