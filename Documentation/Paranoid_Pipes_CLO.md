# CLO Manual and documentation

## Recognized command line options, their variables and default values

### Command line option: `--copy-save-yn`

- Variable name: `Var_script_copy_save`
- Default value: `no`
- Regex restrictions: `a-zA-Z`

> Acceptable values: `'Yes'` or `'No'` Enable or disable writing script copy.

### Command line option: `--copy-save-name`

- Variable name: `Var_script_copy_name`
- Default value: `${0%/*}/disownable_pipe_listener.sh`
- Regex restrictions: `a-zA-Z0-9_@,.:~\/`

> Acceptable values: `'/tmp/test_pipe_listener.sh'` Path and file name to save
> script copy under

### Command line option: `--copy-save-permissions`

- Variable name: `Var_script_copy_permissions`
- Default value: `100`
- Regex restrictions: `0-9`

> Acceptable values: `'100'` or `'110'` Executable permissions only are
> sufficient.

### Command line option: `--copy-save-ownership`

- Variable name: `Var_script_copy_ownership`
- Default value: `${USER}:${USER}`
- Regex restrictions: `a-zA-Z0-9_@,.:~\/`

> Acceptable values: `<user>`:`<group>` allowed to read named pipe and execute
> script copy.

### Command line option: `--debug-level`

- Variable name: `Var_debuging`
- Default value: `6`
- Regex restrictions: `0-9`

> Acceptable values: `'0'` - `'6'` Lower the number silences main script only.

### Command line option: `--disown-yn`

- Variable name: `Var_disown_parser_yn`
- Default value: `yes`
- Regex restrictions: `a-zA-Z`

> Acceptable values: 'Yes' or 'No' Enable or disable running named pipe in
> background.

### Command line option: `--log-level`

- Variable name: `Var_logging`
- Default value: `0`
- Regex restrictions: `0-9`

> Acceptable values: `'0'` - `'6'` Lower the number to log less of main script
> run time.

### Command line option: `--log-file-location`

- Variable name: `Var_log_file_name`
- Default value: `${0%/*}/${Var_script_name%.*}.log`
- Regex restrictions: `a-zA-Z0-9_@,.:~\/`

> Acceptable values: `'/var/log/named_pipe_writer.log'` Path and file name for
> the main script's logs to be written out to.

### Command line option: `--log-file-permissions`

- Variable name: `Var_log_file_permissions`
- Default value: `600`
- Regex restrictions: `0-9`

> Acceptable values: `'600'` or `'660'` Read+write permissions are great for
> debugging.

### Command line option: `--log-file-ownership`

- Variable name: `Var_log_file_ownership`
- Default value: `${USER}:${USER}`
- Regex restrictions: `a-zA-Z0-9_@,.:~\/`

> Acceptable values: `user`:`group` Allowed to read and write to main script's
> log file.

### Command line option: `--log-auto-delete-yn`

- Variable name: `Var_remove_script_log_on_exit_yn`
- Default value: `yes`
- Regex restrictions: `a-zA-Z`

> Acceptable values: `'Yes'` or `'No'` Enable or disable persistent logs
> between main script runs.

### Command line option: `--named-pipe-name`

- Variable name: `Var_pipe_file_name`
- Default value: `${0%/*}/${Var_script_name%.*}.pipe`
- Regex restrictions: `a-zA-Z0-9_@,.:~\/`

> Acceptable values: `'/tmp/named_test.pipe'` Path and file name to make new
> named pipe to listen on.

### Command line option: `--named-pipe-permissions`

- Variable name: `Var_pipe_permissions`
- Default value: `600`
- Regex restrictions: `0-9`

> Acceptable values: `'460'` or `'640'` Read/Write permissions separated by
> owner/group are a good idea.

### Command line option: `--named-pipe-ownership`

- Variable name: `Var_pipe_ownership`
- Default value: `${USER}:${USER}`
- Regex restrictions: `a-zA-Z0-9_@,.:~\/`

> Acceptable values: `<user>`:`<group>` Allowed to read and write to named
> pipe file.

### Command line option: `--listener-quit-string`

- Variable name: `Var_pipe_quit_string`
- Default value: `quit`
- Regex restrictions: `a-zA-Z0-9_@,.:~\/`

> Acceptable values: `'quit'` or
> `"$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c32)"` Non-space
> separated string that will cause listening loops to exit/break on.

