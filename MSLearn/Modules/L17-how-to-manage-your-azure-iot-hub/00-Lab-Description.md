# Remotely monitor and control devices with Azure IoT Hub (L15)

Our asset tracking solution is getting bigger, and provisioning devices one by one (even through DPS) cannot scale. We want to use DPS to enroll many devices automatically and securely using x.509 certificate authentication. Within our solution, we will use sensors to track our assets being transported. Each time a sensor is added in a transportation box, it will auto provision through DPS. We want to have a metric for the warehouse manager of how many boxes were "tagged" and need to count the Device Connected events from IoT Hub.

In this lab, you will setup a Group Enrollment within Device Provisioning Service (DPS) using a Root CA x.509 certificate chain. You will configure the linked IoT Hub to using monitoring to track the number of connected devices and telemetry messages sent, as well as send connection events to a log. Additionally you will create an alert that will be triggered based upon the average number of devices connected. You will the configure 10 simulated IoT Devices that will authenticate with DPS using a Device CA Certificate generated on the Root CA Certificate chain. The IoT Devices will be configured to send telemetry to the the IoT Hub.

In this lab you will:

* Using Azure CLI, created an IoT hub, Linked DPS instance, and a storage account.
* Enable diagnostic logs.
* Enable metrics.
* Set up alerts for those metrics.
* Download and run an app that simulates IoT devices connecting via X509 and sending messages to the hub.
* Run the app until the alerts begin to fire.
* View the metrics results and check the diagnostic logs.

## Links

- [Set up and use metrics and diagnostic logs with an IoT hub](https://docs.microsoft.com/en-us/azure/iot-hub/tutorial-use-metrics-and-diags)

## Prerequisites

1. An introductory knowledge of Azure IoT
1. Ability to navigate the Azure IoT portal
1. Basic familiarity with the Azure Cloud shell and Bash.
1. Ability to use C# at the beginner level
1. Experience using Visual Studio Code at the beginner level

## Steps

1. Setup Resources
1. Enable Logging
1. Configure an Alert
1. Write code for device twins
1. Verify environment
1. Simulate devices
1. Review metrics, alerts and log archive
