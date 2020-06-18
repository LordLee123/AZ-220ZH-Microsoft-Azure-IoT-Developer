---
lab:
    title: '实验室 04：将 IoT 设备连接到 Azure'
    module: '模块 2：设备和设备通信'
---

# 将 IoT 设备连接到 Azure

## 实验室场景

Contoso 以生产高质量的奶酪而闻名。由于公司的知名度和销售量都在迅速增长，他们希望采取措施来确保其奶酪保持其客户期望的高质量水平。

过去，温度和湿度数据是在每次轮班期间由工厂工人收集。该公司担心，随着新设施上线，工厂扩建将需要加强监控，而用于收集数据的手动流程将无法扩展。

Contoso 已决定启动使用 IoT 设备监控温度和湿度的自动化系统。遥测数据的通信速率将可调整，随着批量奶酪通过对环境敏感的处理流程，确保其制造过程受到控制。

为了在全面实施之前评估此资产监视解决方案，你需要将 IoT 设备（包括温度和湿度传感器）连接到 IoT 中心。出于本实验室的目的，你将使用 .NET Core 控制台应用程序模拟实际的 IoT 设备。

将创建以下资源：

![实验室 4 基础结构](media/LAB_AK_04-architecture.png)

## 本实验室概览

在本实验室中，你将完成以下活动：

* 验证是否满足实验室先决条件（具有必需的 Azure 资源）
* 使用 Azure CLI 在 Azure IoT 中心中注册设备 ID
* 配置模拟的 IoT 设备（用 C# 预先生成和编写）以连接到 Azure IoT 中心
* 运行模拟设备以便将设备到云的遥测消息发送到 Azure IoT 中心
* 使用 Azure CLI 验证 Azure IoT 中心正在接收设备遥测

## 实验室说明

### 练习 1：验证实验室先决条件

本实验室假定以下 Azure 资源可用：

| 资源类型 | 资源名称 |
| :-- | :-- |
| 资源组 | AZ-220-RG |
| IoT 中心 | AZ-220-HUB-_{YOUR-ID}_ |

如果这些资源不可用，请按照以下说明运行 **“lab04-setup.azcli”** 脚本，然后再前往练习 2。脚本文件包含在本地克隆作为开发环境配置（实验室 3）的 GitHub 存储库中。

> **注意**：  写入 **lab04-setup.azcli** 脚本，并在 **Bash** shell 环境中运行，执行此操作最简便的方法是在 Azure Cloud Shell 中。

