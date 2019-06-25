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

## Remove System Error Detection

apport messages are generated from the logs in /var/crash/.
Firstly, remove all files in the logs: `$ sudo rm /var/crash/*`

Now disable apport permanently: `$ sudo nano /etc/default/apport`
- Change the line where it says **enabled=1** to **enabled=0**.

*WARNING* It is not recommended that you try to remove apport.
