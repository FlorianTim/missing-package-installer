#!/bin/bash
# Missing package installer for (X)ubuntu 16.04 and 14.04.
# A simple script for installing some of the missing software (i like to use) on new systems
# 2017.04.24 by TRi

VER="0.5.2"
DIST_V="$(lsb_release -r -s)"
DIST_N="$(lsb_release -i -s)"

PKG_SYS="mc htop iftop conky imwheel curl keepassx keepass2 gufw gparted p7zip-full bleachbit compton wmctrl kdocker terminator scrot redshift gtk-redshift synaptic aptitude cups csh lib32stdc++6 cryptkeeper gnome-tweak-tool shutter openjdk-8-jdk openjdk-8-demo openjdk-8-doc openjdk-8-jre-headless openjdk-8-source icedtea-8-plugin"
PKG_DEV="build-essential gdb git tig python-pip monodevelop mono-runtime geany geany-common netbeans meld maven"
PKG_MEDIA="vlc soundconverter easytag sound-juicer libdvdread4 brasero ubuntu-restricted-extras"
PKG_OFFICE="pdfshuffler pdfchain libreoffice-impress gscan2pdf simple-scan nautilus-dropbox thunderbird thunderbird-locale-de xul-ext-lightning tesseract-ocr tesseract-ocr-deu"
PKG_LATEX="texstudio lyx lyx-common texlive texlive-lang-german"
PKG_INET="mumble corebird filezilla polari"
PKG_INET_14="mumble filezilla xchat-gnome"
PKG_GFX="imagemagick inkscape gimp xsane"
PKG_GAMES="wesnoth hedgewars gweled scummvm burgerspace"
PKG_ATOM_EXT="platformio-ide-terminal python-debugger language-haskell git-time-machine git-plus autocomplete-python pdf-view minimap project-manager language-vue bottom-dock gulp-manager todo-manager symbols-tree-view pigments language-ini highlight-selected minimap-highlight-selected rest-client"


NAME_SYSTEM="System"
NAME_DEV="Development"
NAME_MEDIA="Media"
NAME_OFFICE="Office"
NAME_LATEX="LaTeX"
NAME_INET="Internet"
NAME_GFX="Graphics"
NAME_GAMES="Games"
NAME_PPA_KODI="PPA-Kodi"
NAME_PPA_VLC="PPA-VLC"
NAME_PPA_JAVA="PPA-Java"
NAME_PPA_LIBREOFFICE="PPA-Libre"
NAME_PPA_GIT="PPA-Git"
NAME_PPA_ATOM="PPA-Atom"
NAME_PPA_HIPCHAT="PPA-HipChat"
NAME_PPA_PAPIRUS="PPA-Papirus"
NAME_EXT_RUST="Rust-Lang"
NAME_EXT_NODE="Node.js"
NAME_EXT_DOCKER="Docker"
NAME_EXT_GITKRAKEN="Gitkraken (DEB)"
NAME_EXT_VSCODE="Visual Studio Code (PPA)"
NAME_EXT_SKYPE="Skype (DEB)"
NAME_EXT_ZOTERO="Zotero (TAR)"
NAME_EXT_REMARKABLE="Remarkable (DEB)"
NAME_EXT_INTELLIJ="IntelliJ (PPA)"
NAME_EXT_MasterPDF="Master PDF (DEB)"
NAME_SCRIPT_UPDATE="Update-Script"
NAME_SCRIPT_KERNEL="Kernel-Script"
NAME_EXT_Themes="Themes (PPA)"
NAME_EXT_CHROME="Chrome (PPA)"

##
# Updates the already installed packages.
##
function update_packages()
{
	echo -e "\nGoing to update the system packages first"
	sudo apt update && sudo apt upgrade -y
}

##
# Installes giving packages.
##
function install_packages()
{
	echo -e "\nInstalling: $*"
	sudo apt update && sudo apt install -y "$@"
}

##
# Installation of the system update script to /usr/bin/mkupdate.
##
function install_update_script()
{
	echo -e "\nInstalling update script"
	file_tmp="/tmp/mkupdate"
	file_dst="/usr/bin/mkupdate"
	apt_get="sudo apt update && sudo apt upgrade && sudo apt autoremove && sudo apt autoclean"
	apt="sudo apt-get update && sudo apt-get upgrade && sudo apt-get autoremove"

	if [ -f "$file_tmp" ]
	then
		rm $file_tmp
	fi
	touch $file_tmp
	echo -e "#!/bin/sh" >> $file_tmp
	if [ "$DIST_N" == "Ubuntu" ]
	then

		if [ "$DIST_V" == "16.04" ]
		then
			echo -e "$apt" >> $file_tmp

		elif [ "$DIST_V" == "14.04" ]
		then
			echo -e "$apt_get" >> $file_tmp
		fi

	elif [ "$DIST_N" == "LinuxMint" ]
	then

		if [ "$DIST_V" == "18" ]
		then
			echo -e "$apt" >> $file_tmp
		else
			echo -e "$apt_get" >> $file_tmp
		fi

	fi

	if [ -f "$file_dst" ]
	then
		sudo rm $file_dst
	fi
	sudo cp $file_tmp $file_dst
	sudo chmod a+x $file_dst
	echo "Installation of update script complete. Run 'mkupdate'"
}

