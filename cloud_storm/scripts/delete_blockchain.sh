#!/bin/bash

ID=$1
sudo java -jar ./cloud_storm/CloudsStorm-b.1.2.jar delete ./cloud_storm/cloud/$ID/architecture all
rm -rfv ./cloud_storm/cloud/$ID

