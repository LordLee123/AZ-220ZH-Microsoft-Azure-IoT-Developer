# Link Your IoT Hub and Device Provisioning Service

The Device Provisioning Service relies on an existing IoT Hub for device registration and post-deployment device management. As a result, you need to configure DPS with the credentials required to communicate with a specified IoT Hub.

In this task, you will link your IoT Hub and Device Provisioning Service.

1. If necessary, log in to the Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Notice that the AZ-220 dashboard that you created in the previous task has been loaded.

    You should see both your IoT Hub and DPS resources listed - (you may need to hit **Refresh** if the resources were only recently created)

1. On your Resource group tile, click **AZ-220-DPS-_{YOUR-ID}_**.

2. On the _Device Provisioning Service_ blade, under **Settings**, click **Linked IoT hubs**.

3. At the top of the blade, click **+ Add**.

    You will use the _Add link to IoT hub_ blade to provide the information required to link your Device Provisioning service instance to an IoT hub.

4. On the _Add link to IoT hub_ blade, ensure that the **Subscription** dropdown is displaying the subscription that you are using for this course.

    The subscription is used to provide a list of the available IoT hubs.

5. Open the IoT hub dropdown, and then click **AZ-220-HUB-_{YOUR-ID}_**.

    This is the IoT Hub that you created in the previous lab.

6. In the Access Policy dropdown, click **iothubowner**.

    The _iothubowner_ credentials provide the permissions needed to establish the link with the specified IoT hub.

7. To complete the configuration, click **Save**.

    You should now see the selected hub listed on the Linked IoT hubs blade. You might need to click Refresh to show Linked IoT hubs.
