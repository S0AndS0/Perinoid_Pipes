---
title: Installation options for GnuPG on verious systems
---

# GnuPG installation options

> Note the following information for non-Linux based operating systems should be
> considered **experimental** & **untested** by the authors of this project unless
> otherwise specified. Some of the following is not applicable with the scripts
> contained within this project and are only provided for completeness of GnuPG
> applications known to be available.

## Notice of external links

> throughout this document there are embedded URLs to domains external to this
> project. These external links' authors should **not** be bothered by bugs
> found within this project. Instead utilize the information curated to educate
> yourself (the reader) to the options available to current operating system
> that you are reading this document on.

## Windows GPG specific instructions

> Windows file path for user `<name>` GPG configuration. Related external docs;
> [GPG windows config directory location](https://www.gpg4win.org/doc/en/gpg4win-compendium_28.html)

```
C:\Documents and settings\<name>\Application data\gnupg\gpg.rc
```

> Note Windows by default will **not** have the above file after installing
> Gpg4win, thus you will have to make one for your currently logged in user
> `<name>` with a plain text editor, such as `Note Pad`, and modify it as
> directed in the [Gnupg_configuration.md](Gnupg_configuration.md) file under
> the `Documentation/` directory of this project's code repo.

### Outlook (Windows email client) GnuPG integration

[Gpg4Win GpgPL extension](https://www.gpg4win.org/doc/en/gpg4win-compendium_33.html)

> The above external guide covers how to enable support for signed and
> encrypted emails, read sections 1-3 and pay attention to part 3 relating to
> formatting. Once enabled the
> [OutlookPrivacyPlugin](http://dejavusecurity.github.io/OutlookPrivacyPlugin/)
> from GitHub allows Outlook releases up to 2016 to read, encrypt and sign
> emails. There is already a simple guide on using these tools
> [How to Encrypt Emails Using PGP (GPG) in Outlook 2016](http://codepunk.io/how-to-encrypt-emails-using-pgp-gpg-outlook-2016/)
> written by another author, so instructions will not be repeated here.

## Windows 10 experimental instructions

> The following instructions should be preformed **after** reading through the
> following linked guide and are **experimental and untested**;
> [How to install and use the Linux Bash shell on Windows 10](http://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/)

### Open `Start Menu` and under the `search bar`

> input `cmd.exe` to bring up the Windows command line, input the following
> line to install default Bash environment.

```
lxrun /install /y
```

### Set `root`/`Administrator` Bash passphrase

> The default password for the Bash `root` user is nothing at all which is a
> **huge security flaw** as this `root` user is equivalent to `Administrator`
> level users in Windows environment.
> Patch this variability by setting a new password; open `Start Menu` and
> again under the search bar text input type the following...

```
bash
```

> ... or

```
Ubuntu
```

> ... to bring up the `Bash on Ubuntu on Windows` executable, input the
> following line within this **new terminal** window to bring up a password
> prompt.

```
passwd
```

### Update the software that Ubuntu & Bash rely upon

> with the following commands inputed into the `Bash on Ubuntu on Windows`
> terminal. Note each command using a `sudo` prefix will use Window's
> `Administrator` level permissions to do it's magic so be aware of the permission
> level that these commands operate under.

```
sudo apt-get update
sudo apt-get upgrade
```

> The above two commands should be run once to twice a week
> (or month depending upon threat model) to keep all installed packages up to
> date within the `Ubuntu` like environment.

### Install GnuPG command line to `Bash on Ubuntu on Windows`

```
sudo apt-get install gnupg
```

> Note to check if a package is already installed used the following command;
> of course replace `gnupg` with what ever package you wish the install status,
> versions available/installed and availability checked.

```
apt-cache policy gnupg
```

> And to search for packages by key-word try the following command

```
apt-cache search gnupg | less
```

> Note the use of `|` piping above. Press `q` to exit `less`; other
> useful keyboard commands within `less` are; the *arrow* keys,
> `page up`/`page down` and *`space bar`* for scrolling through output.

### Re-opening `bash` terminal on Windows 10

> Open `Start Menu` and under the `search bar` text input type the following.

```
bash
```

> or

```
Ubuntu
```

## Mac OSX+ GnuPG specific instructions

[GPGTools Suite](https://gpgtools.org/)

> The above external link is to an Open Source implementation of PGP for Mac
> and is the one suggested by the main developers of GnuPG. Much like the
> Windows installer, the GPGTools Suite comes with email and command line
> integration.

[OSX with GPG and email integration](http://www.macworld.com/article/2890537/how-to-keep-your-email-private-with-pgp-encryption-on-your-mac.html)

> The above externally linked guide very well written, includes pictures, step
> by step instructions and the authors of this document will suggest Mac users
> preform the above steps prior to using this project's scripts.

### Mac `config` location for GnuPG

> Much like Windows and Linux this'll be under a hidden directory within your
> logged in user's home directory/folder; on Mac, Linux, & Android these
> directories are prefixed by a period (`.`) ei `/home/username/.gnupg`

## Android GnuPG applications

* [Openkeychain](https://www.openkeychain.org/)

> Above is an Open Source Android application available through the two most
> used *market places* for Android apps. The above tool maybe combined with Tor
> and K9 among other applications for a decent level of security on Android with
> GPG, find the full list of known apps to integrate well with
> Openkeychain's [Apps](https://www.openkeychain.org/apps/) listing. However the
> above will **not** integrate with the current scripts found within this project.

* [GnuPG for Android](https://github.com/guardianproject/gnupg-for-android)

> Above is another application for Android but with one feature over the above,
> this one has command line access, so running scripts and using normal GnuPG
> guides work for this application... well so long as other dependencies are
> satisfied; likely you'll need to install `BusyBox` as well as a *terminal
> emulator* for Android to make full use of this project's scripts on mobile.

* [ProtonMail](https://protonmail.com/)

> The above service is one of the cooler companies to emerge from the open
> source crypto communities and appears to be one of the most secure email
> service currently available. With [ProtonMail Source](https://github.com/ProtonMail)
> hosted publicly on GitHub and an Android client application available; they're
> quickly building *trust* among very devoted supporters & developers.

## IOS GnuPG applications

* [Iphmail](https://ipgmail.com/)

> Above costs `$1.99` (USD) last the author of this document checked and only
> supports email, so *no love* will be had between this app and this project's
> scripts.

* [oPenGP](https://itunes.apple.com/us/app/opengp/id414003727?mt=8)

> Above costs `$4.99` (USD) last the author of this document checked but may
> not contain all the *bells & whistles* that external apps or scripts rely upon.
> The authors of this document currently cannot support IOS as a platform for this
> project.

## Linux GPG specific instructions

### Installing GnuPG on Linux (Debian)

```
sudo apt-get install gnupg
```

### Linux GnuPG configuration file path for users

```
/home/${USER}/.gnupg/gpg.conf
```

> Note the above path may not exist for the logged in user, the easiest way
> to have GnuPG generate the directory is to import a key and then use `nano`,
> `vim` or another text editor to make a configuration file at the above file
> path.

## Mutt (Linux email client) GnuPG integration

[Mutt email client GPG config](https://dev.mutt.org/trac/wiki/MuttGuide/UseGPG)

### Linux file path for Mutt GPG configs

```
/home/${USER}/.mutt/gpg.rc
```

> Note Linux conveniently has example config files for above located at the
> following file paths. This makes copying and pasting the example file to the
> above path for your currently logged in `${USER}` name; for example;
> `cat <example_location> | tee ${HOME}/.mutt/gpg.rc` for the appropriate
> `<example_location>`.

 Linux flavor | Example config file path
--------------|-------------------------
 FC 21        | `/usr/share/doc/mutt/gpg.rc`
 OpenBSD >5.4 | `/usr/local/share/examples/mutt/gpg.rc`
 Debian       | `/usr/share/doc/mutt/examples/gpg.rc`

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
