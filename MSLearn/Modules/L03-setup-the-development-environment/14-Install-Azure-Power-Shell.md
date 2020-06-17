# Install Azure PowerShell

Azure PowerShell is designed for managing and administering Azure resources from the command line, and for building automation scripts that work against the Azure Resource Manager. You can use it in your browser with Azure Cloud Shell, or you can install it on your local machine and use it in any PowerShell session. If you are running Azure PowerShell locally, you need to have Windows PowerShell configured.

In this task, you will install Azure PowerShell

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
