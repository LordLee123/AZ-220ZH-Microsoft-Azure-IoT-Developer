# Run Simulated IoT Devices

In this unit, you will run the Simulated Thermostat device so it starts sending telemetry events to Azure IoT Hub.

1. Within **Visual Studio Code**, open the **LabFiles** directory for this unit.

1. Open the **DeviceSimulation.cs** file.

1. Locate the variable for the Container, Truck, and Airplane **Connection Strings**, and change their values to the **Azure IoT Hub Connection Strings** for the IoT Devices registered in IoT Hub.

    ```csharp
    private readonly static string connectionString_Truck = "{Your Truck device connection string here}";
    private readonly static string connectionString_Airplane = "{Your Airplane device connection string here}";
    private readonly static string connectionString_Container = "{Your Container device connection string here}";
    ```

    Be sure to replace the `{Your XXXX device connection string here}` placeholder with the IoT Device Connection String that was copied previously for that IoT Device.

1. Within **Visual Studio Code**, open the **Terminal** pane by clicking the **View** menu, then selecting **Terminal**.

1. Within the **Terminal** pane, navigate to the directory for the `/LabFiles` directory for this unit.

1. Within the **Terminal** execute the following command to build and run the **DeviceSimulation** app.

    ```cmd/sh
    dotnet run
    ```

1. Once the **SimulatedThermostat** device is running, it will begin outputting telemetry data to the Terminal. This will be the telemetry data that it is sending to Azure IoT Hub.

    The **Terminal** output when the **DeviceSimulation** app is running will look similar to the following:

    ```text
    12/27/2019 8:51:30 PM > Sending TRUCK message: {"temperature":35.15660452608195,"humidity":48.422323938240865}
    12/27/2019 8:51:31 PM > Sending AIRPLANE message: {"temperature":17.126545186374237,"humidity":36.46941012936869}
    12/27/2019 8:51:31 PM > Sending CONTAINER message: {"temperature":21.986403302500637,"humidity":47.847680384455096}
    12/27/2019 8:51:32 PM > Sending TRUCK message: {"temperature":36.10474464823629,"humidity":48.82029906486022}
    12/27/2019 8:51:32 PM > Sending AIRPLANE message: {"temperature":16.55005930170971,"humidity":36.49988437459935}
    12/27/2019 8:51:32 PM > Sending CONTAINER message: {"temperature":21.811727088543286,"humidity":50.0}
    ```

1. Leave the **DeviceSimulation** app running for the remaining duration of this lab. This will ensure device telemetry from the three devices (Container, Truck, and Airplane) remain being sent to Azure IoT Hub.

1. Once the **DeviceSimulation** app is running for greater than 30 seconds, you will see output that the **Container** device is changing transport methods between **Truck** and **Airplane** every 30 seconds. The **Terminal** output will look like the following when this happens:

    ```text
    12/27/2019 8:51:40 PM > CONTAINER transport changed to: TRUCK
    ```

    > [!NOTE] In production the shipping container would on change transport methods during the normal course of shipping. For the simulated scenario in this lab, it's performed every 30 seconds to give a short enough data duration that will fit during the course of performing the steps in this lab.
