# Warning

> The scripts found under this directory are significantly less tested or
> completely un-tested! Be sure to run `shellcheck <script_name>` against any
> script found within this directory prior to executing it.

## Scripts available within `Script_Helpers/` directory

[Contributing_initial_setup.sh](Contributing_initial_setup.sh)
 This script is referenced within [../Documentation/Contributing_code_initial_setup.md](../Documentation/Contributing_code_initial_setup.md)
 and maybe used to quickly customize local git configs for this project with
 settings custom for each contributer.

[Paranoid_Pipes_Scenario_One.sh](Paranoid_Pipes_Scenario_One.sh)
 This script is referenced within [../Documentation/Paranoid_Pipes_Scenario_One.md](../Documentation/Paranoid_Pipes_Scenario_One.md)
 as an example of using customized named pipe listener scripts to decrypt log
 files that have appended encrypted contents. This is indented as a *work-around*
 for limitations of GnuPG not *seeming to* recognize listed encrypted data beyond
 the first entry.

[Paranoid_Pipes_Scenario_Three.sh](Paranoid_Pipes_Scenario_Three.sh)
 This script is referenced within [../Documentation/Paranoid_Pipes_Scenario_Three.md](../Documentation/Paranoid_Pipes_Scenario_Three.md)
 as an example of using customized named pipe listener scripts written over SSH.
 This example is a bit more advanced and intended for use in VPS (Virtual Private
 Server) environments that are *rented* and perhaps less than trust worthy in their
 own operational security practices.

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
