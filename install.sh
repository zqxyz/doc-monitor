#!/bin/bash

# 	https://github.com/zqxyz/doc-monitor
#	installation script

echo "Have you already installed and started the host script on your server?"
echo -n "y/n: "
read ANSWER
case $ANSWER in
	y | Y)
		echo "Have you set up passwordless access to your server?"
		echo -n "y/n: "
		read ANSWER2
		case $ANSWER2 in
			y | Y)
				;;
			n | N)
				echo "Then you should not proceed with this step yet."
				echo "See https://linuxize.com/post/how-to-setup-passwordless-ssh-login/"
				return;;
		esac;;
	n | N)
		return;;
esac

echo "Installing doc-monitor"

# Create directory and give ownership to current user
sudo mkdir /opt/doc-monitor/
sudo chown $USER /opt/doc-monitor

# Move scripts into directory and make executable
mv doc-monitor-client.sh doc-monitor-config.sh /opt/doc-monitor/
cd /opt/doc-monitor && chmod 775 *

# Make cronjob at boot
(crontab -l ; echo "@reboot /opt/doc-monitor/doc-monitor-client.sh") 2> /dev/null | crontab -

# Try command line editor, fallback to DE set editor
if [ -z ${EDITOR} ];
then
	xdg-open /opt/doc-monitor/doc-monitor-config.sh;
else
	$EDITOR /opt/doc-monitor/doc-monitor-config.sh;
fi;

# Assume user set up config correctly
echo "Installation complete. Starting program."

# Start script and disown (leave running after closing terminal)
bash /opt/doc-monitor/doc-monitor-client.sh > /dev/null &
disown %1
echo "Running in background. You may close the terminal."

