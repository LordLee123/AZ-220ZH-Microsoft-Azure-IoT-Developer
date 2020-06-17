# Explore the Azure Portal and Dashboard

Before you begin working with the Azure IoT services, it's good to be familiar with how Azure itself works.

Although we commonly refer to Azure as a 'cloud', it is actually a web portal that is designed to make Azure resources accessible from a single web site. All of Azure is accessible through the Azure portal.

In this task, you will explore the Azure portal and examine some ways that you can customize the UI.

1. In your Web browser, to open your Azure portal, navigate to the [portal.azure.com](http://portal.azure.com).

    When you log into Azure you will arrive at the Azure portal. The Azure portal provides you with a customizable UI that you can use to access your Azure resources.

1. In the upper left corner of the portal window, to open the portal menu, click the hamburger menu icon.

    At the top of the portal menu, you should see a section containing four menu options:
    
    * The **Create a resource** button opens a page displaying the services available through the Azure Marketplace, many of which provide free options. Notice that services are grouped by technology, including "Internet of Things", and that a search box is provided.
    * The **Home** button opens a customized page that displays links to Azure services, your recently accessed services, and other tools.
    * The **Dashboard** button opens a page displaying your default (or most recently used) dashboard. You will be creating a dashboard later in this lab.

    * The **All services** button opens a page similar to the **Create a resource** button described above.

    The bottom section of the portal menu is a **FAVORITES** section that can be customized to show your favorite, or most commonly used, resources. Later in this lab, you will learn how to customize this default list of common services to make it a list of your own favorites.

1. On the portal menu, to display the **Home** page, click **Home**.

1. On the home page, to display a map of data center regions, under **Azure services**, click **Service Health**.

    When you subscribe to a resource in Azure you'll pick a region to deploy it to. Azure is supported by a series of regions placed all around the world.

    This map shows the current status of regions associated with your subscription(s). A green circle is used to indicate that services are running normally at that region.

    With any cloud vendor (Azure, AWS, Google Cloud, etc.), services will go down from time to time. If you see a blue 'i' next to a region on the Service Health map, it means the region is experiencing a problem with one or more services. Azure mitigates these issues by running multiple copies of your application in different regions (a practice referred to as *Geo-redundancy*). If a region experiences an issue with a particular service, those requests will roll over to another region to fulfill the request. This is one of the big advantages of hosting apps in the Azure cloud. Azure deals with the issues, so you don't have to.

1. In the upper-left corner of your Azure portal, to navigate back to your home page, click **Microsoft Azure**.

    You can also use the portal menu to perform some simple navigation. You will have a chance to try out some options for portal navigation shortly.

1. Open the portal menu, and then click **All services**.

    The _All services_ page provides you with a few different viewing options and access to all of the services that Azure offers in both PaaS and IaaS. The first time that you open the _All services_ page, you will see the _Overview_ page. This view is accessible from the left side menu.

    >**Definitions:** The term **PaaS** is an acronym for **Platform as a Service**, and the term **IaaS** is an acronym for **Infrastructure as a Service**

1. On the _All services_ page, under _Categories_, click **All**.

    This view displays all of the services organized into groups corresponding to each Category. The Search box at the top can be very helpful.

1. On the left side of the _All services_ page, under _Categories_, click **Internet of Things**.

    The list of services is now limited to the services directly related to an IoT solution.

    Service/Resource pages on the Azure portal are sometimes referred to as _blades_. When you opened the Service Health page a couple of steps back, you opened a Service Health blade.

    The Azure portal uses blades as a kind of navigation pattern, opening new blades to the right as you drill deeper and deeper into a service. This gives you a form of breadcrumb navigation as you navigate horizontally.

1. Hover your mouse pointer over **IoT Hub**.

    A dialog box is displayed. In the top-right corner, notice the "star" shape. When the star shape is filled-in, the service is selected as a favorite. Favorites will appear on the list of your favorite services on the left navigation menu of the portal window. This makes it easier to access the services that you use most often. You can customize your favorites list by selecting the services that you use most.

1. In the top-right corner of the _IoT Hub_ dialog, to add IoT Hub to the list of your favorite services, click the star shaped icon.

    The star should now appear filled. If the star is shown as an outline, click the star icon again.

    >**Tip:** When you add a new item to your list of favorites, it is placed at the bottom of the favorites list on the Azure portal menu. You can rearrange your favorites into the order that you want by using a drag-and-drop operation.

    Use the same process to add the following services to your favorites: **Device Provisioning Services**, **Function App**, **Stream Analytics jobs**, and **Azure Cosmos DB**.

    > [!NOTE] You can remove a service from the list of your favorite services by clicking the star of a selected service.

1. On the left side of the _All services_ page, under _Categories_, click **General**.

1. Ensure that the following services are selected as favorites:

    * **Subscriptions**
    * **Resource groups**

    The favorites that you've added are enough to get you started, but you can use the _Internet of Things_ category to add additional favorites to the portal menu if you want.

1. Notice the toolbar at the top of the portal that runs the full width of the window.

    In addition to the hamburger menu icon on the far left of this toolbar, there several items that you will find helpful.

    First, notice that you have a _Search resources_ tool that can be used to quickly find a particular resource.

    To the right of the search tool are several buttons that provide access to common tools. You can hover the mouse pointer over a button to display the button name.

    * The _Cloud Shell_ button opens an interactive, authenticated shell right in the portal window that you can use to manage Azure resources. The Azure Cloud Shell supports Bash and PowerShell.
    * The _Directory + Subscriptions_ button opens a pane that you can use to manage your Azure subscriptions and account directory (the Azure Active Directory authentication mechanism).
    * The _Notifications_ button that opens a notifications pane. The notifications pane is useful when working with a long running process. You will be monitoring notifications when you create and configure resources throughout this course.
    * There are also buttons for *Settings*, *Feedback*, and *Help*. The *Help* button contains links to help documents and a list of useful keyboard shortcuts.

    On the far right is a button for your account information, providing you with access to things like your account password and billing information.

1. On the toolbar, click **Help**, and then click **Help + support**

1. On the _Help + support_ blade, notice the four Tiles for _Getting started_, _Documentation_, _Learn about billing_, and _Support plans_.

    The _Help + support_ blade gives you access to lots of great resources. You may want to come back to this later for further exploration.

1. On the _Help + support_ blade, click **Learn about billing**

1. On the _Azure Documentation_ page, in the _Filter by title_ textbox, type **Prevent unexpected costs**

1. Just below the filter textbox, click **Prevent unexpected costs**

    If *you* are using a paid Azure subscription and you are responsible for billing (you are the Account Administrator), you can use these instructions to set up billing alerts.
