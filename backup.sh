#!/bin/bash
# Syncs backup to local backup location using rsync. In this case it is my external HDD. The program creates or updates a backup folder named
# "Linux_<foldername>_backup_<date>". If an older backup is found, the program updates the date and syncs the contents. If the program is run for the first time
# the program creates a new backup folder.   
# Daniel Pitulia, 2022-08-02
date=`date +%F`
backup_location=~/../../media/daniel/DanielHDD/Backup

if [ $# != 1 ]
then
	echo 'Please write one command argument which states the name of the folder to backup.'
	exit
fi

if [ ! -d ~/$1 ]
then
	echo 'The folder does not seem to exist'
	exit
fi

if [ -d "$backup_location"/Linux_$1_backup_$date/ ]
then
	echo 'Using rsync to update backup folder...'
	rsync -avz --delete $1/* "$backup_location"/Linux_$1_backup_$date/
	echo $1' has been synced to Backup HDD'
else
	if [ -d "$backup_location"/Linux_$1_backup_*/ ]
	then
		echo 'Older copy found, renaming to current date'
		mv "$backup_location"/Linux_$1_backup_*/ "$backup_location"/Linux_$1_backup_$date
		rsync -avz --delete $1/* "$backup_location"/Linux_$1_backup_$date/
		echo $1' has been synced to Backup HDD'
	else
		echo 'No older copy found, creating new backup'
		mkdir "$backup_location"/Linux_$1_backup_$date
		rsync -avz --delete $1/* "$backup_location"/Linux_$1_backup_$date/
		echo $1' has been added to Backup HDD'
	fi
fi


