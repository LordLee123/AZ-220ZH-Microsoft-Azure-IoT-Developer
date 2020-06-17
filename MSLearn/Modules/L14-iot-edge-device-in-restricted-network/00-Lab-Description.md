# Run an IoT Edge device in restricted network and offline

## Lab Scenario

Conveyor belt system monitors vibrations, telemetry, and counts objects. We want our system to be resilient to network outages and also optimize the bulk upload of telemetry data at specific times in the day (load balancing network usage). We will configure IoT Edge to support offline in case network drops and we will look into storing telemetry from sensors locally and configure for regular syncs at given times.

You will learn the different scenarios where IoT Edge device is on an enterprise network (needs proxy settings) or needs extended offline capabilities. 

## In this Lab

In this lab, you will:

1. Create an IoT Hub and Device ID
1. Deploy Azure IoT Edge Enabled Linux VM
1. Setup IoT Edge Parent with Child IoT Devices
1. Configure IoT Edge Device as Gateway
1. Open IoT Edge Gateway Device Inbound Ports using Azure CLI
1. Configure IoT Edge Device Time-to-Live and Message Storage
1. Connect Child IoT Device to IoT Edge Gateway
1. Test Device Connectivity and Offline Support
