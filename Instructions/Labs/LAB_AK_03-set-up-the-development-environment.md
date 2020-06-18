---
lab:
    title: '实验室 03：设置开发环境'
    module: '模块 2：设备和设备通信'
---

# 设置开发环境

## 实验室场景

作为 Contoso 的开发人员之一，你知道在开始构建 Azure IoT 解决方案之前设置开发环境是重要的一步。你知道 Microsoft 提供了许多可用于开发和支持 IoT 解决方案的工具，并且应该对团队将使用哪些工具做出一些决策。你将准备一个工作环境，供团队用于在 Azure 云端和本地工作环境中开发你的 IoT 解决方案。

经过一番讨论，你的团队对开发环境做出了以下高层决策：

* 操作系统：Windows 10 将用作操作系统。大多数团队成员都使用 Windows，因此这是一个合理的选择。你注意到 Azure IoT 服务支持其他操作系统（如 Mac OS 和 Linux ）， Microsoft 为选择这些备选方案之一的团队成员提供支持文档。
* 一般编码工具：Visual Studio Code 和 Azure CLI 将作为主要的编码工具。这两种工具均支持利用 Azure IoT SDK 的 IoT 扩展。
* IoT Edge 工具：Docker 桌面社区和 Python 将用于支持自定义 IoT Edge 模块开发。

为了支持这些决定，你将设置以下环境：