##
# Installation to the remove old kernel script to /usr/bin/remove-old-kernels.
##
function install_kernel_script()
{
	echo -e "\nInstalling kernel script"
	file_tmp="/tmp/remove-old-kernels"
	file_dst="/usr/bin/remove-old-kernels"
	if [ -f "$file_tmp" ]
	then
		rm $file_tmp
	fi
	touch $file_tmp
	echo -e "#!/bin/sh" >> $file_tmp
	echo -e "echo \$(dpkg --list | grep linux-image | awk '{ print \$2 }' | sort -V | sed -n '/'`uname -r`'/q;p') \$(dpkg --list | grep linux-headers | awk '{ print \$2 }' | sort -V | sed -n '/'\"\$(uname -r | sed \"s/\([0-9.-]*\)-\([^0-9]\+\)/\1/\")\"'/q;p') | xargs sudo apt-get -y purge" >> $file_tmp

	if [ -f "$file_dst" ]
	then
		sudo rm $file_dst
	fi
	sudo cp $file_tmp $file_dst
	sudo chmod a+x $file_dst
	echo "Installation of script to remove old kernels complete. Run 'remove-old-kernels'"
}

##
# PPA: Install Kodi.
##
function install_PPA_Kodi()
{
	echo -e "\nInstalling Kodi PPA"
	sudo add-apt-repository ppa:team-xbmc/ppa -y
	sudo apt update
	sudo apt install -y kodi
	echo "Kodi installed"
}

##
# PPA: Install VLC.
#
function install_PPA_VLC()
{
	echo -e "\nInstalling VLC PPA"
	sudo add-apt-repository ppa:videolan/stable-daily -y
	sudo apt update
	sudo apt install -y vlc
	echo "VLC Player installed"
}

##
# PPA: Oracle Java.
##
function install_PPA_Java()
{
	echo -e "\nInstalling JAVA PPA"
	sudo add-apt-repository ppa:webupd8team/java -y
	sudo apt update
	sudo apt install -y oracle-java8-installer
	echo "Oracle Java 8 installed"
}

##
# PPA: LibreOffice.
##
function install_PPA_LibreOffice()
{
	echo -e "\nInstalling LibreOffice PPA"
	sudo add-apt-repository ppa:libreoffice/ppa -y
	sudo apt update
	sudo apt install -y libreoffice-writer libreoffice-calc libreoffice-draw libreoffice-math
	echo "LibreOffice installed"
}

##
# PPA: Install Git.
##
function install_PPA_Git()
{
	echo -e "\nInstalling Git PPA"
	sudo add-apt-repository ppa:/git-core/ppa -y
	sudo apt update
	sudo apt install -y git
	echo "Git installed"
}

##
# PPA: Install Atom.
##
function install_PPA_Atom()
{
	echo -e "\nInstalling Atom PPA"
	sudo add-apt-repository ppa:webupd8team/atom -y
	sudo apt update
	sudo apt install -y atom
	echo -e "\nInstalling Atom extentions"
	apm install $PKG_ATOM_EXT
	echo "Atom installed"
}

##
# PPA: Atlassian HipChat 4
##
function install_PPA_HIPCHAT()
{
	echo -e "\nInstalling Atlassian HipChat PPA"
	sudo sh -c 'echo "deb https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client $(lsb_release -c -s) main" > /etc/apt/sources.list.d/atlassian-hipchat4.list'
	wget -O - https://atlassian.artifactoryonline.com/atlassian/api/gpg/key/public | sudo apt-key add -
	sudo apt update
	sudo apt install -y hipchat4
	echo "Atlassian HipChat installed"
}

##
# PPA: Papirus Icon Theme
##
function install_PPA_PAIRUS() {
	echo -e "\nInstalling Papirus Icon Theme PPA"
	sudo add-apt-repository ppa:papirus/papirus -y
	sudo apt update
	sudo apt install -y papirus-icon-theme
	echo "Papirus Icon Theme installed"
}

