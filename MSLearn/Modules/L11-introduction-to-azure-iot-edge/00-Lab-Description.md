# Introduction to Azure IoT Edge

## Lab Scenario

Contoso has cheese producing factories worldwide. Factories are equipped with production lines have multiple machines to create their cheeses. At the moment they have IoT devices connected to each machine that streams sensor data to Azure and processes all data in the cloud. Due to the large amount of data being collected and urgent time response needed on some of the machines, Contoso's wants to add a gateway device to bring the intelligence to the edge for processing data to the only send important data to the cloud. Plus, be able to process data and react quickly even if the local network is poor.

You will be setting up a new IoT Edge device that can monitor temperature of one of the machines and deploying Stream Analytics module to calculate the average temperature and send an alert to the device to act quickly.

## In This Lab

* Deploy Azure IoT Edge Enabled Linux VM
* Create IoT Edge Device Identity in IoT Hub using Azure CLI
* Connect IoT Edge Device to IoT Hub
* Add Edge Module to Edge Device
* Deploy Azure Stream Analytics as IoT Edge Module
