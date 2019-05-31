#!/bin/bash
## ImageJ extract specific timepoint tif files
## David R. Hill

## set directory containing unprocessed images
VSIDIR=$1
## set output directory
RESULTDIR=$2
## set timepoint
TIMEPOINT=$3

## set ImageJ macro
IJM=./src/threshold_RFU_measure.ijm
DIRNAME=${VSIDIR%/}
EXPERIMENT=${DIRNAME##*/}

## if arguments are not supplied, prompt user for directories and cores
if [ -z "$1" ]
then
    read -e -p "Directory containing unprocessed VSI images:" VSIDIR
fi

if [ -z "$2" ]
then
read -e -p "Output directory to deposit results:" RESULTDIR
fi

if [ -z "$TIMEPOINT" ]
then
read -p "Timepoint to extract (image #)" TIMEPOINT
fi

## make folder to deposit results
mkdir -p $RESULTDIR

echo "[START] converting VSI files in $VSIDIR to tif files"
echo "experiment $EXPERIMENT and timepoint $TIMEPOINT"

java -jar ./bin/ij.jar --headless -ijpath ./bin -batch ./src/vsi2timepoint.ijm "$VSIDIR $TIMEPOINT"

## move tif files to RESULTDIR
mv $VSIDIR/*.tif $RESULTDIR

echo "[FINISHED] converting T0 VSI files to TIF"

