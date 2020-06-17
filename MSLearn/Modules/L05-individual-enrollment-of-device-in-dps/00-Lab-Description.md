# Individual Enrollment of Device in DPS

## Lab Scenario

Contoso's Asset Monitoring and Tracking Solution will require an IoT Device that has sensors for tracking location, temperature, pressure to be added in product transport boxes. This will help track products and monitor the  condition of the transport boxes to ensure the cheese products are kept in appropriate environments during delivery.

When a new box enters the system, it is equipped with the new IoT Device. The device needs to be auto-provisioned to IoT Hub using Device Provisioning Service. When the box has arrived the sensor is removed from the box and needs to be "decommissioned" through DPS.

## In This Lab

In this lab, you will, create an Individual Enrollment within Azure Device Provisioning Service (DPS) to automatically connect a pre-built simulated device to Azure IoT Hub highlighted in the picture below. You will also fully retire the device by removing it from both DPS and IoT Hub.

![Lab DPS steps](../../Linked_Image_files/MM99_L05_L06_DPS_Solution.PNG)

Tasks include:

* Create New Individual Enrollment in DPS
* Configure Simulated Device
* Test Simulated Device
* Retire the Device
