# Examine the Device Provisioning Service

The IoT Hub Device Provisioning Service is a helper service for IoT Hub that enables zero-touch, just-in-time provisioning to the right IoT hub without requiring human intervention, enabling customers to provision millions of devices in a secure and scalable manner.

In this task, you will use the Azure portal to explore the features and capabilities of your new IoT Hub.

1. Login to [portal.azure.com](https://portal.azure.com) using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Verify that your AZ-220 dashboard is being displayed.

1. On the _AZ-220-RG_ resource group tile, click **AZ-220-DPS-_{YOUR-ID}_**

    When you first open your Device Provisioning Service instance, it will display the _Overview_ blade. As you can see, the area at the top of this blade provides some essential information about your DPS instance, such as status, datacenter location and subscription. This blade also provides the _Quick Links_ section, which provide access to:

    * [Azure IoT Hub Device Provisioning Service Documentation](https://docs.microsoft.com/en-us/azure/iot-dps/)
    * [Learn more about IoT Hub Device Provisioning Service](https://docs.microsoft.com/en-us/azure/iot-dps/about-iot-dps)
    * [Device Provisioning concepts](https://docs.microsoft.com/en-us/azure/iot-dps/concepts-service)
    * [Pricing and scale details](https://azure.microsoft.com/en-us/pricing/details/iot-hub/)

    You can explore these links to learn more.

1. Take a minute to scan the left navigation area options.

    As you might expect, these options open blades that provide access to activity logs, properties and feature of the DPS instance.

1. On the left-side menu, near the top, click **Activity log**

    As the name implies, this blade gives you access to a log that can be used to review activities and diagnose issues. You can also define queries that help with routine tasks. Very handy.

1. On the left navigation area, under **Settings**, click **Quick Start**.

    This blade lists the steps to start using the Iot Hub Device Provisioning Service, links to documentation and shortcuts to other blades for configuring DPS.

1. On the left navigation area, under **Settings**, click **Shared access policies**.

    This blade provides management of access policies, lists the existing policies and the associated permissions.

1. On the left navigation area, under **Settings**, click **Linked IoT hubs**.

    Here you can see the linked IoT Hub from earlier. The Device Provisioning Service can only provision devices to IoT hubs that have been linked to it. Linking an IoT hub to an instance of the Device Provisioning service gives the service read/write permissions to the IoT hub's device registry; with the link, a Device Provisioning service can register a device ID and set the initial configuration in the device twin. Linked IoT hubs may be in any Azure region. You may link hubs in other subscriptions to your provisioning service.

1. On the left navigation area, under **Settings**, click **Certificates**.

    Here you can manage the X.509 certificates that can be used to secure your Azure IoT hub using the X.509 Certificate Authentication. You will investigate X.509 certificates in a later lab.

1. On the left navigation area, under **Settings**, click **Manage enrollments**.

    Here you can manage the enrollment groups and individual enrollments.

    Enrollment groups can be used for a large number of devices that share a desired initial configuration, or for devices all going to the same tenant. An enrollment group is a group of devices that share a specific attestation mechanism. Enrollment groups support both X.509 as well as symmetric. All devices in the X.509 enrollment group present X.509 certificates that have been signed by the same root or intermediate Certificate Authority (CA). Each device in the symmetric key enrollment group present SAS tokens derived from the group symmetric key. The enrollment group name and certificate name must be alphanumeric, lowercase, and may contain hyphens.

    An individual enrollment is an entry for a single device that may register. Individual enrollments may use either X.509 leaf certificates or SAS tokens (from a physical or virtual TPM) as attestation mechanisms. The registration ID in an individual enrollment is alphanumeric, lowercase, and may contain hyphens. Individual enrollments may have the desired IoT hub device ID specified.

1. Take a minute to explore some of the other menu options under **Settings**

   > [!NOTE] This lab is only intended to be an introduction to the IoT Hub Device Provisioning Service at this point, so don't worry if you feel a bit overwhelmed. We will be covering more aspect of the DPS in later parts of the course.
