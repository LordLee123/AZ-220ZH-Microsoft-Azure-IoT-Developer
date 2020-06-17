---
lab:
    title: 'Lab 19: Detect if your IoT Device was Tampered with Azure Security Center for IoT'
    module: 'Module 10: Azure Security Center and IoT Security'
---

# Detect if your IoT Device was Tampered with Azure Security Center for IoT

## Lab Scenario

Contoso has built all their solutions with security in mind. However, they want to see how they can better get a unified view of security across all of their on-premises and cloud workloads, including their Azure IoT solutions. Plus, when onboarding new devices, we want to apply security policies across workloads (Leaf devices, Microsoft Edge devices, IoT Hub) to ensure compliance with security standards and improved security posture.

Contoso is adding a brand new assembly line outfitted with new IoT devices to help with the increasing shipping and packing demands for new orders. You want to ensure that any new devices are secured and also want to be able to see security recommendations to continue improving your solution's security in your full end-to-end IoT solution. You will start investigating using Azure IoT Center for IoT for your solution.

## In This Lab

We will be enabling the Azure Security Center for IoT to be able to see securely in our end to end IoT solutions. Tasks include:

* Verify Lab Prerequisites
* Creating new IoT Hub
* Enabling Azure Security Center for IoT
* Create and Registering new Device
* Create a Security Module Twin
* Install C#-based Security Agent on a Linux Device
* Configure Solution

## Exercise 1: Verify Lab Prerequisites



## Exercise 2: Create an IoT Hub using the Azure portal

In this task, you will use the Azure portal to create an IoT Hub resource.

