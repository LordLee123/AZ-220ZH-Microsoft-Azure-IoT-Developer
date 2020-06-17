# Automatically provision IoT devices securely and at scale with DPS

## Lab Scenario

Our asset tracking solution is getting bigger, and provisioning devices one by one cannot scale. We want to use Device Provisioning Service to enroll many devices automatically and securely using x.509 certificate authentication.

## In This Lab

In this lab, you will setup a Group Enrollment within Device Provisioning Service (DPS) using a Root CA x.509 certificate chain. You will also configure a simulated IoT Device that will authenticate with DPS using a Device CA Certificate generated on the Root CA Certificate chain. The IoT Device will also be configured to handle changes to the Device Twin Desired Property state as configured initially through DPS, and modified via Azure IoT Hub. Finally, you will retire the IoT Device and the Group Enrollment with DPS. Tasks in lab includes:

* Generate and Configure x.509 CA Certificates using OpenSSL
* Create Group Enrollment in DPS
* Configure Simulated Device with x.509 Certificate
* Handle Device Twin Desired Property Changes
* Automatic Enrollment of Simulated Device
* Retire Group Enrollment of Simulated Device
