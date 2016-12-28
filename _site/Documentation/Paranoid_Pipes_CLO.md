# CLO Manual and documentation

## Notes about bellow options

> If using a "Command line option" to pass values into this project's main
> script then they should be prefixed by two dashes (`--`) as shown, however,
> if instead you wish to pass values via the related "Variable name" then
> just pass the variable and value without prefixed. The first command line/
> variable assignment example bellow will include examples of both usage.
> Within most interactive scripts of this project you may also set veriables
> that do not have a related command line option by prefixing the veriable
> with `---` as show much further on within this document.

Standard command line options for most scripts

### Command line option : `--columns`

- Variable name: `Var_columns`
- Default value: `${COLUMNS:-$(tput cols)}`

> Expected values: `80`

### Command line option : `--debug-level`

- Variable name: `Var_debug_level`
- Default value: `0`

> Expected values: `0` - `9`

### Command line option : `--log-level`

- Variable name: `Var_log_level`
- Default value: `0`

> Expected values: `0` - `9`

### Command line option : `--version`

- Variable name: null
- Default value: Display version for this script.

### Command line option: `--help` or `-h`

- Variable name: `Var_help_val`
- Default value: null

> Expected values: ``

### Command line option: `--save-variables-yn`

- Variable name: `Var_save_variables_yn`
- Default value: `no`

> Expected values: ``

### Command line option: `--source-var-file`

- Variable name: `Var_source_var_file`
- Default value: null

> Expected values: ``
> Note using `--source-var-file` CLI option maybe used to assign variable names
> found in Recognized command line options, their variables and default values
> table's middle column. This allows for
> `script_name.sh --source-var-file=/some/path/to/vars`
> to be used to assign script variables instead of defining them at run-time.

### Command line option: `--script-log-path`

- Variable name: `Var_script_log_path`
- Default value: `${0%/*}/${Var_script_name%.*}.log`

> Expected values: ``

### Command line option: `--license`

- Variable name: null
- Default value: null

> Expected values: `null` Prints and exits with `0` script's current license
> and license of scripts that this project writes.

Decryption command line options

### Command line option : `--dec-yn`

- Variable name: `Var_dec_yn`
- Default value: `no`

> Expected values: ``

### Command line option : `--dec-copy-save-yn`

- Variable name: `Var_dec_copy_save_yn`
- Default value: `no`

> Expected values: ``

### Command line option : `--dec-copy-save-path`

- Variable name: `Var_dec_copy_save_path`
- Default value: `${PWD}/Decrypter.sh`

> Expected values: ``

### Command line option : `--dec-copy-save-ownership`

- Variable name: `Var_dec_copy_save_ownership`
- Default value: `$(id -un):$(id -gn)`

> Expected values: ``

### Command line option : `--dec-copy-save-permissions`

- Variable name: `Var_dec_copy_save_permissions`
- Default value: `750`

> Expected values: ``

### Command line option : `--dec-bulk-check-count-max`

- Variable name: `Var_dec_bulk_check_count_max`
- Default value: `0`

> Expected values: ``

### Command line option : `--dec-bulk-check-sleep`

- Variable name: `Var_dec_bulk_check_sleep`
- Default value: `120`

> Expected values: ``

### Command line option : `--dec-gpg-opts`

- Variable name: `Var_dec_gpg_opts`
- Default value: `"--quiet --no-tty --always-trust --passphrase-fd 9 --decrypt"`

> Expected values: ``

### Command line option : `--dec-pipe-make-yn`

- Variable name: `Var_dec_pipe_make_yn`
- Default value: `no`

> Expected values: `yes` or `no`

### Command line option : `--dec-pipe-file`

- Variable name: `Var_dec_pipe_file`
- Default value: `${PWD}/Decryption_Named.pipe`

> Expected values: `null`

### Command line option : `--dec-pipe-permissions`

- Variable name: `Var_dec_pipe_permissions`
- Default value: `600`

> Expected values: ``

### Command line option : `--dec-pipe-ownership`

- Variable name: `Var_dec_pipe_ownership`
- Default value: `$(id -un):$(id -gn)`

> Expected values: ``

### Command line option : `--dec-parsing-bulk-out-dir`

- Variable name: `Var_dec_parsing_bulk_out_dir`
- Default value: `${PWD}/Bulk_Decrypted`

> Expected values: ``

### Command line option : `--dec-parsing-disown-yn`

- Variable name: `Var_dec_parsing_disown_yn`
- Default value: `no`

> Expected values: ``

### Command line option : `--dec-parsing-save-output-yn`

- Variable name: `Var_dec_parsing_save_output_yn`
- Default value: ``

> Expected values: `yes`

### Command line option : `--dec-parsing-output-file`

- Variable name: `Var_dec_parsing_output_file`
- Default value: `${PWD}/Decrypted_Results.txt`

> Expected values: ``

### Command line option : `--dec-parsing-quit-string`

- Variable name: `Var_dec_parsing_quit_string`
- Default value: `quit`

> Expected values: `string-of-charicters-not-normally-seen`

### Command line option : `--dec-pass`

- Variable name: `Var_dec_pass`
- Default value: `null`

> Expected values: `/path/to/pass.txt` or `some-passphrase`

### Command line option : `--dec-search-string`

- Variable name: `Var_dec_search_string`
- Default value: `null`

> Expected values: `Searchable_string`

Encryption command line options

### Command line option : `--enc-yn`

- Variable name: `Var_enc_yn`
- Default value: `no`

> Expected values: '`yes`' or '`no`' Enable or disable encryption processes
> within the script.

### Command line option: `--enc-copy-save-yn`

- Variable name: `Var_enc_copy_save_yn`
- Default value: `no`

