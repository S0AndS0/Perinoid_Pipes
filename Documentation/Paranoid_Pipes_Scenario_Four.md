# Scenario Four

-----

> Logging output **->** Named Pipe encryption input file **->**
> Encrypt & send output to **->** Pipe decryption input file **->**
> Mount decryption input file directory via SSHfs **->**
> Start listener on remote mounted Pipe decryption input file **->**
> Log decrypted output **->** On rotate send encrypted email

-----

## TLDR

> This scenario is an *extension* of the usage model explained within
> [Paranoid_Pipes_Scenario_Two.md](Paranoid_Pipes_Scenario_Two.md) documentation,
> Use `sshfs` to mount your remote's (web server's logging) directory, start
> decryption named pipe listener on local system listening to where the
> remote's encryption output will be sent, then start the remote's encrypting
> named pipe service to output to the shared (`sshfs` mounted) named pipe file.
> So long as your head isn't spinning from that and the file paths are correct,
> then like magic your remote's logs will be saved on the local file system in
> plan text for a finite time prior to being re-encrypted and sent to an email
> account for archival. The *sweet* part of this setup is a disconnect from the
> remote or local side of `sshfs` will cause logs to be saved on the remote's
> file system in an encrypted format 

## Setup local server

### Install additional dependencies

```
sudo apt-get install sshfs
```

### Generate ssh key pair

```
Var_sshfs_user="s0ands0"
## Make a directory and move there for key generation
mkdir -p ~/.ssh_fs
cd ~/.ssh_fs
## Generate key pair of specified name
ssh-keygen -t rsa -b 4096 -f ${Var_sshfs_user}
## Copy public key to local tmp directory
cp ${Var_sshfs_user}.pub /tmp/${Var_sshfs_user}.pub
## Save that path to a variable for latter use
Var_ssh_pubkey="/tmp/${Var_sshfs_user}.pub"
```

### Configure `ssh` client settings

```
Var_ssh_conf="/etc/ssh/ssh_conf"
Var_ssh_host="Web_Host"
Var_ssh_hostname="192.168.0.3"
Var_ssh_user="notsudo"
## The following redirection will append
##  to your ssh configs so long as you remember
##  the number of greater/less-then signs required.
sudo cat >> "${Var_ssh_conf}" <<EOF
Host ${Var_ssh_host}
    Hostname ${Var_ssh_hostname}
    User ${Var_ssh_user}
    IdentityFile ~/.ssh_fs/${Var_sshfs_user}
EOF
```

### Clone project

```
mkdir ~/git_clones
cd ~/git_clones
git clone https://github.com/S0AndS0/Perinoid_Pipes
cd Perinoid_Pipes
```

### Generate GnuPG key pair

```
Var_gnupg_email="user@host.domain"
Var_gnupg_pubkey_file="/tmp/${Var_gnupg_email//[@.]/}"
## Make directory for GnuPG key revoke cert to be save to
mkdir ~/.gpg_remote_pair
cd ~/.gpg_remote_pair
## Allow executable permissions for current running user
##  to the following helper script.
chmod u+x Script_Helpers/GnuPG_Gen_Key.sh
## Print available command line options and their default
##  settings. Note add '--help' at the end to double check
##  your own custom settings.
Script_Helpers/GnuPG_Gen_Key.sh --help
## Run the helper script with the following defined options.
Script_Helpers/GnuPG_Gen_Key.sh\
 --prompt-for-pass-yn='yes'\
 --gnupg-email="${Var_gnupg_email}"\
 --gnupg-export-public-key-yn='yes'\
 --gnupg-export-public-key-location="${Var_gnupg_pubkey_file}"\
```

### Setup named pipe listener for decryption

## Setup named pipe for remote server encryption

## Profit & automate

## Licensing notice for this file

```
    Copyright (C) 2016 S0AndS0.
    Permission is granted to copy, distribute and/or modify this document under
    the terms of the GNU Free Documentation License, Version 1.3 published by
    the Free Software Foundation; with the Invariant Sections being
    "Title page". A copy of the license is included in the directory entitled
    "License".
```

[Link to title page](Contributing_Financially.md)

[Link to related license](../Licenses/GNU_FDLv1.3_Documentation.md)

