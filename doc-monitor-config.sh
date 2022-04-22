#!/bin/bash

#	doc monitor - client configuration
#	script for syncing local and remote directory

# You must specify username and address to server running host script
# Read the README 
HOST=USERNAME@ADDRESS					# Host -- example: user@example.com OR user@192.168.0.27
HOST_DIR=$HOST:/home/USERNAME/Documents/		# Directory to sync with LOCAL_DIR on client machines

# These are some nice defaults. No reason to change these.
LOCAL_DIR=~/Documents/					# Directory to sync with HOST_DIR
HOST_RMLIST=$HOST:/opt/doc-monitor/.rmlist		# Location of rmlist
HOST_DOC_MOD_TIME_FILE=$HOST:/opt/doc-monitor/.pi_doc_mod_time # Location of server's latest file mod timstamp
LAST_LOCAL_MOD_FILE=/opt/doc-monitor/.doc_mod_time	# File to store latest local file modification timestamp	
LAST_SERVER_MOD_FILE=/opt/doc-monitor/.pi_doc_mod_time	# File to store latest server modifcation timestamp
LOCAL_RMLIST=/opt/doc-monitor/.rmlist			# Local copy of rmlist - view readme for info
