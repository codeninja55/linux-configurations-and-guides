#!/bin/bash

############################## Check sudo permission #########################
[ $(id -u) != "0" ] && exec sudo "$0" "$@";


############################## ANSI colors ##############################
##### -- use these variables to make output in differen colors
esc="\033";  # if this doesn't work, enter an ESC directly

# Foreground colours
blackf="${esc}[30m"; redf="${esc}[31m"; greenf="${esc}[32m"; yellowf="${esc}[33m"
bluef="${esc}[34m"; purplef="${esc}[35m"; cyanf="${esc}[36m"; whitef="${esc}[37m"
# Background colors
blackb="${esc}[40m"; redb="${esc}[41m"; greenb="${esc}[42m"; yellowb="${esc}[43m"
blueb="${esc}[44m"; purpleb="${esc}[45m"; cyanb="${esc}[46m"; whiteb="${esc}[47m"
# Bold, italic, underline, and inverse style toggles
boldon="${esc}[1m"; boldoff="${esc}[22m"; italicson="${esc}[3m";
italicsoff="${esc}[23m"; ulon="${esc}[4m"; uloff="${esc}[24m";
invon="${esc}[7m"; invoff="${esc}[27m";
reset="${esc}[0m"

############################## Script variables ##############################
HOME=$HOME
USER=$USER
DOWNLOAD_DIR=$HOME/Downloads

function headerMessage() {
  echo ""
  echo -e "${redb}${whitef}${boldon}|==========| $1 |==========|${boldoff}${reset}"
  echo ""
}

function completeMessage() {
  echo ""
  echo -e "${redb}${whitef}${boldon}|==========| Complete |==========|${boldoff}${reset}"
  echo ""
}

function actionMessage() { echo ""; echo -e "${whiteb}${redf}${boldon}$1...${boldoff}${reset}"; echo ""; }
function generalMessage() { echo -e "${yellowf}$1${reset}"; }
function inputMessage() { echo -e  "${yellowf}Requires input below: ${reset}"; }
function updateApt() { sudo apt update; }
function distUpgradeApt() { sudo apt update && sudo apt -y dist-upgrade; echo ""; }
function upgradeApt() { sudo apt update && sudo apt -y upgrade; echo ""; }
function cleanApt() { sudo apt autoclean && sudo apt-get clean && sudo apt -y autoremove; }
function fixAptInstall() { sudo apt -y install -f; echo ""; }



################################################################################
############################## Main Script #####################################
################################################################################
headerMessage "Ubuntu 18.04 Initial Configurations"
usage() { echo -e "${whitef}Usage: $0 [-r change root passwd])${reset}" 1>&2; exit 1; }

while getopts ":r" OPTION; do
  case "$OPTION" in
    r )
      # r="$OPTARG"
      echo -e "${yellowf}${boldon}[!! IMPORTANT !!] You must change root password${boldoff}${reset}"
      inputMessage
      sudo usermod root -p password
      sudo passwd root
      # TODO: Should validate this and ensure strong password
      completeMessage
      ;;
    \? )
      usage
      ;;
    * )
      usage
      ;;
  esac
done
shift "$(($OPTIND -1))"

echo ""


############################# APT Package Management ###########################
headerMessage "APT Package Management"
actionMessage "Update and upgrade apt packages"
distUpgradeApt
completeMessage

actionMessage "Installing new packages"
generalMessage "Including: git, curl, tlp, xclip, chrome-gnome-shell,
   gnome-tweaks, compizconfig-settings-manager, exfat-utils, exfat-fuse,
   seahorse, scala dconf-tools"
sudo apt install -y git curl tlp tlp-rdw xclip chrome-gnome-shell \
     gnome-tweaks compizconfig-settings-manager exfat-utils exfat-fuse \
     seahorse scala dconf-tools
completeMessage


