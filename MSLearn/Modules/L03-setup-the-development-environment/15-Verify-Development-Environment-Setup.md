# Verify Development Environment Setup

In this unit, you will verify that the development environment has been set up successfully. Once this is complete, you will be ready to start building your IoT solutions.

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
