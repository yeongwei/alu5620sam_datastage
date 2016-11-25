#!/bin/bash
# Licensed Materials - Property of IBM
#     5724-W86, 5724-X63
# Copyright IBM Corporation 2013. All Rights Reserved.
# US Government Users Restricted Rights- Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
#
# Internal script to replicate custom events
#

if [ ${DS_INTERNAL-0} -eq 0 ]; then
  echo "This script should not be called directly, use the wrapper script"
  exit 1
fi  

cd $(dirname $0)
source ./env.sh

if [ -z "$DS_DIR" ]; then
  echo "DS_DIR not set. Make sure you run the job atleast once before running this"
  exit 1
fi

if [ -z "$DS_WORKSPACE" ]; then
  echo "DS_WORKSPACE not set. Make sure you run the job atleast once before running this"
  exit 1
fi

if [ -z "$SAM_UNIQUE_ID" ]; then
  echo "SAM_UNIQUE_ID not set. Make sure you run the job atleast once before running this"
  exit 1
fi

if [ -z "$SAM_USERNAME" ]; then
  echo "SAM_USERNAME not set. Make sure you run the job atleast once before running this"
  exit 1
fi

if [ -z "$SAM_PASSWORD" ]; then
  echo "SAM_PASSWORD not set. Make sure you run the job atleast once before running this"
  exit 1
fi


JAVA_EXE=$DS_DIR/../../ASBNode/apps/jre/bin/java
CLASSPATH=$DS_WORKSPACE/udm/cfg:$DS_WORKSPACE/udm/jar/activemq-all-5.5.1.jar:$DS_WORKSPACE/udm/jar/slf4j-log4j12-1.5.11.jar:$DS_WORKSPACE/udm/jar/log4j-1.2.16.jar:$DS_WORKSPACE/udm/jar/ds-base.jar
JAVA_CLASS=com.ibm.tivoli.tnpm.udm.sam.base.ActiveMQJmsClient

$JAVA_EXE -classpath $CLASSPATH $JAVA_CLASS "$@" 
