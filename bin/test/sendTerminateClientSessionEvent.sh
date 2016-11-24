#!/bin/bash
# Licensed Materials - Property of IBM
#     5724-W86, 5724-X63
# Copyright IBM Corporation 2013. All Rights Reserved.
# US Government Users Restricted Rights- Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
#
# Wrapper script to replicate Terminate client session events
#

cd $(dirname $0)/..
source ./env.sh

UNIX_DATE=` date +"%s"`
EVENT_MESSAGE="<SOAP:Envelope xmlns:SOAP=\"http://schemas.xmlsoap.org/soap/envelope/\"><SOAP:Header><header xmlns=\"xmlapi_1.0\"><eventName>TerminateClientSession</eventName><ALA_category>GENERAL</ALA_category><ALA_OLC>0</ALA_OLC><ALA_isVessel>false</ALA_isVessel><ALA_allomorphic></ALA_allomorphic><MTOSI_osTime>${UNIX_DATE}000</MTOSI_osTime><MTOSI_NTType>NT_STATE_CHANGE</MTOSI_NTType><MTOSI_objectName></MTOSI_objectName><ALA_clientId>${SAM_UNIQUE_ID}@1</ALA_clientId><MTOSI_objectType>TerminateClientSession</MTOSI_objectType><ALA_eventName>TerminateClientSession</ALA_eventName></header></SOAP:Header><SOAP:Body><jms xmlns=\"xmlapi_1.0\"><terminateClientSessionEvent><clientId>${SAM_UNIQUE_ID}@1</clientId></terminateClientSessionEvent></jms></SOAP:Body></SOAP:Envelope>"

./sendJmsMessage.sh tcp://localhost:61616 $SAM_UNIQUE_ID "$EVENT_MESSAGE"
