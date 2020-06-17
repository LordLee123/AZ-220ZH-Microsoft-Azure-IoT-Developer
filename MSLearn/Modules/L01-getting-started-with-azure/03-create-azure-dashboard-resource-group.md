# Create an Azure Dashboard and Resource Group

On the Azure portal, dashboards are used to present a customized view of your resources. Information is displayed through the use of tiles which can be arranged and sized to help you organize your resources in useful ways. You can create many different dashboards that provide different views and serve different purposes.

Each tile that you place on your dashboard exposes one or more of your resources. In addition to tiles that expose the data of an individual resource, you can create a tile for something called a _resource group_.

A resource group is a logical group that contains related resources for a project or application. The resource group can include all the resources for the solution, or only those resources that you want to manage as a group. You decide how you want to allocate resources to resource groups based on what makes the most sense for your organization. Generally, add resources that share the same lifecycle to the same resource group so you can easily deploy, update, and delete them as a group.

In this task, you will create a custom dashboard that you can use during this course and populate it with a resource group tile.

1. In a Web browser, navigate to your Azure portal.

    You can use the following link to open the Azure portal: [Azure portal](https://portal.azure.com)

1. On the portal menu, click **Dashboard**.

1. On the _Dashboard_ page, click **+ New dashboard**

    We are going to create a custom dashboard to organize the resources that we use in this course.

1. To name your new dashboard, replace **My Dashboard** with **AZ-220**

    In the upcoming steps you will be adding a tile to your dashboard manually. Another option would be to use drag-and-drop operations to add tiles from the Tile gallery to the space provided.

1. At the top of the dashboard editor, click **Done customizing**

    You should see an empty dashboard at this point.

1. On the portal menu, click **Resource groups**

    This blade displays all of the resource groups that you have created using your Azure subscription(s). If you are just getting started with Azure, you probably don't have any resource groups yet.

1. On the _Resource groups_ blade, on the top menu, click **+ Add**

    This will open a new blade named _Create a resource group_.

1. Take a moment to review the contents of the _Create a resource group_ blade.

    Notice that the resource group is associated with a Subscription and a Region. Consider the following:

    * How might associating a subscription with your resource group be helpful?
    * How might associating a region with your resource group affect what you include in your resource group?

1. In the **Subscription** dropdown, select the Azure subscription that you are using for this course.

1. In the **Resource group** textbox, enter **AZ-220-RG**

    The name of the resource group must be **unique** within your subscription. A green check mark will appear if the name that you enter has not already been used and confirms to resource group naming rules.

    >**Tip:** The Azure documentation describes all Azure [naming rules and restrictions](https://docs.microsoft.com/en-us/azure/architecture/best-practices/resource-naming).


1. In the **Region** dropdown, select a region that is near you.  You should check with your instructor as well, [as not all regions offer all services](https://azure.microsoft.com/en-us/global-infrastructure/services/).

    You need to provide a location for the resource group because the resource group stores metadata about the resources and acts as the default location for where new resources in the resource group will be created. For compliance reasons, you may want to specify where that metadata is stored. In general, we recommend that you specify a location where most of your resources will reside. Using the same location can simplify the template used to manage your resources.

1. At the bottom of the _Create a resource group_ blade, click **Review + create**.

    You should see a message informing you that the settings for your resource group have been validated successfully.

1. To create your resource group, click **Create**.

1. On the top menu of the _Resource groups_ blade, to see your new resource group, click **Refresh**

    You will learn more about managing your resources as you continue through this course.

1. In the list of named resource groups, click the box to the left of the **AZ-220-RG** resource group that your just created.

    > [!NOTE] You don't want to open the resource group in a new blade, you just want to select it (check mark on the left).

1. On the right side of the screen, click the ellipsis (...) corresponding to your resource group, and then click **Pin to dashboard**

1. Close your _Resource groups_ blade.

    Your dashboard should now contain an empty Resources tile, but don't worry, we fill it up soon enough.
