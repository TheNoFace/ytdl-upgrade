#!/bin/bash

pkgName='youtube-dl'

[[ $(id -u) -ne 0 ]] && echo "Please run as root!" && exit 255 # https://stackoverflow.com/a/28776100

function installCheck()
{
	installedPath=$(command -v $pkgName)
	if [ -z $installedPath ]
	then
		echo -en "$pkgName not found!\nDo you want to install $pkgName? (Y/N): "
		read wishTo

		if [[ "$wishTo" = 'Y' || "$wishTo" = 'y' || "$wishTo" = 'YES' || "$wishTo" = 'Yes' || "$wishTo" = 'yes' ]]
		then
			getPkg
			echo -e "Installed $pkgName (Version: $($pkgName --version))"
			exit 0
		else
			echo "$pkgName installation cancelled!"
			exit 0
		fi
	else
		echo "$pkgName is installed at $installedPath"
	fi
}

function getPkg()
{
	echo -en "Downloading $pkgName..."
	curl -sL https://yt-dl.org/downloads/latest/$pkgName -o /usr/local/bin/$pkgName
	echo -en "\rDownloading $pkgName... Done!\nSetting permission..."
	chmod a+rx /usr/local/bin/$pkgName
	echo -e "\rSetting permission... Done!"
}

function versionCheck()
{
	echo -en "Checking version..."
	currentVersion=$($pkgName --version)
	newVersion=$(curl -s https://raw.githubusercontent.com/ytdl-org/$pkgName/master/ChangeLog | awk 'FNR == 1 {print $2}')

	if [ $currentVersion != $newVersion ]
	then
		isUpdated=0
		echo -e "\rChecking version... ($currentVersion -> $newVersion)\nFound new version, updating..."
		pkgUpdate
	else
		if [ "$isUpdated" = 1 ]
		then
			echo -e "\nUpdate finished ($currentVersion)"
			exit 0
		else
			echo -e "\n$pkgName version is up to date ($currentVersion)"
			exit 1
		fi
	fi
}

function pkgUpdate()
{
	getPkg
	isUpdated=1
	versionCheck
}

###

installCheck
versionCheck

echo -e '\nERROR: EOF' && exit 10
