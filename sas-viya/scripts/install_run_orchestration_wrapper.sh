#!/bin/bash
if [ -e "$HOME/.profile" ]; then
	. $HOME/.profile
fi
if [ -e "$HOME/.bash_profile" ]; then
	. $HOME/.bash_profile
fi
#set -x
#set -v
ScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

FORKS=5

INVENTORY_FILE="inventory.ini"

PID_FILE="/tmp/install_run_orchestration.pid"
RETURN_FILE="/tmp/install_run_orchestration.out"
FILE_OF_RECORD="/tmp/install_run_orchestration.log"
. "/sas/install/env.ini"

if [ ! -e "$PID_FILE" ]; then
    if [ ! -e "$RETURN_FILE" ]; then
        nohup ${ScriptDirectory}/install_run_orchestration.sh "$RETURN_FILE"  </dev/null &> "$FILE_OF_RECORD" &
        PID=$!
        echo $PID > "$PID_FILE"
    else
        exit $(cat $RETURN_FILE)
    fi
else
    if [ ! -e "$RETURN_FILE" ]; then
        PID="$(cat "$PID_FILE")"
        if ! kill -s 0 $PID; then
            echo "Install did not write return file. Assuming install is dead"
            exit 1
        fi
    else
        exit $(cat $RETURN_FILE)
    fi
fi

#tail -100f "$FILE_OF_RECORD" &
#tail_command_pid=$!
# one hour
TIME_TO_LIVE_IN_SECNDS=$((60*60))
CURRENT_TIME_ALIVE_IN_SECONDS=0
# wait for an hour or until the child process finishes.
while [ "$TIME_TO_LIVE_IN_SECNDS" -gt "$CURRENT_TIME_ALIVE_IN_SECONDS" ] && kill -s 0 $PID; do
    sleep 1
    CURRENT_TIME_ALIVE_IN_SECONDS=$((CURRENT_TIME_ALIVE_IN_SECONDS+1))

done
#kill $tail_command_pid
tail -1000 "$FILE_OF_RECORD"
if [ -e "$RETURN_FILE" ]; then
    # if we hit the end and have a return file, then return the value of that (which is the value of the underlying script
    exit $(cat $RETURN_FILE)
else
    if kill -s 0 $PID; then
        # if the process is still running and we just ran out of time, return 0
        exit 0
    else
        # if the process is not running and we don't have a return file, then something went wrong and invenstigation should happen
        exit 1
    fi
fi
