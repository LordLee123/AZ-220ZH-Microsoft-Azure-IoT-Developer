# Configure an Alert

Now let us create an alert. Alerts proactively notify you when important conditions are found in your monitoring data. They allow you to identify and address issues before the users of your system notice them. In our asset tracking scenario, we use sensors to track our assets being transported. Each time a sensor is added in a transportation box, it will auto provision through DPS. We want to have a metric for the warehouse manager of how many boxes were "tagged" and need to count the Device Connected events from IoT Hub.

In this task we are going to add an alert that will inform the warehouse manager when 5 or more devices have connected.

1. In the Azure Portal, navigate to the IoT Hub we are using for this lab.

1. In the left hand navigation area, under **Monitoring**, click **Alerts**.

    The empty **Alerts** page is displayed. Notice that the **Subscription**, **Resource group**, **Resource** and **Time range** fields are pre-populated.

1. Under **Time range**, select **Past hour**.

1. To add a new alert, click **+ New Alert Rule** (while the list is empty, you will see a **New Alert Rule** button in the center of the page - you can click this or the one in the toolbar).

    The **Create rule** pane is displayed.

1. At the top of the page, you will see two fields - **RESOURCE** and **HIERARCHY**. Notice they are pre-populated with the IoT Hub. To change the selected resource, you would click **Select**.

1. Under **Condition** you will see that no conditions have been defined. Click **Add** to add a new condition.

    The **Configure signal logic** pane is displayed. You will notice that there is a paginated table of available signals displayed. The fields above the table filter the table to assist in finding the signal types you want.

1. Under **Signal type**, you will note that **All** is selected. Click on the dropdown and note that there are 3 available options: *All*, *Metrics* and *Activity Log*. Leave the selection as **All** for now.

    > [!NOTE] The signal types available for monitoring vary based on the selected target(s). The signal types may be metrics, log search queries or activity logs.

1. Under **Monitor service**, you will note that **All** is selected. Click on the dropdown and note that there are 3 available options: *All*, *Platform* and *Activity Log - Administrative*. Leave the selection as **All** for now.

    > [!NOTE] The platform service provides metrics on service utiization, where as the activity log tracks administrative activities.

1. in the **Search by signal name** textbox, enter **connected** and this will immediately filter, then select **Connected devices (preview)** from the list below.

    The pane will update to display a chart similar to that you would create under **Metrics**, displaying the values associated with the selected signal (in this case *Connected devices (preview)*).

    Beneath the chart is the area that defines the **Alert logic**.

1. Under **Threshold** there are two possible selections - *Static* and *Dynamic*. You will notice that **Static** is selected and **Dynamic** is unavailable for this signal type.

    > [!NOTE] As the names suggest, *Static Thresholds* specify a constant expression for the threshold, whereas *Dynamic Thresholds* detection leverages advanced machine learning (ML) to learn metrics' historical behavior, identify patterns and anomalies that indicate possible service issues. You can learn more about *Dynamic Thresholds* [here](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-dynamic-thresholds).

    We are going to create a static threshold that raises and alert whenever the *connected devices (preview)* signal is equal to 5 or more.

1. Under **Operator**, click the dropdown list and note the available operators. Select **Greater than or equal to**.

1. Under **Aggregation type**, click the dropdown and note the available options - select **Average**.

1. Under **Threshold value**, enter **5**.

    > [!NOTE] The **Condition preview** refreshes to display the condition in an easier to read format.

    Below the **Condition preview** is the **Evaluation based on** area. The values herein determine the historical time period that is aggregated using the **Aggregation type** selected above and how often the condition is evaluated.

1. Under **Aggregation granularity (Period)**, select the dropdown and notice the available periods - select **5 minutes**.

1. Under **Frequency of evaluation**, select the dropdown and notice the available frequencies, select **Every 1 Minute**.

    > [!NOTE] As the **Frequency of evaluation** is shorter than **Aggregation granularity (Period)**, this results in a sliding window evaluation. What this means is every minute, the preceding 5 minutes of values will be aggregated (in this case, averaged), and then evaluated against the condition. In a minutes time, again the preceding 5 minutes of data will be aggregated - this will include one minute of new data and four minutes of data that was already evaluated. Thus we have a sliding window that moves forward a minute at a time, but is always including 4 minutes of earlier data.

1. To configure the alert condition, click **Done**.

    The **Configure signal logic** pane closes and the **Create rule** pane appears. Notice that the **CONDITION** is now populated and a **Monthly cost in USD** is displayed. At the time of writing, the estimated cost of the alert condition is $0.10.

    Next, we need to configure the action taken when the alert condition is met.

