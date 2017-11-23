# Configurations Guides for Ubuntu GNome 17.10



## System Tweaks

### Remove pre-installed applications list

```bash
$ dpkg --list > installed
$ gedit ~/installed
$ sudo apt-get purge aisleriot brltty cheese gnome-calendar gnome-mahjongg gnome-mines gnome-sudoku imagemagick libreoffice* remmina rhythmbox shotwell thunderbird transmission-gtk vino 
```

_NOTES:_

* When using _dpkg_ you can add the following to not include certain necessary packages `dpkg --list | grep -v python* && lib* && font*`



### Recommended packages to install

```bash
$ sudo apt-get install gnome-tweak-tools openssh-server chromium-browser 
```



### Open VM Tools Shared Folders

> REF: https://partnerweb.vmware.com/GOSIG/Ubuntu_17_10.html
>
> REF: https://kb.vmware.com/s/article/2073803
>
> REF: https://askubuntu.com/questions/580319/enabling-shared-folders-with-open-vm-tools



#### Installation

```bash
$ sudo apt-get update
$ sudo apt-get install open-vm-tools open-vm-tools-desktop
$ vmware-hgfsclient
$ 
```

_NOTES:_

* `vmware-hgfsclient` will list all the available shares between host and client. 



#### Manual mounting

##### Mounting locally

```bash
$ vmhgfs-fuse .host:/$(vmware-hgfsclient) ~/{mountpoint}
```

##### Mounting globally

```bash
$ mount -n -t vmhgfs .host:/$(vmware-hgfsclient) /home/codeninja/{mount_point}
$ sudo mount -t fuse.vmhgfs-fuse .host:/ /mnt/hgfs -o allow_other
```



#### System Startup mounting with fstab configurations

```bash
$ sudo nano /etc/fstab
```

__Add these to the bottom of the file depending on your needs:__

* To place all hgfsclient folders into the one mount point

``` bash
.host:/ /{client_mount_point} fuse.vmhgfs-fuse allow_other,uid=1000,gid=1000,auto_unmount,defaults,nonempty 0 0
```



* To place a single folder into the mount point

```bash
.host:/dropbox /home/codeninja/Dropbox fuse.vmhgfs-fuse allow_other,uid=1000,gid=1000,auto_unmount,defaults 0 0
```



---



## System Security

### Activate Firewall

```bash
$ sudo ufw status
$ sudo ufw enable
$ sudo ufw allow ssh
```



### Change Root password

**VERY IMPORTANT**

Even though you should not use the root superuser (use sudo instead) account
you should change the password so that others cannot.

```bash
$ sudo usermod root -p password
$ sudo passwd root
{Enter your new secure root password}
```



### Change sudo commands for Shutdown

**WARNING**

This can be dangerous if you try to change other commands.

```bash
$ sudo visudo
```

- Add a Cmnd alias specification:

  - Cmnd_Alias SHUTDOWN_CMDS = /sbin/poweroff, /sbin/halt, /sbin/reboot

- Add a user specification under 'User privilege specification' and 'sudo...' specification already present:
  - %{username} ALL=(ALL) NOPASSWD: SHUTDOWN_CMDS



### HMA VPN

Open terminal and install openvpn network manager: `$ sudo apt-get install network-manager-openvpn network-manager-openvpn-gnome fping -y`

Download the config files:

```bash
$ mkdir ~/.hma_vpn
$ wget http://hidemyass.com/vpn-config/vpn-configs.zip
$ cd ~/.hma_vpn
$ wget https://www.hidemyass.com/vpn-config/keys/ca.crt
$ wget https://www.hidemyass.com/vpn-config/keys/hmauser.crt
$ wget https://www.hidemyass.com/vpn-config/keys/hmauser.key
$ unzip vpn-configs.zip
```

Also download the HMA VPN CLI:

```bash
cd ~/.hma_vpn
$ wget https://s3.amazonaws.com/hma-zendesk/linux/hma-linux.zip
$ unzip hma-linux.zip
```

##### Create a shell script to start the server automatically with credentials

Create a credentials file with root permissions: `sudo nano ~/.hma_vpn/.credentials`

The file should have:

```bash
{username}
{password}
```

Then create a shell script in the /bin folder to execute globally: `$ sudo nano /bin/hma.d`

The script should have the following:

```bash
#!/bin/bash
sudo ~/.hma_vpn/hma-vpn.sh -d -c /home/{username}/.hma_vpn/.credentials -f -n {port} -p {tcp/udp}
```

Save and exit, then make it executable: `$ sudo chmod +x /bin/hma.d`

You can now connect to HMA VPN as a daemon service by executing in terminal: `$ hma.d`

NOTE: To quit the daemon service, execute: `$ ~/.hma_vpn/hma-vpn.sh -x`



## Remove System Error Detection

apport messages are generated from the logs in /var/crash/.
Firstly, remove all files in the logs: `$ sudo rm /var/crash/*`

Now disable apport permanently: `$ sudo nano /etc/default/apport`

- Change the line where it says **enabled=1** to **enabled=0**.

*WARNING* It is not recommended that you try to remove apport. 



---



## Cloud Storage

### Dropbox

`$ sudo apt-get update && sudo apt-get install dropbox`



### Insync



---



## Development Tools

* Atom
* PyCharm
* Anaconda
* ​



---



## Development Frameworks

### Java via PPA

```bash
$ sudo apt-get update
$ java –version
$ sudo add-apt-repository ppa:webupd8team/java
$ sudo apt-get update
$ sudo apt-get install oracle-java8-installer
$ sudo apt-get install default-jre
$ sudo apt-get install default-jdk
```

### NODE.JS v6

```bash
$ curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
$ sudo apt-get install -y nodejs build-essentials
```

##### Configure global installation of npm

```bash
$ cd ~
$ npm config set prefix ~/npm/bin
$ echo 'export PATH=$PATH:/home/{username}/npm/bin' >> ~/.bashrc
```



---



## Databases

### MongoDB  



### MySQL Server

Search for the server version you want: `$ sudo apt-get cache search mysql-server*`

- NOTE: installing specific v5.7 with no upgrading
- NOTE: the package mysql-server is always the latest

```bash
$ sudo apt-get update
$ sudo apt-get install mysql-server-5.7 --no-upgrade
```




