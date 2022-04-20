#!/bin/bash

#	doc monitor - client script
#	script for syncing local and remote directory

source /opt/doc-monitor/doc-monitor-config.sh # configuration

# If LAST_LOCAL_MOD_FILE does not exist, create it
if ! [[ -f $LAST_LOCAL_MOD_FILE ]];
then
	echo `find $LOCAL_DIR -type f -printf "%T@\n" | sort | tail -1` > $LAST_LOCAL_MOD_FILE;
fi

# Loop until process is killed
while true
do
	# PART 1 - Run every 5 seconds for 25-30 seconds
	# For pushing updates to pi
	for (( i=0; i<=5; i++ ))
	do
		PREV_MODTIME=`cat $LAST_LOCAL_MOD_FILE`
		NEW_MODTIME=`find $LOCAL_DIR -type f -printf "%T@\n" | sort | tail -1`

		if [ $PREV_MODTIME != $NEW_MODTIME ]
		then
			# Update local copy of rmlist 
			rsync -aXvPE --update $HOST_RMLIST $LOCAL_RMLIST

			# Array of files on rmlist, set for deletion
			mapfile -t RM_ITEMS < <(awk -F" " '{print $2}' $LOCAL_RMLIST)

			UP_ITEMS=() # Array of files to be uploaded
			while IFS= read -r line; do
				if [[ -z "$line" ]];
				then
					break; # Build array until first empty line
				else
					UP_ITEMS+=("$line");
				fi
			done < <(rsync -aXvPE --update --dry-run $LOCAL_DIR $HOST_DIR)

			for a in "${RM_ITEMS[@]}"
			do
				for b in "${UP_ITEMS[@]}"
				do
					if [[ $a == "$b" ]]; # If files pending upload or on rmlist
					then
						echo "$b will be deleted";
						NODE=$LOCAL_DIR/$b

						if [[ -f $NODE ]];
						then 
							rm $NODE;
						else
							if [[ -d $NODE ]];
							then
								rm -r $NODE;
							else
								echo "$NODE not found";
							fi
						fi
					fi
				done
			done

			# Sync to pi if local files are modified
		        rsync -aXvPE --update --exclude '*.swp' $LOCAL_DIR $HOST_DIR
		        echo $NEW_MODTIME > $LAST_LOCAL_MOD_FILE
			scp $LAST_LOCAL_MOD_FILE $HOST_DOC_MOD_TIME_FILE
		fi
		sleep 5s
	done

	# PART 2 - Run every 25-30 seconds
	# For pulling updates from pi
	rsync -aXvPE --update $HOST_DOC_MOD_TIME_FILE $PREV_PI_MOD_TIME_FILE 

	PREV_MODTIME=`cat $LAST_LOCAL_MOD_FILE`

	if [ $PREV_MODTIME != $LAST_SERVER_MOD_FILE ]
	then
		# Update local on remote changes
	        rsync -aXvPE --update --exclude '*.iso' $HOST_DIR $LOCAL_DIR 

	        # Set server modtime to local modtime after sync
	        echo $LAST_SERVER_MOD_FILE > $LAST_LOCAL_MOD_FILE
	fi
done

