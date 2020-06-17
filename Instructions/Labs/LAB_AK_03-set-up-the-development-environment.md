---
lab:
    title: 'Lab 03: Setup the Development Environment'
    module: 'Module 2: Devices and Device Communication'
---

# Setup the Development Environment

## Lab Scenario

As one of the developers at Contoso, setting up your development environment is an important step before starting to build in IoT solution. Azure IoT offers multiple developer tools and support across top IDEs.

## In This Lab

In this lab you will:

* Install the .NET Core 3 SDK, Azure CLI, and the Visual Studio Code (VSCode) editor.
* Install the VSCode extensions for developing Azure IoT solutions.
* Verify your Development Environment setup

## Exercise 1: Install Developer Tools and Products

 > [!NOTE] Check with you Instructor to understand if the lab hosting environment has already been prepared with some or all of the required tools.

### Task 1: Install .NET Core

.NET Core is a cross-platform version of .NET for building websites, services, and console apps.

1. To open the .NET Core download page, use the following link: [.NET Download](https://dotnet.microsoft.com/download)

1. On the .NET download page, under .NET Core, click **Download .NET Core SDK**.

    The .NET Core 3.1 SDK is used to build .NET Core apps.

    If all you need to do is run an app that uses .NET Core on a Windows computer, you can install the .NET Core Runtime. In addition, preview and legacy versions of .NET Core can be installed using the link for "All .NET Core downloads...".

1. On the popup menu, click **Run**, and then follow the on-screen instructions to complete the installation.

    The installation should take less than a minute to complete. The following components will be installed:

    * .NET Core SDK 3.1.100 or later
    * .NET Core Runtime 3.1.100 or later
    * ASP.NET Core Runtime 3.1.100 or later
    * .NET Core Windows Desktop Runtime 3.1.0 or later

    The following resources are available for further information:

    * [.NET Core Documentation](https://aka.ms/dotnet-docs)
    * [.NET Core dependencies and requirements](https://docs.microsoft.com/en-us/dotnet/core/install/dependencies?tabs=netcore31&pivots=os-windows)
    * [SDK Documentation](https://aka.ms/dotnet-sdk-docs)
    * [Release Notes](https://aka.ms/netcore3releasenotes)
    * [Tutorials](https://aka.ms/dotnet-tutorials)

## Task 2: Install Visual Studio Code

Visual Studio Code is a lightweight but powerful source code editor which runs on your desktop and is available for Windows, macOS and Linux. It comes with built-in support for JavaScript, TypeScript and Node.js and has a rich ecosystem of extensions for other languages (such as C++, C#, Java, Python, PHP, Go) and run times (such as .NET and Unity).

1. To open the Visual Studio Code download page, click the following link: [Download Visual Studio Code](https://code.visualstudio.com/Download)

    Instructions for installing Visual Studio Code on Mac OS X and Linux can be found on the Visual Studio Code set up guide [here](https://code.visualstudio.com/docs/setup/setup-overview). This page also includes more detailed instructions and tips for the Windows installation.

1. On the Download Visual Studio Code page, click **Windows**.

    When you start the download, two things will happen: a popup dialog opens and some getting started guidance will be displayed.

1. On the popup dialog, to begin the setup process, click **Run** and then follow the on-screen instructions.

    If you choose to Save the installer to your Downloads folder, you you can complete the installation by opening the folder and then double-clicking the VSCodeSetup executable.

    By default, Visual Studio Code is installed in the "C:\Program Files (x86)\Microsoft VS Code" folder location (for a 64-bit machine). The setup process should only take about a minute.

    > [!NOTE] .NET Framework 4.5 is required for Visual Studio Code when installing on Windows. If you are using Windows 7, please ensure [.NET Framework 4.5](https://www.microsoft.com/en-us/download/details.aspx?id=30653) is installed.

1. In Visual Studio Code, click the **Extensions** button on the left side of the window.

1. In the Visual Studio Code Extension manager, search for and install the following **Extensions**:

    * [Azure IoT Tools](https://marketplace.visualstudio.com/items?itemName=vsciot-vscode.azure-iot-tools) (`vsciot-vscode.azure-iot-tools`) by Microsoft
    * [C# for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp) (`ms-vscode.csharp`) by Microsoft

    For detailed instructions on installing Visual Studio Code, see the Microsoft Visual Studio Code Installation Instruction guide here: <https://code.visualstudio.com/Docs/editor/setup>

### Task 3: Install Azure CLI

Azure CLI 2.0 is a command-line tool that is designed to make scripting Azure-related tasks easier. It also enables you to flexibly query data, and it supports long-running operations as non-blocking processes.

1. Open your browser, and then navigate to the Azure CLI 2.0 tools download page: [Install Azure CLI 2.0](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest "Azure CLI 2.0 Install")

1. On the Install Azure CLI 2.0 page, select the install option for your OS, and then follow the on-screen instructions to install the Azure CLI tool.

    We will be providing detailed instructions for using the Azure CLI 2.0 tools during the labs in this course, but if you want more information now, see [Get started with Azure CLI 2.0](https://docs.microsoft.com/en-us/cli/azure/get-started-with-azure-cli?view=azure-cli-latest)
    
1. Open a new command-line / terminal window use the following command to install the Azure CLI extension for IoT:

    ```
    az extension add --name azure-cli-iot-ext
    ```

### Task 4: Install Azure PowerShell

Azure PowerShell is designed for managing and administering Azure resources from the command line, and for building automation scripts that work against the Azure Resource Manager. You can use it in your browser with Azure Cloud Shell, or you can install it on your local machine and use it in any PowerShell session. If you are running Azure PowerShell locally, you need to have Windows PowerShell configured.

1. On the Windows 10 Start menu, to begin installing the Azure PowerShell tools, right-click **Windows Powershell**, and then click **Run as Administrator**.

    Administrator rights are required to install PowerShell modules, so you will need to run as an administrator to get started.

1. At the command prompt, to determine the version of PowerShellGet installed on your computer, enter the following command:

    `Get-Module -Name PowerShellGet -ListAvailable | Select-Object -Property Name,Version,Path`

    PowerShellGet should be installed by default with Windows 10. However, to install the Azure PowerShell module, you will need PowerShellGet version 1.1.2.0 or higher.

1. If you are running an older version of PowerShellGet (such as version 1.0.0.1), to update PowerShellGet, enter the following command:

    `Install-Module PowerShellGet -Force`

    It will take a moment for your computer to respond.

    If you are prompted to install a newer version of the NuGet provider, type **Y** and then press Enter.

    > [!NOTE] If you re-run the command that we used above to determine the installed version of PowerShellGet, you should see that PowerShellGet version 1.6.0 (or higher) is now installed.

1. To install the Azure Resource Manager modules from the PowerShell Gallery, enter the following command:

    `Install-Module -Name AzureRM -AllowClobber`

    If you see a message stating that "You are installing the modules from an untrusted repository", type **A** and then press Enter.

    > [!NOTE] Once again, it can take a minute for the installation to begin, so just give it a chance.

    The AzureRM module is a rollup module for the Azure Resource Manager cmdlets. When you install the AzureRM module, any Azure PowerShell module not previously installed is downloaded and installed from the PowerShell Gallery.

1. Close the version of PowerShell that is running at elevated privileges, and then open a PowerShell session at a normal privilege level.

    Once the AzureRM module is installed, you need to load the module into your PowerShell session. It is best to do this in a normal (non-elevated) PowerShell session.

1. To load the modules using the Import-Module cmdlet, enter the following command:

    `Import-Module -Name AzureRM`

    We will be providing detailed instructions for using the Azure PowerShell tools during the labs in this course, but if you want more information now, see [Getting started with Azure PowerShell](https://docs.microsoft.com/en-us/powershell/azure/get-started-azureps?view=azurermps-5.7.0)

### Task 5: Verify Development Environment Setup

You should verify that the development environment has been set up successfully. Once this is complete, you will be ready to start building your IoT solutions.

1. Open a new command-line / terminal window.

1. Validate the **Azure CLI** installation by running the following command that will output the version information for the currently installed version of the Azure CLI.

    ```cmd/sh
    az --version
    ```

1. The `az --version` command will output the version information for the currently installed version of the Azure CLI. The `azure-cli` version number is the version of the Azure CLI that's installed, and will be the first version number output by the command. This command also outputs versions of all the Azure CLI modules installed.

    ```cmd/sh
    localmachine:~ User$ az --version
    azure-cli                         2.0.64
    ```

1. Validate the **.NET Core 3.x SDK** installation by running the following command that will output the version number for the currently installed version of the .NET Core SDK.

    ```cmd/sh
    dotnet --version
    ```

1. The `dotnet --version` command will output the version of the .NET Core SDK that is currently installed. This must be .NET Core 3.0 or higher.

Your development environment should be now setup!
