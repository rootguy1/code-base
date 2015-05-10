#!/bin/bash

#VARIABLES
CATALINA_BASE="/billing/tomcat"
CATALINA_HOME="/billing/tomcat"
CATALINA_TMPDIR="/billing/tomcat/temp"
JRE_HOME="/billing/jdk16"


export CATALINA_BASE="/billing/tomcat"
export CATALINA_HOME="/billing/tomcat"
export CATALINA_TMPDIR="/billing/tomcat/temp"
export JRE_HOME="/billing/jdk16"

NAGIOS_OK=0
NAGIOS_WARNING=1
NAGIOS_CRITICAL=2
NAGIOS_UNKNOWN=3

PROGNAME=`basename $0 .sh`
VERSION="Version 1.0"

WGET=/usr/bin/wget
GREP=/bin/grep

print_version() {
    echo "$VERSION"
}

print_help() {
    print_version $PROGNAME $VERSION
    echo ""
    echo "$PROGNAME is a Nagios plugin to check a specific Tomcat Application."
    echo ""
    echo "$PROGNAME -u user -p password -h host -P port -a application"
    echo ""
    echo "Options:"
    echo "  -u/--user)"
    echo "     User name for authentication on Tomcat Manager Application"
    echo "  -p/--password)"
    echo "     Password for authentication on Tomcat Manager Application"
    echo "  -H/--host)"
    echo "     Host Name of the server"
    echo "  -P/--port)"
    echo "     Port Number Tomcat service is listening on"
    echo "  -a/--appname)"
    echo "     Application name to be checked"
    exit $ST_UK
}

if [ ! -x "$WGET" ]
then
	echo "wget not found!"
	exit $NAGIOS_CRITICAL
fi

if [ ! -x "$GREP" ]
then
	echo "grep not found!"
	exit $NAGIOS_CRITICAL
fi




if test -z "$1"
then
	print_help
	exit $NAGIOS_CRITICAL
fi

while test -n "$1"; do
    case "$1" in
        --help|-h)
            print_help
            exit $ST_UK
            ;;
        --version|-v)
            print_version $PROGNAME $VERSION
            exit $ST_UK
            ;;
        --user|-u)
            USER=$2
            shift
            ;;
        --password|-p)
            PASSWORD=$2
            shift
            ;;
        --host|-H)
            HOST=$2
            shift
            ;;
        --port|-P)
            PORT=$2
            shift
            ;;
        --appname|-a)
            APP=$2
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            print_help
            exit $ST_UK
            ;;
        esac
    shift
done
date
if wget -o /dev/null -O - http://$HOST:$PORT/webService/crbtAction/queryMDN?mdn=123456789 | grep succeeded
then
 	return_status="OK: Application $APP is running!"
        exit $NAGIOS_OK
else
         echo "CRITICAL: Application $APP is not running!"


echo -n "Shutting down old instances....."
/etc/init.d/tomcat stop
#cd /billing/tomcat/bin
#./shutdown.sh

echo "[DONE]"

#echo -n "Killing any disfunctioning instances......"
#for i in `ps -ef | grep tomcat | grep -v grep | awk '{ print  $2  }'` ; do kill -9 $i ; done
#echo "[DONE]"

echo -n "Starting instances....."
/etc/init.d/tomcat start
# cd /billing/tomcat/bin
# ./startup.sh
echo "[DONE]"






#        exit $NAGIOS_CRITICAL

fi