### Command line option: `--listener-trap-command`

- Variable name: `Var_trap_command`
- Default value: `$(which rm) -f ${Var_pipe_file_name}`
- Regex restrictions: null

> Acceptable values: `'rm /tmp/named_test.pipe'` Command to run when named
> pipe listener reads above string.

### Command line opton: `--output-pre-parse-yn`

- Variable name: `Var_preprocess_for_comments_yn`
- Default value: `no`
- Regex restrictions: `a-zA-Z`

> Acceptable values: `'Yes'` or `'No'` Enable or disable reading named pipe
> input for comments.

### Command line opton: `--output-pre-parse-comment-string`

- Variable name: `Var_parsing_comment_pattern`
- Default value: `\#*`
- Regex restrictions: `\#*`

> Acceptable values: `"\#*"` or `"\#*|\;*"` A anonymous pipe (`|`) separated
> list of known line commenting characters.

### Command line opton: `--output-pre-parse-allowed-chars`

- Variable name: `Var_parsing_allowed_chars`
- Default value: `[^a-zA-Z0-9 !#%&:;$\/\^\-\"\(\)\{\}\\]`
- Regex restrictions: null

> Acceptable values: `[^a-zA-Z0-9 !#%&:;$\/\^\-\"\(\)\{\}\\]` allowed
> characters in lines not preceded by known comment

### Command line opton: `--output-parse-name`

- Variable name: `Var_parsing_output_file`
- Default value: `${0%/*}/${Var_script_name%.*}.gpg`
- Regex restrictions: `a-zA-Z0-9_@,.:~\/`

> Acceptable values: `/tmp/pipe_read_output.gpg`

### Command line opton: `--output-parse-recipient`

- Variable name: `Var_gpg_recipient`
- Default value: `user@host.domain`
- Regex restrictions: `a-zA-Z0-9_@,.:~\/`

> Acceptable values: `'email_name@email_domain.suffix'` Email address or
> GPG public key ID to encrypt lines or known file types to.

### Command line opton: `--output-save-yn`

- Variable name: `Var_save_ecryption_yn`
- Default value: `yes`
- Regex restrictions: `a-zA-Z`

> Acceptable values: `yes` or `no` Enable or disable writing parsed output
> options and actions.

### Command line opton: `--output-rotate-yn`

- Variable name: `Var_log_rotate_yn`
- Default value: `yes`
- Regex restrictions: `a-zA-Z`

> Acceptable values: `yes` or `no` Enable or disable log rotation options and
> actions.

### Command line opton: `--output-rotate-max-bites`

- Variable name: `Var_log_max_size`
- Default value: `4096`
- Regex restrictions: `0-9`

> Acceptable values: `'4096'` or `'8388608'` Output file max size (in bites)
> before log rotation actions are used.

### Command line opton: `--output-rotate-check-frequency`

- Variable name: `Var_log_check_frequency`
- Default value: `100`
- Regex restrictions: `0-9`

> Acceptable values: `'10'` or `'100000'` Number of output file writes till
> above file size max vs real file size be checked.

### Command line opton: `--output-rotate-actions`

- Variable name: `Var_log_rotate_actions`
- Default value: `compress-encrypt,remove-old`
- Regex restrictions: `a-zA-Z0-9_@,.:~\/`

> Acceptable values: `'compress-encrypt,remove-old'` or
> `'encrypted-email,remove-old'` List of actions, separated by commas `,` to
> take when output file's size and write count reaches above values.

### Command line opton: `--output-rotate-recipient`

- Variable name: `Var_log_rotate_recipient`
- Default value: `user@host.domain`
- Regex restrictions: `a-zA-Z0-9_@,.:~\/`

> Acceptable values: `'admin_name@admin_domain.suffix'` Email address of GPG
> public key ID to re-encrypt and or send compressed output files to.

### Command line opton: `--output-parse-command`

- Variable name: `Var_parsing_command`
- Default value: `$(which gpg) --always-trust --armor --batch --recipient ${Var_gpg_recipient} --encrypt`
- Regex restrictions: null / disabled

> Acceptable values: Disabled to avoid errors during user input parsing when
> spaces are present in values.

### Command line opton: `--output-bulk-dir`

- Variable name: `Var_parcing_bulk_out_dir`
- Default value: `${0%/*}/Bulk_${Var_script_name%.*}`
- Regex restrictions: `a-zA-Z0-9_@,.:~\/`

