# Resources and Unique Names

Throughout this course you will be creating resources. To ensure consistency across the labs and to help in tidying up resources whenever you have finished with them, we will be providing you with the names you should use. However, many of these resources expose services that can be consumed across the web, which means they must have globally unique names. To achieve this, you will be using a unique identifier that will be added to the end of the resource name. Let's create your unique ID.

## Unique ID

Your unique ID will be constructed using your initials and the current date using the following pattern:

```text
YourInitialsYYMMDD
```

So, your initials followed by the last two digits of the current year, the current numeric month, and the current numeric day. Here are some examples:

```text
GWB190123
BHO190504
CAH191216
DM190911
```

In some cases, you may be asked to use the lowercase version of your unique ID:

```text
gwb190123
bho190504
cah191216
dm190911
```

Whenever you are expected to use your unique ID, you will see `{YOUR-ID}`. You will replace the entire string (including the `{}`) with your unique value.

Make a note of your unique ID now and **use the same value through the entire course** - don't update the date each day.

Let's review some examples of resources and the names associated with them.

## Resource Groups

A resource group must have a unique name within a subscription; however, it does not need to be globally unique. Therefore, throughout this course you will be using the resource group name: **AZ-220-RG**.

  > **Information:** Resource Group Name - **AZ-220-RG**

## Publicly Visible Resources

Many of the resources that you create will have publicly-addressable (although secured) endpoints and therefore must have globally unique. Examples of such resources include IoT Hubs, Device Provisioning Services, and Azure Storage Accounts. For each of these you will be provided with a name template and expected to replace `{YOUR-ID}` with your unique ID. Here are some examples:

If your Unique ID is: **CAH191216**

| Resource Type | Name Template | Example |
| :--- | :--- | :--- |
| IoT Hub | AZ-220-HUB-{YOUR-ID} | AZ-220-HUB-CAH191216 |
| Device Provisioning Service | AZ-220-DPS-{YOUR-ID} | AZ-220-DPS-CAH191216 |
| Azure Storage Account <br/> (name must be lower-case and no dashes) | az220storage{YOUR-ID} | az220storagecah191216 |

You may also be required to update values within bash scripts and C# source files as well as entering the names into the Azure Portal UI. Here are some examples:

```bash
#!/bin/bash

YourID="{YOUR-ID}"
RGName="AZ-220-RG"
IoTHubName="AZ-220-HUB-$YourID"

```

Notice that `YourID="{YOUR-ID}"` should be updated to `YourID="CAH191216"` - you do not change `$YourID`. Similarly, in C# you might see:

```csharp
private string _yourId = "{YOUR-ID}";
private string _rgName = "AZ-220-RG";
private string _iotHubName = $"AZ-220-HUB-{_yourId}";
```

Again, `private string _yourId = "{YOUR-ID}";` should be updated to `private string _yourId = "{CAH191216}";` - you do not change `{_yourId}`.