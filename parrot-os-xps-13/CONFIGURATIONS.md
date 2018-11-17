# Some Useful Configurations for Linux Mint 18.2 installed on XPS 13 9360

## Install tlp battery saver

```
$ sudo apt-get update
$ sudo apt-get install tlp tlp-rdw
```

## Touchpad Palm Detection Fix

Install package: `$ sudo apt-get install xserver-xorg-input-libinput`

Make changes to the configuration file: `$ sudo nano /usr/share/X11/xorg.conf.d/40-libinput.conf`

Find this section:

```
Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
EndSection
```

Add in these options after **_Driver_**
```
Option "Tapping" "True"
Option "PalmDetection" "True"
Option "TappingDragLock" "True"
```



## Install Dropbox

Download the Dropbox daemon:

```bash
$ cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
$ ~/.dropbox-dist/dropboxd
```

* From there, follow the link/browser to link a Dropbox account to the system. 

Download the Dropbox python script:

```bash
$ wget --show-progress -O dropbox.py 'https://www.dropbox.com/download?dl=packages/dropbox.py'
$ sudo mv ~/dropbox.py /usr/bin/
$ sudo chmod +x /usr/bin/dropbox.py
$ sudo chmod 755 /usr/bin/dropbox.py
$ source ~/.bashrc
```

Then use the script to configure how Dropbox will work.

```bash
Dropbox command-line interface

commands:

Note: use dropbox help <command> to view usage for a specific command.

 status       get current status of the dropboxd
 throttle     set bandwidth limits for Dropbox
 help         provide help
 stop         stop dropboxd
 running      return whether dropbox is running
 start        start dropboxd
 filestatus   get current sync status of one or more files
 ls           list directory contents with current sync status
 autostart    automatically start dropbox at login
 exclude      ignores/excludes a directory from syncing
 lansync      enables or disables LAN sync
 sharelink    get a shared link for a file in your dropbox
 proxy        set proxy settings for Dropbox
```

Add the startup procedure to cron:

```bash
$ sudo crontab -e
$ 2
```

Add the following to cron:

```
@reboot dropbox.py start
```



## Install Typora

```bash
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE
$ sudo echo 'deb https://typora.io ./linux/' | sudo tee /etc/apt/sources.list.d/typora.list
$ sudo apt update
$ sudo apt install typora
```



## Install Jetbrains Toolbox

Make the following script in a new file called `$ touch ~/jetbrains-toolbox-install.sh`:

```bash
#!/bin/bash

[ $(id -u) != "0" ] && exec sudo "$0" "$@"
echo -e " \e[94mInstalling Jetbrains Toolbox\e[39m"
echo ""

function getLatestUrl() {
  USER_AGENT=('User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36')

  URL=$(curl 'https://data.services.jetbrains.com//products/releases?code=TBA&latest=true&type=release' -H 'Origin: https://www.jetbrains.com' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.8' -H "${USER_AGENT[@]}" -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: https://www.jetbrains.com/toolbox/download/' -H 'Connection: keep-alive' -H 'DNT: 1' --compressed | grep -Po '"linux":.*?[^\\]",' | awk -F ':' '{print $3,":"$4}'| sed 's/[", ]//g')
  echo $URL
}

getLatestUrl

FILE=$(basename ${URL})
DEST=$PWD/$FILE

echo ""
echo -e "\e[94mDownloading Toolbox files \e[39m"
echo ""
wget -cO  ${DEST} ${URL} --read-timeout=5 --tries=0
echo ""
echo -e "\e[32mDownload complete!\e[39m"
echo ""
DIR="/opt/jetbrains-toolbox"
echo ""
echo  -e "\e[94mInstalling to $DIR\e[39m"
echo ""

if mkdir ${DIR}; then
    tar -xzf ${DEST} -C ${DIR} --strip-components=1
fi

chmod -R +rwx ${DIR}
touch ${DIR}/jetbrains-toolbox.sh
echo "#!/bin/bash" >> $DIR/jetbrains-toolbox.sh
echo "$DIR/jetbrains-toolbox" >> $DIR/jetbrains-toolbox.sh

ln -s ${DIR}/jetbrains-toolbox.sh /usr/local/bin/jetbrains-toolbox
chmod -R +rwx /usr/local/bin/jetbrains-toolbox

echo ""
rm ${DEST}

echo  -e "\e[32mDone.\e[39m"
```

