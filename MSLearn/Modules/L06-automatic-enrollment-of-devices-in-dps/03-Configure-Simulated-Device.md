# Configure Simulated Device with x.509 certificate

In this unit, you will configure a Simulated Device written in C# to connect to Azure IoT Hub via Device Provisioning Service (DPS) using an x.509 certificate. This unit will also introduce you to the workflow within the **Simulated Device** source code within the `/LabFiles` directory, and how it works to authenticate with DPS and send messages to IoT Hub.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Open the Azure Cloud Shell by clicking the **Terminal** icon within the top header bar of the Azure portal, and select the **Bash** shell option.

1. Within the **Azure Cloud Shell**, navigate to the `~/certificates` directory by running the following command:

    ```sh
    cd ~/certificates
    ```

    The `~/certificates` directory is where the `certGen.sh` helper scripts was downloaded to and used to generate the CA Certificate for DPS previously. This helper script will also be used to generate a device certificate within the CA Certificate chain.

1. Run the following command to generate an **x.509 Device Certificate** within the CA Certificate chain with the device name of `simulated-device1`. This certificate will generate a leaf device x.509 certificate for the Simulated Device. This certificate will be signed by the CA Certificate generated previously, and will be used to authenticate the device with the Device Provisioning Service (DPS).

    ```sh
    ./certGen.sh create_device_certificate simulated-device1
    ```

    Notice the **Device Name** of `simulated-device1` is passed to the `create_device_certificate` command of the `certGen.sh` script. This command will create a new x.509 certificate that's signed by the CA Certificate and has the specified **Device Name** set within the **Common Name**, or `CN=`, value of the **Device Certificate**.

1. Once the `create_device_certificate` command has completed, then generated **x.509 Device Certificate** will be named `new-device.cert.pfx` and will be located within the `/certs` sub-directory.

    > [!NOTE] This command overwrites the existing certificate. If you want to create a certificate for multiple devices, ensure you copy the `new-device.cert.pfx` each time.

    Run the following command to download the generated **x.509 Device Certificate** from the Cloud Shell to your local machine:

    ```sh
    download ~/certificates/certs/new-device.cert.pfx
    ```

    The Simulated Device will be configured to use this **x.509 Device Certificate** to authenticate with the Device Provisioning Service.

1. Within the Azure portal, navigate to the **Device Provisioning Service** blade, and the **Overview** pane.

1. Within the Overview pane, copy the **ID Scope** for the **Device Provisioning Service**, and save it for reference later.

    The **ID Scope** will be similar to this value: `0ne0004E52G`

1. Copy the downloaded `new-device.cert.pfx` **x.509 Device Certificate** file to the `/LabFiles` directory; within the root directory along-side the `Program.cs` file. The **Simulated Device** project will need to access this certificate file when authenticating to the Device Provisioning Service.

    After copied, the certificate file will be located in the following location:

    ```text
    /LabFiles/new-device.cert.pfx
    ```

1. Using **Visual Studio Code**, open the `/LabFiles` folder.

1. Open the `SimulatedDevice.csproj` file.

1. Within the `SimulatedDevice.csproj` file, ensure the following block of XML exists within the file. This configuration ensures that the `new-device.cert.pfx` certificate file is copied to the build folder when the C# code is compiled, and made available for the program to access when it executes.

    ```xml
        <ItemGroup>
            <None Update="new-device.cert.pfx" CopyToOutputDirectory="PreserveNewest" />
        </ItemGroup>
    ```

    If it's not there, then paste it in before the closing `</Project>` tag. The end of the file should look similar to the following:

    ```xml
            <ItemGroup>
                <None Update="new-device.cert.pfx" CopyToOutputDirectory="PreserveNewest" />
            </ItemGroup>
        </Project>
    ```

1. Open the `Program.cs` file.

1. Locate the `GlobalDeviceEndpoint` variable, and notice it's value is set to `global.azure-devices-provisioning.net`. This is the **Global Device Endpoint** for the Azure Device Provisioning Service (DPS) within the Public Azure Cloud. All devices connecting to Azure DPS will be configured with this Global Device Endpoint DNS name.

    ```csharp
    private const string GlobalDeviceEndpoint = "global.azure-devices-provisioning.net";
    ```

1. Locate the `dpsIdScope` variable, and replace the value with the **ID Scope** of the Device Provisioning Service.

   ```csharp
   private static string dpsIdScope = "<DPS-ID-Scope>";
   ```

1. Locate the `s_certificateFileName` variable. Notice the value to this variable is set to `new-device.cert.pfx`. This is the name of the **x.509 Device Certificate** file that was copied to the `/LabFiles` directory after it was previously generated using the `certGen.sh` helper script within the Cloud Shell. This variable tells the Simulated Device program code what file contains the x.509 Device Certificate to use when authenticating with the Device Provisioning Service.

1. Locate the `s_certificatePassword` variable. This variable contains the **Password** for the **x.509 Device Certificate**. Notice that it's already set to `1234`, as this is the default password used by the `certGen.sh` helper script when generating the x.509 certificates.

    > [!NOTE] For the purpose of this unit, the **Password** is hard coded. In a _Production_ device, the password will need to be stored in a more secure manner. Additionally, the certificate file (PFX) should be stored securely on a production device using a Hardware Security Module (HSM).
    >
    > An HSM (Hardware Security Module), is used for secure, hardware-based storage of device secrets, and is the most secure form of secret storage. Both X.509 certificates and SAS tokens can be stored in the HSM. HSMs can be used with both attestation mechanisms the provisioning service supports.

