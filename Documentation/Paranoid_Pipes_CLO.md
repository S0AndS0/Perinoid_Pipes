# CLO Manual and documentation

## Recognized command line options, their variables and default values

 CLI option name                      | Associated variable name           | Default Value
-------------------------------------:|:----------------------------------:|:----------------------------------------------------------------------------------------
  `--copy-save-yn`                    | `Var_script_copy_save`             | `no`
  `--copy-save-name`                  | `Var_script_copy_name`             | `${0%/*}/disownable_pipe_listener.sh`
  `--copy-save-permissions`           | `Var_script_copy_permissions`      | `100`
  `--copy-save-ownership`             | `Var_script_copy_ownership`        | `${USER}:${USER}`
  `--debug-level`                     | `Var_debuging`                     | `6`
  `--disown-yn`                       | `Var_disown_parser_yn`             | `yes`
  `--log-level`                       | `Var_logging`                      | `0`
  `--log-file-location`               | `Var_log_file_name`                | `${0%/*}/${Var_script_name%.*}.log`
  `--log-file-permissions`            | `Var_log_file_permissions`         | `600`
  `--log-file-ownership`              | `Var_log_file_ownership`           | `${USER}:${USER}`
  `--log-auto-delete-yn`              | `Var_remove_script_log_on_exit_yn` | `yes`
  `--named-pipe-name`                 | `Var_pipe_file_name`               | `${0%/*}/${Var_script_name%.*}.pipe`
  `--named-pipe-permissions`          | `Var_pipe_permissions`             | `660`
  `--named-pipe-ownership`            | `Var_pipe_ownership`               | `${USER}:${USER}`
  `--listener-quit-string`            | `Var_pipe_quit_string`             | `quit`
  `--listener-trap-command`           | `Var_trap_command`                 | `$(which rm) -f ${Var_pipe_file_name}`
  `--output-pre-parse-yn`             | `Var_preprocess_for_comments_yn`   | `no`
  `--output-pre-parse-comment-string` | `Var_parsing_comment_pattern`      | `\#*`
  `--output-pre-parse-allowed-chars`  | `Var_parsing_allowed_chars`        | `[^a-zA-Z0-9 !#%&:;$\/\^\-\"\(\)\{\}\\]`
  `--output-parse-name`               | `Var_parsing_output_file`          | `${0%/*}/${Var_script_name%.*}.gpg`
  `--output-parse-recipient`          | `Var_gpg_recipient`                | `user@host.domain`
  `--output-save-yn`                  | `Var_save_ecryption_yn`            | `yes`
  `--output-rotate-yn`                | `Var_log_rotate_yn`                | `yes`
  `--output-rotate-max-bites`         | `Var_log_max_size`                 | `4096`
  `--output-rotate-check-frequency`   | `Var_log_check_frequency`          | `100`
  `--output-rotate-actions`           | `Var_log_rotate_actions`           | `compress-encrypt,remove-old`
  `--output-rotate-recipient`         | `Var_log_rotate_recipient`         | `user@host.domain`
  `--output-parse-command`            | `Var_parsing_command`              | `$(which gpg) --always-trust --armor --batch --recipient ${Var_gpg_recipient} --encrypt`
  `--output-bulk-dir`                 | `Var_parcing_bulk_out_dir`         | `${0%/*}/Bulk_${Var_script_name%.*}`
  `--output-bulk-suffix`              | `Var_bulk_output_suffix`           | `.gpg`
  `--padding-enable-yn`               | `Var_enable_padding_yn`            | `no`
  `--padding-length`                  | `Var_padding_length`               | `adaptive`
  `--padding-placement`               | `Var_padding_placement`            | `above`
  `--source-var-file`                 | `Var_source_var_file`              | null
  `--save-options-yn`                 | `Var_save_options`                 | `no`
  `--save-variables-yn`               | `Var_save_variables`               | `no`
  `--license`                         | null                               | null
  `--help` or `-h`                    | `Var_help_val`                     | null
  `*`                                 | `Var_extra_input`                  | null

