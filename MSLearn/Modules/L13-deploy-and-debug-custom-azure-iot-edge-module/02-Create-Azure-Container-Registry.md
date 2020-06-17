# Create Azure Container Registry

Azure Container Registry provides storage of private Docker images for container deployments. The service is a managed, private Docker registry service based on the open-source Docker Registry 2.0. Azure Container Registry is used to store and manage your private Docker container images.

In this unit, you will use the Azure portal to create a new Azure Container Registry resource.

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. In the Azure Portal, click **Create a resource** open the Azure Marketplace.

1. On the **New** blade, in the **Search the Marketplace** box, type in and search for **Container Registry**.

1. In the search results, select the **Container Registry** item.

1. On the **Container Registry** item, click **Create**.

1. On the **Create container registry** blade, enter a globally unique name in the **Registry name** field.

    To provide a globally unique name, enter **AZ220ACR{YOUR-ID}**.

    For example: **AZ220ACRCP120419**

    The name of your Azure Container Registry must be globally unique because it is a publicly accessible resource that you must be able to access from any IP connected device.

    Consider the following when you specify a unique name for your new Azure Container Registry:

    * The value that you apply to _Registry name_ must be unique across all of Azure. This is true because the value assigned to the name will be used in the domain name assigned to the service. Since Azure enables you to connect from anywhere in the world to your registry, it makes sense that all container registries must be accessible from the Internet using the resulting domain name.

    * The value that you assign to _Registry name_ cannot be changed once the Azure Container Registry has been created. If you do need to change the name, you'll need to create a new Container Registry, re-deploy your containers, and delete your old Container Registry.

    * The _Registry name_ field is a required field.

    > [!NOTE] Azure will ensure that the name you enter is unique. If the name that you enter is not unique, Azure will display an asterisk at the end of the name field as a warning. You can append the name suggested above with '**01**' or '**02**' as necessary to achieve a globally unique name.

1. In the **Resource group** dropdown, select the **AZ-220-RG** resource group.

1. In the **Location** dropdown, choose the same Azure region that was used for the resource group.

1. On the **Admin user** option, select **Enable**. This option will enable you to Docker login to the Azure Container Registry service using the registry name as the username and admin user access key as the password.

1. In the **SKU** dropdown, choose **Standard**.

    Azure Container Registry is available in multiple service tiers, known as SKUs. These SKUs provide predictable pricing and several options for aligning to the capacity and usage patterns of your private Docker registry in Azure.

1. Click **Create**.

1. Once created, navigate to the **AZ220ACR{YOUR-ID}** resource.

1. In order to determine the admin username and password, under **Settings**, click **Access keys**.

    Make a note of the following values:

    * **Login server**
    * **Username** - this is the admin username and will match the ACR name - **AZ220ACR{YOUR-ID}**
    * **password** - this is the admin password

Now that we have created the Azure Container Registry, we can create a custom IoT Edge Module container that will be store in the registry.