## Create new devices

Test your logic app by creating a new device to trigger an event notification email.

1. From your IoT hub, select **IoT Devices**.

2. Select **+ New**.

3. For **Device ID**, enter `CheeseCave1_Building1_Thermostat`.

4. Select **Save**.

5. You can add multiple devices with different device IDs to test the event subscription filters. Try these examples:

   * CheeseCave1_Building1_Thermostat
   * CheeseCave1_Building1_Light
   * CheeseCave2_Building1_Thermostat
   * CheeseCave2_Building2_Light

   If you added the four examples, your list of IoT devices should look like the following image:

   ![IoT Hub device list](../../Linked_Image_files/MM99-L09-iot-hub-device-list.png)

6. Once you've added a few devices to your IoT hub, check your email to see which ones triggered the logic app.
