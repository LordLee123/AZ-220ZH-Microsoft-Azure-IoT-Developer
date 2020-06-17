# Create your first Azure IoT Central App

## Lab Scenario

Azure IoT Central enables the easy monitoring and management of a fleet of remote devices.
Azure IoT Central encompasses a range of underlying technologies that work great, but can be complicated to implement when many technologies are needed. These technologies include Azure IoT Hub, the Azure Device Provisioning System (DPS), Azure Maps, Azure Time Series Insights, Azure IoT Edge, and others. It's only necessary to use these technologies directly, if more granularity is needed than available through IoT Central.
One of the purposes of this lab is to help you decide if there's enough features in IoT Central to support the scenarios you are likely to need. So, let's investigate what IoT Central can do with a fun and involved scenario.

Contoso operates a fleet of refrigerated trucks. You've a number of customers within a city, and a base that you operate from. You command each truck to take its contents and deliver it to any one customer. However, the cooling system may fail on any one of your trucks, and if the contents does start to melt, you'll need the option of instructing the truck to return to base, and then dump the contents. Alternatively, you can deliver the contents to another customer who might be nearer to the truck when you become aware the contents are melting.

In order to make these decisions, you'll need an up-to-date picture of all that is going on with your trucks. You'll need to know the location of each truck on a map, the state of the cooling system, and the state of the contents.
IoT Central provides all you need to handle this scenario. In the following image, the colored circles show the location of the truck, on its way to a customer.

In this lab, you'll build the app displayed in the above image.

# In This Lab

In this lab you will:

* Create an Azure IoT Central custom app, using the IoT Central * portal
* Create a device template for a custom device, using the IoT * Central portal
* Create a programming project to simulate a refrigerated truck, with routes selected by Azure Maps, using Visual Studio Code, or Visual Studio
* Monitor and command the simulated device, from an IoT Central dashboard

# Prerequisite

* To use C# in Visual Studio Code, ensure both [.NET Core](https://dotnet.microsoft.com/download), and [C# extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp) are installed.