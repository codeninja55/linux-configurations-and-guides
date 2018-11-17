# GIT CONFIGURATIONS

**Testing if ssh is available:** `ssh -V`

## Installing Git with SSH key for GitHub
- https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
- https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/

First, install git: `$ sudo apt-get install git`

Configure git for your local machine:
```
$ git config --global user.name '{name}'
$ git config --global user.email {email}
```

Then execute to generate an SSH key: `$ ssh-keygen -t rsa -b 4096 -C "github_acc_email@example.com"`

- When prompted, press <Enter> to save the keygen in the default location.
- At the next prompt, optional to put in **_passphrase_** for the keygen

When using git clone, always use the ssh protocol.

### Adding your SSH key to the ssh-agent

Start the ssh-agent in the background: `$ eval "$(ssh-agent -s)"`

Add your SSH private key to the ssh-agent
- If you create your key with a different name, or if you are adding an existing key that has a different name, replace _id_rsa_ in the command with the name of your private key file

`$ ssh-add ~/.ssh/id_rsa`

### Adding the new SSH key to GitHub

Install a terminal clipboard: `$ sudo apt-get install xclip`

Copy the SSH key to your clipboard: `$ xclip -sel clip < ~/.ssh/id_rsa.pub`

### If existing local repo, must change the remote url for pushing

```
$ ssh -T git@github.com
$ git remote set-url origin git@github.com:username/your-repo.git
```

Try pushing any updates:

```
$ git add -A
$ git commit -am 'update message'
$ git push origin master
```

## Installing Git with GPG key for GitHub
- https://help.github.com/articles/signing-commits-with-gpg/
- https://help.github.com/articles/generating-a-new-gpg-key/
- https://help.github.com/articles/telling-git-about-your-gpg-key/

First, install git and gnupg: `$ sudo apt-get install git gnupg`

Configure git for your local machine:
```
$ git config --global user.name '{name}'
$ git config --global user.email {email}
```

```
$ gpg --gen-key
```
- At the prompt, specify the kind of key you want, or press `Enter` to accept the default `RSA and RSA`
- Enter the desired key size. We recommend the maximum key size of `4096`
- Enter the length of time the key should be valid. Press `Enter` to specify the default selection, indicating that the key doesn't expire.
- Verify that your selections are correct
- Enter your user ID information
  - Real Name i.e. Andrew Che
  - Email i.e. test@example.com
  - Comment i.e. GitHub username
- Type a secure passphrase

```
$ gpg --list-secret-keys --keyid-format LONG
```
- From the list of GPG keys, copy the GPG key ID you'd like to use. In this example, the GPG key ID is `3AA5C34371567BD2`

```
$ gpg --armor --export 3AA5C34371567BD2
```
- Paste the text below, substituting in the GPG key ID you'd like to use.
- Copy your GPG key, beginning `-----BEGIN PGP PUBLIC KEY BLOCK-----` and ending with `-----END PGP PUBLIC KEY BLOCK-----`

### Signing Commits using GPG



## Git SSH for BitBucket
- https://confluence.atlassian.com/bitbucket/set-up-ssh-for-git-728138079.html

List the contents of your ~/.ssh directory: `$ ls -a ~/.ssh`

The contents should show:
> `. .. *id_rsa id_rsa.pub known_hosts*`

Generate a new rsa key for BitBucket.
- Enter and re-enter a passphrase when prompted.
  - Unless you need a key for a process such as csript, you should always provide a passphrase. The command creates your default identity with its public and private keys.

The whole interaction will look similar to this:
```
ssh-keygen
```
> ```
> Generating public/private rsa key pair.
> Enter file in which to save the key
> (/Users/emmap1/.ssh/id_rsa):
> Created directory '/Users/emmap1/.ssh'
> Enter passphrase (empty for no passphrase):
> Enter same passphrase again:
> Your identification has been saved in
> /Users/emmap1/.ssh/id_rsa.
> Your public key has been saved in
> /Users/emmap1/.ssh/id_rsa.pub.
> The key fingerprint is:
> 4c:80:61:2c:00:3f:9d:dc:08:41:2e:c0:cf:b9:17:69
> emmap1@myhost.local
> The key's randomart image is:
> +--[ RSA 2048]----+
> |*o+ooo.          |
> |.+.=o+ .         |
> |. *.* o .        |
> | . = E o         |
> |    o . S        |
> |   . .           |
> |     .           |
> |                 |
> |                 |
> +-----------------+
> ```

List the contents of ~/.ssh to view the key files: `ls -a ~/.ssh`

Start the ssh-agent and load the keys: `ps -e | grep [s]sh-agent`

If the agent isn't running, start it manually: `ssh-agent /bin/bash`

Add the new identity: `ssh-add ~/.ssh/key_name_rsa`

Use the ssh-add command to list the keys that the agent is managing: `ssh-add -l`

### Adding the new SSH key to BitBucket

Install a terminal clipboard: `$ sudo apt-get install xclip`

Copy the SSH key to your clipboard: `$ xclip -sel clip < ~/.ssh/key_name_rsa.pub`
