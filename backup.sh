#!/bin/bash
# Syncs backup to local backup location using rsync. In this case it is my external HDD. The program creates or updates a backup folder named
# 'Linux_<foldername>_backup_<date>'. If an older backup is found, the program updates the date and syncs the contents. If the program is run for the first time
# the program creates a new backup folder.
# Daniel Pitulia, 2022-08-02

date=`date +%F`
backup_location=~/../../media/daniel/DanielHDD/Backup
backup_folder=${backup_location}/Linux_${1}_backup_${date}/

if [ ! $# == 1 ]
then
	echo 'Please write the source folder as a command argument, e.g. bash backup.sh Documents'
	exit
fi


if [ ! -d $1 ]
then
	echo 'The source folder does not seem to exist'
	exit
fi

if [ -d $backup_folder ]
then
	echo "Using rsync to update backup folder..."
	rsync -avz --delete ${1}/* $backup_folder
	echo ${1} has been synced to Backup HDD
else
	if [ -d ${backup_location}/Linux_${1}_backup_*/ ]
	then
		echo 'Older copy found, renaming to current date'
		mv ${backup_location}/Linux_${1}_backup_*/ $backup_folder
		rsync -avz --delete ${1}/* $backup_folder
		echo ${1} has been synced to Backup HDD
	else
		echo 'No older copy found, creating new backup'
		mkdir $backup_folder
		rsync -avz --delete ${1}/* $backup_folder
		echo ${1} has been added to Backup HDD
	fi
fi
