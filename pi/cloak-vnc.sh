#!/bin/bash
#
#  remot3.it, Inc. : https://remote.it
#
# This script has the following format: script.sh $1 $2 $3 where
#
#   $1 = jobid
#   $2 = api server url
#   $3 = short code
#

# r3_header, -l (Mebst|Choose Action|Cloak Service|Uncloak Service)

#### Settings #####
VERSION=0.0.9
MODIFIED="May 19, 2020"
#
# Config
#
TOOL_DIR="/usr/bin"
DEBUG_DIR="/tmp"
NOTIFIER="connectd_task_notify"

# turn on debug, set to 1 and will write to DEBUG_DIR/scriptname.log
DEBUG_ON=1
DEBUG=0


APIKEY="remote.it.developertoolsHW9iHnd"

# set -x
#
# API for short code
#
apiMethod="https://"
apiURI="/tiny/lookup/"

##### End Settings #####


########################################
# Support Functions                    #
########################################
#----------------------------------------------------------
# JSON parse (very simplistic):  get value frome key $2 in buffer $1,  values or keys must not have the characters {}[",
#   and the key must not have : in it
#
#  Example:
#   value=$(jsonval "$json_buffer" "$key")
#
jsonval()
{
    temp=$(echo "$1" | sed -e 's/[{}\"]//g' | sed -e 's/,/\n/g' | grep -w ${GREPFLAGS} "$2" | cut -d"[" -f2- | cut -d":" -f2-)
    echo "${temp##*|}"
}

#
# Print Usage
#
usage()
{
    echo "Usage: $0 <jobid> <api server> <shortcode>" >&2
    echo "Version $VERSION Build $MODIFIED" >&2
    return 0
}
#
# log if DEBUG_ON is set to /tmp
#
log()
{
    if [ $DEBUG_ON -gt 0 ]; then
        ts=$(date)
        echo "$ts $1" >> ${DEBUG_DIR}/$(basename $0).log
    fi
}
#
# Job Complete
#
Job_Complete()
{
    ret=$(${TOOL_DIR}/$NOTIFIER 1 $jobid $api_server "Job Complete")
}
#
# Job Failed
#
Job_Failed()
{
    ret=$(${TOOL_DIR}/$NOTIFIER 2 $jobid $api_server "Job Failed")
}
#
# Status column A
#
Status_A()
{
    ret=$(${TOOL_DIR}/$NOTIFIER a $jobid $api_server "$1")
}

#
# Status column B
#
Status_B()
{
    ret=$(${TOOL_DIR}/$NOTIFIER b $jobid $api_server "$1")
}

#
# Status column C
#
Status_C()
{
    ret=$(${TOOL_DIR}/$NOTIFIER c $jobid $api_server "$1")
}
#
# Status column D
#
Status_D()
{
    ret=$(${TOOL_DIR}/$NOTIFIER d $jobid $api_server "$1")
}

#
# translate short code
#
translate()
{
    ret=0
    # make api call
    translate_url=${apiMethod}${api_server}${apiURI}${short_code}

    log "Translate URL call using URL $translate_url"

    resp=$(curl -s -S -X GET -H "content-type:application/json" -H "apikey:WeavedDeveloperToolsWy98ayxR" "$translate_url")

    status=$(jsonval "$resp" "status")

    log "return status $status"

    if [ "$status" == "true" ]; then
        #jsonvalx()
        item=$(jsonval "$resp" "item")
        #
        # Convert from base64
        decode=$(echo "$item" | base64 --decode)

        log "item $item -> $decode"

        echo -n "$decode"
    else
        printf "Fail"
        ret=1
    fi

    return $ret
}


########################################
# Put Custom Support Functions Here    #
########################################

cloakSSH()
{
    sed -i 's/#ListenAddress 0.0.0.0/ListenAddress 127.0.0.1/' /etc/ssh/sshd_config
	listen=$(grep "ListenAddress" /etc/ssh/sshd_config)
	systemctl restart sshd
	log "remote.it cloak SSH $listen"
}

uncloakSSH()
{
    sed -i 's/ListenAddress 127.0.0.1/#ListenAddress 0.0.0.0/' /etc/ssh/sshd_config
	listen=$(grep "ListenAddress" /etc/ssh/sshd_config)
	systemctl restart sshd
	log "remote.it uncloak SSH $listen"
}

cloakVNC()
{
  echo "localhost=1" >> /root/.vnc/config.d/vncserver-x11
  systemctl restart vncserver-x11-serviced.service
	log "remote.it cloak VNC 127.0.0.1"
}

uncloakVNC()
{
  sed -i -e '/localhost=1/d' /root/.vnc/config.d/vncserver-x11
  systemctl restart vncserver-x11-serviced.service
	log "remote.it uncloak VNC 0.0.0.0"
}

########################################
# Main Customer Script Starts Here     #
########################################
customer_main()
{
    ################################################
    # parse the flag options (and their arguments) #
    ################################################
    while getopts lvhmcr OPT; do
        case "$OPT" in
        v)
            DEBUG_ON=$((DEBUG_ON+1)) ;;
        h | [?])
            # got invalid option
            usage
            exit 1
            ;;
        esac
    done

}


###############################
# Main program starts here    #
###############################
#
# Must have 3 parameters
#
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    usage
    exit 1
fi

jobid=$1
shift
api_server=$1
shift
short_code=$1

#
if [ $DEBUG_ON -gt 0 ]; then
    echo "$0 called with jobid $jobid api_server $api_server and shortcode $short_code" >> $0.log
fi

command=$(translate $short_code)

if [ "$?" -gt 0 ]; then
    echo "[Fail] translate short code $short_code failed"
    exit 1
fi

if [ $DEBUG_ON -gt 0 ]; then
    echo "Translated short code to $command" >> $0.log
fi


#
# Must use eval to correctly expand command
#
eval set -- ${command}

# keep track of first and second text parameter
parameter=0

################################################
# parse the flag options (and their arguments) #
################################################
while getopts l: OPT; do
    case "$OPT" in
        l)
            # name of web package as shown above in r3-header
            echo "-l"
            echo "(l) $OPTARG"
			if [ "$parameter" -eq 0 ]; then
				action=$(echo "$OPTARG")
				parameter=1
			elif [ "$parameter" -eq 1 ]; then
			    server=$(echo "$OPTARG")
			fi
            ;;
		*)
			echo "$OPT"
		;;
        esac
    done

echo "Case done!"
# hardwire server to VNC for the moment
server="VNC"

set -x

Status_C "$action"
Status_D "$server"

if [ "$action" == "Cloak Service" ]; then
    if [ "$server" == "SSH" ]; then
	    cloakSSH
	elif [ "$server" == "VNC" ]; then
	    cloakVNC
	fi
elif [ "$action" == "Uncloak Service" ]; then
    if [ "$server" == "SSH" ]; then
	    uncloakSSH
	elif [ "$server" == "VNC" ]; then
	    uncloakVNC
	fi
fi

#-------------------------------------------------

Job_Complete
