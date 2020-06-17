# Connect IoT Edge Device to IoT Hub

In this unit you will connect the IoT Edge Device to Azure IoT Hub.

1. Navigate to the `AZ-220-VM-EDGE` IoT Edge virtual machine within the Azure Portal.

1. On the **Overview** pane of the **Virtual machine** blade, click the **Connect** button at the top.

1. Within the **Connect to virtual machine** pane, select the **SSH** option, then copy the **Login using VM local account** value.

    This is a sample SSH command that will be used to connect to the virtual machine that contains the IP Address for the VM and the Administrator username. The command is formatted similar to `ssh demouser@52.170.205.79`.

1. At the top of the Azure Portal click on the **Cloud Shell** icon to open up the **Azure Cloud Shell** within the Azure Portal. When the pane opens, choose the option for the **Bash** terminal within the Cloud Shell.

1. Within the Cloud Shell, paste in the `ssh` command that was copied, and press **Enter**.

1. When prompted with **Are you sure you want to continue connecting?**, type `yes` and press Enter. This prompt is a security confirmation since the certificate used to secure the connection to the VM is self-signed. The answer to this prompt will be remembered for subsequent connections, and is only prompted on the first connection.

1. When prompted to enter the password, enter the Administrator password that was entered when the VM was provisioned.

1. Once connected, the terminal will change to show the name of the Linux VM, similar to the following. This tells you which VM you are connected to.

    ```cmd/sh
    demouser@AZ-220-VM-EDGE:~$
    ```

1. To confirm that the Azure IoT Edge Runtime is installed on the VM, run the following command:

    ```cmd/sh
    iotedge version
    ```

    This command will output the version of the Azure IoT Edge Runtime that is currently installed on the virtual machine.

1. You will need to run the command to configure the Edge device to connect to IoT Hub as Administrator. Run the following `sudo` command to elevate the terminal to run as Administrator:

    ```cmd/sh
    sudo su -
    ```

    > [!NOTE] You will see the user id change in the shell prompt: `root@AZ-220-VM-EDGE:~$`

1. The `/etc/iotedge/configedge.sh` script is used to configure the Edge device with the Connection String necessary to connect it to Azure IoT Hub. This script is installed as part of the Azure IoT Edge Runtime.

1. To configure the Edge device with the **Device Connection String** for Azure IoT Hub that was copied when the IoT Edge Device ID was created, run the following command:

    ```cmd/sh
    /etc/iotedge/configedge.sh "{iot-edge-device-connection-string}"
    ```

    Be sure to replace the `{iot-edge-device-connection-string}` placeholder with the Connection String you copied previously for your IoT Edge Device.

1. Once this command completes, the IoT Edge Device will be configured to connect to Azure IoT Hub using the **Connection String** that was entered. The command will output a `Connection string set to ...` message that includes the Connection String that was set.
