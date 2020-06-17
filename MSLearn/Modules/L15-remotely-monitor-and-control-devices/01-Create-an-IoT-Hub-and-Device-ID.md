# Create an Azure IoT Hub and a Device ID

In this unit, we first create an IoT Hub, and then add a single device to that hub. To complete the unit, we record the connection strings and other properties needed for the coding part of this module.

As part of this course, we have already created an Azure IoT Hub and Device ID using the portal. This time around, we will use the Azure CLI to create the items we need.

1. Using a browser, open the [Azure Shell](https://shell.azure.com/) and login with the Azure subscription you are using for this course.

1. To ensure the Azure Shell is using **Bash**, ensure the dropdown selected value in the top-left is **Bash**.

1. To upload the setup script, in the Azure Shell toolbar, click **Upload/Download files** (fourth button from the right).

1. In the dropdown, select **Upload** and in the file selection dialog, navigate to the **lab-setup.azcli** file for this lab. Select the file and click **Open** to upload it.

    A notification will appear when the file upload has completed.

1. You can verify that the file has uploaded by listing the content of the current directory by entering the `ls` command.

1. To create a directory for this lab, move **lab-setup.azcli** into that directory, and make that the current working directory, enter the following commands:

    ```bash
    mkdir lab15
    mv lab-setup.azcli lab15
    cd lab15
    ```

1. To ensure the **lab-setup.azcli** has the execute permission, enter the following commands:

    ```bash
    chmod +x lab-setup.azcli
    ```

1. To edit the **lab-setup.azcli** file, click **{ }** (Open Editor) in the toolbar (second button from the right). In the **Files** list, select **lab15** to expand it and then select **lab-setup.azcli**.

    The editor will now show the contents of the **lab-setup.azcli** file.

1. In the editor, update the values of the `YourID` and `Location` variables. Set `YourID` to your initials and todays date - i.e. **CAH121119**, and set `Location` to the location that makes sense for your resources.

    > [!NOTE] The `Location` variable should be set to the short name for the location. You can see a list of the available locations and their short-names (the **Name** column) by entering this command:
    > ```bash
    > az account list-locations -o Table
    > ```
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

1. To create a resource group named **AZ-220-RG**, create an IoT Hub named **AZ-220-HUB-{YourID}**, add a device with an ID of **CheeseCaveID**, and display the device connection string, enter the following command:

    ```bash
    ./lab-setup.azcli
    ```

    This will take a few minutes to run. You will see JSON output as each step completes.

1. Once complete, the script will be display data similar to:

    ```text
    Configuration Data:
    ------------------------------------------------
    AZ-220-HUB-DM121119 hub connectionstring:
    HostName=AZ-220-HUB-DM121119.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=nV9WdF3Xk0jYY2Da/pz2i63/3lSeu9tkW831J4aKV2o=

    CheeseCaveID device connection string:
    HostName=AZ-220-HUB-DM121119.azure-devices.net;DeviceId=CheeseCaveID;SharedAccessKey=TzAzgTYbEkLW4nWo51jtgvlKK7CUaAV+YBrc0qj9rD8=

    AZ-220-HUB-DM121119 eventhub endpoint:
    sb://iothub-ns-az-220-hub-2610348-5a463f1b56.servicebus.windows.net/

    AZ-220-HUB-DM121119 eventhub path:
    az-220-hub-dm121119

    AZ-220-HUB-DM121119 eventhub SaS primarykey:
    tGEwDqI+kWoZroH6lKuIFOI7XqyetQHf7xmoSf1t+zQ=
    ```

    Copy these values to a local text file - you will need them for the coding portion of this lab.
    
You've now completed the preparatory work for this module, the next steps are all coding and testing. Before we advance though, a quick knowledge check!