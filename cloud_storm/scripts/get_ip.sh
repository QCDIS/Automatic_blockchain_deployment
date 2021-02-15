#!/bin/bash

ID=$1
log_file="./cloud_storm/cloud/$ID/architecture/Logs/InfrasCode.log"
pub_IP_monitor=`cat $log_file | egrep -o 'monitor#pubIP: .*'`
pub_IP_monitor=`echo $pub_IP_monitor | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])'`
pub_IP_monitor=`echo "$pub_IP_monitor" | tr -d '\n'`
echo $pub_IP_monitor