1. Locate the `public static int Main` method. This is the execution entry for the **Simulated Device**

    This method contains code that initiates the use of the **x.509 Device Certificate** by calling the `LoadProvisioningCertificate` method to load the certificate. The `LoadProvisioningCertificate` method returns an `X509Certificate2` object that contains the **x.509 Device Certificate** from the `new-device.cert.pfx` file.

1. Locate the `LoadProvisioningCertificate` method, and review the necessary code to load an **x.509 Certificate** from the `new-device.cert.pfx` file.

1. Notice the `public static int Main` method also contains code that initiates a **Security** `SecurityProviderX509Certificate` object for the x.509 Device Certificate. It also creates a **Transport** `ProvisioningTransportHandlerAmqp` object that defines the Simulated Device will be using **AMQP** as the communications protocol when connecting to Azure IoT Hub.

1. Notice the `ProvisioningDeviceClient.Create` method is passed the **Security** and **Transport** object, as well as the **DPS ID Scope** and **DPS Global Device Endpoint**,  that will be used to register the device with the Device Provisioning Service.

1. Notice the `ProvisioningDeviceLogic` object is instantiated by passing it the **ProvisioningDeviceClient** and **Security** objects.

    The `ProvisioningDeviceLogic` is a class define within the **Simulated Device** that contains code for the device logic. It contains code for running the device by reading from the simulated device sensors, and sending Device-to-Cloud messages to Azure IoT Hub. It will also be modified later to contain code that updates the device according to changes to Device Twin Desired Properties that are sent to the device from the cloud.

1. Locate the `ProvisioningDeviceLogic.RunAsync` method.

1. Notice the code that calls the `ProvisioningDeviceClient.RegisterAsync` method. This method Registers the device using the **Device Provisioning Service** and assigns it to an **Azure IoT Hub**.

    ```csharp
    DeviceRegistrationResult result = await _provClient.RegisterAsync().ConfigureAwait(false);
    ```

1. Notice the code that instantiates a new `DeviceAuthenticationWithX509Certificate` object. This is a Device Authentication object that will be used to authenticate the Simulated Device to **Azure IoT Hub** using the **x.509 Device Certificate**. The constructor is being passed the **DeviceId** for the device that was registered in DPS, as well as the **x.509 Device Certificate** to authenticate the device.

    ```csharp
    var auth = new DeviceAuthenticationWithX509Certificate(result.DeviceId, (_security as SecurityProviderX509).GetAuthenticationCertificate());
    ```

1. Notice the code that calls the `DeviceClient.Create` method to create a new **IoT Device Client** object that is used to communicate with the Azure IoT Hub service.

    ```csharp
    using (iotClient = DeviceClient.Create(result.AssignedHub, auth, TransportType.Amqp))
    {
    ```

    Notice this code also passes the value of `TransportType.Amqp` telling the **DeviceClient** to communicate with the Azure IoT Hub using the AMQP protocol. Alternatively, Azure IoT Hub can be connected to and communicated with using MQTT or HTTP protocols as well.

1. Notice the call to the `SendDeviceToCloudMessagesAsync` method. This is a method defined within the Simulated Device code, and is where the device logic is located to read from simulated sensors and to send Device-to-Cloud messages to Azure IoT Hub. This method also contains a loop that continues to execute while the Simulated Device is running.

    ```csharp
    await SendDeviceToCloudMessagesAsync(iotClient);
    ```

1. Notice the call to the `DeviceClient.CloseAsync` method. This method closes **DeviceClient** object, and closes the connection with Azure IoT Hub. This is the last line of code executed when the Simulated Device shuts down.

    ```csharp
    await iotClient.CloseAsync().ConfigureAwait(false);
    ```

1. Locate the `SendDeviceToCloudMessagesAsync` method.

1. Notice the code within the `SendDeviceToCloudMessagesAsync` method contains a `while` loop that has code to generate simulated sensor readings, and then send that data to Azure IoT Hub in a Device-to-Cloud message.

1. Notice the simulated sensor readings are combined into a JSON object using the following code:

    ```csharp
        var telemetryDataPoint = new
        {
            temperature = currentTemperature,
            humidity = currentHumidity,
            pressure = currentPressure,
            latitude = currentLatitude,
            longitude = currentLongitude
        };
        var messageString = JsonConvert.SerializeObject(telemetryDataPoint);
        var message = new Message(Encoding.ASCII.GetBytes(messageString));

    ```

1. Notice there is a line of code that adds a `temperatureAlert` property to the Device-to-Cloud **Message**. The value of the property is being set to a `boolean` value representing whether the _temperature_ sensor reading is greater than 30.

    ```csharp
    message.Properties.Add("temperatureAlert", (currentTemperature > 30) ? "true" : "false");
    ```

    This code is a simple example of how to add properties to the **Message** object before sending it to the Azure IoT Hub. This can be used to add additional metadata to the messages that are being send, in addition to the message body content.

1. Notice the call to the `DeviceClient.SendEventAsync` method. This method accepts the **Message** to send as a parameter, then does the work of sending the Device-to-Cloud message to Azure IoT Hub.

    ```csharp
    await deviceClient.SendEventAsync(message);
    ```

1. Notice the last line of code within the `SendDeviceToCloudMessagesAsync` method, that performs a simply delay using the `_telemetryDelay` variable to define how many seconds to wait until sending the next simulated sensor reading.
