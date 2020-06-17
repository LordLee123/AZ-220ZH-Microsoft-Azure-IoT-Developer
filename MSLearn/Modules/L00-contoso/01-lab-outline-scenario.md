# Scenario Overview

In this course, we use Azure IoT platform services such as Azure IoT Hub, Device Provisioning Services, and the Azure IoT device SDKs to build a custom IoT solution from scratch. At the end of the course we will dive into IoT Central, which is a managed IoT application platform, to build and deploy a secure, enterprise-grade IoT solution.

Throughout this course, you will be acting in the role of an Azure IoT Developer helping to build multiple IoT Solutions. You are employed by Contoso, a global company that specializes in making and selling gourmet cheese. They are ready to start their own digital transformation journey to improve their processes across the whole company, which includes their cheese making process on the factory floor, fleeting management, and monitoring conditions of assets.

# Course Breakdown

## Getting Starting and Preparing Development Environment

**Getting Started with Azure IoT Services**

By this time you had an overview on working in the Azure Portal. Now it is time to setup your development environment and start learning who to build with Azure IoT platform services. Getting Started with Azure IoT Services will help you learn where you found your resources.

**Setup the Development Environment**

As one of the developers at Contoso, setting up your development environment is an important step before starting to build in IoT solution. Azure IoT offers multiple developer tools and support across top IDEs. 

## IoT Solution: Asset Condition Monitoring with Sensor Title

Contoso is known for producing the top quality of cheeses. Due to the company rapidly growing in popularity and sales, they want to ensure that their cheeses stay at the high level of quality they are known no matter if the cheese is in the factory floor or on its way to a customer. Contoso decides to deploy a new connect Sensor Tile product to add to their existing transport boxes.  

**The basics of connecting IoT devices to Azure**

Contoso is exploring adding a new device called a Sensor Tile to monitor the temperature and humidity batches of cheeses. You will be connecting a sensor tile to Azure IoT Hub, so you can remotely monitor asset condition (temperature,humidity).

## IoT Solution: Expanding Asset Condition Monitoring Solution with Asset Tracking 

Contsos is looking to grow the number of connect sensor tiles in transport boxes that monitors the condition of their cheeses being delivered to different customers and warehouses. On top of monitoring the temperature and pressure, we also want to track GPS data. 

**IoT device lifecycle from automatic provisioning to retirement with Device Provisioning Service**
 
In this scenario, we will want to use the sensor tiles for tracking location, temperature, pressure of transport box. When a new box enters the system at the warehouse, it is equipped with a new sensor tile. The sensor tile needs to be auto-provisioned to IoT Hub using Device Provisioning Service (DPS). When the box has arrived the sensor is removed from the box and needs to be "decommissioned" through Device Provisioning Service. 

**Automatically provision IoT devices securely and at scale with DPS**

Our asset tracking solution is getting bigger, provisioning devices one by one cannot scale, we want to use Device Provisioning Service to enroll many sensor tiles automatically and securely.

## Data Storage and Processing 

**Introduction to implementing lambda architecture for IoT solutions**

Building IoT Solutions, even a short test app, is going to require you to think about your storage options. If you're new to Azure, the range of resources available can be bewildering. We will be go through architectural concepts of cloud storage solutions, and how they relate to IoT applications. The most common storage options are described at a high level. You won't be asked to do any coding, nor build an app using the portal. 

**Route device messages in IoT Hub to analyze device streams in the cloud**

IoT Scenario: Preventive Maintenance for Conveyor Belt

At Contoso, packages of cheeses are assembled for shipping, then placed on a conveyor belt that takes the packages and drops them off in mailing bins. Your metric for success is the number of packages leaving the conveyor belt. 

You'll learn about Azure IoT Hub, IoT Hub message routing, Azure storage, Azure Stream Analytics, and how to call a built-in ML model. You'll achieve this knowledge by creating an IoT system to monitor and detect vibration anomalies in a conveyor belt. You will detect abnormal vibration levels that can let you know something is wrong, before any damage is caused. 

## Gathering Insights and business integration 

