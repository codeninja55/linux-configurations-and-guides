# Some Useful Configurations for Ubuntu 18.04 installed on Ubuntu G.E.N.I.E PC

## Activate Firewall

```
$ sudo ufw status
$ sudo ufw enable
$ sudo ufw allow ssh
```

## Install Dropbox

`$ sudo apt-get update && sudo apt-get install dropbox`

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

## Install Java via PPA

```
$ sudo apt-get update
$ java –version
$ sudo add-apt-repository ppa:webupd8team/java
$ sudo apt-get update
$ sudo apt-get install oracle-java8-installer
$ sudo apt-get install default-jre
$ sudo apt-get install default-jdk
```

## Install NODE.JS v6

```
$ curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
$ sudo apt-get install -y nodejs build-essential
```

##### Configure global installation of npm

```
$ cd ~
$ npm config set prefix ~/npm/bin
$ echo 'export PATH=$PATH:/home/{username}/npm/bin' >> ~/.bashrc
```

## Install MySQL Server

Search for the server version you want: `$ sudo apt-get cache search mysql-server*`

- NOTE: installing specific v5.7 with no upgrading
- NOTE: the package mysql-server is always the latest

```
$ sudo apt-get update
$ sudo apt-get install mysql-server-5.7 --no-upgrade
```

## Update Thunderbolt firmware

**USE ONLY IF THUNDERBOLT PORT NOT WORKING**

**REQUIRES APPLYING PATCHES**

**DO THIS AT YOUR OWN RISK!**

Refer to Official Dell GitHub fix for more information:
- https://github.com/dell/thunderbolt-nvm-linux

Download the provided local patches to integrate locally: `$ git clone https://github.com/01org/thunderbolt-software-kernel-tree.git ~/thunderbolt-software-kernel-tree`

Download the provided Debian package: `$ git clone https://github.com/dell/thunderbolt-icm-dkms.git ~/thunderbolt-icm-dkms`

**NOTE: Not tested on my own XPS 13. Please do this at your own risk.**


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


## Instal Gnome Shell Display Manager and Remove Unity8

Firstly, install Gnome Shell: `$ sudo apt-get install gnome-shell`
- During installation, select *gdm3* as your login display manager.

Also, install the gnome-tweak-tool: '$ sudo apt-get install gnome-tweak-tool'

### Remove Unity8

```bash
$ sudo apt purge unity8 ubuntu-system-settings && sudo apt autoremove
$ sudo apt purge webbrowser-app
```



## Remove System Error Detection

apport messages are generated from the logs in /var/crash/.
Firstly, remove all files in the logs: `$ sudo rm /var/crash/*`

Now disable apport permanently: `$ sudo nano /etc/default/apport`
- Change the line where it says **enabled=1** to **enabled=0**.

*WARNING* It is not recommended that you try to remove apport.