Make it executable and run:

```bash
$ sudo chmod +x ~/jetbrains-toolbox-install.sh
$ ~/jetbrains-toolbox-install.sh
$ jetbrains-toolbox
```



## Change Root password

**VERY IMPORTANT**

Even though you should not use the root superuser (use sudo instead) account
you should change the password so that others cannot.

```
$ sudo usermod root -p password
$ sudo passwd root
{Enter your new secure root password}
```



## Change sudo commands for Shutdown

**WARNING**

This can be dangerous if you try to change other commands.

```
$ sudo visudo
```

- Add a Cmnd alias specification:

  - Cmnd_Alias SHUTDOWN_CMDS = /sbin/poweroff, /sbin/halt, /sbin/reboot

- Add a user specification under 'User privilege specification' and 'sudo...' specification already present:
  - %{username} ALL=(ALL) NOPASSWD: SHUTDOWN_CMDS

######

## Configure Git and Github





## Install MySQL Server

Search for the server version you want: `$ sudo apt-get cache search mysql-server*`

- NOTE: installing specific v5.7 with no upgrading
- NOTE: the package mysql-server is always the latest

```
$ sudo apt-get update
$ sudo apt-get install mysql-server-5.7 --no-upgrade
```



## Install NORD VPN

Download the config files:
```bash
$ mkdir ~/.nordvpn && ~/.nordvpn/config && cd ~/.nordvpn/config
$ sudo apt-get install ca-certificates traceroute
$ sudo wget https://nordvpn.com/api/files/zip
$ unzip config.zip
```

##### Create a shell script to start the server automatically with credentials
Create a credentials file with root permissions: `sudo nano ~/.nordvpn/.nordvpncred`

The file should have:
```
{username}
{password}
```



## Install HMA VPN

Open terminal and install openvpn network manager: `$ sudo apt-get install network-manager-openvpn network-manager-openvpn-gnome fping -y`

Download the config files:
```
$ mkdir ~/.hma_vpn
$ wget http://hidemyass.com/vpn-config/vpn-configs.zip
$ cd ~/.hma_vpn
$ wget https://www.hidemyass.com/vpn-config/keys/ca.crt
$ wget https://www.hidemyass.com/vpn-config/keys/hmauser.crt
$ wget https://www.hidemyass.com/vpn-config/keys/hmauser.key
$ unzip vpn-configs.zip
```

Also download the HMA VPN CLI:
```
cd ~/.hma_vpn
$ wget https://s3.amazonaws.com/hma-zendesk/linux/hma-linux.zip
$ unzip hma-linux.zip
```

##### Create a shell script to start the server automatically with credentials
Create a credentials file with root permissions: `sudo nano ~/.hma_vpn/.credentials`

The file should have:
```
{username}
{password}
```

Then create a shell script in the /bin folder to execute globally: `$ sudo nano /bin/hma.d`

The script should have the following:
```
#!/bin/bash
sudo ~/.hma_vpn/hma-vpn.sh -d -c /home/{username}/.hma_vpn/.credentials -f -n {port} -p {tcp/udp}
```

Save and exit, then make it executable: `$ sudo chmod +x /bin/hma.d`

You can now connect to HMA VPN as a daemon service by executing in terminal: `$ hma.d`

NOTE: To quit the daemon service, execute: `$ ~/.hma_vpn/hma-vpn.sh -x`
## Change Default Browser

```bash
$ xdg-settings set default-web-browser chromium.desktop
```

