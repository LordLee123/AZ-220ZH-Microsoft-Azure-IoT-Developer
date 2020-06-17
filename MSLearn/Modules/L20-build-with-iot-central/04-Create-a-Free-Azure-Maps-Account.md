## Create a free Azure Maps account

If you do not already have an Azure Maps account, you'll need to create one.

1. Navigate to [Azure Maps](https://azure.microsoft.com/services/azure-maps/?azure-portal=true).

1. Follow the prompts to create a free account. When your account is set up, you'll need the **Subscription Key** for the account. Copy and paste this key into your text document, with a note that it applies to Azure Maps.

1. You can (optionally) verify your Azure Maps subscription key works. Save the following HTML to an .html file. Replace the **subscriptionKey** entry with your own key. Then, load the file into a web browser. Do you see a map of the world?

```html
<!DOCTYPE html>
<html>

<head>
    <title>Map</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Add references to the Azure Maps Map control JavaScript and CSS files. -->
    <link rel="stylesheet" href="https://atlas.microsoft.com/sdk/javascript/mapcontrol/2/atlas.min.css" type="text/css">
    <script src="https://atlas.microsoft.com/sdk/javascript/mapcontrol/2/atlas.min.js"></script>

    <!-- Add a reference to the Azure Maps Services lab JavaScript file. -->
    <script src="https://atlas.microsoft.com/sdk/javascript/mapcontrol/2/atlas-service.min.js"></script>

    <script>
        function GetMap() {
            //Instantiate a map object
            var map = new atlas.Map("myMap", {
                //Add your Azure Maps subscription key to the map SDK. Get an Azure Maps key at https://azure.com/maps
                authOptions: {
                    authType: 'subscriptionKey',
                    subscriptionKey: '<your Azure Maps subscription key>'
                }
            });
        }
    </script>
    <style>
        html,
        body {
            width: 100%;
            height: 100%;
            padding: 0;
            margin: 0;
        }

        #myMap {
            width: 100%;
            height: 100%;
        }
    </style>
</head>

<body onload="GetMap()">
    <div id="myMap"></div>
</body>

</html>
```

## Next steps

You've now completed the preparatory steps of connecting your first IoT Central app to real devices. Good work!

The next step is to create the device app.
