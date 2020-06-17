# Write Code to Send and Receive Telemetry

At the end of this unit, you'll be sending and receiving telemetry.

# Create an app to send telemetry

1. To use C# in Visual Studio Code, ensure both [.NET Core](https://dotnet.microsoft.com/download), and the [C# extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp) are installed.

1. To open a terminal in Visual Studio Code, open the **Terminal** menu and click **New Terminal**.

1. In the terminal, to create a directory called "cheesecavedevice" and change the current directory to that directory, enter the following commands:

   ```bash
   mkdir cheesecavedevice
   cd cheesecavedevice
   ```

1. To create a new .NET console application. enter the following command in the terminal:

    ```bash
    dotnet new console
    ```

    This command creates a **Program.cs** file in your folder, along with a project file.

1. In the terminal, to install the required libraries. Enter the following commands:

    ```bash
    dotnet add package Microsoft.Azure.Devices.Client
    dotnet add package Microsoft.Azure.Devices.Shared
    dotnet add package Newtonsoft.Json
    ```

1. From the **File** menu, open up the **Program.cs** file, and delete the default contents.

    > [!NOTE] If you are unsure where the **Program.cs** file is located, enter the command `pwd` in the console to see the current directory.

1. After you've entered the code below into the **Program.cs** file, you can run the app with the command `dotnet run`. This command will run the **Program.cs** file in the current folder.

## Add Code to Send Telemetry

This section adds code to send telemetry from a simulated device. The device sends temperature (in degrees fahrenheit) and humidity (in percentages), regardless of whether any back-end app is listening or not.

1. If it isn't already open in Visual Studio Code, open the **Program.cs** file for the device app.

1. Copy and paste the following code:

    ```csharp
    // Copyright (c) Microsoft. All rights reserved.
    // Licensed under the MIT license. See LICENSE file in the project root for full license information.

    using System;
    using Microsoft.Azure.Devices.Client;
    using Microsoft.Azure.Devices.Shared;
    using Newtonsoft.Json;
    using System.Text;
    using System.Threading.Tasks;
    using Newtonsoft.Json.Linq;

    namespace simulated_device
    {
        class SimulatedDevice
        {
        // Global constants.
            const float ambientTemperature = 70;                    // Ambient temperature of a southern cave, in degrees F.
            const double ambientHumidity = 99;                      // Ambient humidity in relative percentage of air saturation.
            const double desiredTempLimit = 5;                      // Acceptable range above or below the desired temp, in degrees F.
            const double desiredHumidityLimit = 10;                 // Acceptable range above or below the desired humidity, in percentages.
            const int intervalInMilliseconds = 5000;                // Interval at which telemetry is sent to the cloud.

            // Global variables.
            private static DeviceClient s_deviceClient;
            private static stateEnum fanState = stateEnum.off;                      // Initial setting of the fan.
            private static double desiredTemperature = ambientTemperature - 10;     // Initial desired temperature, in degrees F.
            private static double desiredHumidity = ambientHumidity - 20;           // Initial desired humidity in relative percentage of air saturation.

            // Enum for the state of the fan for cooling/heating, and humidifying/de-humidifying.
            enum stateEnum
            {
                off,
                on,
                failed
            }

            // The device connection string to authenticate the device with your IoT hub.
            private readonly static string s_deviceConnectionString = "<your device connection string>";

            private static void colorMessage(string text, ConsoleColor clr)
            {
                Console.ForegroundColor = clr;
                Console.WriteLine(text);
                Console.ResetColor();
            }
            private static void greenMessage(string text)
            {
                colorMessage(text, ConsoleColor.Green);
            }

            private static void redMessage(string text)
            {
                colorMessage(text, ConsoleColor.Red);
            }

            // Async method to send simulated telemetry.
            private static async void SendDeviceToCloudMessagesAsync()
            {
                double currentTemperature = ambientTemperature;         // Initial setting of temperature.
                double currentHumidity = ambientHumidity;               // Initial setting of humidity.

                Random rand = new Random();

                while (true)
                {
                    // Simulate telemetry.
                    double deltaTemperature = Math.Sign(desiredTemperature - currentTemperature);
                    double deltaHumidity = Math.Sign(desiredHumidity - currentHumidity);

                    if (fanState == stateEnum.on)
                    {
                        // If the fan is on the temperature and humidity will be nudged towards the desired values most of the time.
                        currentTemperature += (deltaTemperature * rand.NextDouble()) + rand.NextDouble() - 0.5;
                        currentHumidity += (deltaHumidity * rand.NextDouble()) + rand.NextDouble() - 0.5;

                        // Randomly fail the fan.
                        if (rand.NextDouble() < 0.01)
                        {
                            fanState = stateEnum.failed;
                            redMessage("Fan has failed");
                        }
                    }
                    else
                    {
                        // If the fan is off, or has failed, the temperature and humidity will creep up until they reaches ambient values, thereafter fluctuate randomly.
                        if (currentTemperature < ambientTemperature - 1)
                        {
                            currentTemperature += rand.NextDouble() / 10;
                        }
                        else
                        {
                            currentTemperature += rand.NextDouble() - 0.5;
                        }
                        if (currentHumidity < ambientHumidity - 1)
                        {
                            currentHumidity += rand.NextDouble() / 10;
                        }
                        else
                        {
                            currentHumidity += rand.NextDouble() - 0.5;
                        }
                    }

                    // Check: humidity can never exceed 100%.
                    currentHumidity = Math.Min(100, currentHumidity);

                    // Create JSON message.
                    var telemetryDataPoint = new
                    {
                        temperature = Math.Round(currentTemperature, 2),
                        humidity = Math.Round(currentHumidity, 2)
                    };
                    var messageString = JsonConvert.SerializeObject(telemetryDataPoint);
                    var message = new Message(Encoding.ASCII.GetBytes(messageString));

                    // Add custom application properties to the message.
                    message.Properties.Add("sensorID", "S1");
                    message.Properties.Add("fanAlert", (fanState == stateEnum.failed) ? "true" : "false");

                    // Send temperature or humidity alerts, only if they occur.
                    if ((currentTemperature > desiredTemperature + desiredTempLimit) || (currentTemperature < desiredTemperature - desiredTempLimit))
                    {
                        message.Properties.Add("temperatureAlert", "true");
                    }
                    if ((currentHumidity > desiredHumidity + desiredHumidityLimit) || (currentHumidity < desiredHumidity - desiredHumidityLimit))
                    {
                        message.Properties.Add("humidityAlert", "true");
                    }

                    Console.WriteLine("Message data: {0}", messageString);

                    // Send the telemetry message.
                    await s_deviceClient.SendEventAsync(message);
                    greenMessage("Message sent\n");

                    await Task.Delay(intervalInMilliseconds);
                }
            }
            private static void Main(string[] args)
            {
                colorMessage("Cheese Cave device app.\n", ConsoleColor.Yellow);

                // Connect to the IoT hub using the MQTT protocol.
                s_deviceClient = DeviceClient.CreateFromConnectionString(s_deviceConnectionString, TransportType.Mqtt);

                SendDeviceToCloudMessagesAsync();
                Console.ReadLine();
            }
        }
    }
    ```

    > **Important:** Read through the comments in the code, noting how the temperature and humidity settings from the description of the scenario in the introduction have worked their way into the code.