1. 使用浏览器，打开 [Azure Cloud Shell](https://shell.azure.com/)，并使用本课程使用的 Azure 订阅登录。

1. 如果系统提示设置 Cloud Shell 的存储，请接受默认设置。

1. 验证 Azure Shell 是否在使用 **Bash**。

    Azure Cloud Shell 页面左上角的下拉菜单用于选择环境。验证所选的下拉值是否为 **Bash**。

1. 在 Azure Shell 工具栏上，单击**上传/下载文件** （从右数第四个按钮）。

1. 在下拉菜单中，单击 **“上传”**。

1. 在“文件选择”对话框中，导航到配置开发环境时下载的 GitHub 实验室文件的文件夹位置。

    在本课程的实验室 3（“设置开发环境”）中，通过下载 ZIP 文件并在本地提取内容来克隆包含实验室资源的 GitHub 存储库。提取的文件夹结构包括以下文件夹路径：

    * Allfiles
      * 实验室
          * 04-将 IoT 设备连接到 Azure
            * 设置

    lab04-setup.azcli 脚本文件位于实验室 4 的 Setup 文件夹中。

1. 选择 **“lab04-setup.azcli”** 文件，然后单击 **“打开”**。

    文件上传完成后，将显示一条通知。

1. 要验证是否上传了正确的文件，请输入以下命令：

    ```bash
    ls
    ```

    使用 `ls` 命令列出当前目录的内容。你应该会看到列出的 lab04-setup.azcli 文件。

1. 若要为此实验室创建一个包含安装脚本的目录，然后移至该目录，请输入以下 Bash 命令：

    ```bash
    mkdir lab4
    mv lab04-setup.azcli lab4
    cd lab4
    ```

    这些命令将为此实验室创建一个目录，将 **“lab04-setup.azcli”** 文件放入该目录，然后将当前工作目录更改为该新目录。

1. 为确保 **“lab04-setup.azcli”** 具有执行权限，请输入以下命令：

    ```bash
    chmod +x lab04-setup.azcli
    ```

1. 在 Cloud Shell 工具栏上，要编辑 **“lab04-setup.azcli”** 文件，请单击 **“打开编辑器”**（右数第二个按钮 - **{ }**）。

1. 在 **“文件”** 列表中，要展开“lab4”文件夹，请单击 **“lab4”**，再单击 **“lab04-setup.azcli”**。

    编辑器现在将显示 **“lab04-setup.azcli”** 文件的内容。

1. 在编辑器中，更新 `{YOUR-ID}` 和 `{YOUR-LOCATION}` 变量的值。

    以下面的示例为例，需要将 `{YOUR-ID}` 设置为在本课程开始时创建的唯一 ID，即 **“CAH191211”**，然后将 `{YOUR-LOCATION}` 设置为与资源组匹配的位置。

```bash
    #!/bin/bash

    RGName="AZ-220-RG"
    IoTHubName="AZ-220-HUB-{YOUR-ID}"

    Location="{YOUR-LOCATION}"
```

    > **注意**：  应将 `{YOUR-LOCATION}` 变量设置为要部署所有资源的区域的短名称。输入以下命令，可以看到可用位置及其短名称的列表（**“名称”** 列）：
    >
    > ```bash
    > az account list-locations -o Table
    >
    > DisplayName           Latitude    Longitude    Name
    > --------------------  ----------  -----------  ------------------
    > East Asia             22.267      114.188      eastasia
    > Southeast Asia        1.283       103.833      southeastasia
    > Central US            41.5908     -93.6208     centralus
    > East US               37.3719     -79.8164     eastus
    > East US 2             36.6681     -78.3889     eastus2
    > ```

1. 要保存对文件所做的更改并关闭编辑器，请单击编辑器窗口右上角的 **“...”**，然后单击 **“关闭编辑器”**。

    如果提示保存，请单击 **“保存”**，编辑器将会关闭。

    > **注意**：  可以使用 **CTRL+S** 随时保存，使用 **CTRL+Q** 关闭编辑器。

1. 要创建本实验室所需的资源，请输入以下命令：

    ```bash
    ./lab04-setup.azcli
    ```

    运行将花费几分钟时间。每个步骤完成时，你将会看到 JSON 输出。

脚本完成后，就可以继续实验室的内容。

### 练习 2：使用 Azure CLI 创建 Azure IoT 中心设备 ID

`iot` Azure CLI 模块包括几个命令，用于在 `az iot hub device-identity` 命令组下管理 Azure IoT 中心内的 IoT 设备。这些命令可用于在脚本内或直接从命令行/终端管理 IoT 设备。

#### 任务 1：管理订阅

一个帐户可能有多个订阅，因此了解如何列出订阅、选择当前活动订阅以及更改默认订阅非常重要。

1. 如有必要，请使用 Azure 帐户凭据登录到 Azure 门户。

    如果有多个 Azure 帐户，请确保使用与该课程将使用的订阅绑定的帐户登录。

1. 在 Azure 门户顶部单击 **Cloud Shell** 图标，以在 Azure 门户内打开 **Azure Cloud Shell**。

1. 如果系统提示设置 Cloud Shell 的存储，请接受默认设置。

1. 窗格打开后，在 Cloud Shell 中选择代表 **Bash**终端的选项。

1. 在命令提示符下，要列出可用的订阅，请输入以下命令：

    ```bash
    az account list --output table

    Name                      CloudName    SubscriptionId                        State    IsDefault
    ------------------------  -----------  ------------------------------------  -------  -----------
    Subscription1             AzureCloud   aa1122bb-4bd0-462b-8449-a1002aa2233a  Enabled  True
    Subscription2             AzureCloud   aa1122bb-4bd0-462b-8449-a1002aa2233b  Enabled  False
    Azure Pass - Sponsorship  AzureCloud   aa1122bb-4bd0-462b-8449-a1002aa2233c  Enabled  False
    ```

    可以看到，已列出本课程所用的 **“Azure Pass - 赞助”**，但未将其设置为默认订阅。

1. 要查看当前活动的订阅，请输入以下命令：

    ```bash
    az account show -o table

    EnvironmentName    IsDefault    Name           State    TenantId
    -----------------  -----------  -------------  -------  ------------------------------------
    AzureCloud         True         Subscription1  Enabled  aa1122bb-4bd0-462b-8449-a1002aa2233a
    ```

1. 要将当前会话的默认订阅更改为 **“Azure Pass - 赞助”**，输入以下命令：

    ```bash
    az account set --subscription "Azure Pass - Sponsorship"
    ```

    > **注意**：你可以使用订阅**名称**，也可以使用带有 **--subscription** 自变量的 **SubscriptionId**。如果你有两个具有相同名称的订阅，则**必须**使用 **“SubscriptionId”**。

1. 要确认更改，请输入以下命令：

    ```bash
    az account show -o table

    EnvironmentName    IsDefault    Name                      State    TenantId
    -----------------  -----------  ------------------------  -------  ------------------------------------
    AzureCloud         True         Azure Pass - Sponsorship  Enabled  aa1122bb-4bd0-462b-8449-a1002aa2233c
    ```

无论何时创建资源，此订阅目前都将在当前会话中使用，等等。

#### 任务 2：创建 IoT 中心设备 ID

1. 要确保在 Cloud Shell 中安装 IoT 扩展，请运行以下命令：

    ``` sh
    az extension add --name azure-cli-iot-ext
    ```

1. 还是在 Cloud Shell 中，运行以下 Azure CLI 命令，以便在 Azure IoT 中心内创建用于模拟设备的**设备标识**。

    ```sh
    az iot hub device-identity create --hub-name {IoTHubName} --device-id SimulatedDevice1
    ```

    > **注意**：  请务必将“{IoTHubName}”__占位符替换为 Azure IoT 中心的名称。如果忘记 IoT 中心名称，可以输入以下命令：
    >
    >```sh
    >az iot hub list -o table
    >```

#### 任务 3：获取设备连接字符串

1. 在 Cloud Shell 中运行以下 Azure CLI 命令，以获取刚刚添加到 IoT 中心的设备 ID 的_设备连接字符串_。此连接字符串将用于将模拟设备连接到 Azure IoT 中心。

    ```cmd/sh
    az iot hub device-identity show-connection-string --hub-name {IoTHUbName} --device-id SimulatedDevice1 --output table
    ```

1. 记录从上一条命令输出的**设备连接字符串**。你需要将其保存，供以后使用。

    连接字符串采用以下格式：

    ```text
    HostName={IoTHubName}.azure-devices.net;DeviceId=SimulatedDevice1;SharedAccessKey={SharedAccessKey}
    ```

### 练习 3：配置和测试模拟设备 (C#)

在本练习中，你将配置以 C# 编写的模拟设备，以使用在上一练习中创建的设备 ID 和共享访问密钥连接到 Azure IoT 中心。然后，你将测试设备并确保 IoT 中心按预期从设备接收遥测。

#### 任务 1：打开实验室 4 初学者代码项目

1. 打开一个新的 Visual Studio Code 实例。

1. 在左侧菜单上，单击 **“资源管理器”**。

    “资源管理器”窗格列出了文件/文件夹的层次结构。你的 Visual Studio Code 新实例没有打开的文件夹。

1. 在“文件”菜单上，单击 **“打开文件夹”**。

1. 在“打开文件夹”对话框中，导航到包含初学者代码项目的“实验室 4”文件夹。

    实验室 4 初学者项目文件夹的本地路径应类似于：

    * AZ-220-Microsoft-Azure-IoT-Developer-master
      * Allfiles
        * Labs
          * 04-Connect an IoT Device to Azure
            * Starter

    > **注意**：在实验室 3 中设置开发环境时，你克隆了 GitHub 项目。要查找资源文件，必要时请与课程讲师联系。

1. 要打开该文件夹，请单击 **“初学者”**，然后单击 **“选择文件夹”**。

    Visual Studio Code 的“资源管理器”窗格现在应列出两个 C# 项目文件：

    * SimulatedDevice.cs
    * SimulatedDevice.csproj

#### 任务 2：更新设备连接字符串

1. 在 Visual Studio Code “资源管理器”窗格中，要打开“SimulatedDevice.cs”文件，请单击 **“SimulatedDevice.cs”**。

1. 在“编辑器”视图中，找到包含 `s_connectionString` 变量的代码行。

    ```C#
    private readonly static string s_connectionString = "{Your device connection string here}";
    ```

1. 将占位符值 `{Your device connection string here}` 替换为你之前复制的设备连接字符串。

    这将使模拟设备能够身份验证、连接并与 Azure IoT 中心通信。

    配置后，该变量将类似于以下内容（包括你的特定连接信息）：

    ```csharp
    private readonly static string s_connectionString = "HostName={IoTHubName}.azure-devices.net;DeviceId=SimulatedDevice1;SharedAccessKey={SharedAccessKey}";
    ```

1. 在 **“查看”** 菜单中，单击 **“终端”**。

    验证所选的终端 shell 是 Windows 命令提示符。

1. 在“终端”视图的命令提示符下，输入以下命令：

    ```cmd/sh
    dotnet run
    ```

    该命令将生成并运行“模拟设备”应用程序。确保将终端位置设置为 `SimulatedDevice.cs` 文件所在的目录。

    > **注意**：  如果命令输出`Malformed Token`或其他错误消息，请确保**设备连接字符串**正确配置为 `s_connectionString` 变量的值。

1. 模拟设备应用程序运行后，将向 Azure IoT 中心发送事件消息，其中包括 `temperature` 和 `humidity` 值。

    终端输出类似于以下内容：

    ```text
    IoT Hub C# Simulated Device. Ctrl-C to exit.

    10/25/2019 6:10:12 PM > Sending message: {"temperature":27.714212817472504,"humidity":63.88147743599558}
    10/25/2019 6:10:13 PM > Sending message: {"temperature":20.017463779085066,"humidity":64.53511070671263}
    10/25/2019 6:10:14 PM > Sending message: {"temperature":20.723927165718717,"humidity":74.07808918230147}
    10/25/2019 6:10:15 PM > Sending message: {"temperature":20.48506045736608,"humidity":71.47250854944461}
    10/25/2019 6:10:16 PM > Sending message: {"temperature":25.027703996760632,"humidity":69.21247714628115}
    10/25/2019 6:10:17 PM > Sending message: {"temperature":29.867399432634656,"humidity":78.19206098010395}
    10/25/2019 6:10:18 PM > Sending message: {"temperature":33.29597232085465,"humidity":62.8990878830194}
    10/25/2019 6:10:19 PM > Sending message: {"temperature":25.77350195766124,"humidity":67.27347029711747}
    ```

    > **注意**：暂时先让模拟设备应用运行。下一个任务是验证 IoT 中心是否正在接收遥测消息。

#### 任务 3：验证发送到 Azure IoT 中心的遥测数据流

在此任务中，你将使用 Azure CLI 验证 Azure IoT 中心正在接收由模拟设备发送的遥测。

1. 使用浏览器，打开 [Azure Cloud Shell](https://shell.azure.com/)，并使用本课程使用的 Azure 订阅登录。

1. 在 Azure Cloud Shell 中，输入以下命令：

    ```cmd/sh
    az iot hub monitor-events --hub-name {IoTHubName} --device-id SimulatedDevice1
    ```

    _务必将 **{IoTHubName}** 占位符替换为 Azure IoT 中心的名称。_

    > **注意**：  在运行 Azure CLI 命令时，如果收到消息指出_需要更新 IoT 扩展版本依赖项_，则按 `y` 键接受更新，然后按 `Enter` 键。这将使命令按预期继续执行。

    `--device-id` 参数是可选的，使你可以监视单个设备事件。如果省略参数，该命令将监视发送到指定 Azure IoT 中心的所有事件。

    `az iot hub` Azure CLI 模块内的 `monitor-events` 命令提供了监视从命令行或终端内部发送到 Azure IoT 中心的设备遥测和消息的功能。

1. 请注意，`az iot hub monitor-events` Azure CLI 命令输出到达指定 Azure IoT 中心的事件的 JSON 表示。 

    通过此命令，你可以监视正在发送到 IoT 中心的事件。你还正在验证设备能否连接到 IoT 中心并与之通信。

    你会看到类似于以下内容的消息显示：

    ```cmd/sh
    Starting event monitor, filtering on device: SimulatedDevice1, use ctrl-c to stop...
    {
        "event": {
            "origin": "SimulatedDevice1",
            "payload": "{\"temperature\":25.058683971901743,\"humidity\":67.54816981383979}"
        }
    }
    {
        "event": {
            "origin": "SimulatedDevice1",
            "payload": "{\"temperature\":29.202181296051563,\"humidity\":69.13840303623043}"
        }
    }
    ```

1. 一旦确认 IoT 中心正在接收遥测，请在“Azure Cloud Shell”和“Visual Studio Code”窗口中按下 **“Ctrl-C”**。

    Ctrl-C 用于停止正在运行的应用。总是记得关闭不必要的应用和作业。