> Expected values: `'Yes'` or `'No'` Enable or disable writing script copy.

### Command line option: `--enc-copy-save-path`

- Variable name: `Var_enc_copy_save_path`
- Default value: `${PWD}/Encrypter.sh`

> Expected values: `'/tmp/test_pipe_listener.sh'` Path and file name to save
> script copy under

### Command line option: `--enc-copy-save-permissions`

- Variable name: `Var_enc_copy_save_permissions`
- Default value: `750`

> Expected values: ``

### Command line option: `--enc-copy-save-ownership`

- Variable name: `Var_enc_copy_save_ownership`
- Default value: `$(id -un):$(id -gn)`

> Expected values: ``

### Command line option: `--enc-parsing-disown-yn`

- Variable name: `Var_enc_parsing_disown_yn`
- Default value: `yes`

> Expected values: ``

### Command line option: `--enc-pipe-file`

- Variable name: `Var_enc_pipe_file`
- Default value: `${PWD}/Encryption_Named.pipe`

> Expected values: ``

### Command line option: `--enc-pipe-permissions`

- Variable name: `Var_enc_pipe_permissions`
- Default value: `600`

> Expected values: ``

### Command line option: `--enc-pipe-ownership`

- Variable name: `Var_enc_pipe_ownership`
- Default value: `$(id -un):$(id -gn)`

> Expected values: ``

### Command line option: `--enc-parsing-quit-string`

- Variable name: `Var_enc_parsing_quit_string`
- Default value: `quit`

> Expected values: ``

### Command line option: `--enc-parsing-filter-input-yn`

- Variable name: `Var_enc_parsing_filter_input_yn`
- Default value: `no`

> Expected values: `yes` or `no`
> Note using `--enc-parsing-filter-input-yn` option above may
> disable the script's ability to recognize file or directory paths and are
> available for further securing your encrypted server logs. **Do Not** use
> pipes with these types of options enabled with bulk file writes because that
> will corrupt your data, ie `cat picture.file > logging.pipe` will not result
> in happy decryption. Instead consider using two pipes; one for logging and
> one for general usage, and naming them such that they're not ever mixed up.

### Command line option: `--enc-parsing-filter-comment-pattern`

- Variable name: `Var_enc_parsing_filter_comment_pattern`
- Default value: `\#*`

> Expected values: ``

### Command line option: `--enc-parsing-filter-allowed-chars`

- Variable name: `Var_enc_parsing_filter_allowed_chars`
- Default value: `[^a-zA-Z0-9 _.@!#%&:;$\/\^\-\"\(\)\{\}\\]`

> Expected values: ``

### Command line option: `--enc-parsing-output-file`

- Variable name: `Var_enc_parsing_output_file`
- Default value: `${PWD}/Encrypted_Results.gpg`

> Expected values: ``

### Command line option: `--enc-parsing-output-permissions`

- Variable name: `Var_enc_parsing_output_permissions`
- Default value: `640`

> Expected values: ``

### Command line option: `--enc-parsing-output-ownership`

- Variable name: `Var_enc_parsing_output_ownership`
- Default value: `$(id -un):$(id -gn)`

> Expected values: ``

### Command line option: `--enc-gpg-opts`

- Variable name: `Var_enc_gpg_opts`
- Default value: `--always-trust --armor --batch --no-tty --encrypt`

> Expected values: ``

### Command line option: `--enc-parsing-recipient`

- Variable name: `Var_enc_parsing_recipient`
- Default value: `$(id -un)@${HOSTNAME}.local`

> Expected values: ``

### Command line option: `--enc-parsing-save-output-yn`

- Variable name: `Var_enc_parsing_save_output_yn`
- Default value: `yes`

> Expected values: ``

### Command line option: `--enc-parsing-output-rotate-yn`

- Variable name: `Var_enc_parsing_output_rotate_yn`
- Default value: `yes`

> Expected values: ``

### Command line option: `--enc-parsing-output-max-size`

- Variable name: `Var_enc_parsing_output_max_size`
- Default value: `4096`

> Expected values: ``

### Command line option: `--enc-parsing-output-check-frequency`

- Variable name: `Var_enc_parsing_output_check_frequency`
- Default value: `100`

> Expected values: ``

### Command line option: `--enc-parsing-output-rotate-actions`

- Variable name: `Var_enc_parsing_output_rotate_actions`
- Default value: `compress-encrypt,remove-old`

> Expected values: `'compress-encrypt,remove-old'` or
> `'encrypted-email,remove-old'` List of actions, separated by commas `,` to
> take when output file's size and write count reaches above values.

### Command line option: `--enc-parsing-output-rotate-recipient`

- Variable name: `Var_enc_parsing_output_rotate_recipient`
- Default value: `$(id -un)@${HOSTNAME}.local`

> Expected values: ``

### Command line option: `--enc-parsing-bulk-out-dir`

- Variable name: `Var_parcing_bulk_out_dir`
- Default value: `${PWD}/Bulk_Encrypted`

> Expected values: ``

### Command line option: `--enc-parsing-bulk-output-suffix`

- Variable name: `Var_enc_parsing_bulk_output_suffix`
- Default value: `.gpg`

> Expected values: ``

### Command line option: `*`

- Variable name: Arr_extra_input
- Default value: null

> Expected values: `null` Writes any unrecognized arguments as lines or
> words that should be written to named pipe if available. This is for
> advanced users of the main script that wish to have a *header* or set
> of lines be the first things parsed by the processes of the pipe parser
> functions or custom script. This is only enabled within the script's main
> function if `--enc-parsing-disown-yn` option has also been set to a
> *yes* like value.

File path variables

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
