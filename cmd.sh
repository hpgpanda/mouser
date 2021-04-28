#!/bin/bash
option="$1"
case $option in
    -p) keyword=$2
	echo keyword=$2
	;;
    *)
	echo other
	;;
esac
