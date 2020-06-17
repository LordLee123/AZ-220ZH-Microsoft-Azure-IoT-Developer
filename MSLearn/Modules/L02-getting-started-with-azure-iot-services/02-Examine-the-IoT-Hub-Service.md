# Examine the IoT Hub Service

As we have already noted, the IoT Hub is a managed service, hosted in the cloud, that acts as a central message hub for bi-directional communication between your IoT application and the devices it manages.

IoT Hub's capabilities help you build scalable, full-featured IoT solutions such as managing industrial equipment used in manufacturing, tracking valuable assets in healthcare, monitoring office building usage, and many more scenarios. IoT Hub monitoring helps you maintain the health of your solution by tracking events such as device creation, device failures, and device connections.

In this task, you will use the Azure portal to explore the features and capabilities of your new IoT Hub.

1. Login to [portal.azure.com](https://portal.azure.com) using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Verify that your AZ-220 dashboard is being displayed.

1. On the AZ-220-RG resource group tile, click **AZ-220-HUB-_{YOUR-ID}_**

    When you first open your IoT Hub, it will display the _Overview_ blade. As you can see, the area at the top of this blade provides some essential information about your IoT Hub service, such as datacenter location and subscription. But this blade also includes tiles that provide information about how you are using your hub and recent activities. Let's take a look at these tiles before exploring further.

1. At the bottom-left of the _Overview_ blade, notice the **IoT Hub Usage** tile.

    > [!NOTE] The tiles flow based upon the width of the browser, so the layout may be a little different than described.

    This tile provides a quick overview of what is connected to your hub and message count. As we add devices and start sending messages, this tile will provide nice "at-a-glance" information.

1. To the right of the _IoT Hub Usage_ tile, notice the **Device twin operations** tile and the **Device to cloud messages** tile.

    The _Device to cloud messages_ tile provides a quick view of the incoming messages from your devices over time. You will be registering a device and sending messages to your hub in the next module.

    You will be learning about device twins and device twin operations during the modules of this course that cover device configuration, device provisioning, and device management. For now all you need to know is that each device that you register with your IoT Hub will have a device twin that you can use when you need to manage the device.

1. Take a minute to scan the left-side navigation menu options.

    As you would expect, these options open blades that provide access to properties and features of your IoT Hub. They also give you access to devices that are connected to your hub.

1. On the left-side menu, under **Explorers**, click **IoT devices**

    This blade can be used to add, modify, and delete devices registered to your hub. You will get pretty familiar with this blade by the end of this course.

1. On the left-side menu, near the top, click **Activity log**

    As the name implies, this blade gives you access to a log that can be used to review activities and diagnose issues. You can also define queries that help with routine tasks. Very handy.

1. On the left-side menu, under **Settings**, click **Built-in endpoints**

    IoT Hub exposes "endpoints" that enable external connections. Essentially, an endpoint is anything connected to or communicating with your IoT Hub. You should see that your hub already has two endpoints defined:

    * _Events_
    * _Cloud to device messaging_

1. On the left-side menu, under **Messaging**, click **Message routing**

    The IoT Hub message routing feature enables you to route incoming device-to-cloud messages to service endpoints such as Azure Storage containers, Event Hubs, and Service Bus queues. You can also create routing rules to perform query-based routes.

1. At the top of the blade, click **Custom endpoints**.

    Custom endpoints (such as Service Bus queue, Blob storage and the others listed here) are often used within an IoT implementation.

1. Take a minute to explore some of the menu options under **Settings**

    > [!NOTE] This lab is only intended to be an introduction to the IoT service at this point, so don't worry if you feel a bit overwhelmed. We will be walking you through the process of configuring and managing your IoT Hub, devices, and communications as this course continues.
