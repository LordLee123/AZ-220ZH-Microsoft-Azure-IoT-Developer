# Integrate IoT Hub with Event Grid

## Lab Scenario

Contoso is installing new connected Thermostats to be able to monitor temperature across different cheese caves. You will create an alert to notify facilities manager when a new thermostat has been created.

To create an alert, you will push device created event type to Event Grid when a new thermostat is created in IoT Hub. You will have a Logic Apps instance that will react on this event (on Event Grid) and will send an email to alert a facilities manager device a new device has been created, device ID, and connection state.

## In This Lab

* Create Logic App that sends an email
* Configure Azure IoT Hub Event Subscription
* Create new devices triggering a Logic Apps which sends an email when alert is flagged by device