############################## Bash Aliases ##############################
headerMessage "Bash Aliases"
touch ${HOME}/.bash_aliases
echo -e "alias clrls='clear && ls -a'
alias clr='clear'
alias lsa='ls -a'
alias lsl='ls -l'
alias gohome='cd /home/codeninja/'
alias godl='cd /home/codeninja/Downloads/'
alias godropbox='cd ~/Dropbox && ls -a'
alias godev='cd ~/Dropbox/development && ls -a'
alias update-apt='sudo apt-get update && sudo apt-get upgrade'
alias git-log='git log --oneline --abbrev-commit --all --graph --decorate --color'" > ${HOME}/.bash_aliases
cat ${HOME}/.bash_aliases
completeMessage

headerMessage "Activating tlp Battery Saver"
sudo tlp start
completeMessage

headerMessage "Activating UFW Firewall"
generalMessage "UFW Status: "
sudo ufw status
actionMessage "Enabling firewall"
sudo ufw enable
actionMessage "Setting rules"
sudo ufw allow ssh
sudo ufw allow from 192.168.5.0/24 to any port 24800
completeMessage


############################## Git Configurations and LFS ######################
headerMessage "Git Configurations and LFS"
actionMessage "Configuring --global"
git config --global user.name "codeninja55"
git config --global user.email andrew@codeninja55.me
completeMessage

actionMessage "Installing Git LFS"
updateApt
sudo apt -y install gnupg apt-transport-https
curl -L https://packagecloud.io/github/git-lfs/gpgkey | sudo apt-key add -
deb https://packagecloud.io/github/git-lfs/ubuntu/ $(lsb_release -cs) main
deb-src https://packagecloud.io/github/git-lfs/ubuntu/ $(lsb_release -cs) main
updateApt
sudo apt install git-lfs

headerMessage "Linux Configurations"
linux_config_url='https://github.com/codeninja55/linux-configurations-and-guides.git'
linux_config_dir=${HOME}/Github/linux-configurations-and-guides
actionMessage "Downloading from ${linux_config_url}"
mkdir ${HOME}/Github
mkdir ${linux_config_dir}
if [ -d "${HOME}/Github/linux-configurations-and-guides" ]; then
    git clone ${linux_config_url} ${linux_config_dir}
fi
chmod -R +rwx ${HOME}/Github
sudo chown -R codeninja:codeninja ${HOME}/Github


############################## Dropbox ##############################
dropbox_linux_url='https://www.dropbox.com/sh/oq9sr4ryaypus6e/AACOpYR8hSgSKlK6JisiISA_a?dl=1'
dropbox_zip=${HOME}/linux.zip
curl -L -o ${dropbox_zip} ${dropbox_linux_url}
BACKUP_DIR=${HOME}/backup
if mkdir ${BACKUP_DIR}; then
  sudo unzip ${dropbox_zip} -d ${BACKUP_DIR}
fi
chmod -R +rwx ${BACKUP_DIR}
sudo chown -R codeninja:codeninja ${BACKUP_DIR}

headerMessage "Dropbox"
dropbox_url='https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb'
dropbox_deb=${DOWNLOAD_DIR}/$(basename ${dropbox_url})
actionMessage "Installing Dropbox from ${dropbox_url}"
wget -cO ${dropbox_deb} ${dropbox_url} --read-timeout=5 --tries=0
sudo dpkg -i ${dropbox_deb}
fixAptInstall
sudo dpkg -i ${dropbox_deb}
rm ${dropbox_deb}
nautilus --quit
generalMessage "[!! IMPORTANT !!] You must install Dropbox and sign in after this this script finishes."

