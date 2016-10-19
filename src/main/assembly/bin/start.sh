#!/bin/sh

#check JAVA_HOME & java
noJavaHome=false
if [ -z "$JAVA_HOME" ] ; then
    noJavaHome=true
    fi
    if [ ! -e "$JAVA_HOME/bin/java" ] ; then
        noJavaHome=true
	fi
	if $noJavaHome ; then
	    echo
	    echo "Error: JAVA_HOME environment variable is not set."
		echo
		exit 1
	fi

#set DIST_HOME
CURR_DIR=`pwd`
cd `dirname "$0"`/..
DIST_HOME=`pwd`
cd $CURR_DIR
if [ -z "$DIST_HOME" ] ; then
    echo
    echo "Error: DIST_HOME environment variable is not defined correctly."
    echo
    exit 1
fi

RUN_CMD="\"$JAVA_HOME/bin/java\""
RUN_CMD="$RUN_CMD -DDIST_HOME=\"$DIST_HOME\" -cp \"../conf:../lib/*\" -jar ../zk-browser.war ${1+$@}"
#echo $RUN_CMD
eval $RUN_CMD
