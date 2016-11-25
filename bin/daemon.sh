#!/bin/bash
# Licensed Materials - Property of IBM
#     5724-W86, 5724-X63
# Copyright IBM Corporation 2013. All Rights Reserved.
# US Government Users Restricted Rights- Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
#
# Wrapper script to start, stop and check status of SAM JMS client daemon
#

cd $(dirname $0)
source ./env.sh

if [ $# -ne 1 ]; then
  echo "USAGE : `basename $0` [start | stop | status]"
  exit 1
fi

ACTION=$1
case $ACTION in
  "start" )
    ./samJms.sh start -t 5620-SAM-topic-xml -s1 $SAM_JMSURL1 -s2 $SAM_JMSURL2 -c $SAM_UNIQUE_ID@1 -d -mq tcp://localhost:61616 -mqs $SAM_UNIQUE_ID
    ;;
  "stop" )
    ./samJms.sh stop
    ;;
  "status" )
    ./samJms.sh status
    ;;
  * )
    echo "USAGE : `basename $0` [start | stop | status]"
    ;;
esac