## Recognized command line options and their optional values

 CLI option name                      | Regex restrictions  | Acceptable values
-------------------------------------:|:--------------------|------------------
  `--copy-save-yn`                    | `a-zA-Z`            | `'Yes'` or `'No'` Enable or disable writing script copy.
  `--copy-save-name`                  | `a-zA-Z0-9_@,.:~\/` | `'/tmp/test_pipe_listener.sh'` or `"${HOME}/test_pipe_listener.sh"` Path and file name to save script copy under
  `--copy-save-permissions`           | `0-9`               | `'100'` or `'110'` Executable permissions only are sufficient.
  `--copy-save-ownership`             | `a-zA-Z0-9_@,.:~\/` | `<user>`:`<group>` Allowed to read named pipe and execute script copy.
  `--debug-level`                     | `0-9`               | `'0'` - `'6'` Lower the number silences main script only.
  `--disown-yn`                       | `a-zA-Z`            | 'Yes' or 'No' Enable or disable running named pipe in background.
  `--log-level`                       | `0-9`               | `'0'` - `'6'` Lower the number to log less of main script run time.
  `--log-file-location`               | `a-zA-Z0-9_@,.:~\/` | `'/var/log/named_pipe_writer.log'` or `"${HOME}/named_pipe_writer.log"` Path and file name for the main script's logs to be written out to.
  `--log-file-permissions`            | `0-9`               | `'600'` or `'660'` Read+write permissions are great for debugging.
  `--log-file-ownership`              | `a-zA-Z0-9_@,.:~\/` | `user`:`group` Allowed to read and write to main script's log file.
  `--log-auto-delete-yn`              | `a-zA-Z`            | `'Yes'` or `'No'` Enable or disable persistent logs between main script runs.
  `--named-pipe-name`                 | `a-zA-Z0-9_@,.:~\/` | `'/tmp/named_test.pipe'` or `"${HOME}/named_test.pipe"` Path and file name to make new named pipe to listen on.
  `--named-pipe-permissions`          | `0-9`               | `'460'` or `'640'` Read/Write permissions separated by owner/group are a good idea.
  `--named-pipe-ownership`            | `a-zA-Z0-9_@,.:~\/` | `<user>`:`<group>` Allowed to read and write to named pipe file.
  `--listener-quit-string`            | `a-zA-Z0-9_@,.:~\/` | `'quit'` or `"$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c32)"` Non-space separated string that will cause listening loops to exit/break on.
  `--listener-trap-command`           | null / disabled    | Disabled to avoid errors in processing command line options. `'rm /tmp/named_test.pipe'` or `"rm -v ${HOME}/named_test.pipe"` Command to run when named pipe listener reads above string.
  `--output-pre-parse-yn`             | `a-zA-Z`            | `'Yes'` or `'No'` Enable or disable reading named pipe input for comments.
  `--output-pre-parse-comment-string` | null                | `\#*`                                                                                    | `"\#*"` or `"\#*|\;*"` A anonymous pipe (`|`) separated list of known line commenting characters.
  `--output-pre-parse-allowed-chars`  | null                | `[^a-zA-Z0-9 !#%&:;$\/\^\-\"\(\)\{\}\\]`                                                 | `'[^a-zA-Z0-9 #\/\-]'` Allowed characters in lines not preceded by known comment
  `--output-parse-name`               | `a-zA-Z0-9_@,.:~\/` | `/tmp/pipe_read_output.gpg`
  `--output-parse-recipient`          | `a-zA-Z0-9_@,.:~\/` | `'email_name@email_domain.suffix'` or `<GPG-Key-ID>` Email address or GPG public key ID to encrypt lines or known file types to.
  `--output-save-yn`                  | `a-zA-Z`            | `yes` or `no` Enable or disable writing parsed output options and actions.
  `--output-rotate-yn`                | `a-zA-Z`            | `yes` or `no` Enable or disable log rotation options and actions.
  `--output-rotate-max-bites`         | `0-9`               | `'4096'` or `'8388608'` Output file max size (in bites) before log rotation actions are used.
  `--output-rotate-check-frequency`   | `0-9`               | `'10'` or `'100000'` Number of output file writes till above file size max vs real file size be checked.
  `--output-rotate-actions`           | `a-zA-Z0-9_@,.:~\/` | `'compress-encrypt,remove-old'` or `'encrypted-email,remove-old'` List of actions, separated by commas `,` to take when output file's size and write count reaches above values.
  `--output-rotate-recipient`         | `a-zA-Z0-9_@,.:~\/` | `'admin_name@admin_domain.suffix'` or `'Admin-GPG-Key-ID'` Email address (if using email log rotation options) or GPG public key ID to re-encrypt and or send compressed output files to.
  `--output-parse-command`            | null / disabled     | Disabled to avoid errors during user input parsing when spaces are present in values.
  `--output-bulk-dir`                 | `a-zA-Z0-9_@,.:~\/` | `'/tmp/encrypted_files'` or `"${HOME}/encrypted_files"` Directory path to save recognized files to. Note these files are not rotated but maybe appended to if not careful.
  `--output-bulk-suffix`              | null                | `'.gpg'` or `'.log'` File suffix to append to bulk encrypted files. Note if decrypting then unset to have previously encrypted file suffixes restored.
  `--padding-enable-yn`               | `a-zA-Z`            | `yes` or `no` default `no`. Used to control if following two options are considered as options for modifying read data.
  `--padding-length`                  | `a-zA-Z0-9_@,.:~\/` | `32` or another integer (whole number) default `adaptive` which assumes the same length as line being read through loop.
  `--padding-placement`               | `a-zA-Z0-9_@,.:~\/` | Order applied within loop; `append`, `prepend`, `above`, `bellow`
  `--source-var-file`                 | `a-zA-Z0-9_@,.:~\/` | File to source for variables defined in previous table. Or file to save values to, see next two options bellow.
  `--save-options-yn`                 | null                | `yes` or `no` Enable or disable saving options file to `--source-var-file`'s path
  `--save-variables-yn`               | null                | `yes` or `no` Enable or disable saving variables file to `--source-var-file`'s path
  `--license`                         | null                | `null` Prints and exits with `0` script's current license and license of scripts that this project writes.
  `--help` or `-h`                    | null                | `null` Prints and exits with `0` script's currently known command line options and current values.
  `--help=<command>` or `-h=<var>`    | null                | `null` Attempts to search for `-h=value` within host system's help documentation and within main script's detailed documentation.
  `*`                                 | null                | `null` Writes any unrecognized arguments as lines or words that should be written to named pipe if available.

 > Note using `--output-pre-parse-yn` or `--padding-enable-yn` options above
 will disable the script's ability to recognize file or directory paths and are
 available for further securing your encrypted server logs. **Do Not** use pipes
 with these options enabled with bulk file writes because that will corrupt your
 data, ie `cat picture.file > logging.pipe` will not result in happy decryption.
 Instead consider using two pipes; one for logging and one for general usage,
 and naming them such that they're not ever mixed up.

 > Note using `--source-var-file` CLI option maybe used to assign variable names
 found in Recognized command line options, their variables and default values
 table's middle column. This allows for
 `script_name.sh --source-var-file=/some/path/to/vars`
 to be used to assign script variables instead of defining them at run-time.
 Additionally this option maybe combined with
 `--save-options-yn` and `--save-variables-yn` options for saving values to a
 file instead; but only if the specified file does **not** already exist.

 > Note using unknown commands ie `'some string within quotes' some words
 outside quotes` will cause the main script to write those unrecognized values
 to the named pipe if/when available. This is for advanced users of the main
 script that wish to have a *header* or set of lines be the first things parsed
 by the processes of the pipe parser functions or custom script.
 This is only enabled within the script's main function if `--disown-yn` option
 has also been set to a *yes* like value.

 > Note using `--help` with additional options may access software external to
 this script but installed on the same host file system. Additionally if any
 scripted documentation exists then that will also be presented to the main
 script's user.

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
