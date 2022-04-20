#!/bin/bash

#	doc monitor - client configuration
#	script for syncing local and remote directory

# See readme for more information

LOCAL_DIR=~/Documents/					# Directory to sync with HOST_DIR
LAST_LOCAL_MOD_FILE=/opt/doc-monitor/.doc_mod_time	# File to store latest local file modification timestamp	
LAST_SERVER_MOD_FILE=/opt/doc-monitor/.pi_doc_mod_time	# File to store latest server modifcation timestamp
LOCAL_RMLIST=/opt/doc-monitor/.rmlist			# Local copy of rmlist - view readme for info

# READ CAREFULLY:
#   You MUST define a HOST address here and you must have
#   passwordless login to this address.
#   See https://linuxize.com/post/how-to-setup-passwordless-ssh-login/
#   If these conditions are not met, you can set save this file
#   and finish the setup, revisiting this file in /opt/doc-monitor
#   later, when you have met the criteria.
HOST=USERNAME@ADDRESS			# Host -- example: user@example.com OR user@192.168.0.27
HOST_RMLIST=$HOST:/home/ubuntu/rmlist	# Location of rmlist
HOST_DIR=$HOST:/home/ubuntu/Documents/	# Directory to sync with LOCAL_DIR on client machines
HOST_DOC_MOD_TIME_FILE=$HOST:/home/ubuntu/pi_doc_mod_time # Location of server's latest file mod timstamp

