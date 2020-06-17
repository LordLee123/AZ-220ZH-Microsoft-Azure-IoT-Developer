# Azure IoT Services

# Course Overview

In this course, we use Azure IoT platform services such as Azure IoT Hub, Device Provisioning Services, and the Azure IoT device SDKs to build a custom IoT solution from scratch. At the end of the course we will dive into IoT Central, which is managed IoT application platform, to build and deploy a secure, enterprise-grade IoT solution.

Through-out this course, you will be Azure IoT Developer for Contoso helping to build multiple IoT Solutions. Contoso is a global company who specializes in making and selling gourmet cheese. They are ready to start their own digital transformation journey to improve their processes across the whole company, which includes their cheesemaking process on the factory floor, fleeting management, and monitoring conditions of assets.

In this course, you will be learning how to build end-to-end IoT Solutions with Azure IoT Services and other services. Below is an overview of the labs including in the course:

## Introduction to IoT and Azure IoT Services

By this time you had an overview on working in the Azure Portal. Now it is time to setup your development environment and start learning how to build with Azure IoT platform services. Getting Started with Azure IoT Services will help you learn where you found your resources. The following labs will give an introduction to Azure and Azure IoT Services:

* Getting Started with Azure
* Getting Started with Azure IoT Services

## Devices and Device Communication

Before you get started you will be setting up your development environment, since this is an important step before starting to build in IoT solution. Azure IoT offers multiple developer tools and support across top IDEs to make device management easier. Next, you will be learning how to connect devices with Azure IoT Hub in an asset condition monitoring scenario. The following labs will get your started with devices and device communication:

* Setup the Development Environment
* The basics of connecting IoT devices to Azure

## Provisioning Devices

In an Asset tracking solution, we use sensors for tracking location, temperature, pressure of transport box. When a new box enters the system, it is equipped with a new sensor. The sensor needs to be auto-provisioned to IoT Hub (using DPS). When the box has arrived the sensor is removed from the box and needs to be "decommissioned" through DPS. In the following labs, learn how to provision your devices with Device Provisioning Service:

* IoT device lifecycle from automatic provisioning to retirement with DPS
* Automatically provision IoT devices securely and at scale with DPS

## Data Storage and Processing

The useful aspects of the data captured by the IoT devices, made possible by data processing and analytics capabilities. This can include “hot path” data that is analyzed in real time, and “cold path” data that is stored for batch processing later. The following labs will go over different storage options are best for different IoT solutions and how to analyze data to start gathering insights:

* Introduction to implementing lambda architecture for IoT solutions
* Route device messages in IoT Hub to analyze device streams in the cloud

## Insights and Business Integration

Actions is what you ultimately do with the data, whether presenting it through a visualization tool, alerting a human to do something, connecting to a business process, or sending a message back to the device. In the following labs, you will build a couple IoT solutions that allow you to drive insights based on the data you collected and follow-up with actions that will positively impact your business's processes:

* Integrate IoT Hub with Event Grid
* Explore and analyze time stamped data with Time Series Insights

## Introduction to Azure IoT Edge

In modern IoT solutions, data processing can occur in the cloud or on the device side. Device-side processing is referred to as “edge computing.” In the following labs, you will be learning the basics of enabling parts of your workload to the edge, reducing time spent by devices sending messages to the cloud and enabling faster reactions to status changes:

* Introduction to Azure IoT Edge
* Setup an IoT Edge Gateway

## IoT Edge Solutions

Not all IoT solutions are in ideal environments or require faster response times. In the following labs, you will create an IoT solution the requires processing on the edge and you will learn how to build solutions in extended offline environments.

* Develop, Deploy and debug a custom module on Azure IoT Edge
* Run an IoT Edge device in restricted network and offline

## Device Management

There are five stages within the IoT device lifecycle—plan, provision, configure, monitor, and retire. In the following labs, you will learn how to monitor and control devices. Plus how to automate the process.

* Remotely monitor and control devices with Azure IoT Hub
* Automatic Device Management

How to manage your Azure IoT Hub (use logs metrics and alerts in)

## IoT Security

Through-out the whole course you be focusing on securely building end-to-end IoT solutions. To add an extra level of end-to-end security for your IoT solutions, Azure Security Center for IoT simplifies hybrid workload protection by delivering unified visibility and control, adaptive threat prevention, and intelligent threat detection and response across workloads running on edge, on-premises, in Azure, and in other clouds. In the following lab, you will be building enabling the Azure IoT Security Center to your IoT Solution.

* Detect your IoT device was tampered with and take action using Azure Security Center

## Build with IoT Central

At Contoso, your team wants to explore building with IoT Central to reduces the burden and cost of developing, managing, and maintaining enterprise-grade IoT solutions. Choosing to build with IoT Central gives you the opportunity to focus time, money, and energy on transforming your business with IoT data, rather than just maintaining and updating a complex and continually evolving IoT infrastructure. In the following lab, you will learn how to build an IoT solution using IoT Central.

* Create your first IoT application in minutes
