# Scripts for Travis Continuous Integration scripts

> The scripts found under this directory are used by the
> [`../.travis.yml`](../.travis.yml) file for automatically building & checking
> this project's main features.

## `before_install.sh`

[before_install_depends.sh](before_install_depends.sh)

- Status: Passing

> Setup Debian based Linux systems with all necessary dependencies. This script
> builds a list of unmet dependacies vs known script dependancies and if any
> are found instals and starts any needed services prior to installing the main
> script of this project. Note for the rest of the build process to complete on
> VMs that `haveged` was added to the dependacies list so that the host server
> has enough entropy to generate test GPG keys latter.

## `before_install_gen_key.sh`

[before_install_gen_key.sh](before_install_gen_key.sh)

- Status: Passing

> Generate new GPG keys for use with testing the main scrip as well as the basic
> logics used within the scripts found within this project.

## `before_install_test_key.sh`

[before_install_test_key.sh](before_install_test_key.sh)

- Status: Passing?

> Test the encryption and decryption with newly generated GPG keys. The steps
> found within this build script should be similar to the common operations that
> the main script and helper scripts try to achive with some further looping
> of logics.

## `install.sh`

[install.sh](install.sh)

- Status: Passing

> Copy the main script to standard install directory: `/usr/local/sbin` and
> change permissions to allow execution of script by proper owner and group.
> And test that script is able to execute it's `help` documentation.

## `script_encrypt.sh`

[script_encrypt.sh](script_encrypt.sh)

- Status: Failing

> Setup an encrypting named pipe file & associated custom listener script.
> Currently the build is failing to find custom files for the customized pipe
> listener. Test key generation works and a custom script is writen but with
> the *enhanced* security that Travis-CI VMs run with the customized script can
> not either be executed or can not find it's associated named pipe file.

## `script_decrypt.sh`

[script_decrypt.sh](script_decrypt.sh)

- Status: Failing

> Further local tests are required before the authors of this project re-enable
> this build script. While there are no apperant `shellcheck` errors popping
> there are some issues with the helper script's capabilaty to find the
> encrypted test file and feading it to the decryption named pipe file.

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