**Integrate IoT Hub with Event Grid**

IoT Scenario: Asset condition remote monitoring of warehouse thermostats 

Contoso wants to being able to remote monitor the thermostats in their storage warehouses that houses cheeses before they are shipped out.

You will build a solution that when the temperature spiked on one of the thermostats, the device sends a telemetry message that is of type "alert". When such a telemetry message arrives in IoT hub it is sent to Event Grid. We have a Logic Apps instance that will react on this event (on Event Grid) and will send an email (need to identify)

**Explore and analyze time stamped data with Time Series Insights**

IoT Scenario: Asset Condition Tracking 

Contoso is shipping cheese to more locations across the globe. Our Asset condition tracking revealed a spike in temperature for a specific asset, we want to find the root cause. We want to understand what happened: we correlate the asset tracking device's sensor data from transportation trucks and planes sensors. 

The temperature in one of the trucks rose and created the heat spike in the transport box: we will make sure transporter uses a truck that maintains temperature in the future.

## Introduction to Azure IoT Edge

**Introduction to Azure IoT Edge**

IoT Scenario: Conveyor Belt Anomaly Detection on the Edge

In our conveyor belt anomaly detection on vibration sensor is happening in the cloud. we want to run it closer to the sensor to respond more rapidly before a problem occurs (no cloud round trip). We will create a simple ASA job for IoT Edge and deploy onto an edge device attached to the conveyor belt.

**Setup an IoT Edge Gateway**

There are different ways to setup an IoT Edge. This lab will be theoretical and walks through the 2 use cases: transparent gateway and protocol translation.

## IoT Edge Solutions

**Develop, Deploy and debug a custom module on Azure IoT Edge**

Scenario: We have a warehouse with a conveyor belt and want to add a simple module to count objects detected on the belt by another object detection module (simulated) on the same IoT Edge device. We will show how to create a custom module that does the counting.

**Run an IoT Edge device in restricted network and offline**

Scenario: conveyor belt system monitors vibrations telemetry and counts objects. We want our system to be resilient to network outages and also optimize the bulk upload of telemetry data at specific times in the day (load balancing network usage). We will configure IoT Edge to support offline in case network drops and we will use Blob Storage module to store telemetry from sensors locally and configure for regular syncs at given times.

## Device Management

**Remotely monitor and control devices with Azure IoT Hub**

IoT Scenario: Monitoring Cheese Caves

Contoso is proud of its cheese, and is careful to maintain the perfect temperature and humidity of a natural cave that is used to age the cheese. There are sensors in the cave that report on the temperature and humidity. A remote operator can set a fan to new settings if needed, to maintain the perfect environment for the aging cheese. The fan can heat and cool, and humidify and de-humidify. In this scenario, you will be remotely monitoring and controlling the fan in different cheese cave global locations with different requirements.

**Automatic Device Management**

Scenario: Monitoring and Control System Updates

Now that Contoso has found success with the own digital transformation, they are looking to expand to not only selling cheese, but to start selling their solutions to other companies needing to monitor and control their own systems. 

Contoso is selling a simple wine cellar monitoring and control system (along with a service) has a new firmware for its devices that will improve the thermostat capabilities.

First the operator will implement a simple firmware update on a single device, then they will setup firmware update jobs to deploy the new firmware one customer at a time (all devices have a Device Twin tag with a customer ID in it).

**How to manage your Azure IoT Hub (use logs metrics and alerts in)**

**Detect your IoT device was tampered with and take action using Azure Security Center**

Contoso has built all their solutions with security in mind. However, they want to see how they can better get a unified view of security across all of their on-premises and cloud workloads, including their Azure IoT solutions. Plus, when onboarding new devices, we want to apply security policies across workloads (Leaf devices, Microsoft Edge devices, IoT Hub) to ensure compliance with security standards and improved security posture.

We will be enabling the Azure Security Center for IoT to be able to see securely in our end to end IoT solutions.

**Create your first IoT application in minutes**

TODO when we get the final thumbs up on tutorial

---

**Instructor Notes**