1. Under **ACTIONS**, notice that no action group is selected. There are two options available - **Select action group** and **Create action group**. As we do not have an action group created yet, click **Create action group**.

    The **Add action group** pane is displayed.

    > [!NOTE] An action group is a collection of notification preferences defined by the owner of an Azure subscription. An action group name must be unique within the Resource Group is is associated with. Azure Monitor and Service Health alerts use action groups to notify users that an alert has been triggered. Various alerts may use the same action group or different action groups depending on the user's requirements. You may configure up to 2,000 action groups in a subscription. You can learn more about creating and managing Action Groups [here](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/action-groups).


1. Next to **Action group name**, enter **AZ-220 Email Action Group**.

    > [!NOTE] An action group name must be unique within the Resource Group is is associated with.

1. Next to **Short name**, enter **AZ220EmailAG**.

    > [!NOTE] The short name is used in place of a full action group name when notifications are sent using this group and is limited to a max of 12 characters.

1. Next to **Subscription**, select the subscription you have been using for this lab.

1. Next to **Resource group**, select the resource group you are using for this lab - "AZ-220-RG".

    > [!NOTE] Action Groups are usually shared across a subscription and would likely be centrally managed by the Azure subscription owner. As such they are more likely to be included in a common resource group rather than in a project specific resource group such as "AZ-220-RG". We are using "AZ-220-RG" to make it easier to clean up the resources after the lab.

1. In the next area, **Actions**, you can define a list of actions that will be performed whenever this action group is invoked.

1. Under **Action name**, enter **AZ220Notifications**.

1. Under **Action Type**, click the dropdown and notice the available options - select **Email/SMS/Push/Voice**.

    Immediately, the **Email/SMS/Push/Voice** action details pane is displayed. Notice that you can choose up to 4 methods for delivering the notification. For the purpose of this lab, we'll use **Email** and **SMS**.

1. Check **Email** and enter an email you wish to use to receive the alert.

1. Check **SMS**, enter your **Country code** and the **Phone number** you wish to receive the SMS alert.

1. Skip **Azure app Push Notifications** and **Voice**.

1. Finally, there is the option to **Enable the common alert schema** - select **Yes**.

   > [!NOTE] There are many benefits to using the Common Alert Schema. It standardizes the consumption experience for alert notifications in Azure today. Historically, the three alert types in Azure today (metric, log, and activity log) have had their own email templates, webhook schemas, etc. With the common alert schema, you can now receive alert notifications with a consistent schema. You can learn more about the Common ALert6 Schema [here](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-common-schema).

   > **Important:** Given the benefits, you may wonder why the common alert schema is not enabled by default - well, when you select **Yes** you will see a warning **Enabling the common alert schema might break any existing integrations.** Bear this in mind in your own environments.

1. To save the **Email/SMS/Push/Voice** action configuration, click **OK**.

    The **Email/SMS/Push/Voice** pane closes and the list of **Actions** on the **Add action group** pane is updated. Notice that the new action has a link to **Edit details** if changes are required.

    At this point, we could add multiple actions if we needed to launch some business integration via *WebHooks* or an *Azure Function*, however for this lab, this notification is enough.

1. To create this action group, click **OK**.

    A few things happen at the same time. First, **Add action group** pane closes and the **Create rule** pane is displayed, with the new Action Group added to the list of **ACTIONS**.

    Then, in quick succession, you should receive both an SMS notification and an email, both of which inform you that you have been added to the **AZ220EmailAG** action group. In the SMS message, you will note that you can reply to the message to stop receiving future notifications and so on - you can learn more about the options [here](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-sms-behavior). In the email, you have links that you can click to view the details on action groups and, towards the bottom of the email (in a smaller font) you can see the option to unsubscribe.

1. Next, we configure the **ALERT DETAILS**.

1. Under **Alert rule name**, enter **Connected Devices Greater or Equal To 5**. The name should be descriptive enough to identify the alert.

1. Under **Description** you can optionally enter a more detailed description, enter **This alert is raised when the AZ-220-HUB  device connection threshold is greater than or equal to 5.**.

1. Under **Severity**, select the severity of the alert. In our scenario, this alert is *informational* and not indicative of any critical failure, therefore select **Sev 3**.

    > [!NOTE] Severity options and the associated severity:
    >* Sev 0 = Critical
    >* Sev 1 = Error
    >* Sev 2 = Warning
    >* Sev 3 = Informational
    >* Sev 4 = Verbose

1. Under **Enable rule upon creation**, ensure **Yes** is selected.

    > [!NOTE] It can take up to 10 minutes for a metric alert rule to become active.

1. To finally create the rule, click **Create alert rule**.

    The **Create rule** pane is closed and the list of **Alerts** is displayed. The **New alert rule** button that was previously displayed has now been replaced by **Manage alert rules(1)**. As we have yet to trigger any alerts, no alerts are listed here.

Now that we have create our alert, we should configure the environment we need for the device siumulation we will use to trigger the alert.