# Setup Development Environment

In this unit you will install the .NET Core 3.1 SDK, Azure CLI, Azure PowerShell, and the Visual Studio Code (VSCode) editor. You will also install the VSCode extensions for developing Azure IoT solutions.

## Install .NET Core 3.1 SDK

1. Download and Install the [.NET Core 3.1 SDK](https://dotnet.microsoft.com/download)

    > [!NOTE] You're selecting the .NET Core 3.1 release because it is the most recent LTS ("Long-Term Support") release.

## Install Visual Studio Code

1. Download and Install the [Visual Studio Code](https://code.visualstudio.com) editor.

    > [!NOTE] .NET Framework 4.5 is required for Visual Studio Code when installing on Windows. If you are using Windows 7, please ensure [.NET Framework 4.5](https://www.microsoft.com/en-us/download/details.aspx?id=30653) is installed.

2. Go to the Visual Studio Marketplace and install the following extensions for Visual Studio Code:

    - [Azure IoT Tools](https://marketplace.visualstudio.com/items?itemName=vsciot-vscode.azure-iot-tools) by Microsoft
    - [C#](https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp) by Microsoft

## Install Azure CLI 2.0 or newer

1. Download and install the most recent version of the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) command-line tool. 
   
    > [!IMPORTANT] Make sure you install the current tools and **not** the Classic tools.

2. Once the Azure CLI is installed, open a new command-line window, and run the following command to add the Microsoft Azure IoT Extension for Azure CLI. This extension adds IoT Hub, IoT Edge, and IoT Device Provisioning Service (DPS) specific commands to Azure CLI.

    ```cmd/sh
    az extension add --name azure-cli-iot-ext
    ```

## Install Azure PowerShell

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

    If you see a message stating that `You are installing the modules from an untrusted repository`, type **A** and then press **Enter**.

    > [!NOTE] Once again, it can take a minute for the installation to begin, so just give it a chance.

    The AzureRM module is a rollup module for the Azure Resource Manager cmdlets. When you install the AzureRM module, any Azure PowerShell module not previously installed is downloaded and installed from the PowerShell Gallery.

## Verify Development Environment

1. Open a new command-line / terminal window.

2. Validate the Azure CLI installation by running the following command that will output the version information for the currently installed version of the Azure CLI.

    ```cmd/sh
    az --version
    ```

3. Validate the .NET Core 3.1 installation by running the following command that will output the version number for the currently installed versions of the .NET Core SDK.  It's okay if you have multiple versions; we will select the appropriate version later.

    ```cmd/sh
    dotnet --list-sdks
    ```
4. Validate the PowerShell module installation by closing the instance of PowerShell that is running at elevated privileges, and then open a PowerShell session at a normal privilege level. (This is following a security best practice by not running elevated if it is not necessary.)  To load the modules using the Import-Module cmdlet, enter the following command:

    ```PowerShell
    Get-Module -Name AzureRM -ListAvailable | Select-Object -Property Name,Version,Path
    ```

    We will be providing detailed instructions for using the Azure PowerShell tools during the labs in this course, but if you want more information now, see [Getting started with Azure PowerShell](https://docs.microsoft.com/en-us/powershell/azure/get-started-azureps?view=azurermps-5.7.0)