> Acceptable values: `'/tmp/encrypted_files'` Directory path to save
> recognized files to. Note these files are not rotated but maybe appended to
> if not careful.

### Command line opton: `--output-bulk-suffix`

- Variable name: `Var_bulk_output_suffix`
- Default value: `.gpg`
- Regex restrictions: null

> Acceptable values: `'.gpg'` or `'.log'` File suffix to append to bulk
> encrypted files. Note if decrypting then unset to have previously encrypted
> file suffixes restored.

### Command line opton: `--padding-enable-yn`

- Variable name: `Var_enable_padding_yn`
- Default value: `no`
- Regex restrictions: `a-zA-Z`

> Acceptable values: `yes` or `no` default `no`. Used to control if following
> two options are considered as options for modifying read data.

### Command line opton: `--padding-length`

- Variable name: `Var_padding_length`
- Default value: `adaptive`
- Regex restrictions: `a-zA-Z0-9_@,.:~\/`

> Acceptable values: `32` or another integer (whole number) default `adaptive`
> which assumes the same length as line being read through loop.

### Command line opton: `--padding-placement`

- Variable name: `Var_padding_placement`
- Default value: `above`
- Regex restrictions: `a-zA-Z0-9_@,.:~\/`

> Acceptable values: Order applied within loop; `append`, `prepend`, `above`,
> `bellow`

### Command line opton: `--source-var-file`

- Variable name: `Var_source_var_file`
- Default value: null
- Regex restrictions: `a-zA-Z0-9_@,.:~\/`

> Acceptable values: File to source for variables defined in previous table.
> Or file to save values to, see next two options bellow.

### Command line opton: `--save-options-yn`

- Variable name: `Var_save_options`
- Default value: `no`
- Regex restrictions: null

> Acceptable values: `yes` or `no` Enable or disable saving options file to
> `--source-var-file`'s path

### Command line opton: `--save-variables-yn`

- Variable name: `Var_save_variables`
- Default value: `no`
- Regex restrictions: null

> Acceptable values: `yes` or `no` Enable or disable saving variables file to
> `--source-var-file`'s path

### Command line opton: `--license`

- Variable name: null
- Default value: null
- Regex restrictions: null

> Acceptable values: `null` Prints and exits with `0` script's current license
> and license of scripts that this project writes.

### Command line opton: `--help` or `-h`

- Variable name: `Var_help_val`
- Default value: null
- Regex restrictions: null
- Acceptable values: `null` Prints and exits with `0` script's currently known command line options and current values.

> Acceptable values: `null` Attempts to search for `-h=value` within host
> system's help documentation and within main script's detailed documentation.

### Command line opton: `*`

- Variable name: Arr_extra_input
- Default value: null
- Regex restrictions: null

> Acceptable values: `null` Writes any unrecognized arguments as lines or
> words that should be written to named pipe if available.

## Notes about above

### Note one

> Note using `--output-pre-parse-yn` or `--padding-enable-yn` options above
> will disable the script's ability to recognize file or directory paths and are
> available for further securing your encrypted server logs. **Do Not** use
> pipes with these options enabled with bulk file writes because that will
> corrupt your data, ie `cat picture.file > logging.pipe` will not result in
> happy decryption. Instead consider using two pipes; one for logging and one
> for general usage, and naming them such that they're not ever mixed up.

### Note two

> Note using `--source-var-file` CLI option maybe used to assign variable names
> found in Recognized command line options, their variables and default values
> table's middle column. This allows for
> `script_name.sh --source-var-file=/some/path/to/vars`
> to be used to assign script variables instead of defining them at run-time.
> Additionally this option maybe combined with
> `--save-options-yn` and `--save-variables-yn` options for saving values to a
> file instead; but only if the specified file does **not** already exist.

### Note three

> Note using unknown commands ie `'some string within quotes' some words
> outside quotes` will cause the main script to write those unrecognized values
> to the named pipe if/when available. This is for advanced users of the main
> script that wish to have a *header* or set of lines be the first things parsed
> by the processes of the pipe parser functions or custom script.
> This is only enabled within the script's main function if `--disown-yn` option
> has also been set to a *yes* like value.

### Note four

> Note using `--help` with additional options may access software external to
> this script but installed on the same host file system. Additionally if any
> scripted documentation exists then that will also be presented to the main
> script's user.

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