##
# External: Rust lang installation.
##
function install_ext_rust()
{
	echo -e "\nInstalling Rust Lang"
	sudo apt update && sudo apt install -y curl
	curl -sSf https://static.rust-lang.org/rustup.sh | sudo sh
	echo "Rust installed"
}

##
# External: Node.js installation.
##
function install_ext_node()
{
	echo -e "\nInstalling Node.js"
	sudo apt update && sudo apt install -y curl
	curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
	sudo apt install -y nodejs
	echo "Node.js insalled"
}

##
# External: Docker installation.
##
function install_ext_docker()
{
	echo -e "\nInstalling Docker"
	sudo apt install -y apt-transport-https ca-certificates
	sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

	file_tmp="/tmp/docker.list"
	file_dst="/etc/apt/sources.list.d/docker.list"

	if [ -f "$file_tmp" ]
	then
		rm $file_tmp
	fi
	touch $file_tmp

	if [ "$DIST_N" == "Ubuntu" ]
	then

		if [ "$DIST_V" == "16.04" ]
		then
			echo -e "deb https://apt.dockerproject.org/repo ubuntu-xenial main" >> $file_tmp


		elif [ "$DIST_V" == "14.04" ]
		then
			echo -e "deb https://apt.dockerproject.org/repo ubuntu-trusty main" >> $file_tmp
		
		elif [ "$DIST_V" == "17.04" ]
		then
			echo -e "deb https://apt.dockerproject.org/repo ubuntu-zesty main" >> $file_tmp
		fi

	elif [ "$DIST_N" == "LinuxMint" ]
	then

			if [ "$DIST_V" == "18" ]
			then
				echo -e "deb https://apt.dockerproject.org/repo ubuntu-xenial main" >> $file_tmp
			fi
	fi

	if [ -f "$file_dst" ]
	then
		sudo rm $file_dst
	fi
	sudo cp $file_tmp $file_dst

	sudo apt update
	sudo apt install -y docker-engine
	sudo usermod -aG docker $USER
	echo "Docker installed"
}

##
# External: Gitkraken installation.
##
function install_ext_gitkraken()
{
	echo -e "\nInstalling Gitkraken"
	sudo apt update && sudo apt install -y curl
	curl -sL -o gitkraken.deb https://release.gitkraken.com/linux/gitkraken-amd64.deb | sudo -E bash -
	# using dpkg to force install gitkraken over older versions
	sudo dpkg -i gitkraken.deb
	rm gitkraken.deb
	echo "Gitkraken insalled"
}

##
# External: Visual Studio Code installation.
##
function install_ext_vscode()
{
	echo -e "\nInstalling Visual Studio Code"
	sudo apt update && sudo apt install -y curl
	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
	sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
	sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
	sudo apt-get update
	sudo apt-get install code # or code-insiders
	echo "Visual Studio Code insalled"
}


##
# External: Skype installation.
##
function install_ext_skype()
{
	echo -e "\nInstalling Skype"
	sudo apt update && sudo apt install -y curl
	curl https://repo.skype.com/data/SKYPE-GPG-KEY | sudo apt-key add -
	curl -sL -o skype.deb https://go.skype.com/skypeforlinux-64.deb | sudo -E bash -
	# using dpkg to force install deb over older versions
	sudo dpkg -i skype.deb
	rm skype.deb
	echo "Skype insalled"
}


##
# External: Zotero installation.
##
function install_ext_zotero()
{
	echo -e "\nInstalling zotero"
	sudo apt update && sudo apt install -y curl tar tar-doc 
	ZOTERO_DIR="/opt/zotero"
	ZOTERO_FILE="zotero.tar.bz2"
	sudo mkdir $ZOTERO_DIR
	sudo chown "$USER":"$USER" $ZOTERO_DIR
	curl -sL -o $ZOTERO_FILE https://download.zotero.org/standalone/4.0.29.10/Zotero-4.0.29.10_linux-x86_64.tar.bz2 | sudo -E bash -
	sudo tar -xjf $ZOTERO_FILE -C $ZOTERO_DIR
	rm $ZOTERO_FILE
	sudo chown -R "$USER":"$USER" $ZOTERO_DIR
	sudo ln -s $ZOTERO_DIR/Zotero_linux-x86_64/zotero /usr/bin/
	sudo chmod ugo+x /usr/bin/zotero
	echo "zotero insalled"
}


