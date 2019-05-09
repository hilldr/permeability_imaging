#!/bin/bash
## ImageJ threshold quantification processing script
## David R. Hill

## set directory containing unprocessed images
VSIDIR=$1
## set output directory
RESULTDIR=$2

## set minimum threshold value with --min_thresh=
for i in "$@"
do
case $i in
    --min_thresh=*)
    MINTHRESH="${i#*=}"
    shift # past argument=value
    ;;

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

if [ -z "$MINTHRESH" ]
then
read -p "Set minimum threshold value (in quotes if multiple):" MINTHRESH
fi

## make folder to deposit results
mkdir -p $RESULTDIR

echo "[START] converting VSI files in $VSIDIR to tif files for experiment $EXPERIMENT"

java -jar ./bin/ij.jar --headless -ijpath ./bin -batch ./src/vsi2baseline.ijm $VSIDIR

echo "[FINISHED] converting T0 VSI files to TIF"

## warn the user this may take some time
echo '[START] Computing fluorescence intensity values...'


## create data file and add header line
echo 'Filename	Area	Mean	Min	Max	Median' > \
     $RESULTDIR/$EXPERIMENT\_threshold_estimates.txt

## process all files in VSIDIR and output to threshold_estimates.txt
start_count=$(ls -d $VSIDIR/*.tif | wc -l)
for file in $VSIDIR/*.tif
do
    ## count number of tif files remaining
    count=$(ls -d $VSIDIR/*.tif | wc -l)
    echo "$count of $start_count tif files remaining in $VSIDIR"

    for value in $MINTHRESH
    do
    ## run imagej measurement script
	java -jar ./bin/ij.jar --headless -ijpath ./bin -batch $IJM "$file $value" | sed '1d' | cut -f 2-7 >> $RESULTDIR/$EXPERIMENT\_threshold_estimates.txt
    done

    ## delete tif file to save disk space
    rm $file
done

## print first 10 lines and message indicating completion
echo '[FINISHED] Computing fluorescence intensity values'
echo '[IMAGE PROCESSING FINISHED]'
echo 'Printing first 10 lines of output'
echo '#################################'
head $RESULTDIR/$EXPERIMENT\_threshold_estimates.txt
