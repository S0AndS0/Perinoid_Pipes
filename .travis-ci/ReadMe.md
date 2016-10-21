# Scripts for Travis Continuous Integration scripts

> The scripts found under this directory are used by the
> [`../.travis.yml`](../.travis.yml) file for automatically building & checking
> this project's main features.

## `before_install.sh`

[before_install.sh](before_install.sh)

> Setup Debian based Linux systems with all necessary dependencies.

## `install.sh`

[install.sh](install.sh)

> Copy the main script to standard install directory: `/usr/local/sbin`
> and change permissions to allow execution of script.

## `script_encrypt.sh`

[script_encrypt.sh](script_encrypt.sh)

> Setup an encrypting named pipe file & associated custom listener script. 

## `lib/functions.sh`

[lib/functions.sh](lib/functions.sh)

> Functions that are sourced by above scripts for logics that are reusable.

## `lib/variables.sh`

[lib/variables.sh](lib/variables.sh)

> Variables that are sourced by above scripts for values that are reusable.

## ReadMe.md Copyright notice

```
    Copyright (C) 2016 S0AndS0.
    Permission is granted to copy, distribute and/or modify this document under
    the terms of the GNU Free Documentation License, Version 1.3 published by
    the Free Software Foundation; with the Invariant Sections being
    "Title page". A copy of the license is included in the directory entitled
    "License".
```

[Link to title page](../Documentation/Contributing_Financially.md)

[Link to related license](../Licenses/GNU_FDLv1.3_Documentation.md)

## Licensing notice for scripts/code examples

```
    Paranoid_Pipes.sh, maker of named pipe parsing template Bash scripts.
     Copyright (C) 2016 S0AndS0
    This program is free software: you can redistribute it and/or modify it
     under the terms of the GNU Affero General Public License as published by
     the Free Software Foundation, version 3 of the License. You should have
     received a copy of the GNU Afferno General Public License along with this
     program. If not, see <http://www.gnu.org/licenses/>. Contact authors of
    [Paranoid_Pipes.sh] at: strangerthanbland@gmail.com
```

[Link to related license](../Licenses/GNU_AGPLv3_Code.md)
