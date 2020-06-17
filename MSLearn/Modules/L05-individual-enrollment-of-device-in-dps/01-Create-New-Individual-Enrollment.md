# Create new Individual Enrollment (Symmetric keys) in DPS

In this unit you will create a new Individual Enrollment for a device within the Device Provisioning Service (DPS) using Symmetric key attestation.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Notice that the **AZ-220** dashboard that you created in the previous task has been loaded.

    You should see both your IoT Hub and DPS resources listed.

1. On your Resource group tile, click **AZ-220-DPS-{YOUR-ID}**.

1. On the Device Provisioning Service **Settings** pane on the left side, click **Manage enrollments**.

1. At the top of the blade, click **+ Add individual enrollment**.

1. On the **Add Enrollment** blade, in the **Mechanism** dropdown, click **Symmetric Key**. This sets the attestation method to use Symmetric key authentication.

1. Notice the **Auto-generate keys** option is checked. This sets DPS to automatically generate both Primary and Secondary Keys for the device enrollment when it's created.

    Optionally, un-checking this option enables custom keys to be manually entered.

1. In the **Registration ID** field, enter **DPSSimulatedDevice1** as the Registration ID to use for the device enrollment within DPS.

    By default, the Registration ID will be used as the IoT Hub Device ID when the device is provisioned from the enrollment. If these values need to be different, then enter the required IoT Hub Device ID in that field.

1. Notice that the **AZ-220-HUB-{YOUR-ID}** IoT Hub is selected within the **Select the IoT hubs this device can be assigned to** dropdown. This field specifies the IoT Hub(s) this device can be assigned to.

1. Locate the **Initial Device Twin State** field. This contains JSON data that represents the initial configuration of desired properties for the device.

1. In the Initial Device Twin State field, modify the `properties.desired` JSON object to include a property named `telemetryDelay` with the value of `"2"`. This will be used by the Device to set the time delay for reading sensor telemetry and sending events to IoT Hub.

    The final JSON will be like the following:

    ```json
    {
        "tags": {},
        "properties": {
            "desired": {
                "telemetryDelay": "2"
            }
        }
    }
    ```

1. Click **Save**

1. In the Manage enrollments pane, click on the **Individual Enrollments** tab to view the list of individual device enrollments.

1. In the list, click on the **DPSSimulatedDevice1** individual enrollment that was just created to view the enrollment details.

1. Locate the **Authentication Type** section, and notice the Mechanism is set to Symmetric Key.

1. Copy the **Primary Key** and **Secondary Key** values for this device enrollment, and save them for reference later.

    These are the authentication keys for the device to authenticate with the service.

1. Locate the **Initial Device Twin State**, and notice the JSON for the Device Twin Desired State contains the `telemetryDelay` property set to the value of `"2"`.
