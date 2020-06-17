# Create and Register a New Device

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

1. Click Save.
