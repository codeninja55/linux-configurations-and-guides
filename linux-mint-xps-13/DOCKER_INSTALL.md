# Docker Installation for Linux Mint 19 - Tara

[1]: https://docs.docker.com/install/linux/docker-ce/ubuntu/	"Docker Documentation"
[2]: https://www.hiroom2.com/2018/08/06/linuxmint-19-docker-en/



## Prequisites

### OS requirements

To install Docker CE, you need the 64-bit version of one of these Ubuntu versions:

* Bionic 18.04 (LTS)
* Xenial 16.04 (LTS)
* Trusy 14.04 (LTS)

### Uninstall old versions

Older versions of Docker were called `docker` or `docker-engine`. If these are installed, uninstall them:

```bash
$ sudo apt-get remove --purge docker docker-engine docker.io
```

The contents of `/var/lib/docker/`, including images, containers, volumes, and networks, are preserved. The Docker CE package is now called `docker-ce`.

## Install Docker CE

1. Install dependency packages:

```bash
$ sudo apt-get update
$ sudo apt-get install -y apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
```

2. Add Docker's official GPG key:

```bash
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

* Verify that you now have the key with the fingerprint`9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88`, by searching for the last 8 characters of the fingerprint.

```bash
$ sudo apt-key fingerprint 0EBFCD88

pub   4096R/0EBFCD88 2017-02-22
      Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid                  Docker Release (CE deb) <docker@docker.com>
sub   4096R/F273FCD8 2017-02-22
```

3. Use the following command to set up the **stable**repository. You always need the **stable** repository, even if you want to install builds from the **edge** or **test**repositories as well. To add the **edge** or **test** repository, add the word `edge` or `test` (or both) after the word `stable` in the commands below.

   > **Note**: The `lsb_release -cs` sub-command below returns the name of your Ubuntu distribution, such as `xenial`. Sometimes, in a distribution like Linux Mint, you might need to change `$(lsb_release -cs)` to your parent Ubuntu distribution. For example, if you are using`Linux Mint Rafaela`, you could use `trusty`.

```bash
$ export LSB_ETC_LSB_RELEASE=/etc/upstream-release/lsb-release
$ V=$(lsb_release -cs)
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu ${V} stable"
$ sudo apt update -y
```

4. Install Docker CE

```bash
$ sudo apt-get install -y docker-ce
```

5. Add user to docker group. Added users can run docker command without sudo.

```bash
$ sudo gpasswd -a "${USER}" docker
```

### Execution Test

Run the default hello-world image.

```bash
$ sudo docker run hello-world
```

