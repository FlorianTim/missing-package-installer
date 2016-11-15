#!/bin/bash 

SDK_DIR="/opt/programme/Android/SDK"

require
sudo apt install libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 lib32z1-dev 

android sdk
sudo apt-add-repository ppa:paolorotolo/android-studio
sudo apt update
sudo apt install android-studio 


if ! grep -q "export ANDROID_HOME=$SDK_DIR" "${HOME}/.bashrc"; then
	echo "export ANDROID_HOME=$SDK_DIR" >> ~/.bashrc
	echo "export PATH=${PATH}:$SDK_DIR/tools:$SDK_DIR/platform-tools" >> ~/.bashrc
fi


#export path
export ANDROID_HOME=$SDK_DIR
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

