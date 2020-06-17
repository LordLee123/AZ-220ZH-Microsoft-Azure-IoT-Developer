# Set Up and Use Metrics and Diagnostic Logs with an IoT Hub

If you have an IoT Hub solution running in production, you want to set up some metrics and enable diagnostic logs. Then if a problem occurs, you have data to look at that will help you diagnose the problem and fix it more quickly. In this lab, you'll see how to enable the diagnostic logs, and how to check them for errors. You'll also set up some metrics to watch, and alerts that fire when the metrics hit a certain boundary.

For example, you could have an e-mail sent to you when the number of connected devices exceed a certain threshold, or when the number of messages used gets close to the quota of messages allowed per day for the IoT Hub.

## Setup Resources

In order to complete this lab, you will need to reuse a number of resources from a previous lab - **Automatic Enrollment of Devices in DPS** as well as a storage account.

1. Open a new tab on your browser and navigate to the [Azure Cloud Shell](https://shell.azure.com/).

1. Login to you Azure Subscription (the same one you used for your IoT Central App) and if your account is a member of more than one directory, choose the directory you used for your IoT Central account.

1. Once the bash shell is open, create** a **monitoring** folder, and navigate to it by entering the following commands:

    ```bash
    mkdir ~/monitoring
    cd ~/monitoring
    ```

1. To create an empty file in which we will copy the setup script, enter the following commands:

    ```bash
    touch setup.sh
    chmod +x setup.sh
    ```

1. To edit the contents of the **setup.sh** file, use the **{ }** icon in Azure Cloud Shell to open the **Cloud Editor**.

    To open the **setup.sh** file, you will have to expand the **monitoring** node in the **Files** list to locate it.

1. Copy the following script into the cloud editor:

    ```bash
    #!/bin/bash

    YourID="{YOUR-ID}"
    RGName="AZ-220"
    Location="westus"
    IoTHubName="$RGName-HUB-$YourID"
    DPSName="$RGName-DPS-$YourID"
    DeviceName="asset-track"
    StorageAccountName="$RGName-STORAGE-$YourID"

    # Storage Account name must be in lowercase with no '-'
    ToLowerAlphaNum () {
        echo $1 | tr '[:upper:'] '[:lower:]' | tr -cd '[:alnum:]'
    }

    StorageAccountName=$( ToLowerAlphaNum $StorageAccountName )

    # create resource group
    az group create --name $RGName --location $Location -o Table

    # create IoT Hub
    az iot hub create --name $IoTHubName -g $RGName --sku S1 --location $Location -o Table

    # create DPS
    az iot dps create --name $DPSName -g $RGName --sku S1 --location $Location -o Table

    # Get IoT Hub Connection String so DPS can be linked
    IoTHubConnectionString=$(
        az iot hub show-connection-string --hub-name $IoTHubName --query connectionString --output tsv
    )

    # Link IoT Hub with DPS
    az iot dps linked-hub create --dps-name $DPSName -g $RGName --connection-string $IoTHubConnectionString --location $Location

    # Create a Storage Account
    az storage account create --name $StorageAccountName --resource-group $RGName --location=$Location --sku Standard_LRS -o Table 

    StorageConnectionString=$( az storage account show-connection-string --name $StorageAccountName -o tsv )
    ```

    > [!NOTE] Review this script. You can see that it perform the following actions (and create resources if they don't already exist):
    > * Builds the resource names
    >   * Note that the storage account name is set to lowercase with no dashes to match the naming rules.
    > * Create Resource Group
    > * Create IoT Hub
    > * Create DPS
    > * Link IoT Hub and DPS
    > * Create Storage Account

1. In order to specify the correct resource names and location, update the following variables at the top of the file:

    * YourID
    * RGName
    * Location

    > [!NOTE] If you have existing resources you wish to reuse, ensure you set the **YourID** value to the same you used before, as well as the same **RGName** and **Location**.

1. To save the edited **setup.sh** file, press **CTRL-Q**. If prompted to save you changes before closing the editor, click **Save**.

1. To run the **setup.sh** script, run the following:

    ```bash
    ./setup.sh
    ```

    > [!NOTE] If the IoT Hub and DPS resources already exist, you will see red warnings stating the name is not available - you can ignore these errors.

You have now ensured the resources are available for this lab. Next, we shall setup monitoring and logging.