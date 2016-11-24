#!/bin/bash
# Licensed Materials - Property of IBM
#     5724-W86, 5724-X63
# Copyright IBM Corporation 2013. All Rights Reserved.
# US Government Users Restricted Rights- Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
#
# Wrapper script to replicate JMS Missed events
#

cd $(dirname $0)/..
source ./env.sh

UNIX_DATE=` date +"%s"`
EVENT_MESSAGE="<SOAP:Envelope xmlns:SOAP=\"http://schemas.xmlsoap.org/soap/envelope/\"><SOAP:Header><header xmlns=\"xmlapi_1.0\"><eventName>JmsMissedEvents</eventName><MTOSI_osTime>${UNIX_DATE}000</MTOSI_osTime><ALA_clientId>${SAM_UNIQUE_ID}@1</ALA_clientId><MTOSI_NTType>ALA_OTHER</MTOSI_NTType><MTOSI_objectType>StateChangeEvent</MTOSI_objectType><ALA_category>GENERAL</ALA_category><ALA_isVessel>false</ALA_isVessel><ALA_allomorphic/><ALA_eventName>JmsMissedEvents</ALA_eventName><MTOSI_objectName/><ALA_OLC>0</ALA_OLC></header></SOAP:Header><SOAP:Body><jms xmlns=\"xmlapi_1.0\"><stateChangeEvent><eventName>JmsMissedEvents</eventName><state>jmsMissedEvents</state></stateChangeEvent></jms></SOAP:Body></SOAP:Envelope>"

./sendJmsMessage.sh tcp://localhost:61616 $SAM_UNIQUE_ID "$EVENT_MESSAGE"