#
##
# External: remarkable installation.
##
function install_ext_remarkable()
{
	echo -e "\nInstalling remarkable"
	sudo apt update && sudo apt install -y curl
	curl -sL -o remarkable.deb https://remarkableapp.github.io/files/remarkable_1.87_all.deb | sudo -E bash -
	# using dpkg to force install deb over older versions
	sudo apt -i remarkable.deb
	rm remarkable.deb
	echo "remarkable insalled"
}

##
# PPA: Install IntelliJ.
#
function install_PPA_intellij()
{
	echo -e "\nInstalling IntelliJ PPA"
	sudo sudo add-apt-repository ppa:mmk2410/intellij-idea -y
	sudo apt update
	sudo apt install -y intellij-idea-ultimate
	#intellij-idea-community
	echo "IntelliJ installed"
}


##
# External: Master-PDF installation.
##
function install_ext_masterpdf()
{
	echo -e "\nInstalling masterpdf"
	sudo apt update && sudo apt install -y curl
	curl -sL -o masterpdf.deb http://get.code-industry.net/public/master-pdf-editor-4.1.30_qt5.amd64.deb | sudo -E bash -
	# using dpkg to force install deb over older versions
	sudo dpkg -i masterpdf.deb
	rm masterpdf.deb
	echo "masterpdf insalled"
}

##
# PPA: Install Themes.
#
function install_PPA_themes()
{
	echo -e "\nInstalling themes PPA"
	sudo sudo sudo add-apt-repository ppa:noobslab/themes -y
	sudo sudo sudo add-apt-repository ppa:noobslab/icons -y
	sudo apt update
	sudo apt install -y t4g-v2-theme minwaita-theme albatross-theme chrome-android-os-themes arc-theme
	sudo apt install -y perforated-edge-icons arc-icons faenza-icon-theme faience-icon-theme 
	#evolvere-icon-suite
	echo "themes installed"
}

##
# External: Chrome installation.
##
function install_ext_chrome()
{
	echo -e "\nInstalling Chrome"
	if [[ $(getconf LONG_BIT) = "64" ]]
	then
    echo "64bit Detected" &&
    echo "Installing Google Chrome" &&
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
    sudo dpkg -i google-chrome-stable_current_amd64.deb &&
    rm -f google-chrome-stable_current_amd64.deb
	else
    echo "32bit Detected" &&
    echo "Installing Google Chrome" &&
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb &&
    sudo dpkg -i google-chrome-stable_current_i386.deb &&
    rm -f google-chrome-stable_current_i386.deb
	fi
	echo "Chrome insalled"
}


## Warning msg on start
if [ "$DIST_N" == "Ubuntu" ]
then
	whiptail --title "Missing Package Installer V$VER" --msgbox "This script supports (x)ubuntu 16.04 and 14.04 at the moment.\nAnd as always: use at your own risk." 8 78
else
	whiptail --title "Missing Package Installer V$VER" --msgbox "This script was tested only with (x)ubuntu 16.04 and 14.04 yet.\nIt may not work properly on other distribution.\n\nUse at your own risk." 10 78
fi

