#!/bin/bash

#Stablishing directory
direct="/home/alejandro/"

#Create log file
touch cambios.log

#Registers changes done to the directory

while true; do
	cambio=$(inotifywait -e create,delete,modify,move --format '%T %w%f %e' --timefmt '%Y-%m-%d %H:%M:%S' "$direct")
	echo "$cambio" >> cambios.log
done