1. Login to [portal.azure.com](https://portal.azure.com) using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Notice that the AZ-220 dashboard that you created in the previous task has been loaded.

    You will be adding resources to your dashboard as the course continues.

1. On the portal menu, click **+ Create a resource**.

    The Azure Marketplace is a collection of all the resources you can create in Azure. The marketplace contains resources from both Microsoft and the community.

1. In the Search textbox, type **IoT Hub** and then press Enter.

1. On the search results blade, click **IoT Hub**.

    Notice the "USEFUL LINKS" displayed on this blade.

1. In the list of links, click **Documentation**.

    The IoT Hub Documentation page is the root page for IoT Hub resources and documentation. You can use this page to explore current documentation and find tutorials and other resources that will help you to explore activities that are outside the scope of this course. We will refer you to the docs.microsoft.com site throughout this course for additional reading on specific topics.

1. Use your browser to navigate back to the Azure portal tab.

1. To begin the process of creating your new IoT Hub, click **Create**.

    Next, you need to specify information about the Hub and your subscription. The following steps walk you through the settings, explaining each of the fields as you fill them in.

1. On the IoT hub blade, on the Basics tab, ensure that the Azure subscription that you intend to use for this course is selected.

1. To the right of Resource Group, open the **Select existing** dropdown, and then click **AZ-220-RG**

    This is the resource group that you created in the previous lab. We will be grouping the resources that we create for this course together in the same resource group. This should help you to clean up your resources when you have completed the course.

1. To the right of Region, open the drop-down list and select the geographic location that is closest to you and also supports Event Grid.

    As we saw previously, Azure is supported by a series of datacenters that are placed in regions all around the world. When you create something in Azure, you deploy it to one of these datacenter locations.

    > [!NOTE] For the current list of Regions that support Event Grid, see the following link: [Products available by region](https://azure.microsoft.com/en-us/global-infrastructure/services/?products=event-grid&regions=all)

    > [!NOTE] When picking a datacenter to host your app, keep in mind that picking a datacenter close to your end users will decrease load/response times. If you are on the other side of the world from your end users, you should not be picking the datacenter nearest you.

1. To the right of IoT Hub Name, enter a globally unique name for your IoT Hub.

    To provide a globally unique name, enter **AZ-220-HUB-{YOUR-ID}** (remember to replace **{YOUR-ID}** with the unique ID you created in Lab 1.).

    For example: **AZ-220-HUB-CAH102119**

    The name of your IoT hub must be globally unique because it is a publicly accessible resource that you must be able to access from any IP connected device.

    Consider the following when you specify a unique name for your new IoT Hub:

    * The value that you apply to _IoT Hub Name_ must be unique across all of Azure. This is true because the value assigned to the name will be used in the IoT Hub's connection string. Since Azure enables you to connect devices from anywhere in the world to your hub, it makes sense that all Azure hubs must be accessible from the Internet using the connection string and that connection strings must therefore be unique. We'll explore connection strings later in this lab.

    * The value that you assign to _IoT Hub Name_ cannot be changed once the app service has been created. If you do need to change the name, you'll need to create a new IoT Hub, re-register your devices to it, and delete your old IoT Hub.

    * The _IoT Hub Name_ field is a required field.

    > [!NOTE] Azure will ensure that the name you enter is unique. If the name that you enter is not unique, Azure will display an asterisk at the end of the name field as a warning. You can append the name suggested above with '**-01**' or '**-02**' as necessary to achieve a globally unique name.

1. At the top of the blade, click **Size and scale**.

    Take a minute to review the information presented on this blade.

1. To the right of Pricing and scale tier, open the dropdown and then select **S1: Standard tier**.

    You can choose from several tier options depending on how many features you want and how many messages you send through your solution per day. The free tier is intended for testing and evaluation. It allows 500 devices to be connected to the IoT hub and up to 8,000 messages per day. Each Azure subscription can create one IoT Hub in the free tier.

    The **S1** tier that we are using in this course allows a total of 400,000 messages per unit per day and provides the all of the services that are required in this training. We won't actually need 400,000 messages per unit per day, but we will be using features provided at this tier level, such as Cloud-to-device commands, Device management, and IoT Edge. IoT Hub also offers a free tier that is meant for testing and evaluation. It has all the capabilities of the standard tier, but limited messaging allowances. However, you cannot upgrade from the free tier to either basic or standard.

    > [!NOTE] The "S1 - Standard" tier has a cost of $25.00 USD per month per unit. We will be specifying 1 unit.

    For details about the other tier options, see [Choosing the right IoT Hub tier for your solution](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-scaling)).

1. To the right of Number of S1 IoT Hub units, ensure that 1 is selected.

    As mentioned above, the pricing tier that you choose establishes the number of messages that your hub can process per unit per day. To increase the number of messages that you hub can process without moving to a higher pricing tier, you can increase the number of units. For example, if you want the IoT hub to support ingress of 700,000 messages, you choose *two* S1 tier units. For the IoT courses created by Microsoft we will be using just 1 unit.

1. Under Advanced Settings, ensure that Device-to-cloud partitions is set to 4.

    The number of partitions relates the device-to-cloud messages to the number of simultaneous readers of these messages. Most IoT hubs will only need four partitions, which is the default value. For this course we will create our IoT Hub using the default number of partitions.

1. At the top of the blade, click **Review + create**.

1. At the bottom of the blade, to finalize the creation of your IoT Hub, click **Create**.

    Deployment can take a minute or more to complete. You can open the Azure portal Notification pane to monitor progress.

1. Notice that after a couple of minutes you receive a notification stating that your IoT Hub was successfully deployed to your **AZ-220-RG** resource group.

1. On the portal menu, click **Dashboard**, and then click **Refresh**.

    You should see that your Resource group tile lists your new IoT Hub.

## Exercise 3: Enable Azure Security Center for IoT Hub

The Azure Security Center for IoT Hub unifies security management and enables end-to-end threat detection and analysis across hybrid cloud workloads and your Azure IoT solution.

## Enable Azure Security Center for IoT Hub

You will enable the **Azure Security Center for IoT Hub**. 

1. On the Azure portal menu, click Dashboard and open your IoT Hub - **AZ-220-HUB-{YOUR-ID}**.

   You can also use the portal search bar by entering your IoT Hub name and then select your IoT Hub resource once it is listed.

1. Under **Security** menu on the left side, to onboard Azure Security Center for IoT Hub, click on any of the Security blades, such as **Overview**, and click **Secure your IoT solution**.

## Log Analytics creation

When Azure Security Center for IoT is turned on, a default Azure Log Analytics workspace is created to store raw security events, alerts, and recommendations for your IoT devices, IoT Edge, and IoT Hub.

To change the workspace configuration of Log Analytics:

1. Open your IoT Hub and then select **Overview** from the Security menu.

1. Choose the **Settings** screen and notice the workspace  configuration of Log Analytics settings. They are already setup for your when you enabled Azure Security Center for IoT.

By default, turning on the Azure Security Center for IoT solution automatically secures all IoT Hubs under your Azure subscription.

## Exercise 4: Create and Register a New Device

## Create a new IoT Device

You are going to now create a new IoT device that will later be used to measure vibrations on a new conveyor belt. For this lab, you will be using a VM to act like an IoT device.

1. Login to [portal.azure.com](https://portal.azure.com) using your Azure account credentials.

1. On the portal menu, click **+ Create a resource**, then Search the Marketplace for **Ubuntu Server 18.04 LTS**

1. In the search results, select the **Ubuntu Server 18.04 LTS** item.

1. On the **Ubuntu Server 18.04 LTS** item, click **Create**.

1. On the **Create a virtual machine** blade, select your Azure Subscription and use the **Create new** Resource group option to create a new Resource Group for the VM named **vm-device01**.

1. In the **Virtual machine name** box, enter **vm-device01** for the name of the Virtual Machine.

1. In the **Region** dropdown, select the Azure Region closest to you, or the region where your Azure IoT Hub is provisioned.

1. Notice the **Image** dropdown has the **Ubuntu Server 18.04 LTS** image selected.

1. Under **Administrator account**, select the **Password** option for **Authentication type**.

1. Enter an Administrator **Username** and **Password** for the VM.

1. Notice the **Inbound port rules** is configured to enable inbound **SSH** access to the VM. This will be used to remote into the VM to configure/manage it.

1. Click **Review + create**.

1. Once validation passes, click **Create** to begin deploying the virtual machine.

    > [!NOTE] Deployment will take approximately 5 minutes to complete. You can continue on to the next unit while it is deploying.

## Register New Devices

A device must be registered with your IoT hub before it can connect.

1. On the Azure portal menu, click Dashboard and open your IoT Hub. You can also in the portal search bar type in your IoT Hub name and select your IoT Hub resource once it pops up.

1. Select and open IoT Edge under Automatic Device Management from the left menu.

1. Open your IoT Hub in Azure portal.

1. Select and open **IoT devices** under **Explorers** from the left menu.

1. On the top of IoT devices blade, Click  **+ New**

1. Type in **vm-device01** under **Device ID**. Leave the other defaults.

    > [!NOTE] To make following this lab easier,you can set **Device ID** to **vm-device01**.

1. Click **Save**.

## Exercise 5: Create a Security Module Twin

Azure Security Center for IoT offers full integration with your existing IoT device management platform, enabling you to manage your device security status as well as make use of existing device control capabilities. Azure Security Center for IoT integration is achieved by making use of the IoT Hub twin mechanism.

Azure Security Center for IoT makes use of the module twin mechanism and maintains a security module twin named azureiotsecurity for each of your devices.

The security module twin holds all the information relevant to device security for each of your devices.

To make full use of Azure Security Center for IoT features, you'll need to create, configure and use these security module twins for your new IoT Edge device.

The security module twin **azureiotsecurity** can be created in two ways:

* [Module batch script](https://github.com/Azure/Azure-IoT-Security/tree/master/security_module_twin) - automatically creates module twin for new devices or devices without a module twin using the default configuration.
* Manually editing each module twin individually with specific configurations for each device.

In this task, you will be creating a security module twin manually.

1. Navigate to your new IoT device if you are not there already.

    1. On the Azure portal menu, click Dashboard and open your IoT Hub. You can also in the portal search bar type in your IoT Hub name and select your IoT Hub resource once it pops up.

    1. In your IoT Hub, locate **IoT devices** under **Explorers**.

1. Click on **vm-device01**.

1. Click on **+ Add Module Identity**.

1. In the Module Identity Name field, enter **azureiotsecurity**. Leave all over fields the same and click **Save**. You should now see **azureiotsecurity** under **Module Identities** for your device.

    > [!NOTE] The Module Identity must be called **azureiotsecurity** and not another unique name.

1. While you are viewing the **vm-device01** information, copy the device's **Primary Key** to use later.

    > [!NOTE] Make sure to copy the device's **Primary Key** and not the connection string.

1. Navigate back to your IoT Hub, click on **Overview**.  Copy your IoT Hub hostname.

    > [!NOTE] Example of what an IoT Hub hostname looks like: AZ-220-HUB-CAH102119.azure-devices.net


## Exercise 6: Deploy Azure Security Center for IoT C# Security Agent

Azure Security Center for IoT provides reference architecture for security agents that log, process, aggregate, and send security data through IoT Hub. You will be adding a security agent for C# to deploy on your simulated device (Linux VM). There are C and C# based agents. C agents are recommended for devices with more restricted or minimal device resources.

Security agents support the following features:

* Collect raw security events from the underlying Operating System (Linux, Windows). To learn more about available security data collectors, see Azure Security Center for IoT agent configuration.
* Aggregate raw security events into messages sent through IoT Hub.
* Authenticate with existing device identity, or a dedicated module identity. See Security agent authentication methods to learn more.
* Configure remotely through use of the **azureiotsecurity** module twin. To learn more, see Configure an Azure Security Center for IoT agent.

## Logging into IoT Device - Linux VM

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Navigate to your newly created virtual machine (**vm-01**)  within the Azure Portal.

1. On the **Overview** pane of the **Virtual machine** blade, click the **Connect** button at the top.

1. Within the **Connect to virtual machine** pane, select the **SSH** option, then copy the **Login using VM local account** value.

    This is a sample SSH command that will be used to connect to the virtual machine that contains the IP Address for the VM and the Administrator username. The command is formatted similar to `ssh demouser@52.170.205.79`.

1. At the top of the Azure Portal click on the **Cloud Shell** icon to open up the **Azure Cloud Shell** within the Azure Portal. When the pane opens, choose the option for the **Bash** terminal within the Cloud Shell.

1. Within the Cloud Shell, paste in the `ssh` command that was copied, and press **Enter**.

1. When prompted with **Are you sure you want to continue connecting?**, type `yes` and press Enter. This prompt is a security confirmation since the certificate used to secure the connection to the VM is self-signed. The answer to this prompt will be remembered for subsequent connections, and is only prompted on the first connection.

1. When prompted to enter the password, enter the Administrator password that was entered when the VM was provisioned.

1. Once connected, the terminal will change to show the name of the Linux VM, similar to the following. This tells you which VM you are connected to.

    ```cmd/sh
    demouser@IoTDeviceLinuxVM:~$
    ```

## Add Symmetric Keys to your device

With the C agent you will be connecting to your IoT Hub. This means you will need your device's symmetric key or certificate information. For this lab, you will be using the symmetric key as authentication and will store in a temporary text document on the device. To do this you will need to do the following:

1. Open in the Azure Portal in a new browser tab.

1. On the Azure portal menu, click Dashboard and open your IoT Hub. You can also in the portal search bar type in your IoT Hub name and select your IoT Hub resource once it pops up.

1. In your IoT Hub, locate **IoT devices** under **Explorers**.

1. Click on **vm-device01**.

1. Copy your **Primary Key**.

1. Go back to your IoTDeviceLinuxVM that is open Cloud Shell in the other tab.

1. Create device Authentication type file with your **vm-device01** device's **Primary Key**.

    ```cmd/sh
    echo "<primary_key>" > s.key
    ```

    > [!NOTE] To check if you added the correct Primary key into the file, Open your file with `nano s.key`command. Check to see your device's **Primary Key** is in the file. To exit the nano editor, holding `Ctrl` and `X`. Save file by holding `shift` and `Y`. Then hit enter.

## Installing Security Agent

1. Download the recent version of Security Agent for C# to your device.

    ```cmd/sh
    wget https://github.com/Azure/Azure-IoT-Security-Agent-CS/releases/download/0.0.6/ubuntu-18.04-x64.tar.gz
    ```

1. Extract the contents of the package and navigate to the /Install folder.

    ```cmd/sh
    tar -xzvf ubuntu-18.04-x64.tar.gz && cd Install
    ```

1. Add running permissions to the `InstallSecurityAgent` script by running the following commands

    ```cmd/sh
    chmod +x InstallSecurityAgent.sh
    ```

1. Next, run the following command with root privileges. You will need to switch out for your authentication parameters.

    ```cmd/sh
    sudo ./InstallSecurityAgent.sh -i -aui Device -aum SymmetricKey -f <Insert file location of your s.key file> -hn <Insert your IoT Hub host name> -di vm-device01
    ```

    An example of what the command would look like. Please make sure you swap out for your IoT Hub hostname instead: `sudo ./InstallSecurityAgent.sh -i -aui Device -aum SymmetricKey -f ../s.key -hn Lab16.azure-devices.net -di vm-device02`

    This script performs the following function:
    * Installs prerequisites.
    * Adds a service user (with interactive sign in disabled).
    * Installs the agent as a Daemon - assumes the device uses systemd for service management.
    * Configures sudoers to allow the agent to do certain tasks as root.
    * Configures the agent with the authentication parameters provided.

1. A reboot is required to complete agent installation. Type in **"y"** for yes when asked `Do you wish to do it now?`

1. Within the Cloud Shell, SSH back into your virtual machine with the SSH command you used earlier.

1. Check the deployment of the Azure Security Center for IoT Agent status by running the following command. Your Azure Security Center for IoT Agent should now be active and running.

    ```cmd/sh
    systemctl status ASCIoTAgent.service
    ```

    > [!NOTE] If your Azure Security Center for IoT Agent isn't running or active, please check out [Deploy Azure Security Center for IoT C# based security agent for Linux Guide Troubleshooting Section](https://docs.microsoft.com/en-us/azure/asc-for-iot/how-to-deploy-linux-cs).

1. Navigate back to the Azure portal to your  **vm-device01**. TO do that, go in your IoT Hub, locate IoT devices under Explorers. Click on **vm-device01**.

1. Notice that your **azureiotsecurity** Module is now on **Connected** state. 

Now that your Azure Security Center for IoT device agents on your devices are installed, the agents will be able to collect, aggregate and analyze raw security events from your devices.




## Exercise 7: Configure Solution Management

Azure Security Center for IoT provides comprehensive end-to-end security for Azure-based IoT solutions.

With Azure Security Center for IoT, you can monitor your entire IoT solution in one dashboard, surfacing all of your IoT devices, IoT platforms and back-end resources in Azure.

Once enabled on your IoT Hub, Azure Security Center for IoT automatically identifies other Azure services, also connected to your IoT Hub and related to your IoT solution.

In addition to automatic relationship detection, you can also pick and choose which other Azure resource groups to tag as part of your IoT solution. Your selections allow you to add entire subscriptions, resource groups, or single resources.

1. Open your IoT Hub in Azure portal.

1. Select and open **Resources** under Security from the left menu.

1. Click **Edit**.

1. Add your Subscriptions and Resource groups to Solution Management.

1. Click **Apply**.

After defining all of the resource relationships, Azure Security Center for IoT leverages Azure Security Center to provide you security recommendations and alerts for these resources.

## View Azure Security Center for IoT in Action

Now that you have your the security agent installed on your device and your solution configure, take some time to check out Azure Security Center for IoT different views. 

1. Navigate **Overview** under Security. You will see start to see an overview of the health of your devices, hubs, and other resources. You can see the Built-in real-time monitoring, recommendations and alerts that were enabled right when you turn on your Azure IoT Security Center.

1. Navigate **Resources** under Security, to see the health of your resources across your IoT solution.
