#!/bin/bash
# Licensed Materials - Property of IBM
#     5724-W86, 5724-X63
# Copyright IBM Corporation 2013. All Rights Reserved.
# US Government Users Restricted Rights- Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
#
# Wrapper script to replicate File available events
#

cd $(dirname $0)/..
source ./env.sh

if [ $# -ne 1 ]; then
    echo "Incorrect arguments. required arguments - <fileName>"
    exit 1
fi

FILENAME="$1"

UNIX_DATE=` date +"%s"`
EVENT_MESSAGE="<SOAP:Envelope xmlns:SOAP=\"http://schemas.xmlsoap.org/soap/envelope/\"><SOAP:Header><header xmlns=\"xmlapi_1.0\"><MTOSI_osTime>${UNIX_DATE}000</MTOSI_osTime><ALA_clientId /><MTOSI_objectType>FileAvailableEvent</MTOSI_objectType><MTOSI_NTType>ALA_OTHER</MTOSI_NTType><ALA_category>GENERAL</ALA_category><ALA_allomorphic /><MTOSI_objectName /></header></SOAP:Header><SOAP:Body><jms xmlns=\"xmlapi_1.0\"><fileAvailableEvent><fileName>${FILENAME}</fileName></fileAvailableEvent></jms></SOAP:Body></SOAP:Envelope>"

./sendJmsMessage.sh tcp://localhost:61616 $SAM_UNIQUE_ID "$EVENT_MESSAGE"
