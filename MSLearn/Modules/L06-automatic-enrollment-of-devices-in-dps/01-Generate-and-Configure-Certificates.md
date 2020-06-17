# Generate and Configure x.509 CA Certificates using OpenSSL

In this unit, you will generate an x.509 CA Certificate using OpenSSL within the Azure Cloud Shell. This certificate will be used to configure the Group Enrollment within the Device Provisioning Service (DPS).

1. If necessary, log in to your Azure portal using your Azure account credentials.

    If you have more than one Azure account, be sure that you are logged in with the account that is tied to the subscription that you will be using for this course.

1. Open the **Azure Cloud Shell** by clicking the **Terminal** icon within the top header bar of the Azure portal, and select the **Bash** shell option.

    > [!NOTE] Both *Bash* and *PowerShell* interfaces for the Azure Cloud Shell support the use of **OpenSSL**. In this unit you will use some helper scripts written for the *Bash* shell.

1. Within the Azure Cloud Shell, run the following commands that will download a helper script for using *OpenSSL* to generate x.509 CA Certificates. They will be placed within the `~/certificates` directory inside your Cloud Shell storage.

    ```sh
    # create certificates directory
    mkdir certificates
    # navigate to certificates directory
    cd certificates

    # download helper script files
    curl https://raw.githubusercontent.com/Azure/azure-iot-sdk-c/master/tools/CACertificates/certGen.sh --output certGen.sh
    curl https://raw.githubusercontent.com/Azure/azure-iot-sdk-c/master/tools/CACertificates/openssl_device_intermediate_ca.cnf --output openssl_device_intermediate_ca.cnf
    curl https://raw.githubusercontent.com/Azure/azure-iot-sdk-c/master/tools/CACertificates/openssl_root_ca.cnf --output openssl_root_ca.cnf

    # update script permissions so user can read, write, and execute it
    chmod 700 certGen.sh
    ```

    These helper scripts are being downloaded from the `Azure/azure-iot-sdk-c` open source project hosted on Github. This is an open source project that's a part of the Azure IoT SDK. The `certGen.sh` helper script will help demonstrate the purpose of CA Certificates without diving into the specifics of OpenSSL configuration that's outside the scope of this unit.

    For additional instructions on using this helper script, and for instructions on how to use PowerShell instead of Bash, please see this link: <https://github.com/Azure/azure-iot-sdk-c/blob/master/tools/CACertificates/CACertificateOverview.md>

    > **Warning:** Certificates created by this helper script **MUST NOT** be used for Production. They contain hard-coded passwords ("*1234*"), expire after 30 days, and most importantly are provided for demonstration purposes to help you quickly understand CA Certificates. When building products against CA Certificates, you'll need to use your own security best practices for certification creation and lifetime management.

1. The first x.509 certificates needed are CA and intermediate certificates. These can be generated using the `certGen.sh` helper script by passing the `create_root_and_intermediate` option.

    Run the following command within the `~/certificates` directory of the **Azure Cloud Shell** to generate the CA and intermediate certificates:

    ```sh
    ./certGen.sh create_root_and_intermediate
    ```

1. The previous command generated a CA Root Certificate named `azure-iot-test-only.root.ca.cert.pem` is located within the `./certs` directory.

    Run the following command within the **Azure Cloud Shell** to download this certificate to your local machine so it can be uploaded to DPS.

    ```sh
    download ~/certificates/certs/azure-iot-test-only.root.ca.cert.pem
    ```

1. Navigate to the **Device Provisioning Service** (DPS) named `AZ-220-DPS-{YOUR-ID}` within the Azure portal.

1. On the **Device Provisioning Service** blade, click the **Certificates** link under the **Settings** section.

1. On the **Certificates** pane, click the **Add** button at the top to start process of uploading the x.509 CA Certificate to the DPS service.

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
