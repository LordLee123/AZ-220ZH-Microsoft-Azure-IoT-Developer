---
lab:
    title: 'Lab 09: Integrate IoT Hub with Event Grid'
    module: 'Module 5: Insights and Business Integration'
---

# Integrate IoT Hub with Event Grid

## Lab Scenario

Contoso is installing new connected Thermostats to be able to monitor temperature across different cheese caves. You will create an alert to notify facilities manager when a new thermostat has been created.

To create an alert, you will push device created event type to Event Grid when a new thermostat is created in IoT Hub. You will have a Logic Apps instance that will react on this event (on Event Grid) and will send an email to alert a facilities manager device a new device has been created, device ID, and connection state.

## In This Lab

* Verify Lab Prerequisites
* Create Logic App that sends an email
* Configure Azure IoT Hub Event Subscription
* Create new devices triggering a Logic Apps which sends an email when alert is flagged by device

## Exercise 1: Verify Lab Prerequisites

## Exercise 2: Create HTTP Web Hook Logic App that sends an email

Azure Logic Apps is a cloud service that helps you schedule, automate, and orchestrate tasks, business processes, and workflows when you need to integrate apps, data, systems, and services across enterprises or organizations.

In this exercise, you will create a new Azure Logic App that will be triggered via an HTTP Web Hook, then send an email using an Outlook.com email address.

