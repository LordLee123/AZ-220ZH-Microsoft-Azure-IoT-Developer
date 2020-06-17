# Retire Group Enrollment

In this unit, you will retire an Enrollment Group and it's devices from both the Device Provisioning Service and Azure IoT Hub.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On your Resource group tile, click **AZ-220-DPS-{YOUR-ID}** to navigate to the Device Provisioning Service.

1. On the Device Provisioning Service settings pane on the left side, click **Manage enrollments**.

1. Click on the **simulated-devices** in the list of Group Enrollments.

1. On the **Enrollment Group Details** pane, locate the **Enable entry** option and set it to **Disable**, then click **Save**.

    Disabling the Group Enrollment within DPS allows you to temporarily disable devices within this Enrollment Group. This provides a temporary blacklist of the x.509 certificate used by these devices.

1. To permanently delete the Enrollment Group, you must delete the **Enrollment Group** from DPS. To do this, check the box next to the **simulated-devices** **Group Name** on the **Manage enrollments** pane, then click the **Delete** button at the top.

1. When prompted to confirm the action to **Remove enrollment**, click **Yes**. Once deleted, the Group Enrollment is completely removed from DPS, and would need to be recreated to add it back.

    > [!NOTE] If you delete an enrollment group for a certificate, devices that have the certificate in their certificate chain might still be able to enroll if a different, enabled Enrollment Group still exists for the root certificate or another intermediate certificate higher up in their certificate chain.

1. Once the **Group Enrollment** has been removed from the Device Provisioning Service (DPS), the device registration will still existing within Azure IoT Hub. To fully retire the devices, you will need to remove that registration as well.

1. Within the Azure portal, on your Resource group tile, click **AZ-220-HUB-{YOUR-ID}** to navigate to the **Azure IoT Hub**.

1. On the **IoT Hub** blade, click on the **IoT devices** link under the **Explorers** section.

1. Notice that the **simulated-devices** Device ID still exists within the Azure IoT Hub device registry.

1. To remove the  **Device ID**, check box next to it in the list, then click the **Delete** button at the top of the pane.

1. When prompted with "_Are you certain you wish to delete selected device(s)_", click **Yes** to confirm and perform the deletion.

1. With the **Group Enrollment** delete from the Device Provisioning Service, and the **Device ID** deleted from the Azure IoT Hub device registry, the device(s) have fully been removed from the solution.

1. Run the **Simulated Device** again executing the `dotnet run` command within the Visual Studio Code **Terminal** window again.

1. Now that the **Group Enrollment** and **Device ID** have been deleted, the **Simulated Device** will no longer be able to connect. When the application attempts to use the configured x.509 certificate to connect to DPS, it will return a `ProvisioningTransportException` error message.

    ```txt
    Found certificate: AFF851ED016CA5AEB71E5749BCBE3415F8CF4F37 CN=simulated-device1; PrivateKey: True
    Using certificate AFF851ED016CA5AEB71E5749BCBE3415F8CF4F37 CN=simulated-device1
    RegistrationID = simulated-device1
    ProvisioningClient RegisterAsync . . . Unhandled exception. Microsoft.Azure.Devices.Provisioning.Client.ProvisioningTransportException: {"errorCode":401002,"trackingId":"df969401-c766-49a4-bab7-e769cd3cb585","message":"Unauthorized","timestampUtc":"2019-12-20T21:30:46.6730046Z"}
       at Microsoft.Azure.Devices.Provisioning.Client.Transport.ProvisioningTransportHandlerAmqp.ValidateOutcome(Outcome outcome)
       at Microsoft.Azure.Devices.Provisioning.Client.Transport.ProvisioningTransportHandlerAmqp.RegisterDeviceAsync(AmqpClientConnection client, String correlationId, DeviceRegistration deviceRegistration)
       at Microsoft.Azure.Devices.Provisioning.Client.Transport.ProvisioningTransportHandlerAmqp.RegisterAsync(ProvisioningTransportRegisterMessage message, CancellationToken cancellationToken)
    ```

You have completed the registration, configuration, and retirement as part of the IoT devices life cycle with Device Provisioning Service.
