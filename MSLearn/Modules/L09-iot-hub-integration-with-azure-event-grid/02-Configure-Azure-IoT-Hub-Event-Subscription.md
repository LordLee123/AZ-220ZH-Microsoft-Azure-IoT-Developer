# Configure Azure IoT Hub Event Subscription

Azure IoT Hub integrates with Azure Event Grid so that you can send event notifications to other services and trigger downstream processes. You can configure business applications to listen for IoT Hub events so that you can react to critical events in a reliable, scalable, and secure manner. For example, build an application that updates a database, creates a work ticket, and delivers an email notification every time a new IoT device is registered to your IoT hub.

In this unit, you will create an Event Subscription within Azure IoT Hub to setup Event Grid integration that will trigger a Logic App to send an alert email.

1. Login to [portal.azure.com](https://portal.azure.com) using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. On your Resource group tile, click **AZ-220-HUB-{YOUR-ID}** to navigate to the Azure IoT Hub.

1. On the IoT Hub summary blade, click the **Events** link on the left-side of the blade.

1. On the **Events** pane, click the **+Event Subscription** button at the top.

1. Create the event subscription with the following values:

   * **Event Subscription Details**: Provide a descriptive name (for example: *MyDeviceCreateEvent*) and select **Event Grid Schema**.

   * **Event Types**: In the **Filter to Event Types**, uncheck all of the choices except **Device Created**.

       ![subscription event types](../../Linked_Image_files/MM99-L09-subscription-event-types.png)

   * **Endpoint Details**: Select Endpoint Type as **Web Hook** and select *select an endpoint* and paste the URL that you copied from your logic app and confirm selection.

   When you're done, the pane should look like the following example: 

    ![Sample event subscription form](../../Linked_Image_files/MM99-L09-subscription-form.png)

1. You could save the event subscription here, and receive notifications for every device that is created in your IoT hub. For this tutorial, though, let's use the optional fields to filter for specific devices. Select **Filters** at the top of the pane.

1. Select **Add new filter**. Fill in the fields with these values:

   * **Key**: Select `Subject`.

   * **Operator**: Select `String begins with`.

   * **Value**:  Enter `devices/CheeseCave1_` to filter for device events in building 1.
  
   Add another filter with these values:

   * **Key**: Select `Subject`.

   * **Operator**: Select `String ends with`.

   * **Value**: Enter `_Thermostat` to filter for device events related to temperature.

   The **Filters** tab of your event subscription should now look similar to this image:

7. Select **Create** to save the event subscription.
