# Code issues & Markdown formatting statistics

[![Version](https://img.shields.io/badge/Version-1--1477518852-blue.svg)](Paranoid_Pipes.sh)
 [![Code Climate](https://codeclimate.com/github/S0AndS0/Perinoid_Pipes/badges/gpa.svg)](https://codeclimate.com/github/S0AndS0/Perinoid_Pipes)
 [![Build Status](https://travis-ci.org/S0AndS0/Perinoid_Pipes.svg?branch=master)](https://travis-ci.org/S0AndS0/Perinoid_Pipes)

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

## Help documentation for version two

### Standard command line options

```
# --columns				Var_columns="80"
# --debug-level				Var_debug_level="0"
# --log-level				Var_log_level="0"
# --script-log-path			Var_script_log_path="${PWD}/${Var_script_name%.sh*}.log"
# --save-variables-yn			Var_save_variables_yn="no"
# --source-var-file			Var_source_var_file=""
# --license				Display the license for this script.
# --help				Display this message.
# --version				Display version for this script.
```

### Decryption command line options

```
# --dec-yn				Var_dec_yn="no"
# --dec-copy-save-yn			Var_dec_copy_save_yn="no"
# --dec-copy-save-path			Var_dec_copy_save_path="${PWD}/Decrypter.sh"
# --dec-copy-save-ownership		Var_dec_copy_save_ownership="$(id -un):$(id -gn)"
# --dec-copy-save-permissions		Var_dec_copy_save_permissions="750"
# --dec-bulk-check-count-max		Var_dec_bulk_check_count_max="0"
# --dec-bulk-check-sleep		Var_dec_bulk_check_sleep="120"
# --dec-gpg-opts			Var_dec_gpg_opts="--quiet --no-tty --always-trust --passphrase-fd 9 --decrypt"
# --dec-pipe-make-yn			Var_dec_pipe_make_yn="no"
# --dec-pipe-file			Var_dec_pipe_file="${PWD}/Decryption_Named.pipe"
# --dec-pipe-permissions		Var_dec_pipe_permissions="600"
# --dec-pipe-ownership			Var_dec_pipe_ownership="$(id -un):$(id -gn)"
# --dec-parsing-bulk-out-dir		Var_dec_parsing_bulk_out_dir="${PWD}/Bulk_Decrypted"
# --dec-parsing-disown-yn		Var_dec_parsing_disown_yn="no"
# --dec-parsing-save-output-yn		Var_dec_parsing_save_output_yn="yes"
# --dec-parsing-output-file		Var_dec_parsing_output_file="${PWD}/Decrypted_Results.txt"
# --dec-parsing-quit-string		Var_dec_parsing_quit_string="quit"
# --dec-pass				Var_dec_pass=""
# --dec-search-string			Var_dec_search_string=""
```

### Encryption command line options

```
# --enc-yn				Var_enc_yn="no"
# --enc-copy-save-yn			Var_enc_copy_save_yn="no"
# --enc-copy-save-path			Var_enc_copy_save_path="${PWD}/Encrypter.sh"
# --enc-copy-save-ownership		Var_enc_copy_save_ownership="$(id -un):$(id -gn)"
# --enc-copy-save-permissions		Var_enc_copy_save_permissions="750"
# --enc-gpg-opts			Var_enc_gpg_opts="--always-trust --armor --batch --no-tty --encrypt"
# --enc-parsing-bulk-out-dir		Var_enc_parsing_bulk_out_dir="${PWD}/Bulk_Encrypted"
# --enc-parsing-bulk-output-suffix	Var_enc_parsing_bulk_output_suffix=".gpg"
# --enc-parsing-disown-yn		Var_enc_parsing_disown_yn="yes"
# --enc-parsing-filter-input-yn		Var_enc_parsing_filter_input_yn="no"
# --enc-parsing-filter-comment-pattern	Var_enc_parsing_filter_comment_pattern="\#*"
# --enc-parsing-filter-allowed-chars	Var_enc_parsing_filter_allowed_chars="[^a-zA-Z0-9 _.@!#%&:;$\/\^\-\"\(\)\{\}\\]"
# --enc-parsing-recipient		Var_enc_parsing_recipient="$(id -un)@${HOSTNAME}.local"
# --enc-parsing-output-file		Var_enc_parsing_output_file="${PWD}/Encrypted_Results.gpg"
# --enc-parsing-output-rotate-yn	Var_enc_parsing_output_rotate_yn="yes"
# --enc-parsing-output-rotate-actions	Var_enc_parsing_output_rotate_actions="compress-encrypt,remove-old"
# --enc-parsing-output-rotate-recipient	Var_enc_parsing_output_rotate_recipient="$(id -un)@${HOSTNAME}.local"
# --enc-parsing-output-max-size		Var_enc_parsing_output_max_size="4096"
# --enc-parsing-output-check-frequency	Var_enc_parsing_output_check_frequency="100"
# --enc-parsing-save-output-yn		Var_enc_parsing_save_output_yn="yes"
# --enc-parsing-quit-string		Var_enc_parsing_quit_string="quit"
# --enc-pipe-permissions		Var_enc_pipe_permissions="600"
# --enc-pipe-ownership			Var_enc_pipe_ownership="$(id -un):$(id -gn)"
# --enc-pipe-file			Var_enc_pipe_file="${PWD}/Encryption_Named.pipe"
# --enc-parsing-output-permissions	Var_enc_parsing_output_permissions="640"
# --enc-parsing-output-ownership	Var_enc_parsing_output_ownership="$(id -un):$(id -gn)"
```

### File path variables

> The following maybe set or left at thier default values.

```
# ---Var_dev_null			Var_dev_null="/dev/null"
# ---Var_echo				Var_echo="$(which echo)"
# ---Var_chmod				Var_chmod="$(which chmod)"
# ---Var_chown				Var_chown="$(which chown)"
# ---Var_mkfifo				Var_mkfifo="$(which mkfifo)"
# ---Var_mv				Var_mv="$(which mv)"
# ---Var_rm				Var_rm="$(which rm)"
# ---Var_tar				Var_tar="$(which tar)"
# ---Var_cat				Var_cat="$(which cat)"
# ---Var_gpg				Var_gpg="$(which gpg)"
# ---Var_mkdir				Var_mkdir="$(which mkdir)"
# ---Var_touch				Var_touch="$(which touch)"
```

## Usage examples

> The following examples maybe used for custom setups and usually involve two
> sets of commands issued to the script to setup both encryption and decryption.

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
