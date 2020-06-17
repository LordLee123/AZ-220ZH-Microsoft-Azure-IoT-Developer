# Connect IoT Device to Azure

## Lab Scenario

Contoso is known for producing high quality of cheeses. Due to the company rapidly growing in popularity and sales, they want to ensure that their cheeses stay at the same level of quality. At the moment, a worker temperature and humidity data is collected by floor workers every shift.

Contoso is exploring adding an IoT device to monitor the temperature and humidity of their batches of cheeses. For the asset monitoring solution, you will be connecting an IoT device with temperature and humidity sensors (temperature, humidity) to IoT Hub.

## In This Lab

In this lab, you will do the following:

![IoT Hub Architecture Diagram for solution](../../Linked_Image_files/MM99_L04_IoT_Hub_Arch_01.png)

* Register a Device ID in Azure IoT Hub using the Azure CLI.
* You will then configure and run a pre-built Simulated Device written in C# to connect to Azure IoT Hub and send Device-to-Cloud telemetry messages.
* Verify the device telemetry is being received by Azure IoT Hub using the Azure CLI.
