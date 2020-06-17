# Install Azure IoT EdgeHub Dev Tool

In this unit, you will will install the Azure IoT EdgeHub Dev Tool.

1. To develop Azure IoT Edge modules with C#, you will need to install the Azure IoT EdgeHub Dev Tool. This tool required Python 2.7, 3.6, or 3.7 to be installed.

    > [!NOTE] Currently, the Azure IoT EdgeHub Dev Tool uses a docker-py library that is not compatible with Python 3.8.

1. To install Python, navigate to [https://www.python.org/downloads/](https://www.python.org/downloads/), then download and install Python.

1. Pip is required to install the Azure IoT EdgeHub Dev Tool on your development machine. With Python already installed, run the following commands to install Pip:

    ```cmd/sh
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python get-pip.py
    ```

    > [!NOTE] If you have issues installing Pip, please reference the official Pip installation instructions here: [https://pip.pypa.io/en/stable/installing/](https://pip.pypa.io/en/stable/installing/).

1. Run the following command to install [Azure IoT EdgeHub Dev Tool](https://pypi.org/project/iotedgehubdev/)

    ```cmd/sh
    pip install iotedgehubdev
    ```

    > [!NOTE] If you have multiple Python including pre-installed Python 2.7 (for example, on Ubuntu or macOS), make sure you are using the correct `pip` or `pip3` to install `iotedgehubdev`.

Now we have configured the python environment and installed these tools, we are now ready to create an Azure Container Registry which will be used to store our custom IoT Edge Module.