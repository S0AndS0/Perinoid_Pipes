# Licensing notice for this directory

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

## Files contained within this directory

### GnuPG installation and configuration

[Gnupg_installation_options.md](Gnupg_installation_options.md)
 Documentation of various options available to non-Linux & Linux based operating
 systems. Note the only platform that this project is known to work on are Linux
 based OSs and the only platform that this project is likely not able to work on
 are IOS based devices.

[Gnupg_configuration.md](Gnupg_configuration.md)
 Documentation of *best practices* configuration of GnuPG, the attached configs
 are very similar to what contributers and authors of this project make or should
 make use of.

[Gnupg_usefull_commands.md](Gnupg_usefull_commands.md)
 Documentation of daily use command line command for GnuPG; in other words a
 "cheet sheet" for GnuPG.

[Gnupg_key_management.md](Gnupg_key_management.md)
 Documentation of key management command line commands to use with GnuPG. Topics
 covered include; generating new private keys, revocation certificates, signing
 other GnuPG user's public keys, and editing *`trust`* settings for keys.

[Gnupg_with_git_tips.md](Gnupg_with_git_tips.md)
 Covers the finer points of setting `git` up with GnuPG such that future code
 contributers do not run into avoidable errors.

[Gnupg_usefull_tools.md](Gnupg_usefull_tools.md)
 Documentation of tools other than those found within this project that the
 authors of this project believe are worth notifying readers of. While not all
 have been tested by the authors of this project, some where just *too cool* and
 not mentioning'em would be a shame.

### Documentation for [Paranoid_Pipes.sh](../Paranoid_Pipes.sh)

[Paranoid_Pipes_Quick_Start.md](Paranoid_Pipes_Quick_Start.md)
 Documentation on getting this project's main script up and running with test
 data. Note the steps documented are only for testing the features available,
 see `Paranoid_Pipes_CLO.md` for a full list of all known command line options.

[Paranoid_Pipes_Asymmetric_Encryption.md](Paranoid_Pipes_Asymmetric_Encryption.md)
 Documentation for explaining what data cannot be protected by this project or
 the scripts that it writes.

[Paranoid_Pipes_Bash_Logics.md](Paranoid_Pipes_Bash_Logics.md)
 Documentation for the internal logics of this project's main script operations.

[Paranoid_Pipes_CLO.md](Paranoid_Pipes_CLO.md)
 Documentation for all recognized command line options (`CLO`) available to the
 `Paranoid_Pipes.sh` script.

[Paranoid_Pipes_Scenario_One.md](Paranoid_Pipes_Scenario_One.md)
 Documentation for setting up web server logging operations to write to one of
 this project's named pipes for encryption.

[Paranoid_Pipes_Scenario_Two.md](Paranoid_Pipes_Scenario_Two.md)
 Documentation for setting up named pipes for both encryption and decryption on
 the same host but on segregated file systems. Much like `Scenario One` but with
 the requirements that an IDS/IPS system is monitoring plain-text logs for the
 brief time that they're allowed to live on that host.

[Paranoid_Pipes_Scenario_Three.md](Paranoid_Pipes_Scenario_Three.md)
 Documentation for how to setup multiple remote servers with customized script
 copies over `ssh`.

[Paranoid_Pipes_Warnings.md](Paranoid_Pipes_Warnings.md)
 Contains documentation on all know issues that new and current users of this
 project should be aware of.

### Documentation for code & documet contributions to this project

[Contributing_code_credits.md](Contributing_code_credits.md)
 Will eventually contain information on how users of this project can support
 code & documentation maintainers of this project as well as how these
 maintainers have contributed to this project. When available this will take
 the place of [title page](Contributing_Financially.md) info.

[Contributing_code_initial_setup.md](Contributing_code_initial_setup.md)
 Covers steps for setting up your local environment for contributing changes to
 the `origin/master` branch of this project and having the highest chance of
 having changes being accepted; in short this project requires GnuPG/PGP
 generated signatures to be applied to commits, merges and pull requests.

[Contributing_code_maintenance.md](Contributing_code_maintenance.md)
 Covers steps that will be repeated throughout code and documentation editing
 for this project by the maintainers and authors. Once finished with initial
 setup this document and the following linked document will become your *go-to*
 for how to contribute code to this project's `origin/master` branch.

[Contributing_code_merge_conflicts.md](Contributing_code_merge_conflicts.md)
 Covers steps for resolving merge conflicts between project branches using
 `vimdiff` as the `git mergetool` on the command line.

[Contributing_documentation.md](Contributing_documentation.md)
 How to have your own documentation merged into the `master` branch of this
 project. Note steps found in the `Contributing_code_initial_setup.md` file
 should be followed prior following the above documentation.

[Contributing_Financially.md](Contributing_Financially.md)
 Documentation for how users of this project may contribute to the author's
 of this project financially. If you wish to have your contribution known the
 authors are happy to add your info to a `Contributing_Financially_credits.md`
 file within this project's `Documentation/` directory.

### Self education on encryption & scripting resources

[Education_resources.md](Education_resources.md)
 Documentation of verious resources that authors of this project found useful
 when developing this project's script as well as useful resources for describing
 the finer points of the encryption subject as a whole.

### Miscalanious documentation

[FAQ.md](FAQ.md)
 Some of the questions already asked about this project as well as questions the
 authors believed would be asked about this project along with some sample
 answers. While not exhaustive yet this should be one of the first documents new
 users of this project visit to get quickly acquainted with what this project is
 all about.

[Modifying.md](Modifying.md)
 Covers steps for making local/private changes to this project that prevent
 private modifications from causing `git` to *lock-up* and refuse to `fetch`
 updates from the authors. Note following this document will cause your commits
 or changes to become un-signed and thus these private changes will become very
 difficult to merge with the main project.
