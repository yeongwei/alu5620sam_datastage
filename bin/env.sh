#!/bin/bash
# Licensed Materials - Property of IBM
#     5724-W86, 5724-X63
# Copyright IBM Corporation 2013. All Rights Reserved.
# US Government Users Restricted Rights- Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
#
# Internal script to setup environment for other scripts
#

# cd to bin directory should happen before reaching this
BINDIR=$PWD ; export BINDIR
CFGDIR=../cfg ; export CFGDIR
LOGDIR=../logs ; export LOGDIR
WORK_DIR=$CFGDIR ; export WORK_DIR
DAEMON=$BINDIR/daemonize

DS_INTERNAL=1 ; export DS_INTERNAL

eval $($BINDIR/daemonize -M STATUS -d $CFGDIR)
export DS_DIR
export SAM_JMSURL1
export SAM_JMSURL2
export DS_WORKSPACE
export SAM_UNIQUE_ID
export SAM_USERNAME
export SAM_PASSWORD


#JAVA 1.7 path to connect to SAM13

export JAVA_HOME=$DS_DIR/../../ASBNode/apps/jre/bin/java
#export JAVA_HOME=/home/dsadm/jdk1.8.0_05/bin/java
