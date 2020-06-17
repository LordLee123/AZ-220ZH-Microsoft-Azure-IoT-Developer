# Configure Device (C#)

In this unit you will configure a simulated device written in C# to connect to Azure IoT Hub using the Device ID and Shared Access Key created in the previous unit.

1. Using **Visual Studio Code**, open the `/LabFiles` folder.

2. Open the `SimulatedDevice.cs` file.

3. Locate the `s_connectionString` variable, and replace the value placeholder `{Your device connection string here}` with the **Device Connection String** that was copied previously. This will enable the Simulated Device to authenticate, connect, and communicate with the Azure IoT Hub.

    Once configured, the variable will look similar to the following:

    ```csharp
    private readonly static string s_connectionString = "HostName={IoTHubName}.azure-devices.net;DeviceId=SimulatedDevice1;SharedAccessKey={SharedAccessKey}";
    ```

4. In Visual Studio Code, click on the **View** menu, then click **Terminal** to open the _Terminal_ pane.

5. Run the following command within the **Terminal** to build and run the Simulated Device application. Be sure the terminal location is set to the directory with the `SimulatedDevice.cs` file.

    ```cmd/sh
    dotnet run
    ```

    > [!NOTE] If the command outputs a `Malformed Token` or other error message, then make sure the **Device Connection String** is configured correctly as the value of the `s_connectionString` variable.

6. Once the Simulated Device application is running, it will be sending event messages to the Azure IoT Hub that include `temperature` and `humidity` values.

    The terminal output will look similar to the following:

    ```text
    IoT Hub C# Simulated Device. Ctrl-C to exit.

    10/25/2019 6:10:12 PM > Sending message: {"temperature":27.714212817472504,"humidity":63.88147743599558}
    10/25/2019 6:10:13 PM > Sending message: {"temperature":20.017463779085066,"humidity":64.53511070671263}
    10/25/2019 6:10:14 PM > Sending message: {"temperature":20.723927165718717,"humidity":74.07808918230147}
    10/25/2019 6:10:15 PM > Sending message: {"temperature":20.48506045736608,"humidity":71.47250854944461}
    10/25/2019 6:10:16 PM > Sending message: {"temperature":25.027703996760632,"humidity":69.21247714628115}
    10/25/2019 6:10:17 PM > Sending message: {"temperature":29.867399432634656,"humidity":78.19206098010395}
    10/25/2019 6:10:18 PM > Sending message: {"temperature":33.29597232085465,"humidity":62.8990878830194}
    10/25/2019 6:10:19 PM > Sending message: {"temperature":25.77350195766124,"humidity":67.27347029711747}
    ```
