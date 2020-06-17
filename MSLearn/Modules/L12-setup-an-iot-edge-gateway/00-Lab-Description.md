# Setup an IoT Edge Gateway

## Lab Scenario

This module is theoretical and will walk you through how an IoT Edge device can be used as a gateway.

There are three patterns for using an IoT Edge device as a gateway: transparent, protocol translation, and identity translation:

**Transparent** – Devices that theoretically could connect to IoT Hub can connect to a gateway device instead. The downstream devices have their own IoT Hub identities and are using any of the MQTT, AMQP, or HTTP protocols. The gateway simply passes communications between the devices and IoT Hub. The devices are unaware that they are communicating with the cloud via a gateway, and a user interacting with the devices in IoT Hub is unaware of the intermediate gateway device. Thus, the gateway is transparent. Refer to Create a transparent gateway for specifics on using an IoT Edge device as a transparent gateway.

**Protocol translation** – Also known as an opaque gateway pattern, devices that do not support MQTT, AMQP, or HTTP can use a gateway device to send data to IoT Hub on their behalf. The gateway understands the protocol used by the downstream devices, and is the only device that has an identity in IoT Hub. All information looks like it is coming from one device, the gateway. Downstream devices must embed additional identifying information in their messages if cloud applications want to analyze the data on a per-device basis. Additionally, IoT Hub primitives like twins and methods are only available for the gateway device, not downstream devices.

**Identity translation** - Devices that cannot connect to IoT Hub can connect to a gateway device, instead. The gateway provides IoT Hub identity and protocol translation on behalf of the downstream devices. The gateway is smart enough to understand the protocol used by the downstream devices, provide them identity, and translate IoT Hub primitives. Downstream devices appear in IoT Hub as first-class devices with twins and methods. A user can interact with the devices in IoT Hub and is unaware of the intermediate gateway device.

![Screenshot showing how to create contents state for the simulated device](../../Linked_Image_files/MM99-L12-edge-gateway.png)

## In This Lab

In this lab, you will:

1. Deploy Azure IoT Edge Enabled Linux VM as an IoT Edge Device
1. Generate and Configure IoT Edge Device CA Certificates
1. Create IoT Edge Device Identity in IoT Hub using Azure Portal
1. Setup IoT Edge Gateway Hostname
1. Connect IoT Edge Gateway Device to IoT Hub
1. Open IoT Edge Gateway Device Ports for Communication
1. Create Downstream Device Identity in IoT Hub
1. Connect Downstream Device to IoT Edge Gateway
1. Verify Event Flow
