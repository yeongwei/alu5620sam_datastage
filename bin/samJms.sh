#!/bin/bash
# Licensed Materials - Property of IBM
#     5724-W86, 5724-X63
# Copyright IBM Corporation 2013. All Rights Reserved.
# US Government Users Restricted Rights- Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
#
# Internal script to start, stop and check status of SAM JMS client daemon
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

if [ -z "$SAM_JMSURL1" ]; then
  echo "SAM_JMSURL1 not set. Make sure you run the job atleast once before running this"
  exit 1
fi

if [ -z "$SAM_JMSURL2" ]; then
  echo "SAM_JMSURL2 not set. Make sure you run the job atleast once before running this"
  exit 1
fi


######################################################
### check whether daemon is alive
###		return 1 if it's a live
###		return 0 if otherwise
######################################################
function isDaemonAlive
{
  eval $($DAEMON -M STATUS -d $WORK_DIR)			# this will force the variables from the output for status

  if [ $UDMD_STATUS == "RUNNING" ] ; then
    return 1
  elif [ $UDMD_STATUS == "STOPPED" ] ; then
    return 0
  elif [ $UDMD_STATUS == "NEW" ] ; then
    return 0
  else
    return 2
  fi
}

######################################################
### start the daemon
### send STATUS: SUCCESS/RUNNING/STOP to DS monitor
######################################################
function doStart
{
  # Java daemon needs sets of jar to be included
  export CLASSPATH=$DS_WORKSPACE/udm/cfg:$DS_WORKSPACE/udm/jar/sam-jms-daemon.jar:$DS_WORKSPACE/udm/jar/log4j-1.2.16.jar:$DS_WORKSPACE/udm/jar/samOss.jar:$DS_WORKSPACE/udm/jar/activemq-all-5.5.1.jar:$DS_WORKSPACE/udm/jar/ds-base.jar:$DS_WORKSPACE/udm/jar/slf4j-log4j12-1.5.11.jar

  isDaemonAlive # first check the status
  isRunning=$?
  if [ $isRunning == 0 ] ; then  # start the daemon if it's not running
    # Generate filter list based classes from configuration
    CLSSTR=""
    CLSLIST=$(cat ../cfg/relation_lookup.csv | cut -d, -f4,6 | grep ',1$' | cut -d, -f1 | sort | uniq)
    for CLSNAME in $CLSLIST; do
      CLSSTR=$CLSSTR"'"$CLSNAME"',"
    done
    CLSSTR=${CLSSTR%,}
    FILTER="\"ALA_clientId in ('$SAM_UNIQUE_ID@1', '') and MTOSI_objectType in ('KeepAliveEvent','StateChangeEvent','TerminateClientSession','FileAvailableEvent','LogFileAvailableEvent',$CLSSTR) and ALA_category not in('STATISTICS','ACCOUNTING','FAULT')\""

    # start the daemon
    eval $DAEMON -M START -l $LOGDIR/daemon.log -d $WORK_DIR -e DS_DIR -e SAM_JMSURL1 -e SAM_JMSURL2 -e DS_WORKSPACE -e SAM_UNIQUE_ID -e SAM_USERNAME -e SAM_PASSWORD -c $JAVA_HOME -a com.ibm.tivoli.tnpm.udm.sam.jms.JmsDaemon -a "=f" -a $FILTER ${ARGSLIST[*]}
    sleep 10     # wait for 10 seconds
    isDaemonAlive
    status=$?
    if [ $status == 1 ] ; then
      echo "STATUS: SUCCESS"
    elif [ $status == 0 ] ; then
      echo "STATUS: STOP"
    else
      echo "STATUS: UNKNOWN"
    fi
  elif [ $isRunning == 1 ] ; then
    echo "STATUS: RUNNING"
  else
    echo "STATUS: UNKNOWN"
  fi
echo "$SAM_JMSURL1 : ${ARGSLIST[*]}"

}

######################################################
### stop the daemon
### stop daemon if and only if it's running
### return STATUS: STOP/RUNNING to DS daemon
######################################################
function doStop
{
  isDaemonAlive # first check the status
  isRunning=$?

  if [ $isRunning == 1 ] ; then     # stop the daemon if it's currently running
    $DAEMON -M STOP -d $WORK_DIR

    isDaemonAlive                   # check the daemon again
    status=$?

    if [ $status == 1 ] ; then
      echo "STATUS: RUNNING"        # daemon is currently running
    elif [ $status == 0 ] ; then
      echo "STATUS: STOP"						# daemon is currenly stopped
    else
      echo "STATUS: UNKNOWN"
    fi
  elif [ $isRunning == 0 ] ; then
    echo "STATUS: STOP"
  else
    echo "STATUS: UNKNOWN"
  fi
}
######################################################
### check the status of daemon
###		to be used from command line
######################################################
function doStatus
{
  $DAEMON -M STATUS -d $WORK_DIR
}

######################################################
### MAIN PROGRAM STARTS HERE
######################################################

  # check if we are asked to start, stop or just check status
  STARTSTOP=$1
  shift

  # get every arguments and place it in argument list
  INDEX=1
  LAST=$#
  while (( $INDEX < $LAST + 1 )); do
    ARGVAL="$1"
    if [ "${ARGVAL#-}" != "$ARGVAL" ] ; then
      ARGVAL="="${ARGVAL#-}
    fi

    ARGSLIST[${#ARGSLIST[*]}]="-a"
    ARGSLIST[${#ARGSLIST[*]}]=\"$ARGVAL\"
    shift
    INDEX=$(( $INDEX + 1 ))
  done

  case $STARTSTOP in
    "start" )
      doStart
      ;;
    "stop" )
      doStop
       ;;
    "status" )
      doStatus
      ;;
    * )
      echo "STATUS: UNKNOWN"
      ;;	
  esac
