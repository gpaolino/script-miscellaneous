#!/bin/bash
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                       #
# Can be launched from an external scheduler using this command:        #
# CMDNAME /home/java/jboss-eap-X.X/standalone/custom/run-extws-1.0.0.sh #
# ARGS "JOBNAME"                                                        #
#                                                                       #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

PreconditionFailed=412
ErrorCallWs=420
Success=00


extws_code=${1}
sleep_time=${2-20}
polling_interval=${3-10}
port=${4-8889}
ARGS=$#
host=$(hostname)
ESITO_START=`curl  -s -X POST http://$host:$port/extws/job.$extws_code/`



get_script_dir () {
     SOURCE="${BASH_SOURCE[0]}"
     # While $SOURCE is a symlink, resolve it
     while [ -h "$SOURCE" ]; do
          DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
          SOURCE="$(readlink "$SOURCE")"
          # If $SOURCE was a relative symlink (so no "/" as prefix, need to resolve it relative to the symlink base directory
          [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
     done
     DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
     echo "$DIR"
}

LOG_DIR=$(get_script_dir)"/"
LOG_NAME_FILE="$(basename "$0" .sh).log"
LOG_PATH_FILE=${LOG_DIR}${LOG_NAME_FILE}


log(){
    echo "$(date '+%Y-%m-%d %H:%M:%S,%3N') - $1": "$2" >> "$LOG_PATH_FILE"
}

property(){
    echo -e "\t"$1 >> "$LOG_PATH_FILE"
}

info() {
    log INFO "$1"
}
error() {
    log ERROR "$1"
}
warning() {
    log WARNING "$1"
}


# Start Script
startScript(){
    info  "Start script"
}


# End Error Script
endErrorScript(){
    error "Return code: $1" >> "$LOG_PATH_FILE"
    info "End script" >> "$LOG_PATH_FILE"
    echo "-----------------------------------" >> "$LOG_PATH_FILE"
}


# End Success Script
endSuccessScript(){
    info "Return code: $1" >> "$LOG_PATH_FILE"
    info "End script" >> "$LOG_PATH_FILE"
    echo "-----------------------------------" >> "$LOG_PATH_FILE"
}


checkArgs() {
    if [ $ARGS -eq 0 ]; then
         error "Numero Parametri non corretto"
         endErrorScript $PreconditionFailed
         exit $PreconditionFailed
    fi
}

callWs() {

    info "ESITO_START=$ESITO_START"

    if [ "$ESITO_START" -eq "$ESITO_START" ] 2>/dev/null
    then
        info "$ESITO_START  executionid to poll!!"
    else
        error "ERROR: $ESITO_START :server in invalid state"
        endErrorScript $ErrorCallWs
        exit $ErrorCallWs
    fi

}

checkJobExecution() {

    sleep $sleep_time
    while [ 1 ]
    do
    info "polling status in $polling_interval seconds..."

      sleep $polling_interval

       info "polling status now..."
       ESITO_QUERY=`curl -s http://$host:$port/extws/job.$extws_code/$ESITO_START/`
       info "ESITO_QUERY=$ESITO_QUERY"
         case "$ESITO_QUERY" in
            "EXECUTING") info "EXECUTING";;
            "COMPLETED")  info "COMPLETED"
                       endSuccessScript $Success
                       exit $Success
                             ;;
            "COMPLETED_WARN")  warning "COMPLETED_WARN"
                       endSuccessScript $Success
                       exit $Success
                             ;;
              *) error "KO"
                    endErrorScript $Success
                    exit 1
                    ;;
         esac

    done

}


startScript
checkArgs
callWs

checkJobExecution

endSuccessScript $Success
exit $Success

