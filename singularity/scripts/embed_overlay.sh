#!/bin/bash

# get the path to this script
REPO_PATH=`dirname "$0"`
REPO_PATH=`( cd "$REPO_PATH/.." && pwd )`
FILE_NAME=${1:-'simulation'}

singularity sif add --datatype 4 --partfs 2 --parttype 4 --partarch 2 --groupid 1 $REPO_PATH/images/$FILE_NAME.sif $REPO_PATH/overlays/$FILE_NAME.img