1. Replace the `<your device connection string>` with the device connection string you saved off in the previous unit. No other lines of code need to be changed.

1. Save the **Program.cs** file.

## Test your Code to Send Telemetry

1. To run the app in the terminal, enter the following command:

    ```bash
    dotnet run
    ```

   This command will run the **Program.cs** file in the current folder.

1. You should quickly see console output, similar to the following:

    ![Console Output](../../Linked_Image_Files/M99-L15-cheesecave-telemetry.png)

    > [!NOTE] Green text is used to show things are working as they should and red text when bad stuff is happening. If you don't get a screen similar to this image, start by checking your device connection string.

1. Watch the telemetry for a short while, checking that it is giving vibrations in the expected ranges.

1. You can leave this app running, as it's needed for the next section.

## Create a Second App to Receive Telemetry

Now we have a device pumping out telemetry, we need to listen for that telemetry with a back-end app, also connected to our IoT Hub.

1. As the device app is running in a copy of Visual Studio Code, you will need to open a new instance of Visual Studio Code.

1. To open a terminal in Visual Studio Code, open the **Terminal** menu and click **New Terminal**.

1. In the terminal, to create a directory called "cheesecaveoperator" and change the current directory to that directory, enter the following commands:

   ```bash
   mkdir cheesecaveoperator
   cd cheesecaveoperator
   ```

1. To create a new .NET console application. enter the following command in the terminal:

    ```bash
    dotnet new console
    ```

    This command creates a **Program.cs** file in your folder, along with a project file.

1. In the terminal, to install the required libraries. Enter the following commands:

    ```bash
    dotnet add package Microsoft.Azure.EventHubs
    dotnet add package Microsoft.Azure.Devices
    dotnet add package Newtonsoft.Json
    ```

1. From the **File** menu, open up the **Program.cs** file, and delete the default contents.

    > [!NOTE] If you are unsure where the **Program.cs** file is located, enter the command `pwd` in the console to see the current directory.

1. After you've entered the code below into the **Program.cs** file, you can run the app with the command `dotnet run`. This command will run the **Program.cs** file in the current folder.

## Add Code to Receive Telemetry

This section adds code to receive telemetry from the IoT Hub Event Hub endpoint. 

1. If it isn't already open in Visual Studio Code, open the **Program.cs** file for the device app.

