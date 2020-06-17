# Device Message Routing

## Lab Scenario

Suppose you manage a packaging facility. Packages are assembled for shipping, then placed on a conveyor belt that takes the packages and drops them off in mailing bins. Your metric for success is the number of packages leaving the conveyor belt.

The conveyor belt is a critical link in your process, and is monitored for vibration. The conveyor belt has three speeds: stopped, slow, and fast. The number of packages being delivered at slow speed is less than at the faster speed, though the vibration is also less at the slower speed. If the vibration becomes excessive, the conveyor belt has to be stopped and inspected. A broken conveyor wheel, for example, can exacerbate the vibrations, in a cyclical fashion.

![Graph of cyclical forced vibration](../../Linked_Image_Files/M99-L01-Vibration1.png)

There are a number of different types of vibration. Forced vibration is vibration caused by an external force. Such a force as the broken wheel example, or a weighty package placed improperly on the conveyor belt. There's also increasing vibration, which might happen if a design limit is exceeded.

Vibration is typically measured as an acceleration (meters per second squared, m/s2).

![Graph of cyclical forced vibration](../../Linked_Image_Files/M99-L01-Vibration2.png)

The goal here is preventive maintenance. Detect that something is wrong, before any damage is caused.

It's not always easy to detect abnormal vibration levels. For this reason, you are looking to Azure IoT Hub to detect data anomalies. You plan to have a vibration detection sensor on the conveyor belt, sending continuous telemetry to an IoT Hub. The IoT Hub will use Azure Stream Analytics, and a built-in ML model, to give you advance warning of vibration anomalies. You also plan to archive all the telemetry data, just in case it's ever needed.

You decide to build a prototype of the planned system, initially using simulated telemetry.

In this lab you will:

* Create an Azure IoT Hub, and a device ID using Azure CLI
* Create a C# app to send device telemetry to the IoT Hub, using Visual Studio code
* Create a message route, through to blob storage, using the Azure portal
* Create a second message route, through to an Azure Analytics job, using the Azure portal
* Create an Azure Function to identify anomalies.


## Links

* [Search for data anomalies using IoT Hub routing, Stream Analytics, and a built-in ML model](https://docs.microsoft.com/en-us/learn/modules/data-anomaly-detection-using-azure-iot-hub/)

## Prerequisites

* An introductory knowledge of Azure IoT
* Ability to navigate the Azure IoT portal
* Ability to use C#, at the beginner level
* Experience using Visual Studio, or Visual Studio Code, at the beginner level