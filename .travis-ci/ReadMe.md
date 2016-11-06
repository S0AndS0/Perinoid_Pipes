# Scripts for Travis Continuous Integration scripts

> The scripts found under this directory are used by the
> [`../.travis.yml`](../.travis.yml) file for automatically building & checking
> this project's main features.

## `before_install.sh`

[![Status](https://img.shields.io/badge/Status-Passing-blue.svg)](before_install_depends.sh)

> Setup Debian based Linux systems with all necessary dependencies. This script
> builds a list of unmet dependacies vs known script dependancies and if any
> are found instals and starts any needed services prior to installing the main
> script of this project. Note for the rest of the build process to complete on
> VMs that `haveged` was added to the dependacies list so that the host server
> has enough entropy to generate test GPG keys latter.

## `install.sh`

[![Status](https://img.shields.io/badge/Status-Passing-blue.svg)](install.sh)

> Copy the main script to standard install directory: `/usr/local/sbin` and
> change permissions to allow execution of script by proper owner and group.
> And test that script is able to execute it's `help` documentation.

## `before_script_gen_key.sh`

[![Status](https://img.shields.io/badge/Status-Passing-blue.svg)](before_script_gen_key.sh)

> Generate new GPG keys for use with testing the main scrip as well as the basic
> logics used within the scripts found within this project.

## `before_script_test_key.sh`

[![Status](https://img.shields.io/badge/Status-Passing-blue.svg)](before_script_test_key.sh)

> Test the encryption and decryption with newly generated GPG keys. The steps
> found within this build script should be similar to the common operations that
> the main script and helper scripts try to achive with some further looping
> of logics.

## `script_encrypt.sh`

[![Status](https://img.shields.io/badge/Status-Passing-blue.svg)](script_encrypt.sh)

> Setup an encrypting named pipe file & associated custom listener script.
> Currently the build is failing to find custom files for the customized pipe
> listener. Test key generation works and a custom script is writen but with
> the *enhanced* security that Travis-CI VMs run with the customized script can
> not either be executed or can not find it's associated named pipe file.

## `script_decrypt.sh`

[![Status](https://img.shields.io/badge/Status-Passing-blue.svg)](script_decrypt.sh)

> This script maybe used as an example of how to use the helper script referanced
> within [../Documentation/Paranoid_Pipes_Scenario_One.md](../Documentation/Paranoid_Pipes_Scenario_One.md)
> for bulk decryption of multi-message files that have been armored & encrypted.

## `script_encrypt_copy.sh`

[![Status](https://img.shields.io/badge/Status-Untested-yellow.svg)](script_encrypt_copy.sh)

> This script tests encryption via a saved copy of the main script (abreviated)
> The authors will be enabling testing for this and the bellow build script.

## `script_decrypt_copy.sh`

[![Status](https://img.shields.io/badge/Status-Untested-yellow.svg)](script_decrypt_copy.sh)

> This script tests encryption via a saved copy of the main script (abreviated)
> The authors will be enabling testing for this and the above build script.

## `lib/functions.sh`

[![Status](https://img.shields.io/badge/Status-Passing-blue.svg)](lib/functions.sh)

> Functions that are sourced by above scripts for logics that are reusable.

## `lib/variables.sh`

[![Status](https://img.shields.io/badge/Status-Passing-blue.svg)](lib/variables.sh)

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
