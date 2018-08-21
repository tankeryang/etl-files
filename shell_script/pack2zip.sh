#! /bin/bash

BASE_PATH=$(cd `dirname $0`; cd ..; pwd)
JOB_PATH=$(cd ${BASE_PATH}/job; pwd)
ZIP_PATH=$(cd ${BASE_PATH}/zip; pwd)

OPT=`getopt -o n:d: --long zip-name:,dir-name:`

zip_name=""
dir_name=""

case "$1" in
    -n|--zip-name)
        zip_name=$2
        shift; shift;;
esac

# echo $zip_name

case "$1" in
    -d|--dir-name)
        if [ $zip_name == "" ]; then
            zip_name=$2
        fi;
        # echo $zip_name
        dir_name=$2;
        shift; shift;;
esac

zip -rv ${ZIP_PATH}/${zip_name}.zip ${JOB_PATH}/${dir_name}