1. Login to [portal.azure.com](https://portal.azure.com) using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. In the Azure Portal, click **+ Create a resource** to open the Azure Marketplace.

1. On the **New** blade, in the **Search the Marketplace** box, type in and search for **Logic App**.

1. In the search results, select the **Logic App** item.

1. On the **Logic App** item, click **Create**.

2. On the **Logic App** blade, in the **Name** field, enter **AZ-220-LogicApp-_{YOUR-ID}_**.

    For example: **AZ-220-LogicApp-CP191218**

    The name of your Azure Logic App must be globally unique because it is a publicly accessible resource that you must be able to access from any IP connected device.

3. In the **Resource group** dropdown, select **Use Existing**, then select the **AZ-220-RG** resource group.

4. In the **Location** dropdown, choose the same Azure region that was used for the resource group.

5. Leave **Log Analytics** set to **Off**.

6. Click **Create**.

    > [!NOTE] It will take a minute or two for the Logic App deployment to complete.

7. Navigate to the **Logic App** resource that was just deployed.

8. When navigating to the **Logic App** for the first time, the **Logic Apps Designer** pane will be displayed.

    If this doesn't come up automatically, click on the **Logic app designer** link under the **Development Tools** section on the **Logic App** blade.

9. Select the **When a HTTP request is received** trigger under the **Start with a common trigger** section.

10. The **Logic Apps Designer** will open with the visual designer displayed, and with the **When a HTTP request is received** trigger selected.

11. On the **When a HTTP request is received** trigger, under the **Request Body JSON Schema** textbox, click the **Use sample payload to generate schema** link.

12. When prompted, paste in the following sample JSON into the textbox and click **Done**.

    ```json
     [{
      "id": "56afc886-767b-d359-d59e-0da7877166b2",
      "topic": "/SUBSCRIPTIONS/<subscription ID>/RESOURCEGROUPS/<resource group name>/PROVIDERS/MICROSOFT.DEVICES/IOTHUBS/<hub name>",
      "subject": "devices/LogicAppTestDevice",
      "eventType": "Microsoft.Devices.DeviceCreated",
      "eventTime": "2018-01-02T19:17:44.4383997Z",
      "data": {
        "twin": {
          "deviceId": "LogicAppTestDevice",
          "etag": "AAAAAAAAAAE=",
          "deviceEtag": "null",
          "status": "enabled",
          "statusUpdateTime": "0001-01-01T00:00:00",
          "connectionState": "Disconnected",
          "lastActivityTime": "0001-01-01T00:00:00",
          "cloudToDeviceMessageCount": 0,
          "authenticationType": "sas",
          "x509Thumbprint": {
            "primaryThumbprint": null,
            "secondaryThumbprint": null
          },
          "version": 2,
          "properties": {
            "desired": {
              "$metadata": {
                "$lastUpdated": "2018-01-02T19:17:44.4383997Z"
              },
              "$version": 1
            },
            "reported": {
              "$metadata": {
                "$lastUpdated": "2018-01-02T19:17:44.4383997Z"
              },
              "$version": 1
            }
          }
        },
        "hubName": "egtesthub1",
        "deviceId": "LogicAppTestDevice"
      },
      "dataVersion": "1",
      "metadataVersion": "1"
    }]
    ```

    This sample JSON is an example of the JSON that Event Grid will POST to the Web Hook endpoint for the Logic App once it's created. This sample includes the IoT Hub Message Telemetry properties for the IoT Device that will be sending telemetry messages.

13. Notice the **Request Body JSON Schema** box is now populated with a JSON schema that was automatically generated based on the sample JSON that was pasted in.

14. Click the **+ New step** button below the **When a HTTP request is received** trigger.

15. Enter `Outlook.com` into the search box, then locate and select the **Send an email (V2) (Preview)** action for the **Outlook.com** connector.

    > [!NOTE] These instructions walk through configuring the Logic App to send an email using an **Outlook.com** email address. Alternatively, the Logic App can also be configured to send email using the Office 365 Outlook or Gmail connectors as well.

16. On the **Outlook.com** Connector, click the **Sign in** button, and follow the prompts to authenticate with an existing Outlook.com account.

17. If prompted to **Let this app access your info**, click **Yes**. 

18. In the **Send an email (V2) (Preview)** action, on the **To** field, enter an email address to send email messages to.

    Enter an email address where you can receive emails; such as the Outlook.com account used for this connector.

    The Outlook.com account that was authenticated will be used to send the emails from that account. You can actually enter any email address you want to send the notifications to.

19. For the **Subject**, fill in `IoT Hub alert:`.

20. Next, begin work on the **Body**.  Your desired conent is the following:
   `This is an automated email to inform you that: {eventType} occurred at {eventTime} IoT Hub: {hubName} Device ID: {deviceID} Connection state: {connectionState}`
   Each curly-braces entry should be dynamic content.  If you can't see the Dynamic content, select the **Add dynamic content** hyperlink under the **Body** text box. If it doesn't show you the fields you want, click *more* in the Dynamic content screen to include the fields from the previous action.
   When you add the first dynamic content value, because the input data schema is for an array, the Logic Apps Designer will automatically change the e-mail action to be nested inside of a **For each** action.  When this happens, the **Send an email (V2) (Preview)** action will collapse; simply click on it to open it up again and continue editing the body.

    ![Fill out email information](../../Linked_Image_files//MM99_L09_email_content.png)

18. Click **Save** at the top of the designer to save all changes to the Logic App Workflow.

19. Expand the **When a HTTP request is received** trigger, copy the value for the **HTTP POST URL** that is displayed, and save it for future reference. This is the _web hook_ endpoint URL for the Logic App that will be used by Event Grid to trigger the execution of the Logic App workflow.

    ![HTTP request info](../../Linked_Image_files/MM99_L09_http_post.png)


    The **HTTP POST URL** will be similar to the following:

    ```text
    https://prod-87.eastus.logic.azure.com:443/workflows/b16b5556cbc54c97b063479ed55b2669/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=ZGqYl-R5JKTugLG3GR5Ir1FuM0zIpCrMw4Q2WycJRiM
    ```

    This URL is the Web Hook endpoint to call the Logic App trigger via HTTPS. Notice the **sig** query string parameter and it's value. The **sig** parameter contains the shared access key that is used to authenticate requests to the Web Hook endpoint.

## Exercise 3: Configure Azure IoT Hub Event Subscription

Azure IoT Hub integrates with Azure Event Grid so that you can send event notifications to other services and trigger downstream processes. You can configure business applications to listen for IoT Hub events so that you can react to critical events in a reliable, scalable, and secure manner. For example, build an application that updates a database, creates a work ticket, and delivers an email notification every time a new IoT device is registered to your IoT hub.

In this exercise, you will create an Event Subscription within Azure IoT Hub to setup Event Grid integration that will trigger a Logic App to send an alert email.

1. Navigate back to your Azure Portal dashboard.

1. On your resource group tile, click **AZ-220-HUB-_{YOUR-ID}_** to navigate to your Azure IoT Hub.

2. On the **IoT Hub** blade, on the left side, click the **Events** link.

3. On the **Events** pane, at the top, click the **+ Event Subscription** button.

4. Create the event subscription with the following values:

   * **EVENT SUBSCRIPTION DETAILS**
     * **Name**: `MyDeviceCreateEvent`
     * **EventSchema**: **Event Grid Schema**

   * **TOPIC DETAILS**: will be informational and read-only
  
   * **EVENT TYPES**
     * **Filter to Event Types**: Uncheck all of the choices except **Device Created**.

       ![subscription event types](../../Linked_Image_files/MM99-L09-subscription-event-types.png)

   * **ENDPOINT DETAILS**:
     * **Endpoint Type**: **Web Hook**
     * Click **Select an endpoint**, and then, in the **Select Web Hook** pane, under **Subscriber Endpoint**, paste the URL that you copied from your logic app, then click **Confirm Selection**.

  *Do not yet click Create!*

   When you're done, the pane should look like the following example: 

    ![Sample event subscription form](../../Linked_Image_files/MM99-L09-subscription-form.png)

5. You could save the event subscription here, and receive notifications for every device that is created in your IoT hub. For this tutorial, though, let's use the optional fields to filter for specific devices. Select **Filters** at the top of the pane.

6. At the bottom of the pane, select **Add new filter**. Fill in the fields with these values:

   * **Key**: Enter `Subject`.

   * **Operator**: Select `String begins with`.

   * **Value**:  Enter `devices/CheeseCave1_` to filter for device events in building 1.
  
   Add another filter with these values:

   * **Key**: Enter `Subject`.

   * **Operator**: Select `String ends with`.

   * **Value**: Enter `_Thermostat` to filter for device events related to temperature.

   The **Filters** tab of your event subscription should now look similar to this image:

7. Select **Create** to save the event subscription.

## Exercise 4: Test Your Logic App with New Devices

Test your logic app by creating a new device to trigger an event notification email.

1. From your IoT hub, on the left side, under **Explorers**, select **IoT Devices**.

2. At the top, select **+ New**.

3. For **Device ID**, enter `CheeseCave1_Building1_Thermostat`.

4. Leave all other fields at the defaults, and select **Save**.

5. You can add multiple devices with different device IDs to test the event subscription filters. Try these other examples:

   * `CheeseCave1_Building1_Light`
   * `CheeseCave2_Building1_Thermostat`
   * `CheeseCave2_Building2_Light`

   If you added the four examples total, your list of IoT devices should look like the following image:

   ![IoT Hub device list](../../Linked_Image_files/MM99-L09-iot-hub-device-list.png)

6. Once you've added a few devices to your IoT hub, check your email to see which ones triggered the logic app.







