# Prerequisites and Setup Scripts

This topic outlines the prerequisite resources in Azure for this lab and provides instructions for executing the **lab-setup.azcli** script should the resources need to be recreated.

> [!NOTE] Executing the **lab-setup.azcli** script may take up to 10 minutes.

## Prerequisite

This lab assumes the following resources are available:

| Resource Type | Resource Name |
| :-- | :-- |
| Resource Group | AZ-220-RG |
| IoT Hub | AZ-220-HUB-{YOUR-ID} |
| Device Provisioning Service | AZ-220-DPS-{YOUR-ID} |

If the resources are unavailable, please execute the **lab-setup.azcli** script before starting the lab.

## Execute Setup Script

The **lab-setup.azcli** script is written to run in a **bash** shell environment - the easiest way to execute this is in the Azure Cloud Shell.

1. Using a browser, open the [Azure Shell](https://shell.azure.com/) and login with the Azure subscription you are using for this course.

1. To ensure the Azure Shell is using **Bash**, ensure the dropdown selected value in the top-left is **Bash**.

1. To upload the setup script, in the Azure Shell toolbar, click **Upload/Download files** (fourth button from the right).

1. In the dropdown, select **Upload** and in the file selection dialog, navigate to the **lab-setup.azcli** file for this lab. Select the file and click **Open** to upload it.

    A notification will appear when the file upload has completed.

1. You can verify that the file has uploaded by listing the content of the current directory by entering the `ls` command.

1. To create a directory for this lab, move **lab-setup.azcli** into that directory, and make that the current working directory, enter the following commands:

    ```bash
    mkdir lab5
    mv lab-setup.azcli lab5
    cd lab5
    ```

1. To ensure the **lab-setup.azcli** has the execute permission, enter the following commands:

    ```bash
    chmod +x lab-setup.azcli
    ```

1. To edit the **lab-setup.azcli** file, click **{ }** (Open Editor) in the toolbar (second button from the right). In the **Files** list, select **lab5** to expand it and then select **lab-setup.azcli**.

    The editor will now show the contents of the **lab-setup.azcli** file.

1. In the editor, update the values of the `{YOUR-ID}` and `{YOUR-LOCATION}` variables. Set `{YOUR-ID}` to the Unique ID you created at the start of this - i.e. **CAH121119**, and set `{YOUR-LOCATION}` to the location that makes sense for your resources.

    ```bash
    #!/bin/bash

    RGName="AZ-220-RG"
    IoTHubName="AZ-220-HUB-{YOUR-ID}"

    Location="{YOUR-LOCATION}"
    ```

    > [!NOTE] The `{YOUR-LOCATION}` variable should be set to the short name for the location. You can see a list of the available locations and their short-names (the **Name** column) by entering this command:

    > ```bash
    > az account list-locations -o Table
    >
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

1. To create a resources required for this lab, enter the following command:

    ```bash
    ./lab-setup.azcli
    ```

    This will take a few minutes to run. You will see JSON output as each step completes.

Once the script has completed, you will be ready to continue with the lab.
