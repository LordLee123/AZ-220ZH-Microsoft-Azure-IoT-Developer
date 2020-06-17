# Remotely monitor and control devices with Azure IoT Hub (L15)

## Lab Scenario

Suppose you manage a gourmet cheese making company in a southern location. The company is proud of its cheese, and is careful to maintain the perfect temperature and humidity of a natural cave that is used to age the cheese. There are sensors in the cave that report on the temperature and humidity. A remote operator can set a fan to new settings if needed, to maintain the perfect environment for the aging cheese. The fan can heat and cool, and humidify and de-humidify.

Caves are used to mature cheese, their constant temperature, humidity, and air flow make them nearly ideal for the process. Not to mention the cachet of having your cheese products mature in a natural cave, instead of a constructed cellar. Something to put on your product labels!

The accepted ideal temperature for aging cheese is 50 degrees fahrenheit (10 degrees centigrade), with up to 5 degrees (2.78 degrees C) either side of this being acceptable. Humidity is also important. Measured in percentage of maximum saturation, a humidity of between 75 and 95 percent is considered fine. We'll set 85 percent as the ideal, with a 10 percent variation as acceptable. These values apply to most cheeses. To achieve specific results, such as a certain condition of the rind, cheese makers will adjust these values for some of the time during aging.

In a southern location, a natural cave near the surface might have an ambient temperature of around 70 degrees. The cave might also have a relative humidity of close to 100 percent, because of water seeping through the roof. These high numbers aren't perfect conditions for aging cheese. At a more northerly location, the ambient temperature of a natural cave can be the ideal of 50 degrees. Because of our location, we need some Azure IoT intervention!

In this lab you will:

* Create a custom Azure IoT Hub, using the IoT Hub portal
* Create an IoT Hub device ID, using the IoT Hub portal
* Create an app to send device telemetry to the custom IoT Hub, in C# or Node.js
* Create a back-end service app to listen for the telemetry
* Implement a direct method, to communicate settings to the remote device
* Implement device twins, to maintain remote device properties

## Links

- [Understand extended offline capabilities for IoT Edge devices, modules, and child devices](https://docs.microsoft.com/en-us/azure/iot-edge/offline-capabilities)

## Prerequisites

1. An introductory knowledge of Azure IoT
1. Ability to navigate the Azure IoT portal
1. Ability to use Node.js, or C#, at the beginner level
1. Experience using Visual Studio, or Visual Studio Code, at the beginner level

## Steps

1. Create an Azure ioT Hub, and Device Id, using the Microsoft Azure Portal
1. Write code to send and receive telemetry
1. Write code to invoke a direct method
1. Write code for device twins

