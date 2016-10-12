# Licensing notice for this directory

 > ```
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

[Contributing_Financially.md](Contributing_Financially.md)
 Documentation for how users of this project may contribute to the author's
 of this project financially. If you wish to have your contribution known the
 authors are happy to add your info to a `Contributing_Financially_credits.md`
 file within this project's `Documentation/` directory.

[FAQ.md](FAQ.md)
 Some of the questions already asked about this project as well as questions the
 authors believed would be asked about this project along with some sample
 answers. While not exhaustive yet this should be one of the first documents new
 users of this project visit to get quickly acquainted with what this project is
 all about.

[Gnupg_with_git_tips.md](Gnupg_with_git_tips.md)
 Covers the finer points of setting `git` up with GnuPG such that future code
 contributers do not run into avoidable errors.

[Modifying.md](Modifying.md)
 Covers steps for making local/private changes to this project that prevent
 private modifications from causing `git` to *lock-up* and refuse to `fetch`
 updates from the authors. Note following this document will cause your commits
 or changes to become un-signed and thus these private changes will become very
 difficult to merge with the main project.

[Paranoid_Pipes_Asymmetric_Encryption.md](Paranoid_Pipes_Asymmetric_Encryption.md)
 Documentation for explaining what data cannot be protected by this project or
 the scripts that it writes. This file was originally apart of the
 `ReadMe_Paranoid_Pipes.md` file so there maybe some editing still left to do.

[Paranoid_Pipes_Bash_Logics.md](Paranoid_Pipes_Bash_Logics.md)
 Documentation for the internal logics of this project's main script operations.
 This file was originally apart of the `ReadMe_Paranoid_Pipes.md` file so there
 maybe some editing still left to do.

[Paranoid_Pipes_CLO.md](Paranoid_Pipes_CLO.md)
 Documentation for all recognized command line options (`CLO`) available to the
 `Paranoid_Pipes.sh` script. This file was originally apart of the
 `ReadMe_Paranoid_Pipes.md` file so there maybe some editing still left to do.

[Paranoid_Pipes_Scenario_One.md](Paranoid_Pipes_Scenario_One.md)
 Documentation for setting up web server logging operations to write to one of
 this project's named pipes for encryption. This file was originally apart of
 the `ReadMe_Paranoid_Pipes.md` file so there maybe some editing still left to
 do.

[Paranoid_Pipes_Scenario_Two.md](Paranoid_Pipes_Scenario_Two.md)
 Documentation for setting up named pipes for both encryption and decryption on
 the same host but on segregated file systems. Much like `Scenario One` but with
 the requirements that an IDS/IPS system is monitoring plain-text logs for the
 brief time that they're allowed to live on that host. This file was originally
 apart of the `ReadMe_Paranoid_Pipes.md` file so there maybe some editing still
 left to do.

[Paranoid_Pipes_Scenario_Three.md](Paranoid_Pipes_Scenario_Three.md)
 Documentation for how to setup multiple remote servers with customized script
 copies over `ssh`. This file was originally apart of the
 `ReadMe_Paranoid_Pipes.md` file so there maybe some editing still left to do.

[Paranoid_Pipes_Warnings.md](Paranoid_Pipes_Warnings.md)
 Contains documentation on all know issues that new and current users of this
 project should be aware of. This file was originally apart of the
 `ReadMe_Paranoid_Pipes.md` file so there maybe some editing still left to do.

# External links to documentation used within this project

 > Note the bellow links are **not** directly related to the project and serve
 as the author of this project crediting the following authors for having solved
 or documented techniques prior to the publication of this project. In other
 words **do not** bother them because of bugs within this project; instead
 communicate with this project's authors to resolve this project's bugs.

[General GitHub guide for contributing code](https://guides.github.com/activities/contributing-to-open-source/)

[Git guide - Signing your work](https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work)

[Source for `hub` command line tool for `git` with GitHub](https://github.com/github/hub)

[Beautiful `git` with `vimdiff` tutorial in markdown format](https://gist.github.com/karenyyng/f19ff75c60f18b4b8149)

[Cheat sheet for `vimdiff` with some good comments](https://gist.github.com/mattratleph/4026987)

[Mergetool `vimdiff` cheat sheat](http://devmartin.com/blog/2014/06/basic-vimdiff-commands-for-git-mergetool/)

[Spell checking `vim` tutorial](https://www.linux.com/learn/using-spell-checking-vim)

[Grab last command used on Bash](http://stackoverflow.com/a/9502698)

[Methods of generating random strings of specified length](https://gist.github.com/earthgecko/3089509)

[Nginx log rotation documentation](https://www.nginx.com/resources/wiki/start/topics/examples/logrotation/)

[Appache2.4 log rotation documentation](https://httpd.apache.org/docs/2.4/programs/rotatelogs.html)

[Stack Exchange - Rsyslog to fifo answered](http://unix.stackexchange.com/questions/134896/how-to-redirect-logs-to-a-fifo-device)

[Server Fault - Run local script over SSH to remote](http://serverfault.com/a/595256)

[Fair Source License - Home page](https://fair.io/)

[Fair License](http://fairlicense.org/)

[Wiki - Derivative works defined](https://en.wikipedia.org/wiki/Derivative_work)

## Others seeking tools similar to this

[Security Stac Exchange - Write only one way encrypted directory](http://security.stackexchange.com/questions/6218/is-there-any-asymmetrically-encrypted-file-system)
 Currently only one tool offered seems to fit their requirements but accepted answer doesn't provide solution; just reasons as to why there's no solution.

[Serverfault - Asymmetric encrypt server logs that end up with sensitive data written to them](http://serverfault.com/questions/89126/asymmetrically-encrypted-filesystem)
 No solutions posted!

[Stack Overflow - Android asymmetric encryption line by line](http://stackoverflow.com/questions/29131427/efficient-asymmetric-log-encryption-in-android/29134101)
 No solutions posted!

## Similar tools & guides

[Guide to asymmetric encryption with OpenSSL](https://www.devco.net/archives/2006/02/13/public_-_private_key_encryption_using_openssl.php)
 Seems pretty snazzy but authors of this script have not tested it yet.
