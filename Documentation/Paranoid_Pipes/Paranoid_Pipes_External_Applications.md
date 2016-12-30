---
title: Audit of applications used by the main script of this project
---

# External application used

> Note these are organized by licensing agreements that the applications
> external to this project operate under,
> Documentation specific to each command bellow can be found with
> `<command> --help` or `man <command>`

## GNU GPL v2

### `mutt`

> [GNU GPL v2+](https://dev.mutt.org/hg/mutt/file/084fb086a0e7/COPYRIGHT#l20)
> Email client used by this script for log rotation actions.

## [GNU GPL v3](https://www.gnu.org/copyleft/gpl.html)

### `gpg` or `gpg2`

> Encryption, decryption & signature verification of data parsed by this
> project's custom scripts & named pipes.

### `mkdir`

> Makes directories if not already present for output files to.

### `cp`

> Copies files or directories recursively at times.

### `rm`

> Removes files, pipes and old logs; never used recursively within main script.

### `cat`

> Concatenates files or strings passed as files to terminal or parsing pipe
> input commands.

### `echo`

> Prints messages to scripts users and used for redirecting messages to
> script log files.

### `tar`

> Compresses parsed log files during log rotation actions if enabled.

### `chown`

> Change ownership `<user>:<group>` of files and/or directories.

### `mkfifo`

> Make *first-in-first-out* named pipe file. This is one of the *magic*
> commands used in this script.

### `date`

> Print date to script log files or in user messages.

### `bash`

> Interprets *human readable* source code (this project's scripts) into
> compatible machine instructions, often used as the command line interpreter
> for user logins and scripting, rarely used or seen as a programing language.

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
