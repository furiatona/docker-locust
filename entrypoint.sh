#!/bin/sh

set -e
LOCUST_MODE=${LOCUST_MODE:-standalone}
LOCUST_MASTER_BIND_PORT=${LOCUST_MASTER_BIND_PORT:-5557}
LOCUST_FILE=${LOCUST_FILE:-locustfile.py}

if [ -z ${TARGET_HOST+x} ] ; then
    echo "Please set TARGET_HOST (E.g. http://example.com)."
    exit 1
fi

LOCUST_OPTS="-f ${LOCUST_FILE} --host=${TARGET_HOST} $LOCUST_OPTS"

case `echo ${LOCUST_MODE} | tr 'a-z' 'A-Z'` in
"MASTER")
    LOCUST_OPTS="--master --master-bind-port=${LOCUST_MASTER_BIND_PORT} $LOCUST_OPTS"
    ;;

"SLAVE")
    LOCUST_OPTS="--slave --master-host=${LOCUST_MASTER_HOST} --master-port=${LOCUST_MASTER_BIND_PORT} $LOCUST_OPTS"
    if [ -z ${LOCUST_MASTER_HOST+x} ] ; then
        echo "Please set LOCUST_MASTER_HOST (E.g. hostname or IP)."
        exit 1
    fi
    ;;
esac

locust ${LOCUST_OPTS}