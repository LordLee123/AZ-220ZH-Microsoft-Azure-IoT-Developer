# Create HTTP Web Hook Logic App that sends an email

Azure Logic Apps is a cloud service that helps you schedule, automate, and orchestrate tasks, business processes, and workflows when you need to integrate apps, data, systems, and services across enterprises or organizations.

In this unit, you will create a new Azure Logic App that will be triggered via an HTTP Web Hook, then send an email using an Outlook.com email address.

1. Login to [portal.azure.com](https://portal.azure.com) using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. In the Azure Portal, click **+Create a resource** to open the Azure Marketplace.

1. On the **New** blade, in the **Search the Marketplace** box, type in and search for **Logic App**.

1. In the search results, select the **Logic App** item.

1. On the **Logic App** item, click **Create**.

1. On the **Create Logic App** blade, enter a globally unique name in the Registry **name** field.

    To provide a globally unique name, enter **AZ-220-LogicApp-{YOUR-ID}**.

    For example: **AZ-220-LogicApp-CP121819**

    The name of your Azure Logic App must be globally unique because it is a publicly accessible resource that you must be able to access from any IP connected device.

1. In the **Resource group** dropdown, select **Use Existing**, then select the **AZ-220-RG** resource group.

1. In the **Location** dropdown, choose the same Azure region that was used for the resource group.

1. Click **Create**.

    > [!NOTE] It will take a minute or two for the Logic App deployment to complete.

1. Navigate to the **Logic App** resource that was just deployed.

1. When navigating to the **Logic App** for the first time, the **Logic Apps Designer** pane will be displayed.

    If this doesn't come up automatically, click on the **Logic app designer** link under the **Development Tools** section on the **Logic App** blade.

1. Select the **When a HTTP request is received** trigger under the **Start with a common trigger** section.

1. The **Logic Apps Designer** will open with the visual designer displayed, and with the **When a HTTP request is received** trigger selected.

1. On the **When a HTTP request is received** trigger, click the **Use sample payload to generate schema** link.

1. When prompted, paste in the following sample JSON into the textbox and click **Done**.

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

1. Notice the **Request Body JSON Schema** box is now populated with a JSON Schema that was automatically generated base don the Sample JSON that was pasted in.

1. Click the **+New step** button below the **When a HTTP request is received** trigger.

1. Enter "**Outlook.com**" into the search box, then locate and select the **Send an email** action for the **Outlook.com** connector.

    > [!NOTE] These instructions walk through configuring the Logic App to send an email using an **Outlook.com** email address. Alternatively, the Logic App can also be configured to send email using the Office 365 Outlook or Gmail connectors as well.

1. On the **Outlook.com Connector**, click the **Sign in** button, and follow the prompts to authenticate with an existing Outlook.com account.

1. In the **To** field, on the **Send an email** action, enter an email address to send email messages to.

    Enter an email address where you can receive emails; such as the Outlook.com Account used for this connector.

    The Outlook.com Account that was authenticated will be used to send the emails from that account. You can actually enter any email address you want to send the notifications to.

1. Build your email template.

   * **To**: Enter the email address to receive the notification emails. For this tutorial, use an email account that you can access for testing.

   * **Subject**: Fill in the text for the subject. When you click on the Subject text box, you can select dynamic content to include. Type in `IoT Hub alert:`. If you can't see Dynamic content, select the **Add dynamic content** hyperlink -- this toggles it on and off.

   * **Body**: Write the text for your email. Select JSON properties from the selector tool to include dynamic content based on event data. For this lab, add the following text and dynamic content: `This is an automated email to inform you that: {eventType} occurred at {eventTime} IoT Hub: {hubName} Device ID: {deviceID} Connection state: {connectionState}`.  If you can't see the Dynamic content, select the **Add dynamic content** hyperlink under the **Body** text box. If it doesn't show you the fields you want, click *more* in the Dynamic content screen to include the fields from the previous action.

    ![Fill out email information](../../Linked_Image_files//MM99_L09_email_content.png)

1. Click **Save** to save all changes to the Logic App Workflow.

1. Expand the **When a HTTP request is received** trigger, copy the value for the **HTTP POST URL** that is displayed, and save it for future referent. This is the Web Hook endpoint URL for the Logic App that will be used by Event Grid to trigger the execution of the Logic App workflow.

    ![HTTP request info](../../Linked_Image_files/MM99_L09_http_post.png)


    The **HTTP POST URL** will be similar to the following:

    ```text
    https://prod-87.eastus.logic.azure.com:443/workflows/b16b5556cbc54c97b063479ed55b2669/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=ZGqYl-R5JKTugLG3GR5Ir1FuM0zIpCrMw4Q2WycJRiM
    ```

    This URL is the Web Hook endpoint to call the Logic App trigger via HTTPS. Notice the **sig** query string parameter and it's value. The **sig** parameter contains the shared access key that is used to authenticate requests to the Web Hook endpoint.