* Windows 10 64 位：专业版、企业版或教育版（版本15063 或更新版本）。包括
  * 4GB – 8GB 系统 RAM（对于Docker，RAM 越高越好）
  * 必须启用 Windows 的 Hyper-V 和容器功能。
  * 必须在 BIOS 设置中启用 BIOS 级硬件虚拟化支持。

  > **注释**：在虚拟机上设置开发环境时，VM 环境必须支持嵌套虚拟化 - [嵌套虚拟化](https://docs.microsoft.com/zh-cn/virtualization/hyper-v-on-windows/user-guide/nested-virtualization)

* Azure CLI（当前/最新）
* .NET Core 3.1.200（或更高版本）SDK
* VS 代码（最新）
* Python 3.7（非 3.8）
* Docker Desktop Community 2.1.0.5（或更高版本）设置为 Linux 容器
* Power BI Desktop（用于数据可视化）
* VS Code 和 Azure CLI 的 IoT 扩展

> **注释**：为此课程创建了一个虚拟机，该虚拟机提供了上面指定的大多数工具。以下说明支持使用准备好的 VM 或使用 PC 在本地设置开发环境。

## 本实验室概览

在本实验室中，你将完成以下操作：

* 安装将在本课程的各个实验室中使用的基本工具和产品。
* 安装用于 Azure CLI 和 Visual Studio Code 的 Azure IoT 扩展。
* 验证开发环境设置

## 实验室说明

### 练习 1：安装开发工具和产品

> **注释**：与本练习相关的工具和产品已预先安装在为此课程创建的虚拟机上。在继续之前，请咨询你的课程讲师，了解你是否要使用托管实验室 VM 环境完成实验，或者在电脑上本地设置开发环境。

#### 任务 1：安装 .NET Core

.NET Core 是 .NET 的跨平台版本，用于生成网站、服务和控制台应用。

1. 要打开 .NET Core 下载页面，请使用以下链接：[.NET 下载](https://dotnet.microsoft.com/download)

1. 在 .NET 下载页面上的 .NET Core 下，单击 **“下载 .NET Core SDK”**。

    .NET Core SDK 用于生成 .NET Core 应用。在本课程的各个实验室中，你将使用它来生成/编辑代码文件。

    如果你只需在 Windows 计算机上运行使用 .NET Core 的应用，则可以安装 .NET Core 运行时。此外，可以使用“所有 .NET Core 下载...”链接安装 .NET Core 的预览版本和旧版本。

1. 在弹出菜单上，单击 **“运行”**，然后按照屏幕上的说明完成安装。

    安装时间应该不超过一分钟。将安装以下组件：

    * .NET Core SDK 3.1.100 或更高版本
    * .NET Core 运行时 3.1.100 或更高版本
    * ASP.NET Core 运行时 3.1.100 或更高版本
    * .NET Core Windows 桌面运行时 3.1.0 或更高版本

    以下资源可用于获取更多信息：

    * [.NET Core 文档](https://aka.ms/dotnet-docs-chs)
    * [.NET Core 依赖性和要求](https://docs.microsoft.com/zh-cn/dotnet/core/install/dependencies?tabs=netcore31&pivots=os-windows)
    * [SDK 文档](https://aka.ms/dotnet-sdk-docs-chs)
    * [发行说明](https://aka.ms/netcore3releasenotes)
    * [教程](https://aka.ms/dotnet-tutorials-chs)

#### 任务 2：安装 Visual Studio Code

Visual Studio Code 是一个轻量级但功能强大的源代码编辑器，可在你的台式机上运行，并且可用于 Windows、macOS 和 Linux。它内置了对 JavaScript、typescript 和 Node.js 的支持，并且具有丰富的扩展生态系统，可用于其他语言（如 C++、C#、Java、Python、PHP、Go）和运行时间（如 .NET 和 Unity ）。

1. 要打开 Visual Studio Code 下载页面，请单击以下链接：[下载 Visual Studio Code](https://code.visualstudio.com/Download)

    可在[此处](https://code.visualstudio.com/docs/setup/setup-overview)的 Visual Studio Code 设置指南中找到在 Mac OS X 和 Linux 上安装 Visual Studio Code 的说明。此页面还包括 Windows 安装的更多详细说明和技巧。

1. 在“下载 Visual Studio Code”页面上，单击 **“Windows”**。

    开始下载时，将发生两件事：打开一个弹出对话框，并显示一些入门指南。

1. 在弹出对话框中，要开始设置过程，请单击 **“运行”**，然后按照屏幕上的说明进行操作。

    如果选择将安装程序保存到 Downloads 文件夹中，则可以通过打开该文件夹，然后双击 VSCodeSetup 可执行文件来完成安装。

    Visual Studio Code 默认安装在“C:\Program Files (x86)\Microsoft VS Code”文件夹位置（对于 64 位计算机而言）。设置过程应该只需要几分钟。

    > **注释**：  在 Windows 上安装时，Visual Studio Code 需要 .NET Framework 4.5。如果你使用 Windows 7，请确保已安装 .NET Framework 4.5[](https://www.microsoft.com/zh-cn/download/details.aspx?id=30653)。

    有关安装 Visual Studio Code 的详细说明，请参见以下网站上的《Microsoft Visual Studio Code 安装说明》指南：[https://code.visualstudio.com/Docs/editor/setup](https://code.visualstudio.com/Docs/editor/setup)

#### 任务 3：安装 Azure CLI

Azure CLI 2.2 是一种命令行工具，旨在简化 Azure 相关任务的脚本编写。它还使你能够灵活地查询数据，并支持长时间运行的操作作为非阻塞过程。

1. 打开浏览器，然后导航到 Azure CLI 2.2 工具下载页面：[安装 Azure CLI 2.2](https://docs.microsoft.com/zh-cn/cli/azure/install-azure-cli?view=azure-cli-latest "Azure CLI 2.2 Install")

    你应该安装最新版本的 Azure CLI 工具。如果 2.2 版本不是此“azure-cli-latest”下载页面上列出的最新版本，请安装最新版本。

1. 在“安装 Azure CLI 2.2”页面上，为你的操作系统选择安装选项，然后按照屏幕上的说明安装 Azure CLI 工具。

    我们将在本课程的实验中提供有关使用 Azure CLI 2.2 工具的详细说明，但是如果你现在想要更多信息，请参阅 [Azure CLI 2.2 入门](https://docs.microsoft.com/zh-cn/cli/azure/get-started-with-azure-cli?view=azure-cli-latest)

#### 任务 4：安装 Python 3.7

你将使用 Python 3.7 以便支持 IoT Edge 和 Docker。 

1. 在 Web 浏览器中，导航至 [https://www.python.org/downloads/](https://www.python.org/downloads/)

1. 在 Python 3.7.6 右侧的“正在寻找特定版本？”下，单击 **“下载”**。

1. 在“Python 3.7.6”页面上，向下滚动至页面的“文件”部分。

1. 在“文件”下，选择适合你的操作系统的安装程序文件。

1. 出现提示时，选择该选项以运行安装程序

1. 在“安装 Python 3.7.6”对话框中，单击 **“将 Python 3.7 添加到 PATH”**。

1. 请单击 **“立即安装”**。

1. 出现“安装成功”页面时，单击 **“禁用路径长度限制”**。

1. 要完成安装过程，请单击 **“关闭”**。

#### 任务 5：安装 Docker 桌面

在实验（介绍部署 IoT Edge 模块）期间，你将使用 Docker Desktop Community 2.1.0.5（或更高版本）设置为 Linux 容器。

1. 在 Web 浏览器中，导航至 [https://docs.docker.com/docker-for-windows/install/](https://docs.docker.com/docker-for-windows/install/)

    左侧导航菜单提供对其他操作系统的安装的访问。

1. 确认你的 PC 符合系统要求。

    你可以使用 Windows 设置打开“Windows 功能”对话框，以验证是否启用了 Hyper-V 和容器。

1. 单击 **“从 Docker Hub 下载”**

1. 在适用于 Windows 的 Docker 桌面下，单击 **“获取适用于 Windows 的 Docker 桌面（稳定）”**。

1. 要开始安装，请单击 **“运行”**。

    可能需要一段时间才能显示 Docker Desktop 的安装对话框。

1. 出现“安装成功”消息时，单击 **“关闭”**。

    Docker Desktop 在安装后不会自动启动。要启动 Docker Desktop，请搜索 Docker，然后在搜索结果中选择 Docker Desktop。当状态栏中的鲸鱼图标保持稳定时，Docker Desktop 将启动并运行，并且可以从任何终端窗口访问。

### 练习 2：安装开发工具扩展

Visual Studio Code 和 Azure CLI 工具均支持扩展，可帮助开发人员更有效地创建其解决方案。IoT 扩展由 Microsoft 开发，可利用 IoT SDK 并缩短开发时间。

#### 任务 1：安装 Visual Studio Code 扩展

1. 打开 Visual Studio Code。

1. 在“Visual Studio Code”窗口的左侧，单击 **“扩展”**。

    “扩展”按钮是从上往下数的第六个按钮。你可以将鼠标指针悬停在按钮上以显示按钮名称。

1. 在 Visual Studio Code 扩展管理器中，搜索并安装以下扩展：

    * [Azure IoT Tools](https://marketplace.visualstudio.com/items?itemName=vsciot-vscode.azure-iot-tools) (`vsciot-vscode.azure-iot-tools`)（提供者：Microsoft）
    * [用于 Visual Studio Code 的 C#](https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp) (`ms-vscode.csharp`)（提供者：Microsoft）

#### 任务 2：安装 Azure CLI 扩展

1. 打开一个新的命令行/终端窗口。

1. 在命令提示符下，要安装用于 IoT 的 Azure CLI 扩展，请输入以下命令：

```bash
    az extension add --name azure-cli-iot-ext
```

#### 任务 3：验证开发环境设置

你应该验证开发环境是否已设置成功。完成后，你便可开始构建 IoT 解决方案。

1. 打开一个新的命令行/终端窗口。

1. 通过运行以下命令验证 **Azure CLI** 安装，该命令将输出当前安装的 Azure CLI 版本的版本信息。

    ```cmd/sh
    az --version
    ```

    `az --version` 命令将输出已安装的 Azure CLI 的版本信息（`azure-cli` 版本号）。此命令还会输出所有已安装的 Azure CLI 模块的版本号，包括 IoT 扩展。你会看到类似于以下内容的输出：

    ```cmd/sh
    azure-cli                           2.2.0

    command-modules-nspkg               2.0.3
    core                                2.2.0
    nspkg                               3.0.4
    telemetry                           1.0.4

    Extensions:
    azure-cli-iot-ext                   0.8.9
    ```

1. 通过运行以下命令验证 **NET Core 3.x SDK** 安装，该命令将输出当前安装的 .NET Core SDK 版本的版本号。

    ```cmd/sh
    dotnet --version
    ```

1. `dotnet --version` 命令将输出当前安装的 .NET Core SDK 的版本。这必须是 .NET Core 3.1 或更高版本。

现在应该设置你的开发环境！

### 练习 3：设置课程实验室文件和替代工具

本课程中的许多实验室都依赖于预先构建的资源，例如可以用作实验室活动起点的代码项目。我们通过使用 GitHub 项目提供对这些实验室资源的访问。除了直接支持课程实验室的资源（GitHub 项目中包含的资源）之外，还有一些工具可用于支持实际课程之外的学习机会。下面的说明将引导你完成这两种资源类型的配置。

#### 任务 1：下载课程实验室文件

Microsoft 已经创建了一个 GitHub 存储库来提供对实验室资源文件的访问权限。在某些情况下，需要将这些文件放在本地开发环境，而在许多其他情况下，这样很方便。在此任务中，你将在开发环境中下载并提取存储库的内容。

1. 在你的 Web 浏览器中，导航到以下位置：[https://github.com/MicrosoftLearning/AZ-220ZH-Microsoft-Azure-IoT-Developer](https://github.com/MicrosoftLearning/AZ-220ZH-Microsoft-Azure-IoT-Developer)

1. 在页面右侧，单击 **“克隆或下载”**，然后单击 **“下载 ZIP”**。

1. 要将 ZIP 文件保存到你的开发环境中，请单击 **“保存”**。

1. 保存文件后，单击 **“打开文件夹”**。

1. 右键单击保存的 ZIP 文件，然后单击 **“提取所有”**

1. 请单击 **“浏览”**，然后导航到方便访问的文件夹位置。

1. 要提取文件，请单击 **“提取”**。

    确保记下文件的位置。

#### 任务 2：安装 Azure PowerShell 模块

> **注释**：本课程中的实验活动没有让你使用 PowerShell，但可在使用 PowerShell 的参考文档中看到示例代码。如果要运行 PowerShell 代码，可以按照以下说明完成安装步骤。

Azure PowerShell 是一组 cmdlet，用于直接从 PowerShell 命令行管理 Azure 资源。Azure PowerShell 旨在使其易于学习和入门，但提供了强大的自动化功能。Azure PowerShell 用 .NET Standard 编写，可在 Windows 上使用 PowerShell 5.1，在所有平台上都可以使用 PowerShell 6.x 及更高版本。

> **警告**：  不能同时为 PowerShell 5.1 for Windows 安装 AzureRM 和 Az 模块。如果需要使 AzureRM 在系统上保持可用状态，请为 PowerShell Core 6.x 或更高版本安装 Az 模块。为此，请安装 PowerShell Core 6.x 或更高版本，然后在 PowerShell Core 终端中按照以下说明进行操作。

1. 确定是只为当前用户（建议的方法）还是为所有用户安装 Azure PowerShell 模块。

1. 启动你选择的 PowerShell 终端 - 如果要为所有用户安装，则必须通过以下任一方式启动提升的 PowerShell 会话：在 macOS 或 Linux 上选择“以管理员身份运行”**或者运行 sudo** 命令。

1. 若要仅为当前用户安装，请输入以下命令：

```powershell
    Install-Module -Name Az -AllowClobber -Scope CurrentUser
```

    或者，若要为系统上的所有用户安装，请输入以下命令：

```powershell
    Install-Module -Name Az -AllowClobber -Scope AllUsers
```

1. 默认情况下，PowerShell 库未配置为 PowerShellGet 的可信存储库。首次使用 PSGallery 时，会收到以下提示：

```output
    Untrusted repository

    You are installing the modules from an untrusted repository. If you trust this repository, change
    its InstallationPolicy value by running the Set-PSRepository cmdlet.

    Are you sure you want to install the modules from 'PSGallery'?
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"):
```

1. 回答 **“是”** 或 **“全部是”** 继续安装。

    Az 模块是 Azure PowerShell cmdlet 的汇总模块。安装它会下载所有可用的 Azure 资源管理器模块，并使它们的 cmdlet 可供使用。

> **注释**：如果已安装 **Az** 模块，则可运行以下命令将其更新到最新版本：
> 
> ```powershell
> Update-Module -Name Az
> ```