## Choose dialog
DISTROS=$(whiptail --title "Missing Package Installer V$VER" --checklist \
"Choose missing software packages to install" 27 66 21 \
$NAME_SYSTEM " - System core software" OFF \
$NAME_DEV " - Development software" OFF \
$NAME_MEDIA " - Multimedia software" OFF \
$NAME_OFFICE " - Office software" OFF \
$NAME_LATEX " - LaTeX software"  OFF \
$NAME_INET " - Internet software" OFF \
$NAME_GFX " - Graphics software" OFF \
$NAME_GAMES " - Just some FOSS Games" OFF \
$NAME_PPA_JAVA " - Oracle Java 8" OFF \
$NAME_PPA_GIT " - The latest Git" OFF \
$NAME_PPA_LIBREOFFICE " - The latest LibreOffice" OFF \
$NAME_PPA_KODI " - The latest Kodi" OFF \
$NAME_PPA_VLC " - The latest VLC" OFF \
$NAME_PPA_ATOM " - Atom hackable text editor" OFF \
$NAME_PPA_HIPCHAT " - Atlassian HipChat4" OFF \
$NAME_PPA_PAPIRUS " - Papirus icon Theme" OFF \
$NAME_EXT_RUST " - Install Rust Language" OFF \
$NAME_EXT_NODE " - Install Node.js" OFF \
$NAME_EXT_DOCKER " - Install Docker" OFF \
"$NAME_EXT_GITKRAKEN" " - Install Gitkraken" OFF \
"$NAME_EXT_VSCODE" " - Install Visual Studio Code" OFF \
"$NAME_EXT_SKYPE" " - Install Skype" OFF \
"$NAME_EXT_ZOTERO" " - Install Zotero" OFF \
"$NAME_EXT_REMARKABLE" " - Install Remarkable" OFF \
"$NAME_EXT_INTELLIJ" " - Install IntelliJ" OFF \
"$NAME_EXT_MasterPDF" " - Install Master PDF" OFF \
"$NAME_EXT_Themes" " - Install Themes" OFF \
"$NAME_EXT_CHROME" " - Install Chrome" OFF \
$NAME_SCRIPT_UPDATE " - A system update script" OFF \
$NAME_SCRIPT_KERNEL " - A script to remove unused kernels " OFF \
3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then

	## Update the system first
	update_packages

	## Scripts
	case "${DISTROS[@]}" in  *$NAME_SCRIPT_UPDATE*)
		install_update_script ;; esac

	case "${DISTROS[@]}" in  *$NAME_SCRIPT_KERNEL*)
		install_kernel_script ;; esac


	## Install main packages first
	packages=""
	case "${DISTROS[@]}" in *$NAME_SYSTEM*)
		packages="$packages "$PKG_SYS ;; esac

	case "${DISTROS[@]}" in *$NAME_MEDIA*)
		packages="$packages "$PKG_MEDIA ;; esac

	case "${DISTROS[@]}" in *$NAME_OFFICE*)
		packages="$packages "$PKG_OFFICE ;; esac

	case "${DISTROS[@]}" in *$NAME_LATEX*)
		packages="$packages "$PKG_LATEX ;; esac

	case "${DISTROS[@]}" in *$NAME_INET*)

		if [ $DIST_V == "16.04" ]
		then
			packages="$packages "$PKG_INET

		elif [ $DIST_V == "14.04" ]
		then
			packages="$packages "$PKG_INET_14
		fi
		;; esac

	case "${DISTROS[@]}" in *$NAME_GFX*)
		packages="$packages "$PKG_GFX ;; esac

	case "${DISTROS[@]}" in *$NAME_GAMES*)
		packages="$packages "$PKG_GAMES ;; esac

	if [ ! -z "$packages" -a "$packages" != " " ]; then
       		install_packages $packages
	fi


	## PPAs
	case "${DISTROS[@]}" in *$NAME_PPA_KODI*)
		install_PPA_Kodi ;; esac

	case "${DISTROS[@]}" in *$NAME_PPA_VLC*)
		install_PPA_VLC ;; esac

	case "${DISTROS[@]}" in *$NAME_PPA_JAVA*)
		install_PPA_Java ;; esac

	case "${DISTROS[@]}" in *$NAME_PPA_LIBREOFFICE*)
		install_PPA_LibreOffice ;; esac

	case "${DISTROS[@]}" in *$NAME_PPA_GIT*)
		install_PPA_Git ;; esac

	case "${DISTROS[@]}" in *$NAME_PPA_ATOM*)
		install_PPA_Atom ;; esac

	case "${DISTROS[@]}" in *$NAME_PPA_HIPCHAT*)
		install_PPA_HIPCHAT ;; esac

	case "${DISTROS[@]}" in *$NAME_PPA_PAPIRUS*)
		install_PPA_PAIRUS ;; esac


	## External
	case "${DISTROS[@]}" in *$NAME_EXT_RUST*)
		install_ext_rust ;; esac

	case "${DISTROS[@]}" in *$NAME_EXT_NODE*)
		install_ext_node ;; esac

	case "${DISTROS[@]}" in *$NAME_EXT_DOCKER*)
		install_ext_docker ;; esac

	case "${DISTROS[@]}" in *$NAME_EXT_GITKRAKEN*)
		install_ext_gitkraken ;; esac

	case "${DISTROS[@]}" in *$NAME_EXT_VSCODE*)
		install_ext_vscode ;; esac

	case "${DISTROS[@]}" in *$NAME_EXT_SKYPE*)
		install_ext_skype ;; esac

	case "${DISTROS[@]}" in *$NAME_EXT_ZOTERO*)
		install_ext_zotero ;; esac

	case "${DISTROS[@]}" in *$NAME_EXT_REMARKABLE*)
		install_ext_remarkable ;; esac

	case "${DISTROS[@]}" in *$NAME_EXT_INTELLIJ*)
		install_PPA_intellij ;; esac
	
	case "${DISTROS[@]}" in *$NAME_EXT_MasterPDF*)
		install_ext_masterpdf ;; esac

	case "${DISTROS[@]}" in *$NAME_EXT_Themes*)
		install_PPA_themes ;; esac

	case "${DISTROS[@]}" in *$NAME_EXT_CHROME*)
		install_ext_chrome ;; esac




else
    	echo "Package installation aborted."
fi
