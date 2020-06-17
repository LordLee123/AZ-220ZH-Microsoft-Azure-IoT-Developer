# Develop, Deploy and debug a custom module on Azure IoT Edge with VS Code

## Lab Scenario

Contoso's warehouse moves inventory that is ready to be packed for delivery on a conveyor belt.

In order to make sure the correct amount of products have been packed, you will add a simple module to count objects detected on the belt by another object detection module (simulated) on the same IoT Edge device. We will show how to create a custom module that does object counting.

## In This Lab

IoT Edge solution development in VS Code

- Create Container Registry
- Create and customize an Edge module
- Deploy modules to Edge device

## Prerequisites

- Visual Studio Code with the following extensions installed:
  - [Azure IoT Tools](https://marketplace.visualstudio.com/items?itemName=vsciot-vscode.azure-iot-tools) by Microsoft
  - [C#](https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp) by Microsoft
  - [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
- Docker Community Edition installed on development machine
  - [Download Docker Desktop for Mac and Windows](https://www.docker.com/products/docker-desktop)
