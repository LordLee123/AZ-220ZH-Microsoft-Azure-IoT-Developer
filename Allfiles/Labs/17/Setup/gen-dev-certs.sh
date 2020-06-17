#!/bin/bash

# Generate 10 device certificates 
# Rename for each device
# download from the Cloud CLI
pushd ~/certificates
for i in {1..10}
do
    chmod +w ./certs/new-device.cert.pem
    ./certGen.sh create_device_certificate asset-track$i
    sleep 5
    cp ./certs/new-device.cert.pfx ./certs/new-asset-track$i.cert.pfx 
    download ./certs/new-asset-track$i.cert.pfx 
done
popd
