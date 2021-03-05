#!/bin/bash

[[ $(id -u) -ne 0 ]] && echo "Please run as root!" && exit 255 # https://stackoverflow.com/questions/18215973/how-to-check-if-running-as-root-in-a-bash-script
[[ -z "$(command -v youtube-dl)" ]] && echo "youtube-dl not found!" && exit 1

function versionCheck()
{
	echo -en "Checking version..."
	currentVersion=$(youtube-dl --version)
	newVersion=$(curl -s https://raw.githubusercontent.com/ytdl-org/youtube-dl/master/ChangeLog | awk 'FNR == 1 {print $2}')

	if [ $currentVersion != $newVersion ]
	then
		isUpdated=0
		echo -e "\rChecking version... ($currentVersion / $newVersion)"
		echo -en "Found new version, updating..."
		ytdlUpdate
	else
		if [ "$isUpdated" = 1 ]
		then
			echo -e "\nUpdate finished ($currentVersion)"
		else
			echo -e "\nyoutube-dl version is up to date ($currentVersion)"
		fi
	fi
}

function ytdlUpdate()
{
	curl -sL https://yt-dl.org/downloads/latest/youtube-dl -o /usr/bin/youtube-dl
	chmod a+rx /usr/bin/youtube-dl
	isUpdated=1
	echo -e "\rFound new version, updating... Done!"
	versionCheck
}

###

versionCheck
exit 0
