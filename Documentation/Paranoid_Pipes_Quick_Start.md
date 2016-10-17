# Quick start

> See guides under the [`Documentation/`](Documentation/) directory for
> complete explanations of this project's target usage information and command
> line options. This document only covers downloading and initial testing of
> project features. See the Frequently asked questions document
> [FAQ.md](Documentation/FAQ.md) for answers to common questions.

## Step 1

> Import public GnuPG key into server that will be running this script or one of
> it's written custom copies.

### From file transfer to server

```
gpg --import /path/to/pubkey
```

### From key server instead

```
gpg --import user@email.domain --recv-keys https://key-server.domain
```

> Note for the most secure results with GnuPG encryption via this script the
> related private key should **not** ever live on the same server that is
> running this script. For testing and special usage cases you may wish to
> (be tempted to) generate a private/public key pare on the target server using
> this script, however, this would be generally a very discouraged security
> practice to implement on publicly accessible servers; see Section
> `Scenario two` within [`Documentation/`](Documentation/) directory for more
> information. If only testing then don't forget to delete both keys again and
> to **not** upload test keys to pubic key servers as that would be a rude use
> of their services.

## Step(s) 2

> Download main script from GitHub

### Change to desired download directory.

```
cd ~/Downloads
```

### Clone project from GitHub & change directories to the project's folder

```
git clone https://github.com/S0AndS0/Perinoid_Pipes
cd ~/Downloads/Perinoid_Pipes
```

### Change script's name and location (optional)

```
cp Paranoid_Pipes.sh /usr/local/sbin/pipe_writer.sh
```

### Change script ownership

> Note the use of `${USER}` built in variable bellow, this will set the script
> copy to be owned by currently logged in user.

```
chown ${USER}:${USER} /usr/local/sbin/pipe_writer.sh
```

### Change script permissions

> Note the bellow setting of `700` sets permissions such that only the owning
> `${USER}` may execute the script copy, if instead you wish to also allow to
> group execution then use `710` instead.

```
chmod 700 /usr/local/sbin/pipe_writer.sh
```

### Change current working directory

> Note bellows's use of `~` (tilde) will change your shell's working directory to
> the default (usually `${HOME}`) for currently logged in user. However, if logged
> in as `root` the bellow will instead transfer your shell's working directory to
> `/` (root) directory.

```
cd ~
```

## Step(s) 3

### Run script copy `-h`/`--help` docs

```
pipe_writer.sh -h
```

> You (the readers) will be using this switch often when testing this script's
> variable assignments; place either `-h` or `--help` at the end of your commands
> to test if the script is reading your other input as desired.

> Note above will only work if you have chosen to copy or move the main
> script to a path that is also found within your shell's `${PATH}` variable;
> hint `echo -e "${PATH//:/\\n}"` will display every directory within the
> variable one per line, choose one of those paths for saving your copy of the
> main script for easy access to it's powers.

### Run script with command line options

> Note all command line options can be found within the
> [Paranoid_Pipes_CLO.md](Documentation/Paranoid_Pipes_CLO.md) file listed in
> tables that provide their default state and constraints.

> Test named pipe reading script by outputting to current terminal using the
> following options. Note if script was moved as shown above then use
> `pipe_writer.sh` instead of `./Paranoid_Pipes.sh`, ie without `./` when
> modifying bellow command.

```
pipe_writer.sh --copy-save-yn=no\
 --output-save-yn=no\
 --disown-yn=no\
 --debug-level=5 --log-level=0\
 --output-bulk-dir=/tmp/test_bulk\
 --named-pipe-name=/tmp/test.pipe\
 --output-parse-recipient=youremail@host.domain\
 --output-rotate-recipient=youremail@host.domain -h
```

> Remove the '-h' option from above command to have parsed output read from
> above pipe name dumped to current terminal. Additionally the back-slashes
> (`\`) in above (and much of bellow) are only to aid in reading and you may
> instead enter command line options on a single line so long as your remember
> to remove the back-slashes while following along.

> Test above by opening second terminal and writing some stings, concatenating
> files, and/or writing file paths to the new pipe file.

### Example commands that maybe used to test your new named pipe

#### Example of writing single line string to named pipe

```
echo 'Testing 123 abc' >  /tmp/test.pipe
```

#### Example of writing multi-line string to named pipe

```
echo -e 'Testing 123 abc\nTesting cba 321' >  /tmp/test.pipe
```

#### Example of cat'ing multi-line file to named pipe

```
cat /etc/rc.local > /tmp/test.pipe
```

#### Example of cat'ing multi-line string to named pipe

```
cat > /tmp/test.pipe <<EOF
testing multi-line
redirection
to named pipe
EOF
```

> The output of all of above example pipe write commands should appear in
> original terminal with `----GPG Begin...` and `-----End...` lines preceding
> and ending each interaction.

Next example is different though...

#### Example of providing full file path to named pipe instead

```
echo '/etc/rc.local' > /tmp/test.pipe
```

... because a known file path was used as an input to the named pipe then this
 script (and those that it writes) will detect this and treat'em special; even
 more special treatment is used on known directory paths.

> Note if you have changed the '--output-bulk-dir=/tmp/test_bulk' command
> line option above then this directory file path will be that which was defined.

#### Example of providing file directory path

```
echo "${HOME}/Pictures" > /tmp/test.pipe
```

> One *gotcha* the above two examples will only work on the first line that
> includes a file or directory path of a multi-line write command. This is to
> avoid the script main script or it's copies from misinterpreting file paths
> in a text document as paths to take action on. So do **not** do
> `cat mylist_of_files.txt > /tmp/test.pipe` and expect anything but funky
> things to happen.

#### Example command to list encrypted files under the bulk output directory.

```
ls -hal /tmp/test_bulk/*.gpg
```

## Step 4

### Quit background or foreground pipe listener

> By writing the default quit string to named pipe from another terminal as
> shown bellow, the script will not only quit within the previous terminal but
> also remove it's associated named pipe file.

```
echo 'quit' > /tmp/test.pipe
```

> Note the above mentioned basic cleanup steps taken by this script are to
> prevent a processes from *talking* to *nobody* when there's no listener
> attached to named pipe. Writing to a named pipe with no listener will cause
> **blocking** within your system so please don't try to circumvent cleanup.

## Step 5

> Was that to easy? Then consider checking out the advanced usage scenarios
> linked within the [ReadMe.md](Documentation/ReadMe.md) file for specific threat
> models that the authors of this project have already documented. Or consider
> writing your own and submitting a `pull-request`/`request-pull` command with
> `git` to get your additions merged into this project for others to use.

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
