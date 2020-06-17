# Write Code to Invoke a Direct Method

In this unit, we'll add code to the device app for a direct method to turn on the fan. Next, we add code to the back-end service app to invoke this direct method.

## Add Code to Define a Direct Method in the Device App

1. Return to the Visual Studio Code instance that is running the **cheesecavedevice** app.

1. If the app is still running, place input focus on the terminal and press **CTRL+C** to exit the app.

1. In the editor, ensure **Program.cs** is open.

1. To define the direct method, add the following code at the end of the **SimulatedDevice** class:

    ```csharp
    // Handle the direct method call
    private static Task<MethodResponse> SetFanState(MethodRequest methodRequest, object userContext)
    {
        if (fanState == stateEnum.failed)
        {
            // Acknowledge the direct method call with a 400 error message.
            string result = "{\"result\":\"Fan failed\"}";
            redMessage("Direct method failed: " + result);
            return Task.FromResult(new MethodResponse(Encoding.UTF8.GetBytes(result), 400));
        }
        else
        {
            try
            {
                var data = Encoding.UTF8.GetString(methodRequest.Data);

                // Remove quotes from data.
                data = data.Replace("\"", "");

                // Parse the payload, and trigger an exception if it's not valid.
                fanState = (stateEnum)Enum.Parse(typeof(stateEnum), data);
                greenMessage("Fan set to: " + data);

                // Acknowledge the direct method call with a 200 success message.
                string result = "{\"result\":\"Executed direct method: " + methodRequest.Name + "\"}";
                return Task.FromResult(new MethodResponse(Encoding.UTF8.GetBytes(result), 200));
            }
            catch
            {
                // Acknowledge the direct method call with a 400 error message.
                string result = "{\"result\":\"Invalid parameter\"}";
                redMessage("Direct method failed: " + result);
                return Task.FromResult(new MethodResponse(Encoding.UTF8.GetBytes(result), 400));
            }
        }
    }
    ```

    > [!NOTE] This code defines the implementation of the direct method and is executed when the direct method is invoked. The fan has three states: *on*, *off*, and *failed*. The method above sets the fan to either of the first two of these states. If the payload text doesn't match one of these two, or the fan is in a failed state, an error is returned.

1. To register the direct method, add the following lines of code to the Main method, after creating the device client.

    ```csharp
    // Create a handler for the direct method call
    s_deviceClient.SetMethodHandlerAsync("SetFanState", SetFanState, null).Wait();
    ```

    The modified **Main** method should look like:

    ```csharp
    private static void Main(string[] args)
    {
        colorMessage("Cheese Cave device app.\n", ConsoleColor.Yellow);

        // Connect to the IoT hub using the MQTT protocol.
        s_deviceClient = DeviceClient.CreateFromConnectionString(s_deviceConnectionString, TransportType.Mqtt);

        // Create a handler for the direct method call
        s_deviceClient.SetMethodHandlerAsync("SetFanState", SetFanState, null).Wait();

        SendDeviceToCloudMessagesAsync();
        Console.ReadLine();
    }
    ```

1. Save the **Program.cs** file.

You've completed what is needed at the device end of things. Next, we need to add code to the back-end service.

## Add Code to Call a Direct Method in the Back End App

1. Return to the Visual Studio Code instance that is running the **cheesecaveoperator** app.

1. If the app is still running, place input focus on the terminal and press **CTRL+C** to exit the app.

1. In the editor, ensure **Program.cs** is open.

1. Add the following line to the global variables at the top of the **ReadDeviceToCloudMessages** class:

    ```csharp
    private static ServiceClient s_serviceClient;
    ```

1. Add the following task to the **ReadDeviceToCloudMessages** class, after the **Main** method:

    ```csharp
    // Handle invoking a direct method.
    private static async Task InvokeMethod()
    {
        try
        {
            var methodInvocation = new CloudToDeviceMethod("SetFanState") { ResponseTimeout = TimeSpan.FromSeconds(30) };
            string payload = JsonConvert.SerializeObject("on");

            methodInvocation.SetPayloadJson(payload);

            // Invoke the direct method asynchronously and get the response from the simulated device.
            var response = await s_serviceClient.InvokeDeviceMethodAsync("CheeseCaveID", methodInvocation);

            if (response.Status == 200)
            {
                greenMessage("Direct method invoked: " + response.GetPayloadAsJson());
            }
            else
            {
                redMessage("Direct method failed: " + response.GetPayloadAsJson());
            }
        }
        catch
        {
            redMessage("Direct method failed: timed-out");
        }
    }
    ```

    > [!NOTE] This code is used to invoke the **SetFanState** direct method on the device app.

1. Add the following code to the **Main** method, before creating the receivers to listen for messages:

    ```csharp
    // Create a ServiceClient to communicate with service-facing endpoint on your hub.
    s_serviceClient = ServiceClient.CreateFromConnectionString(s_serviceConnectionString);
    InvokeMethod().GetAwaiter().GetResult();
    ```

    > [!NOTE] This code creates the client we used to connect to the IoT Hub so we can invoke the direct method on the device.

1. Save the **Program.cs** file.

You have now completed the code changes to support the **SetFanState** direct method.

## Test the direct method

To test the method, start the apps in the correct order. We can't invoke a direct method that hasn't been registered!

1. Start the **cheesecavedevice** device app. It will begin writing to the terminal, and telemetry will appear.

1. Start the **cheesecaveoperator** back-end app. This app immediately calls the direct method. Do you notice it's handled by the back-end app, with output similar to the following?

    > [!NOTE] If you see the message `Direct method failed: timed-out` then double check you have saved the changes in the **cheesecavedevice** and started the app.

    ![Console Output](../../Linked_Image_Files/M99-L15-cheesecave-direct-method-sent.png)

1. Now check the console output for the **cheesecavedevice** device app, you should see that the fan has been turned on.

   ![Console Output](../../Linked_Image_Files/M99-L15-cheesecave-direct-method-received.png)

You are now successfully monitoring and controlling a remote device. We have turned on the fan, which will slowly move the environment in the cave to our initial desired settings. However, we might like to remotely specify those desired settings. We could specify desired settings with a direct method (which is a valid approach). Or we could use another feature of IoT Hub, called device twins. Let's look into the technology of device twins.
