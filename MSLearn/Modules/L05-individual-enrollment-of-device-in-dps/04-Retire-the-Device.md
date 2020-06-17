# Retire the Device

In this unit you will perform the necessary tasks to retire the device from both the Device Provisioning Service (DPS) and Azure IoT Hub. To fully retire an IoT Device from an Azure IoT solution it must be removed from both of these services. When the transport box arrives at it's final destination, then sensor will be removed from the box, and needs to be "decommissioned". Complete device retirement is an important step in the life cycle of IoT devices within an IoT solution.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Notice that the **AZ-220** dashboard that you created in the previous task has been loaded.

    You should see both your IoT Hub and DPS resources listed.

1. On your Resource group tile, click **AZ-220-DPS-{YOUR-ID}** to navigate to the Device Provisioning Service.

1. On the Device Provisioning Service settings pane on the left side, click **Manage enrollments**.

1. In the Manage enrollments pane, click on the **Individual Enrollments** link to view the list of individual device enrollments.

1. Select the `DPSSimulatedDevice1` individual device enrollment by checking the box next to it in the list, then click **Delete**.

    > [!NOTE]
    > Deleting the Individual Enrollment from DPS will permanently remove the enrollment. To temporarily disable the enrollment, you can set the **Enable entry** setting to **Disable** within the **Enrollment Details** for the Individual Enrollment.

1. On the **Remove enrollment** prompt, click **Yes** to confirm that you want to delete this device enrollment from the Device Provisioning Service.

1. The Individual Enrollment is now removed from the Device Provisioning Service (DPS). To complete the device retirement, the **Device ID** for the Simulated Device also must be removed from the **Azure IoT Hub** service.

1. On your Resource group tile, click **AZ-220-HUB-{YOUR-ID}** to navigate to the Azure IoT Hub.

1. On the Azure IoT Hub pane, click on **IoT devices** under **Explorers** section on the left side.

1. Select the `DPSSimulatedDevice1` **Device ID** by checking the box next to the device in the list, then click **Delete**.

    > [!NOTE] Deleting the Device ID from IoT Hub will permanently remove the device registration. To temporarily disable the device from connecting to IoT Hub, you can set the **Enable connection to IoT Hub** to **Disable** within the properties for this **Device ID**.

1. On the **Are you certain you wish to delete selected device(s)** prompt, click **Yes** to confirm that you want to delete this device from Azure IoT Hub.

Now that the Device Enrollment has been removed from the Device Provisioning Service, and the matching Device ID has been removed from the Azure IoT Hub, the simulated device has been fully retired from the solution.
