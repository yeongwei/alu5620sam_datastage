#!/bin/bash
# Licensed Materials - Property of IBM
#     5724-W86, 5724-X63
# Copyright IBM Corporation 2013. All Rights Reserved.
# US Government Users Restricted Rights- Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
#
# Wrapper script to replicate done event
#

cd $(dirname $0)
source ./env.sh

./sendJmsMessage.sh tcp://localhost:61616 $SAM_UNIQUE_ID action/DONE
kill -9 `ps -eaf | grep defunc | tr -s " " |cut -d " " -f3| tr "\n" " "`
kill -9 `ps -eaf | grep defunc | tr -s " " |cut -d " " -f2| tr "\n" " "`