1. Copy and paste the following code:

    ```csharp
    // Copyright (c) Microsoft. All rights reserved.
    // Licensed under the MIT license. See LICENSE file in the project root for full license information.

    using System;
    using System.Threading.Tasks;
    using System.Text;
    using System.Collections.Generic;
    using System.Linq;

    using Microsoft.Azure.EventHubs;
    using Microsoft.Azure.Devices;
    using Newtonsoft.Json;

    namespace cheesecave_operator
    {
        class ReadDeviceToCloudMessages
        {
            // Global variables.
            // The Event Hub-compatible endpoint.
            private readonly static string s_eventHubsCompatibleEndpoint = "<your event hub endpoint>";

            // The Event Hub-compatible name.
            private readonly static string s_eventHubsCompatiblePath = "<your event hub path>";
            private readonly static string s_iotHubSasKey = "<your event hub Sas key>";
            private readonly static string s_iotHubSasKeyName = "service";
            private static EventHubClient s_eventHubClient;

            // Connection string for your IoT Hub.
            private readonly static string s_serviceConnectionString = "<your service connection string>";

            // Asynchronously create a PartitionReceiver for a partition and then start reading any messages sent from the simulated client.
            private static async Task ReceiveMessagesFromDeviceAsync(string partition)
            {
                // Create the receiver using the default consumer group.
                var eventHubReceiver = s_eventHubClient.CreateReceiver("$Default", partition, EventPosition.FromEnqueuedTime(DateTime.Now));
                Console.WriteLine("Created receiver on partition: " + partition);

                while (true)
                {
                    // Check for EventData - this methods times out if there is nothing to retrieve.
                    var events = await eventHubReceiver.ReceiveAsync(100);

                    // If there is data in the batch, process it.
                    if (events == null) continue;

                    foreach (EventData eventData in events)
                    {
                        string data = Encoding.UTF8.GetString(eventData.Body.Array);

                        greenMessage("Telemetry received: " + data);

                        foreach (var prop in eventData.Properties)
                        {
                            if (prop.Value.ToString() == "true")
                            {
                                redMessage(prop.Key);
                            }
                        }
                        Console.WriteLine();
                    }
                }
            }

            public static void Main(string[] args)
            {
                colorMessage("Cheese Cave Operator\n", ConsoleColor.Yellow);

                // Create an EventHubClient instance to connect to the IoT Hub Event Hubs-compatible endpoint.
                var connectionString = new EventHubsConnectionStringBuilder(new Uri(s_eventHubsCompatibleEndpoint), s_eventHubsCompatiblePath, s_iotHubSasKeyName, s_iotHubSasKey);
                s_eventHubClient = EventHubClient.CreateFromConnectionString(connectionString.ToString());

                // Create a PartitionReceiver for each partition on the hub.
                var runtimeInfo = s_eventHubClient.GetRuntimeInformationAsync().GetAwaiter().GetResult();
                var d2cPartitions = runtimeInfo.PartitionIds;

                // Create receivers to listen for messages.
                var tasks = new List<Task>();
                foreach (string partition in d2cPartitions)
                {
                    tasks.Add(ReceiveMessagesFromDeviceAsync(partition));
                }

                // Wait for all the PartitionReceivers to finish.
                Task.WaitAll(tasks.ToArray());
            }

            private static void colorMessage(string text, ConsoleColor clr)
            {
                Console.ForegroundColor = clr;
                Console.WriteLine(text);
                Console.ResetColor();
            }
            private static void greenMessage(string text)
            {
                colorMessage(text, ConsoleColor.Green);
            }

            private static void redMessage(string text)
            {
                colorMessage(text, ConsoleColor.Red);
            }
        }
    }
    ```

    > **Important:** Read through the comments in the code. Our implementation only reads messages after the back-end app has been started. Any telemetry sent prior to this isn't handled.

1. Replace the `<your device connection string>` with the device connection string you saved off in the previous unit. No other lines of code need to be changed.

1. Replace the `<your event hub endpoint>`, `<your event hub path>`, and the `<your event hub Sas key>` with the strings you saved off to your text file.

1. Save the **Program.cs** file.

## Test your Code to Receive Telemetry

This test is important, checking whether your back-end app is picking up the telemetry being sent out by your simulated device. Remember your device app is still running, and sending telemetry.

1. To run the app in the terminal, enter the following command:

    ```bash
    dotnet run
    ```

   This command will run the **Program.cs** file in the current folder.

   > [!NOTE] You can ignore the warning about the unused variable `s_serviceConnectionString` - we will be using that variable shortly.

1. You should quickly see console output, and immediately respond if it successfully connects to IoT Hub. If not, carefully check your IoT Hub service connection string, noting that this string should be the service connection string, and not any other.:

    ![Console Output](../../Linked_Image_Files/M99-L15-cheesecave-telemetry-received.png)

    > [!NOTE] Green text is used to show things are working as they should and red text when bad stuff is happening. If you don't get a screen similar to this image, start by checking your device connection string.

1. Watch the telemetry for a short while, checking that it is giving vibrations in the expected ranges.

1. You can leave this app running, as it's needed for the next section.

1. Visually compare the telemetry sent and received. Is there an exact match? Is there much of a delay? If it looks good, close both the console windows for now.

Completing this unit is great progress. you've an app sending telemetry from a device, and a back-end app acknowledging receipt of the data. This unit covers the monitoring side of our scenario. The next step handles the control side - what to do when issues arise with the data. Clearly, there are issues, we're getting temperature and humidity alerts!
