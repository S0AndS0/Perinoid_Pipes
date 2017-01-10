# Code issues & Markdown formatting statistics

[![Version](https://img.shields.io/badge/Version-2--0-blue.svg)](Paranoid_Pipes.sh)
 [![Code Climate](https://codeclimate.com/github/S0AndS0/Perinoid_Pipes/badges/gpa.svg)](https://codeclimate.com/github/S0AndS0/Perinoid_Pipes)
 [![Build Status](https://travis-ci.org/S0AndS0/Perinoid_Pipes.svg?branch=testing)](https://travis-ci.org/S0AndS0/Perinoid_Pipes)
 [![Documentation](https://img.shields.io/badge/gh--pages-Documentation-gray.svg)](https://s0ands0.github.io/Perinoid_Pipes)

> The version is the main script's version number combined with last date that the
> authors of this project have tested operations and is provided by [Shields.io](https://shields.io).
> The `Code Climate` is an over all *grade* of both code **&** documentation
> found within this project. And is provided by [Code Climate](https://codeclimate.com/).
> The 'Build Status'es are provided by [Travis-CI](https://travis-ci.org/) and
> which runs tests scripts called within the [.travis.yml](.travis.yml) file
> and reports of any bugs within this project's main script normal usage
> scenarios. Build scripts used for Travis-CI auto-build checks can be found
> under the [.travis-ci](.travis-ci) directory. Which shows exsactly which
> features of this project are fully working in much the same styling.

## Project goals (generalized)

### Provide automated encryption & decryption via GnuPG to logging services & users

> See [Paranoid_Pipes_Scenario_One.md](Documentation/Paranoid_Pipes_Scenario_One.md)
> for detailed instructions on how to set this up for Nginx or Apache2 web
> server logging. See further documentation that include the word `Scenario` for
> other applications that this project maybe applied to easily.

### Provide template(s) of script-able interactions that use GnuPG

> See [Documentation/ReadMe.md](Documentation/ReadMe.md) file to find further
> listed examples as well as *helper* scripts found
> under [`Script_Helpers`](Script_Helpers) that enable more features of this
> project or help setup this project for contribution.

### The core ideals held within this script's design

> Your data should be yours and only those you have authorized to access it
> should be allowed access. Furthermore, your data should be unreadable to
> those that do gain unauthorized access.

## Usage examples

> The following examples maybe used for custom setups and usually involve two
> sets of commands issued to the script to setup both encryption and decryption.
> Find all documented command line options within [Paranoid_Pipes_CLO.md](Documentation/Paranoid_Pipes_CLO.md)
> for further information.

### Write customized encryption copy script

```
version_two.sh\
 --enc-yn='yes'\
 --enc-copy-save-yn='yes'\
 --enc-copy-save-path="${PWD}/Encrypter.sh"\
 --enc-parsing-output-file="${PWD}/Encrypted_Results.gpg"\
 --enc-parsing-bulk-out-dir="${PWD}/Bulk_Encrypted"\
 --enc-parsing-recipient="<your-pub-key-email-address>"\
 --enc-parsing-output-rotate-recipient="<your-bosses-pub-key-email-address>"\
 --enc-pipe-file="${PWD}/Encryption_Named.pipe" --help
```

> Modify the `*-recipient` command line options above and remove `--help` once
> ready to take action instead of displaying current command line option values.
> The above will write a customized script spicific for encryption and auto
> start it if executable. The customized script maybe called on boot without
> providing any further command line options if desired to have encryption
> options always available to the loged in user.

### Write customized decryption copy script

```
version_two.sh\
 --dec-yn="yes"\
 --dec-copy-save-yn="yes"\
 --dec-copy-save-path="${PWD}/Decrypter.sh"\
 --dec-parsing-bulk-out-dir="${PWD}/Bulk_Decrypted"\
 --dec-parsing-output-file="${PWD}/Decrypted_Results.txt"\
 --dec-pass="<private-key-passphrase>"\
 --enc-parsing-output-file="${PWD}/Encrypted_Results.gpg"\
 --enc-parsing-bulk-out-dir="${PWD}/Bulk_Encrypted"\
 --dec-bulk-check-count-max="1" --help
```

> Modify the `--dec-pass` to point to your passphrase file location and remove
> the `--help` command option to write customized script instead of displaying
> current command line option values. The customized script maybe called without
> providing additional command line options to decrypt logs, directories, or
> files encrypted by the customized encryption script.

## ReadMe.md Copyright notice

```
    Copyright (C) 2016 S0AndS0.
    Permission is granted to copy, distribute and/or modify this document under
    the terms of the GNU Free Documentation License, Version 1.3 published by
    the Free Software Foundation; with the Invariant Sections being
    "Title page". A copy of the license is included in the directory entitled
    "License".
```

[Link to title page](Documentation/Contributing_Financially.md)

[Link to related license](Licenses/GNU_FDLv1.3_Documentation.md)
