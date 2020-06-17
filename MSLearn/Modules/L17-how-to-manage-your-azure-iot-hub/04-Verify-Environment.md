# Simulating the Sensors

As part of the asset-tracking scenario, we need to have devices that simulate the tags that will be used to track the assets during transportation. As each device is activated, it should use automatic device provisioning to connect to the Iot solution and start sending telemetry. In order to automatically connect, each device will need its own X509 certificate that is part of a chain to the root certificate used to create a group enrollment.

In this task, we will verify the existing environment, perform any necessary setup, generate 10 device certificates, and configure a console application that will simulate the 10 devices.

## Verify Environment

In **Lab 6-Automatic Enrollment of Devices in DPS** you configured DPS to use X509 resources. If you still have that configuration available, that will shortcut a few steps. However, if you did not complete the lab, make sure you check every step below.

### Verify DPS Configuration

1. In your browser, navigate to the [Azure Portal](https://portal.azure.com/) and login to your subscription.

1. Navigate to the "AZ-220-RG" resource group and look for a **Device Provisioning Service** named **AZ-220-DPS-{YOUR INITIALS and DATE}**.

    > [!NOTE] If the DPS does not exist, return to the **Setup Resources** task earlier in this lab.

1. To review the configuration of the DPS service, click  **AZ-220-DPS-{YOUR INITIALS and DATE}**.

1. To verify the certificate configuration, in the left hand navigation area, under **Settings**, click **Certificates**.

    > [!NOTE] If the certificates list is empty, jump to the **Verify OpenSSL** section

1. Examine the certificate entry and ensure the **Status** for the certificate in the **Certificates** pane is displayed as **Verified**.

    > [!NOTE] If the certificate status is **Unverified**, click the certificate to view the details, then click **Delete**. Enter the **Certificate Name** to confirm the deletion and click **OK**. Jump to the **Verify OpenSSL** section.

1. To verify the group enrollment, in the left navigation area, under **Settings** select **Manage enrollments**.

1. In the **Manage enrollments** pane, click on the **Enrollment Groups** link to view the list of enrollment groups in DPS.

    > [!NOTE] Does the **simulated-devices** enrollment group **exist**? If so jump to the **Generate Device Certificates** in the next task.

1. If the  **simulated-devices** enrollment group does not exist, continue with the **Verify OpenSSL** section below.

### Verify OpenSSL

In the following steps you will verify that OpenSSL tools installed in an earlier lab are still available.

1. In your browser, navigate to the [Azure Shell](https://shell.azure.com/) and login to your subscription.

1. At the shell prompt, enter the following command:

    ```bash
    cd ~/certificates
    ```

    If you see an error that states **No such file or directory** then jump down to the **Install OpenSSL Tools** section below.

1. At the shell prompt, enter the following command:

    ```bash
    cd ~/certs
    ```

    If you see an error that states **No such file or directory** then jump down to the **Generate and Configure x.509 CA Certificates using OpenSSL** section below.

1. Jump down to the **Generate Device Certificates** in the next task.

## Install OpenSSL Tools

1. In the cloud shell, enter the following commands:

    ```bash
    mkdir ~/certificates

    # navigate to certificates directory
    cd ~/certificates

    # download helper script files
    curl https://raw.githubusercontent.com/Azure/azure-iot-sdk-c/master/tools/CACertificates/certGen.sh --output certGen.sh
    curl https://raw.githubusercontent.com/Azure/azure-iot-sdk-c/master/tools/CACertificates/openssl_device_intermediate_ca.cnf --output openssl_device_intermediate_ca.cnf
    curl https://raw.githubusercontent.com/Azure/azure-iot-sdk-c/master/tools/CACertificates/openssl_root_ca.cnf --output openssl_root_ca.cnf

    # update script permissions so user can read, write, and execute it
    chmod 700 certGen.sh
    ```

1. Continue to the **Generate and Configure x.509 CA Certificates using OpenSSL** section below.

### Generate and Configure x.509 CA Certificates using OpenSSL

The first x.509 certificates needed are CA and intermediate certificates. These can be generated using the `certGen.sh` helper script by passing the `create_root_and_intermediate` option.

1. In the cloud shell, run the following command within the `~/certificates` directory of the **Azure Cloud Shell** to generate the CA and intermediate certificates:

    ```sh
    ./certGen.sh create_root_and_intermediate
    ```

1. The previous command generated a CA Root Certificate named `azure-iot-test-only.root.ca.cert.pem` is located within the `./certs` directory.

    Run the following command within the **Azure Cloud Shell** to download this certificate to your local machine so it can be uploaded to DPS.

    ```sh
    download ~/certificates/certs/azure-iot-test-only.root.ca.cert.pem
    ```

1. Navigate to the **Device Provisioning Service** (DPS) named `AZ-220-DPS-{YOUR-INITIALS-AND-CURRENT-DATE}` within the Azure portal.

1. On the **Device Provisioning Service** blade, click the **Certificates** link under the **Settings** section.

1. On the **Certificates** pane, click the **Add** button at the top to start process of uploading the x.509 CA Certificate to the DPS service.

    > [!NOTE] If see an existing certificate, select and delete it.

1. On the **Add Certificate** pane, select the x.509 CA Certificate file in the **Certificate .pem or .cer file** upload field. This is the `azure-iot-test-only.root.ca.cert.pem` CA Certificate that was just downloaded.

1. Enter a logical name for the _Root CA Certificate_ into the **Certificate Name** field. For example, `root-ca-cert`

    This name could be the same as the name of the certificate file, or something different. This is a logical name that has no correlation to the _Common Name_ within the x.509 CA Certificate.

1. Click **Save**.

1. Once the x.509 CA Certificate has been uploaded, the **Certificates** pane will display the certificate with the **Status** of **Unverified**. Before this CA Certificate can be used to authenticate devices to DPS, you will need to verify **Proof of Possession** of the certificate.

1. To start the process of verifying **Proof of Possession** of the certificate, click on the **CA Certificate** that was just uploaded to open the **Certificate Details** pane for it.

1. On the **Certificate Details** pane, click on the **Generate Verification Code** button.

1. Copy the newly generated **Verification Code** that is displayed above the _Generate_ button.

    > [!NOTE] You will need to leave the **Certificate Details** pane **Open** while you generate the Verification Certificate. If you close the pane, you will invalidate the Verification Code and will need to generate a new one.

1. Open the **Azure Cloud Shell**, if it's not still open from earlier, and navigate to the `~/certificates` directory.

1. **Proof of Possession** of the CA Certificate is provided to DPS by uploading a certificate generated from the CA Certificate with the **Validate Code** that was just generated within DPS. This is how you provide proof that you actually own the CA Certificate.

    Run the following command, passing in the **Verification Code**, to create the **Verification Certificate**:

    ```sh
    ./certGen.sh create_verification_certificate <verification-code>
    ```

    Be sure to replace the `<verification-code>` placeholder with the **Verification Code** generated by the Azure portal.

    For example, the command run will look similar to the following:

    ```sh
    ./certGen.sh create_verification_certificate 49C900C30C78D916C46AE9D9C124E9CFFD5FCE124696FAEA
    ```

1. The previous command generated a **Verification Certificate** that is chained to the CA Certificate with the Verification Code. The generated Verification Certificate named `verification-code.cert.pem` is located within the `./certs` directory of the Azure Cloud Shell.

    Run the following command within the **Azure Cloud Shell** to download this **Verification Certificate** to your local machine so it can be uploaded to DPS.

    ```sh
    download ~/certificates/certs/verification-code.cert.pem
    ```

1. Go back to the **Certificate Details** pane for the **CA Certificate** within DPS.

1. Select the newly created, and downloaded, **Verification Certificate** file, named `verification-code.cert.pem`, within the **Verification Certificate .pem or .cer file** field.

1. Click **Verify**.

1. With the **Proof of Possession** completed for the CA Certificate, notice the **Status** for the certificate in the **Certificates** pane is now displayed as **Verified**.

1. On the Device Provisioning Service settings pane on the left side, click **Manage enrollments**.

1. At the top of the blade, click **Add enrollment group**.

1. On the **Add Enrollment Group** blade, enter "**simulated-devices**" in the **Group name** field for the name of the enrollment group.

1. Ensure that the **Attestation Type** is set to **Certificate**.

1. Set the **Certificate Type** field to **CA Certificate**.

1. In the **Primary Certificate** dropdown, select the **CA Certificate** that was uploaded to DPS previously.

1. Notice the **Select the IoT hubs this group can be assigned to** dropdown has the **AZ-220-HUB-{YOUR-ID}** IoT Hub selected. This will ensure when the device is provisioned, it gets added to this IoT Hub.

1. In the Initial Device Twin State field, modify the `properties.desired` JSON object to include a property named `telemetryDelay` with the value of `"1"`. This will be used by the Device to set the time delay for reading sensor telemetry and sending events to IoT Hub.

    The final JSON will be like the following:

    ```js
    {
        "tags": {},
        "properties": {
            "desired": {
                "telemetryDelay": "1"
            }
        }
    }
    ```

1. Click **Save**

Now that the environment is setup, it's time to generate our device certificates.
