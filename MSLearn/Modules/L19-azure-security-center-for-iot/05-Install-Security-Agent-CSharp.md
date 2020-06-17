# Deploy Azure Security Center for IoT C# Security Agent

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

    ![Screenshot of Azure IoT Security Module Connected](../../Linked_Image_files/MM99-L16-device-connected-agent.png)


Now that your Azure Security Center for IoT device agents on your devices are installed, the agents will be able to collect, aggregate and analyze raw security events from your devices.