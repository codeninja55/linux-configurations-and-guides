#!/bin/bash

# Check sudo permission
[ $(id -u) != "0" ] && exec sudo "$0" "$@";

##### Script variables
HOME=$HOME
USER=$USER
DOWNLOADS=$HOME/Downloads
GITHUB=${HOME}/Github
DROPBOX=${HOME}/Dropbox

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
function fixAptInstall() { sudo apt install -f; echo ""; }

# Check there is a Dropbox and Github folder
if [ ! -d "${DROPBOX}" ]; then
  generalMessage "[!! IMPORTANT !!] There must be an up-to-date Dropbox dir for this to continue."
  exit 1
fi

##### Main Script
headerMessage "Ubuntu 18.04 Backup Configurations"

# Save IntelliJ, PyCharm, CLion, WebStorm, and DataGrip configurations
# Save Atom configurations
# Save gnome extenions and dconf file
linux_config_dir = ${GITHUB}/linux-configurations-and-guides
gnome_shell_backup=${linux_config_dir}/ubuntu-xps-13/gnome_shell
dconf dump / > ${gnome_shell_backup}/saved_settings.dconf
cp -rv ${HOME}/.local/share/gnome-shell/extenions/* ${gnome_shell_backup}/
