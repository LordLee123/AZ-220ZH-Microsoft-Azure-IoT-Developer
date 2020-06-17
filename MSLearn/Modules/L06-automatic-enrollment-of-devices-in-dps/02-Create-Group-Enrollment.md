# Create Group Enrollment (x.509 Certificate) in DPS

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On your Resource group tile, click **AZ-220-DPS-{YOUR-ID}**.

1. On the Device Provisioning Service settings pane on the left side, click **Manage enrollments**.

1. At the top of the blade, click **Add enrollment group**.

1. On the **Add Enrollment Group** blade, enter "**simulated-devices**" in the **Group name** field for the name of the enrollment group.

1. Ensure that the **Attestation Type** is set to **Certificate**.

1. Set the **Certificate Type** field to **CA Certificate**.

1. In the **Primary Certificate** dropdown, select the **CA Certificate** that was uploaded to DPS previously.

1. Notice the **Select the IoT hubs this group can be assigned to** dropdown has the **AZ-220-HUB-{YOUR-ID}** IoT Hub selected. This will ensure when the device is provisioned, it gets added to this IoT Hub.

1. In the Initial Device Twin State field, modify the `properties.desired` JSON object to include a property named `telemetryDelay` with the value of `"1"`. This will be used by the Device to set the time delay for reading sensor telemetry and sending events to IoT Hub.

    The final JSON will be like the following:

    ```js
    {
        "tags": {},
        "properties": {
            "desired": {
                "telemetryDelay": "1"
            }
        }
    }
    ```

1. Click **Save**

1. In the Manage enrollments pane, click on the **Enrollment Groups** tab to view the list of enrollment groups in DPS.

1. In the list, click on the **simulated-devices** enrollment group that was just created to view the enrollment group details.

1. On the **Enrollment Group Details** pane, locate the **Certificate Type**, notice it's set to **CA Certificate**. Also, notice the Primary Certificate information is displayed, including the ability to update the certificates if needed.

1. Locate the **Initial Device Twin State**, and notice the JSON for the Device Twin Desired State contains the `telemetryDelay` property set to the value of `"1"`.

1. Close the **Enrollment Group Details** pane.