headerMessage "Pictures"
actionMessage "Restoring pictures from backup"
cp -vr ${BACKUP_DIR}/Pictures/* ${HOME}/Pictures/
completeMessage


############################## Java 8 ##############################
headerMessage "Java 8"
updateApt
generalMessage "Java version"
java -version
actionMessage "Adding ppa:webupd8team/java"
sudo add-apt-repository -y ppa:webupd8team/java
updateApt
actionMessage "Installing Oracle Java 8 JRE and JDK"
inputMessage
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt install -y oracle-java8-installer
echo ""
sudo apt install -y default-jre
echo ""
sudo apt install -y default-jdk
sudo apt install -y oracle-java8-set-default
cleanApt


### TODO: Need to do configurations for Node


### TODO: Need to do configurations for Spark
############################## Spark ##############################
headerMessage "Spark 2.1.3"
spark_zip=${BACKUP_DIR}/Packages/spark-2.1.3-bin-hadoop2.7.tgz
spark_intermed_dir=${HOME}/spark-2.1.3-bin-hadoop2.7
spark_dir=/usr/local/spark-2.1.3-bin-hadoop2.7

actionMessage "Installating Spark to ${spark_dir}"
tar -xvf ${spark_intermed_dir} -C ${spark_intermed_dir}
sudo mv ${spark_intermed_dir} /usr/local/
sudo ln -s ${spark_dir} /usr/local/spark
echo "##### SPARK #####
export JAVA_HOME=/usr/lib/jvm/java-8-oracle/jre
export SCALA_HOME=/usr/share/scala-2.11
export SPARK_HOME=/usr/local/spark
export PATH=\$SPARK_HOME/bin:\$JAVA_HOME/bin:\$SCALA_HOME/bin:\$PATH" >> ${HOME}/.bashrc


############################## Typora ##############################
headerMessage "Typora"
actionMessage "Adding key"
wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
actionMessage "Adding repository"
sudo add-apt-repository 'deb https://typora.io/linux ./'
updateApt
actionMessage "Installing typora"
sudo apt install -y typora


############################## Google Chrome ##############################
headerMessage "Google Chrome"
chrome_url='https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
chrome_deb=${DOWNLOAD_DIR}/$(basename ${chrome_url})

actionMessage "Installing Google Chrome from ${chrome_url}"
wget -cO ${chrome_deb} ${chrome_url} --read-timeout=5 --tries=0
sudo dpkg -i ${chrome_deb}
rm ${chrome_deb}


############################## Atom ##############################
headerMessage "Atom"
atom_url='https://atom.io/download/deb'
atom_deb=${DOWNLOAD_DIR}/"atom-amd64.deb"

actionMessage "Installing Atom from ${atom_url}"
wget -cO ${atom_deb} ${atom_url} --read-timeout=5 --tries=0
sudo apt install -y gconf2 libgnome-keyring0
sudo dpkg -i ${atom_deb}
rm ${atom_deb}

actionMessage "Installing Atom plugins"
apm install atom-material-ui
apm install atom-material-syntax
apm install atom-material-syntax-dark
apm install language-scala
apm install linter-scalac
apm install intellij-idea-keymap


############################## Gitkraken ##############################
headerMessage "GitKraken"
gitkraken_url='https://release.gitkraken.com/linux/gitkraken-amd64.deb'
gitkraken_deb=${DOWNLOAD_DIR}/$(basename ${gitkraken_url})

actionMessage "Installing GitKraken from ${gitkraken_url}"
wget -cO ${gitkraken_deb} ${gitkraken_url} --read-timeout=5 --tries=0
sudo dpkg -i ${gitkraken_deb}
fixAptInstall
sudo dpkg -i ${gitkraken_deb}
rm ${gitkraken_deb}


############################## Jetbrains ##############################
headerMessage "Jetbrains Toolbox"
function getLatestUrl() {
  USER_AGENT=('User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36')

  URL=$(curl 'https://data.services.jetbrains.com//products/releases?code=TBA&latest=true&type=release' -H 'Origin: https://www.jetbrains.com' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.8' -H "${USER_AGENT[@]}" -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: https://www.jetbrains.com/toolbox/download/' -H 'Connection: keep-alive' -H 'DNT: 1' --compressed | grep -Po '"linux":.*?[^\\]",' | awk -F ':' '{print $3,":"$4}'| sed 's/[", ]//g')
  echo $URL
}
getLatestUrl
FILE=$(basename ${URL})
DEST=$PWD/$FILE

actionMessage "Downloading Toolbox files"
wget -cO  ${DEST} ${URL} --read-timeout=5 --tries=0
echo ""
generalMessage "Download complete."

DIR="/opt/jetbrains-toolbox"
actionMessage "Installing to $DIR"

if mkdir ${DIR}; then
    tar -xzf ${DEST} -C ${DIR} --strip-components=1
fi

chmod -R +rwx ${DIR}
touch ${DIR}/jetbrains-toolbox.sh
echo "#!/bin/bash" >> $DIR/jetbrains-toolbox.sh
echo "$DIR/jetbrains-toolbox" >> $DIR/jetbrains-toolbox.sh
echo ""
ln -s ${DIR}/jetbrains-toolbox.sh /usr/local/bin/jetbrains-toolbox
chmod -R +rwx /usr/local/bin/jetbrains-toolbox
rm ${DEST}

cp -r ${BACKUP_DIR}/.IntelliJIdea2018.2 ${HOME}
cp -r ${BACKUP_DIR}/.CLion2018.2 ${HOME}
cp -r ${BACKUP_DIR}/.PyCharm2018.2 ${HOME}

completeMessage


############################## Synergy ##############################
headerMessage "Synergy"
actionMessage "Installing Synergy 1"
synergy_deb=${BACKUP_DIR}/Packages/synergy_1.10.1.stable_b81+8941241e_ubuntu_amd64.deb
sudo dpkg -i ${synergy_deb}
rm ${synergy_deb}


############################## Global Protect ##############################
headerMessage "Global Protect"
actionMessage "Installing Global Protect"
globalprotect_deb=${BACKUP_DIR}/Packages/GlobalProtect_deb-4.1.5.0-8.deb
sudo dpkg -i ${globalprotect_deb}
rm ${globalprotect_deb}


############################## Numix Theme ##############################
headerMessage "Numix Theme"
numix_dest=${BACKUP_DIR}/Numix-Pack_0.4.6.1.tar.xz
numix_dir=${HOME}/Numix

actionMessage "Downloading Numix theme from ${numix_url}"
generalMessage "Destination: ${numix_dest}"
if mkdir ${numix_dir}; then
  tar xvf ${numix_dest} -C ${numix_dir} --strip-components=1
fi

actionMessage "Copying files"
generalMessage "From ${numix_dir} to ${HOME}"
chmod -R +rwx ${numix_dir}

if [ -d "${HOME}/.config" ]; then
  cp -r ${numix_dir}/.config ${HOME}/.config
else
  cp -r ${numix_dir}/.config ${HOME}/
fi

if [ -d "${HOME}/.local" ]; then
  cp -r ${numix_dir}/.local ${HOME}/.local
else
  cp -r ${numix_dir}/.local ${HOME}/
fi

if [ -d "${HOME}/.icons" ]; then
  cp -r ${numix_dir}/.icons ${HOME}/.icons
else
  cp -r ${numix_dir}/.icons ${HOME}/
fi

if [ -d "${HOME}/.themes" ]; then
  cp -r ${numix_dir}/.themes ${HOME}/.themes
else
  cp -r ${numix_dir}/.themes ${HOME}/
fi
actionMessage "Cleaning up"
generalMessage "Deleting ${numix_dest} and ${numix_dir}"
rm ${numix_dest}
rm -rf ${numix_dir}
completeMessage


############################## GNOME SHELL CONFIGURATIONS ######################
# headerMessage "gnome shell configurations"
# gnome_shell_backup=${linux_config_dir}/ubuntu-xps-13/gnome_shell
# actionMessage "Installing dependencies for system-monitor"
# #### system-monitor extension
# sudo apt install -y gir1.2-gtop-2.0 gir1.2-networkmanager-1.0 gir1.2-clutter-1.0
# sudo apt install -y -f
# sudo apt install -y gir1.2-gtop-2.0 gir1.2-networkmanager-1.0 gir1.2-clutter-1.0
# actionMessage "Copying extensions to ${HOME}/.local/share/gnome-shell/extenions/"
# sudo cp -vr ${gnome_shell_backup}/*  ${HOME}/.local/share/gnome-shell/extensions/
# dconf load / < ${gnome_shell_backup}/saved_settings.dconf
#
# gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
# gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
# gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode FIXED
# gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
# gsettings set org.gnome.shell.extensions.dash-to-dock unity-backlit-items true
#
# gsettings reset org.gnome.shell.extensions.dash-to-dock dash-max


############################## Ubuntu Cleanup ##############################
headerMessage "Cleaning Up Ubuntu"
cleanApt

actionMessage "Disabling evolution"
sudo mv /usr/lib/evolution-data-server /usr/lib/evolution-data-server-disabled
sudo mv /usr/lib/evolution /usr/lib/evolution-disabled

actionMessage "Disabling packagekitd and gnome-software"
sudo mkdir /usr/lib/packagekit/backup
sudo mv -v /usr/lib/packagekit/packagekitd /usr/lib/packagekit/backup/
sudo killall packagekitd
gsettings set org.gnome.software download-updates false

actionMessage "Disabling snapd"
sudo mkdir /usr/lib/snapd/backup
sudo mv -v /usr/lib/snapd/snapd /usr/lib/snapd/backup/
sudo killall snapd

actionMessage "Removing accessibility utilities"
sudo apt purge speech-dispatcher orca
actionMessage "Installing zRam"
sudo apt install -y zram-config
actionMessage "Defragging"
sudo e4defrag -c /
cleanApt
completeMessage


############################## NVIDIA CONFIGURATIONS ###########################
headerMessage "Nvidia Configurations"
actionMessage "Checking for AkiTiO Node and Nvidia devices"
echo "Check that kernel version is at least 4.13"
uname -a
echo -e "\nCheck that eGPU appears as Thunderbolt device"
cat /sys/bus/thunderbolt/devices/0-1/device_name
echo ""
echo "Authorize eGPU device"
sudo sh -c 'echo 1 > /sys/bus/thunderbolt/devices/0-1/authorized'
echo -e "\nCheck that eGPU now shows up with lspci"
lspci -nn | grep -i nvidia
echo ""
ubuntu-drivers devices

actionMessage "Blacklisting Nouveau"
sudo touch /etc/modprobe.d/blacklist-nouveau.conf
sudo echo "blacklist nouveau
options nouveau modeset=0" > /etc/modprobe.d/blacklist-nouveau.conf
sudo cat /etc/modprobe.d/blacklist-nouveau.conf
sudo update-initramfs -u
sudo update-grub
generalMessage "[!! IMPORTANT !!] Must reboot for these changes to take effect"


############################## R Interpreter ##############################
headerMessage "R Interpreter"
actionHeader "Adding R project server"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'
updateApt
actionHeader "Installing R interpreter"
sudo apt -y install r-base


############################## Anaconda ##############################
headerMessage "Anaconda"
anaconda_run=${BACKUP_DIR}/Packages/Anaconda3-5.3.0-Linux-x86_64.sh
actionHeader "Installing Anaconda"
sudo chmod +x ${anaconda_run}
inputMessage
${anaconda_run}


############################## Git PKI ##############################
headerMessage "Github RSA"
actionMessage "Creating Github RSA Key"
cat /dev/zero | ssh-keygen -t rsa -b 4096 -C "andrew@codeninja55.me" -f ${HOME}/.ssh/github_rsa -q -N ""
eval "$(ssh-agent -s)"
ssh-add ${HOME}/.ssh/github_rsa
xclip -sel clip < ${HOME}/.ssh/github_rsa.pub
generalMessage "Go to paste new key https://github.com/settings/keys"
completeMessage

headerMessage "Ubuntu 18.04 Initial Configurations COMPLETE"
