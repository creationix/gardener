#!/bin/sh
set -e
rm -f firmware*.bin
echo "Compiling in the cloud..."
particle compile
echo "Flashing via USB using DFU mode..."
sudo particle flash --usb firmware*.bin
