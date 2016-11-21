# Warning

> The scripts found under this directory are significantly less tested or
> completely un-tested! Be sure to run `shellcheck <script_name>` against any
> script found within this directory prior to executing it.

## Scripts available within `Script_Helpers/` directory

### `Contributing_initial_setup.sh`

[![Status](https://img.shields.io/badge/Status-Untested-yellow.svg)](Contributing_initial_setup.sh)

> This script is referenced within
> [../Documentation/Contributing_code_initial_setup.md](../Documentation/Contributing_code_initial_setup.md)
> and maybe used to quickly customize local git config for this project with
> settings custom for each contributer. Use the command line option `--help`
> with this helper script to print all settable options and their current
> values.

### `Fold_Message.sh`

[![Status](https://img.shields.io/badge/Status-Passing-blue.svg)](Fold_Message.sh)

> This script is referenced within
> [../Documentation/Contributing_code_maintenance.md](../Documentation/Contributing_code_maintenance.md)
> and maybe used to quickly format messages to no more than a certain length.
> This helper script does **not** accept command line options but instead a
> string of words, quoted or double quoted or not quoted, and prints formated
> output, adding new lines at spaces when allowed when read input is greater
> than intarnally set colom width variable.

Example usage for commiting `git` message

```
git commit -S -am "Title of changes" -m "$(Fold_Message.sh "really long text string...")"

```

### `Format_git_badge.sh`

[![Status](https://img.shields.io/badge/Status-Passing-blue.svg)](Format_git_badge.sh)

> This script is used to generate custom badges for this project and is provided
> by the [Shields.io](https://shields.io) site to allow for *prettier*
> documentation.

### `GnuPG_Gen_Key.sh`

[![Status](https://img.shields.io/badge/Status-Passing-blue.svg)](GnuPG_Gen_Key.sh)

> This script is a combination of notes found for configuring and setting up GnuPG
> with *best practices* and sane defaults taken into account by it's authors. This
> script is also used within the auto-build scripts for making test keys on VPSs.
> Note for source code readers, the function `Func_gen_revoke_cert` may not be
> pretty it **does** work. Use command line option `--help` to print available
> options and their current values.

### `Paranoid_Pipes_Scenario_One.sh`

[![Status](https://img.shields.io/badge/Status-Passing-blue.svg)](Paranoid_Pipes_Scenario_One.sh)

> This script is referenced within
> [../Documentation/Paranoid_Pipes_Scenario_One.md](../Documentation/Paranoid_Pipes_Scenario_One.md)
> as an example of using customized named pipe listener scripts to decrypt log
> files that have appended encrypted contents. However a named pipe does not
> necessarily need to be present for this script to operate; hint, try running
> with `--help` command line option to find out what input it accepts and the
> output it produces. This helper script is indented as a *work-around* for
> limitations within GnuPG when using `--armor` option to encrypt files or
> streams of data, if your encrypted logs where made without this option then
> you may try `--allow-multiple-messages` as a `gpg` command line option added
> to your own command to recover log files encrypted with this project's main
> script with one exception for right now, if the main script had the padding
> option enabled there will still be padded data within the decrypted output.

### `Paranoid_Pipes_Scenario_Three.sh`

[![Status](https://img.shields.io/badge/Status-Untested-yellow.svg)](Paranoid_Pipes_Scenario_Three.sh)

> This script is referenced within
> [../Documentation/Paranoid_Pipes_Scenario_Three.md](../Documentation/Paranoid_Pipes_Scenario_Three.md)
> as an example of using customized named pipe listener scripts written over SSH.
> This example is a bit more advanced and intended for use on VPS (Virtual Private
> Server) or other environments that are rented and perhaps less than swift in
> their own operational security practices.

### `Template_interactive_script.sh`

[![Status](https://img.shields.io/badge/Status-Example-gray.svg)](Template_interactive_script.sh)

> This script serves as a quick start for authors or contributors to use
> when starting a new script for this project. Many of the above scripts
> are modled off of this script's methods of assigning user input to
> variables used by the script for processing or desision making.

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

> See [`../Licenses/ReadMe.md`](../Licenses/ReadMe.md) for further information as
> to the hows and whys of these licensing choices made by this project's authors.

## Licensing notice for this file

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
