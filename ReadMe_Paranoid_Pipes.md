### ReadMe_Paranoid_Pipes.md Copyright notice

 >```bash
        Copyright (C)  2016 S0AndS0.
        Permission is granted to copy, distribute and/or modify this document
        under the terms of the GNU Free Documentation License, Version 1.3
        published by the Free Software Foundation;
        with the Invariant Sections being Title page.
        A copy of the license is included in the section entitled "GNU
        Free Documentation License".
```

### Title page

Paranoid Pipes project documentation

Support the original authors finacially via the following methods

 Currency Type   | Wallet public address
-----------------|-----------------------
 USD (PayPal)    | paypal.me/S0AndS0
 BTC (bitcoin)   | 1JJXnF2NMcTT24Rj7g9XkEDN5qP5nRFk1o
 LTC (litecoin)  | LKucbsSHxQxDekJquwpdSpnsdbnqEVbTe2
 DOGE (dogecoin) | DS9PXxjQr12s1nAUUSQyR7YQK6HM1GbdkC
 DRK (darkcoin)  | XradYSbZ2oZT9Qi1JwmFVx3UCzeqfX5Fvy
 VTC (vertcoin)  | VvRePCWBatR5nohf2xXXwLLmvUfWG2mFE4
 RDD (reddcoin)  | Ro4CyYZWEPqjSMbmZgiyQE7VfaLmd6gh5P

### About this project

 + Script name: Paranoid Pipes (Version 1)

 + Target system OS: Linux Debian (Jessie) or up to date Debian derivative

 + Target Bash version: 4.3+

 + External application (default) dependencies:

 - -  `gnupg` &/or `gnupg2` installed to same file system as scripts that make use of'em.

 - - `haveged` for embedded & mobile devices is suggested but not required.

 - - See `CLO Manual and documentation` second section within this document for complete list.

 + Target Usages:

 - - Encrypt rsyslogs on VPS (or other remote server) with named pipes and customized listening scripts.

 - - Mitigate server breach cleanup procedures by never allowing non-keyed clients to access clear text logs.

 - - Mitigate data transport risks associated with data transmission across untrusted networks.

 - - Mitigate known word or string attacks with the use of `--padding-enable-yn` related options, however see Warning 4 & 5 before using

### Navigating this file

 Section title                        | Info contained
--------------------------------------|----------------------------------------------------------------------
 Warnings                             | List of known *gotchas* and features that may cause file corruption, skip at your own risk.
 Linux Asymmetric Log Encryption      | Introduction of script's authors intentions and aims at solving general problems had with encryption using pubic private keys for arbitrary lengths of data.
 TLDR (Quick start)                   | Guide for downloading this script
 CLO Manual and documentation         | Listing of known Command Line Options for changing script behaviour and documentation on how the script makes decisions based upon those options.
 Story time                           | Covers (two currently written) three usage scenarios that authors predicted for encrypting named pipe listening scripts.
 Sources of info                      | Links (external to this document) used to build script and this guide.
 Others seeking tools similar to this | Links (external to this document) used to inspire designing this script.
 Similar tools & guides               | Links (external to this document) found by this script's authors to provide similar functionality
 Licensing & Usage agreement          | Describes user licensing of project, software and licensing external to this project are under their respective licensing requirements.

### Warnings

 0. This project, it's scripts and those contained within this document and this document itself are all without warranty nor will the authors be held liable for damages sustained to users, their hardware or the hardware of others while using this project's scripts, guides, or examples.

 - - released under `` licence found under the `Licencing & Usage agreement` section within this document explains this in much greater detail.

 - - allowed use, user agreement, reproduction and modification are further explained in the `` section within this document.

 1. Do not send **all** logging daemon output through this script's (or the script copy's) named pipe(s); be selective.

 - - first because this script likely generates system logs so sending all `rsyslog`'s data into one of these named pipes would be analogous to force feeding a snake it's own tail & the rest of the kitchen along with,

 - - second because even with filtering this script from your logging daemon's output, logging everything else through an encrypting pipe will likely slow down if not crash your system.

 - - Be very specific as to what data you send through!

 2. Do not send untrusted input into decrypting or encrypting pipes without understanding what this tool is doing!

 - -  much care has been taken to provide options towards preventing data passing through named pipes from expansion into shell commands

 - - still it is possible that a devoted attacker could embed malicious code within that is either expanded upon while writing or reading.

 3. Do not read decrypted content on an insecure or default configured document reader.

 - - Same reasoning as `Warning 2` above and,

 - - default configured document readers often save caches and/or backups in clear text at some obscure location; kinda defeats the porous of keeping secrets if your reader tattles on you.

 4. only enable `--output-pre-parse-yn` and/or `--padding-enable-yn` options when you are certain as to what those options do. Default values for each are `no` so do not worry about manually disabling them.

 - - the `--output-pre-parse-yn` option if enabled will cause the listening loop to prepend `#` to read lines that do not have them at the start of the line already

 - - the `--padding-enable-yn` option if enabled will cause lines read to also include random alpha and numeric characters the be added to read lines.

 - - See `CLO Manual and documentation` section within this document for all command line options of this project explained in greater detail.

 - - The authors of this project will not aid users in recovering corrupted files if either of these options where in use on user's target systems.

 5. `--padding-enable-yn` and related options can *rob* the host OS of entropy,

 - - consider using `haveged`, ie `apt-get install haveged && /etc/init.d/haveged restart` let your system chill then check your entropy available `cat /proc/sys/kernel/random/entropy_avail`

 - - or buy a secure random number generator to seed `/dev/urandom` when entropy is low.

 - - or build an entropy seeder.

 6. ` --output-parse-recipient` and `--output-rotate-recipient` options are **required** if `--help` option is excluded from script command line options.

 - - these email addresses maybe the same or different, but must be passed via command line or edited in manually. See section `` within `` for automation examples.

 7. Script examples contained within this document **are** under the same licencing and terms agreement as the main script of this project, **however**, note that the script examples within this document are not as well tested as the main script and they're meant as general guidance of problem solving with Bash.

### Linux Asymmetric Log Encryption

	The core ideals held within this script's design are; your data should be yours and only those you have authorized to access it should be allowed access, your data should be unreadable to those that gain unauthorized access. The authors of this project believe that though customized usage of this script, users that share these ideals may achieve great control over their data access rights. Currently this is achieved using some Bash magics with `mkfifo`, and via GnuPG's public/private key pare encryption methods; though with a little modification it appears this project maybe capable of sending data through other encryption software such as OpenSSL. In short while much has been finished and now works, there is still much more that could be done to improve and/or increase this project's capabilities.

	Encryption of arbitrary data or files is a common enough request that this tool was developed. This is not a partition encryption solution (often LUKS partitions are the goto for such Kernel level supported encryption where a file system can be mounted, read, and written to) instead this is a method of file by file and/or line by line asymmetric encryption at the host OS's software layer.

-----

 > Because of the differences in kernel vs software implementation of encryption, the authors of this project feal it is worth warning users that there is some risk for leakage of data destined for encryption. Often this data can be found in the form of system logs or shell history files showing the interactions between a program or user and another program, ie `tail -n4 /root/.bash_history`-

 - Bash's history file output example
```bash
cd /some/file/path
gpg -r emailuser@host.domain -e some_file -o /tmp/some_file.gpg
echo 'Email body about attached file' | mutt -s 'Subject of encrypted files attached' -a /tmp/some_file.gpg
clear
```

 > Known as metadata this amount of information leakage may, or may not, be acceptable depending upon your own perceived threat modal and upon your system permission and physical access levels on the target server. Some logging of interactions may not be preventable.
 > For this script's process ID both running in the background or foreground the authors have selected to turn off Bash history but have not gone any further to protect users from system logging services. User may mitigate logging metadata further by setting up custom templates or filters for their logging daemon's configuration, however, this topic is better suited for other documentation; hint 'man <logging-daemon>' may yield exceptional information on how to selectively not log this script's actions... Though that maybe a very bad idea, instead consider turning down the verbosity of your logging service for this script's tasks until assured that you're not leaking data destined for encryption.

-----

 # Hint: for both log daemon auditing (and auditing of the script) see section 'CLO Manual and documentation' within this document for listing of every Bash built-in command & external program called listed without repeats.


### TLDR (Quick start)

	Check the `Story time` section within this guide for more in-depth setup instructions specific to various threat models. Check the above warnings as they're not likely to be repeated.

-----

 # Step 1; 
	Import public GnuPG key into server that will be running this script or one of it's written custom copies.

 - From file transfer to server
```bash
gpg --import /path/to/pubkey
```

 - From key server instead
```bash
gpg --import user@email.domain --recv-keys https://key-server.domain
```

 Note for the most secure results with GnuPG encryption via this script the related private key should **not** ever live on the same server that is running this script.
 For testing and special usage cases you may wish (be tempted) to generate a private/public key pare on the target server using this script, however, this would be generally a very discouraged security practice to implement on publicly accessible servers; see Section `Story time` -> `Scenario two` within this document for more information.
 If only for testing then don't forget to delete both keys again and to **not** upload test keys to pubic key servers as that would be a rude use of their services.

 # Step(s) 2; 
	Download main script from GitHub

 - Change to desired download directory.
```bash
cd ~/Downloads
```

 - Clone project from GitHub and change directories to the new repo's folder
```bash
git clone <URL>
cd ~/Downloads/<Project_Name>
```

 - Change script ownership to be owned by currently logged in user.
```bash
chown ${USER}:${USER} <Script_Name>
```

 - Change script permissions such that owning **`u`**ser may e**`x`**ecute.
```bash
chmod u+x <Script_Name>
```

 - Change script's name and location (optional)
```bash
mv <Script_Name> /usr/local/sbin/pipe_writer.sh
```

 - Change current working directory to default for currently logged in user and attempt to call by name without file path.
```bash
cd
pipe_writer.sh -h
```
 Note above will only work if you have chosen to copy or move the main script to a path that is also found within your shell's `${PATH}` variable; hint `echo -e "${PATH//:/\\n}" will display every directory within the variable one per line, choose one of those paths for saving your copy of the main script for easy access to it's powers.

 # Step(s) 3

	List command line options, current values and exit with '0' status. Note replace `<Script_Name>` with the script's name if re-named
```bash
./<Script_Name> --help
# Print exit status of last command/script
echo -e "# Exit status of: !!\n# Was $?"
```

	Test named pipe reading script by outputting to current terminal using the following options. Note if script was moved as shown above then use `script_name` instead of `./script_name`, ie without `./` when modifying bellow command because it assumes you're still in `/$HOME/Downloads/Script_dir` directory.
```bash
./Script_Name --copy-save-yn=no\
 --output-save-yn=no\
 --disown-yn=no\
 --debug-level=5 --log-level=0\
 --output-bulk-dir=/tmp/test_bulk\
 --named-pipe-name=/tmp/test.pipe\
 --output-parse-recipient=youremail@host.domain\
 --output-rotate-recipient=youremail@host.domain -h
```
 Remove the '-h' option from above command to have parsed output read from above pipe name dumped to current terminal. Additionally the back-slashes (`\`) in above (and much of bellow) are only to aid in reading and you may instead enter command line options on a single line so long as your remember to remove the back-slashes while following along.

	Test above by opening second terminal and writing some stings, concatenating files, and/or writing file paths to the new pipe file.

 Here's a set of example commands that maybe used to test your new named pipe;

 - Example of writing single line string to named pipe
```bash
echo 'Testing 123 abc' >  /tmp/test.pipe
```

 - Example of writing multi-line string to named pipe
```bash
echo -e 'Testing 123 abc\nTesting cba 321' >  /tmp/test.pipe
```

 - Example of cat'ing multi-line file to named pipe
```bash
cat /etc/rc.local > /tmp/test.pipe
```

 - Example of cat'ing multi-line string to named pipe
```bash
cat > /tmp/test.pipe <<EOF
testing multi-line
redirection
to named pipe
EOF
```

The output of all of above example pipe write commands should appear in original terminal with `----GPG Beguin...' and `-----End...` lines preceding and ending each interaction.

 Next example is different though...

 - Example of providing full file path to named pipe instead
```bash
echo '/etc/rc.local' > /tmp/test.pipe
```

 ... because a known file path was used as an input to the named pipe then this script (and those that it writes) will detect this and treat'em special; even more special treatment is used on known directory paths.
 Note if you have changed the '--output-bulk-dir=/tmp/test_bulk' command line option above then this directory file path will be that which was defined.

 - Example of providing file directory path (via built in Bash variable) to named pipe instead
```bash
echo "${HOME}/Pictures" > /tmp/test.pipe
```

 - One *gotcha* the above two examples will only work on the first line that includes a file or directory path of a multi-line write command. This is to avoid the script main script or it's copies from misinterpreting file paths in a text document as paths to take action on. So do **not** do `cat mylist_of_files.txt > /tmp/test.pipe` and expect anything but funky things to happen.

 - Example command to list encrypted files under the bulk output directory.
```bash
ls -hal /tmp/test_bulk/*.gpg
```

 # Step 4

	Quit by writing default quit string to named pipe from another terminal as shown bellow
```bash
echo 'quit' > /tmp/test.pipe
```


 - For bulk lists of files you'll need some form of looping though a target directory and outputting files one by one to named pipe.
```bash
#!/usr/bin/env bash
Var_dir="$1"
Var_pipe="$2"
Var_script_name="${0##*/}"
if [ -p "${Var_pipe}" ]; then
	echo "# Writing to [${Var_pipe}] will begin if [${Var_dir}] is a directory"
else
	echo "## Usage: ${Var_script_name} <dir-path> <pipe-path>"
	echo "# Error: \$2 [${Var_pipe}] is not a pipe?"
	echo "# Exiting with errors" && exit 1
fi
if [ -d "${Var_dir}" ]; then
	for _file_to_check in $(ls -l ${Var_dir} | awk '{print $9}'); do
		if ! [ -z "${_file_to_check}" ] && [ -f "${Var_dir}/${_file_to_check}" ]; then
		## Un-comment bellow and comment above to instead recursively encrypt sub-dirs under
		##  found under ${Var_dir} file path.
#		if ! [ -z "${_file_to_check}" ] && [ -d "${Var_dir}/${_file_to_check}" ]; then
			echo "# File path [${Var_dir}/${_file_to_check}] will be written to [${Var_pipe}] pipe "
			echo "${Var_dir}/${_file_to_check}" > ${Var_pipe}
		else
			echo "# Notice: skipping [${Var_dir}/${_file_to_check}] because it is either blank or not a file."
		fi
	done
	_exit_status=$?
else
	echo "## Usage: ${Var_script_name} <dir-path> <pipe-path>"
	echo "# Error: \$1 [${Var_dir}] not a directory?"
	echo "# Exiting with errors" && exit 1
fi
echo "# Finished: exited loop with [${_exit_status}] exit code."
```

 - Note above sample script will not preform recursive file encryption, ie sub directories are ignored.
 Instead if you wish for a directory to be recursively encrypted then just pass the directory path, however, know that the data will be passed through `tar -zcf - <dir_passed> | <encryption_commands> >> <output_file>`
 command so to decrypt and expand you'll need the following commands to decrypt and expand it out again to a `/tmp` directory
```bash
mkdir -vp /tmp/extraction_dir
cd /tmp/extraction_dir
gpg -o- 011...foo.tgz.gpg | tar zxvf - 
```

-----

	Decrypt output lines by copy/pasting into text reader capable of using related GnuPG privet key and decrypt files from `/tmp/test_bulk/` directory after transfer to verify script operates as expected. Then seek further documentation bellow for answers to the questions script's authors' expect.

### CLO Manual and documentation

	# Recognized command line options, their variables and default values

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
  `--output-rotate-check-requency`    | `Var_log_check_frequency`          | `100`
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

	# Recognized command line options and their optional values

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
  `--output-rotate-check-requency`    | `0-9`               | `'10'` or `'100000'` Number of output file writes till above file size max vs real file size be checked.
  `--output-rotate-actions`           | `a-zA-Z0-9_@,.:~\/` | `'compress-encrypt,remove-old'` or `'encrypted-email,remove-old'` List of actions, separated by commas `,` to take when output file's size and write count reaches above values.
  `--output-rotate-recipient`         | `a-zA-Z0-9_@,.:~\/` | `'admin_name@admin_domain.suffix'` or `'Admin-GPG-Key-ID'` Email address (if using email log rotation options) or GPG public key ID to re-encrypt and or send compressed output files to.
  `--output-parse-command`            | null / disabled    | Disabled to avoid errors during user input parsing when spaces are present in values.
  `--output-bulk-dir`                 | `a-zA-Z0-9_@,.:~\/` | `'/tmp/encrypted_files'` or `"${HOME}/encrypted_files"` Directory path to save recognized files to. Note these files are not rotated but maybe appended to if not careful.
  `--output-bulk-suffix`              | null                | `'.gpg'` or `'.log'` File suffix to append to bulk encrypted files. Note if decrypting then unset to have previously encrypted file suffixes restored.
  `--padding-enable-yn`               | `a-zA-Z`            | `yes` or `no` default `no`. Used to control if following two options are considered as options for modifying read data.
  `--padding-length`                  | `a-zA-Z0-9_@,.:~\/` | `32` or another integer (whole number) default `adaptive` which assumes the same length as line being read through loop.
  `--padding-placement`               | `a-zA-Z0-9_@,.:~\/` | Order of presidence in loop; `append`, `prepend`, `above`, `bellow`
  `--source-var-file`                 | `a-zA-Z0-9_@,.:~\/` | File to source for variables defined in previous table. Or file to save values to, see next two options bellow.
  `--save-options-yn`                 | null                | `yes` or `no` Enable or disable saving options file to `--source-var-file`'s path
  `--save-variables-yn`               | null                | `yes` or `no` Enable or disable saving variables file to `--source-var-file`'s path
  `--license`                         | null                | `null` Prints and exits with `0` script's current license and license of scripts that this project writes.
  `--help` or `-h`                    | null                | `null` Prints and exits with `0` script's currently known command line options and current values.
  `--help=<command>` or `-h=<var>`    | null                | `null` Attempts to search for `-h=value` within host system's help documentation and within main script's detailed documentation.
  `*`                                 | null                | `null` Writes any unrecognized arguments as lines or words that should be written to named pipe if available.

 > Note using `--output-pre-parse-yn` or `--padding-enable-yn` options above will disable the script's ability to recognize file or directory paths and are available for further securing your encrypted server logs.
 **Do Not** use pipes with these options enabled with bulk file writes because that will corrupt your data, ie `cat picture.file > logging.pipe` will not result in happy decryption.
 Instead consider using two pipes; one for logging and one for general usage, and naming them such that they're not ever mixed up.

 > Note using `--source-var-file` CLI option maybe used to assign variable names found in Recognized command line options, their variables and default values table's middle column. This allows for `script_name.sh --source-var-file=/some/path/to/vars` to be used to assign script variables instead of defining them at run-time.
 Additionally this option maybe combined with `--save-options-yn` and `--save-variables-yn` options for saving values to a file instead; but only if the specified file does **not** already exist.

 > Note using unknown commands ie `'some string within quotes' some words outside quotes` will cause the main script to write those
 unrecognized values to the named pipe if/when available. This is for advanced users of the main script that wish to
 have a *header* or set of lines be the first things parsed by the processes of the pipe parser functions or custom script.
 This is only enabled within the script's main function if `--disown-yn` option has also been set to a *yes* like value.

 > Note using `--help` with additional options may access software external to this script but installed on the same host file system.
 Additionally if any scripted documentation exists then that will also be presented to the main script's user.

# Documentation for named pipe encryption scripted logics

	External application usage

 External program | Licence type | Usage within script
------------------|:------------:|--------------------
 `gpg` or `gpg2`  | [GNU GPL v3](https://www.gnu.org/copyleft/gpl.html) | Encryption, decryption and signature verification of data parsed by this project's custom scripts and named pipes.
 `mkdir`          | [GNU GPL v3](https://www.gnu.org/copyleft/gpl.html) | Makes directories if not already present for output files (bulk or otherwise) and log files.
 `cp`             |  | Copies files or directories recursively at times.
 `mutt`           | [GNU GPL v2 or greater](https://dev.mutt.org/hg/mutt/file/084fb086a0e7/COPYRIGHT#l20) | Email client used by this script for log rotation actions involving emailing admins.
 `rm`             |  | Removes files, pipes and old logs.
 `cat`            |  | Concatenates files or strings passed as files to terminal or parsing pipe input commands.
 `echo`           |  | Prints messages to scripts users and used for redirecting messages to script log files.
 `tar`            |  | Compresses parsing log files during log rotation actions if enabled.
 `chown`          |  | Change ownership `<user>:<group>` of files and/or directories.
 `mkfifo`         |  | Make *first-in-first-out* named pipe file. This is one of the *magic* commands used in this script.
 `date`           |  | Print date to script log files or in user messages.
 `bash`           | [GNU GPL v3 or greater](https://www.gnu.org/software/bash/) | Interprets *human readable* source code (this project's scripts) into compatible machine instructions, often used as the command line interpreter for user logins and scripting, rarely used or seen as a programing language.

	Documentation specific to each command above can be found with `<command> --help` or `man <command>`

 Bash commands | Usage within script
---------------|--------------------
 `touch`       | Make or remake files, such as when rotating logs just prior to restarting permissions and ownership again.
 `trap`        | Remove pipes on exiting reader and logs on exiting main script if above `--log-auto-delete-yn=<y/n>` option is set to a `yes` value.
 `read`        | Read input from users, such as prompts to continue if main script's above `--debug-level=<n>` option is set high enough.
 `mapfile`     | Read multiple lines of input from a named pipe into an array such that the data maybe reinserted into parsing commands.
 `set`         | Turn on and off Bash history logging to prevent commands such as `echo "supper secret string" | gpg -r myself@host.domain >> mysuppersecrits.gpg` from appearing in in `~/.bash_history` file.
 `let`         | Set numerical values to internal variables used to keep arrays' indexes ordered in looped Bash logic.
 `disown`      | Disown the PID of last function (or script) called allows for backgrounding the processes used to listen to named pipes and output to log files and bulk directory.
 `break`       | Breaks out of looped Bash logics such that the parent process can either exit or restart listening again.

	Documentation specific to each command above can be found with `help <command>` and/or `man <command>`

 Bash switch, loops, & operators  | Help command   | Usage within script
----------------------------------|----------------|--------------------
 `&&` and `||`                    | `man operator` | Are *short-handed* tests for success or failure, known as "and"s & "or"s, ie `first command && second command` vs `first command || second command` will operate differently based upon `first command`'s exit status.
 `case`...`in`...`esac`           | `help case`    | Are used to test a variable's value against many possible outcomes, ie `case "$(date +%u)" in 1) echo "Ug, mondays";; 3) echo "hump day keep it up!";; 7) echo "get some sun";; *) echo "$(date +%u)";; esac`
 `for`...`do`...`done`            | `help for`     | Used until looping through command line options of main script finishes resetting any script variables over written at the command line.
 `if`...`then`...`fi`             | `help if`      | Are used for if *something* equals another *something*, ie numerical values and file's existence or string equivalency with another string, ie `if [ "1" = "0" ]; then echo "Mathematical believes shattered" else echo "Math still works"; fi`
 `until`...`do`...`done`          | `help until`   | Preform actions until test statements return true, ie `until [ "0" = "1" ]; do echo "# Mathematical believes assured; 0 does not equal 1... yet..." && sleep 1; done`
 `while`...`do`...`done`          | `help while`   | Preform actions while test statements do not return false, ie `while ! [ "0" = "1" ]; do echo "# Mathematical believes assured; 0 does not equal 1... yet..." && sleep 1; done`
 `[ "`...`" =`or`!= "`...`" ]`    | `man operator` | Often seen in use with `-gt` in place of `=` or `-f` or `-p` preceding a variable, this is used in combination with `if`, `until` and others to quickly test equivalency or if a file or pipe is present.
 `first_command | second_command` | `man pipe`    | for anonymous piping output of `first_command` into input of `second_command`


 Bash variable & array syntax                   | Usage within script
------------------------------------------------|--------------------
 `var=value`                                    | Assign `value` to variable named `var`. Often seen assigning directory or file paths or other values to descriptive variable names.
 `echo "${var//,/ }"`                           | Expand variable named `var` replacing every comma `,` with a space ` `. Usually found in debugging messages and within loops such as `for _word in ${var//,/ }; do echo "# Read word ${_word} in ${var} list"; done` to separate words in a `,` separate list.
 `arr=( "value1" "value two" "3" )`             | Assign `value1` and `value two` to array named `arr`. Arrays are a whole'nuther can'o'worms but are one of the *magic* things that makes this script tick. Note above tricks of replacing a target character with another also work with arrays.
 `echo "${arr[@]}"`                             | Expand all indexes in array named `arr`. More often you'll find this written as `until [ "${#arr[@]}" = "${_count}" ] || [ "${arr[${_count}]}" = "${_quit_line}" ]; do echo "# Doing stuff to ${arr[${_count}]}" && let _count++; done` to loop through an indexed array much like a `for` loop would loop over a list.
 `echo "${arr[@]:1}"`                           | Expand all indexes in array `arr` after index `1`. This can be used similarly to the looping example above but we can get fancy. Here's is a tip on how to *dump* everything in above array after `${_count}`+`1`
 `_arr_remiander=( ${arr[$((${_count}+1))]}  )` | When you see how above loop has evolved (hint, check `Senerio one` within this document) ya might just chuckle at the work-around.
 `command <<<${var}`                            | for one-way redirection of `${var}`'s value into `command`'s input

 Bash internal variables | Usage within script
-------------------------|--------------------
 `$?`                    | Saves exit of previous command to a variable, ie `touch fire; _exit_var=$?; echo "Exit status [${_exit_var}] for last command"`
 `var=${PIPESTATUS[@]}`  | to capture exit statuses of multi piped or redirected commands
 `$!`                    | Saves PID of last command to a variable for use with `unset` command when backgrounding processes or script.

 # Bash function assignment and calling syntax:

 - assign a function named `func`
```bash
func(){
  var="${1:-value}"
  echo "${var}"
}
```

 - call above function named `func`
```bash
func "yo"
```

 - manipulating via assigning function `func` with argument `yo` to variable `func_var`
```bash
func_var=$(func "yo")
```

 # Bash write file method: 

 - Write to `/dir/file.name` text until `EOF` is found on it's own line.
```bash
cat > "/dir/file.name" <<EOF
some text with "EOF" on a new line to end statement
some variables with "\" and some without depending
upon if they should be expanded on write or on re-read/execution
EOF
```

## Story time

	Scenario one:
	Logging output -> Pipe (encryption) input -> Encrypted log output -> Rotate using encrypted email and compression

	This scenario was written with the following link's questions as it's inspiration [Serverfault - Asymmetric encrypt server logs that end up with sensitive data written to them](http://serverfault.com/questions/89126/asymmetrically-encrypted-filesystem)

	Quote begin

 > I'm dealing with some data that's governed by specific regulations and that must be handled in a specific manner.

 > I'm finding that this data ends up in some of my log files as a result of the system operating as intended. I'd like to find a way to log messages on the server that receives that date, but to do so in such a way that the data is encrypted as it's written to disk and may not be decrypted by that same server.

 > ...

	Quote cut-off

-----

	As of the time of writing this document the authors of this project and the author of the above question have not found a suitable solution aside from the following command lime options being used on the project's script that is...

```bash
/script/path/script_name.sh --copy-save-yn='yes'\
 --copy-save-name="/jailer_scripts/website_host/Web_log_encrypter.sh"\
 --copy-save-ownership="notwwwuser:notwwwgroup"\
 --copy-save-permissions='100'\
 --debug-level='6'\
 --listener-quit-string='sOmErAnDoM_sTrInG_wItHoUt_SpAcEs_tHaT_iS_nOt_NoRmAlY_rEaD'\
 --log-level='0'\
 --named-pipe-name="/jailed_servers/website_host/var/log/www/access.log.pipe"\
 --named-pipe-ownership='notwwwuser:wwwgroup'\
 --named-pipe-permissions='420'\
 --output-parse-name="/jailed_logs/website_host/www_access.gpg"\
 --output-parse-recipient="user@host.domain"\
 --output-rotate-actions='compress-encrypt,remove-old'\
 --output-rotate-check-requency='25000'\
 --output-rotate-max-bites='8388608'\
 --output-rotate-recipient="user@host.domain"\
 --output-rotate-yn='yes'\
 --output-save-yn='yes'\
 --disown-yn='yes' --help
```

	Note, if you've setup the web server within a chroot (as is assumed by example values) then future attackers will not see your server's log data from previous connections, instead they'll see a named pipe that they can not write to unless they're the same `group` as that that preforms normal log writes. Nor will future attackers gain access to the encrypted logs until they've broken out of the server's jail. Even then the encrypted logs should be useless to them so long as the private key is **not** also stored on the host.

 # Summery of logging data flow

  1. Client interacts with server such that logs are generated. Note, modify the server or daemon to use the same file path as defined by `--named-pipe-name` option for output of it's logs.

  2. Written data to named pipe is read by Bash loops contained in customized script copy defined by `--copy-save-name` option.

  3. Using public key defined by `--output-parse-recipient` option, every data block read by the script copy will be encrypted. Note this script is capable of reading multi-line writes to it's named pipe in a single operation, thus if your logging daemon or server writes multiple lines per client interaction then the entire write action is captured up to a few thousand lines at a time.

  4. The encrypted data is then saved (appended) to file defined by `--output-parse-name` option and the Bash loop checks it's internal write count against the count defined by `--output-rotate-check-frequency` option and usually restarts processes that listen to named pipe for more writes.

 - - If the internal write count matches that of `--output-rotate-check-frequency` or is greater then the `--output-rotate-max-bites` value is used to check the encrypted log file size.

 - - If the encrypted log file size matches that of `--output-rotate-max-bites` or is greater then the actions defined by `--output-rotate-actions` option is considered.

 > Note the more actions listed in the `--output-rotate-actions` option the longer that the named pipe will be blocked for writing to.

 > Note if your server has `mutt` installed and configured to send emails you may wish to use the following instead. Additionally when emailed log rotation is enabled it will be the address defined by `--output-rotate-recipient` option that receives attached encrypted logs.

 - Enable emailed log rotation instead.
```bash
--output-rotate-actions='encrypted-email,remove-old'
```

 - - If no line matches `--listener-quit-string` option then reading named pipe for write actions from server or logging daemon is resumed and step `1` above starts again.

	What does the other above options do?

 - Enable saving script copy saving operation, all customized options are then saved by the main script to the script copy saved to the path defined by `--copy-save-name` option.
```bash
--copy-save-yn='yes'
```

 - The `<user>:<group>` allowed to run script copy. This should be a **non**-root and/or **non**-sudo user group combo because it'll be parsing logs generated by the web server and thus unknown clients with unknown motives.
```bash
--copy-save-ownership="notwwwuser:notwwwgroup"
```

 - Set execute permissions for script owner only because, once written it should not be modifiable by any user other than a root/sudo user capable of running `su -u notwwuser -c "/jailer_scripts/website_host/Web_log_encrypter.sh"`.
```bash
--copy-save-permissions='100'
```

 - Set debug levels really high so that all saving script operations are shown. Note setting this level equal to or higher than `3` will cause the main script to prompt to continue, this is normal and a requires a `yes` like response to continue.
```bash
--debug-level='6'
```

 - Set log level to lowest value possible value to avoid writing anything unintentional to host system. If instead a log of every message passed is desired then use n+1, where `n` is the level chosen above with `--debug-level` option, ei `7` to capture every message from above example to a log file.
```bash
--log-level='0'
```

 - The `User` allowed to read from above pipe file name and the `Group` allowed to write to named pipe file. Tip the owner in bellow should be the same as the script copy's owner and the group should be the same as one that the chrooted web server's logger is apart of. 
```bash
--named-pipe-ownership='notwwwuser:wwwgroup'
```

 - Read and write permissions that support the above ownership split; that would be readable by the script copy's owner, writable by logging group, and nothing more.
```bash
--named-pipe-permissions='420'
```

 > The combination of these above ownership and permission options **must** be correct for the target server or either; the logging service will be unable to write to the named pipe file, or the script copy will be unable to read from the named pipe.

 > Tip: `ls -hal /path/to/standard.log` will reveal the `user` and `group` that the target server currently uses, make use of the old log file's `group`'s permissions for defining the above command line `wwwgroup` value.

 - Cause script, once written, to be run in the background via (internally called) `disown` command. This option is the last in above example options that will be written to the script copy.
```bash
--disown-yn='yes'
```

 - Cause main script to exit after printing set options and without writing custom script. Remove this option after reviewing that options are set for your needs and the script will be saved and started prior to the main script exiting.
```bash
--help
```

	Last steps are to configure the target server or log daemon to start writing to the above named pipe instead of their default locations; note if using a log daemon such as `rsyslog` then for testing you may wish to have logs written to both default location and new named pipe location. For servers such as Nginx and other web servers be sure to check the documentation for "Log Rotation" for how to properly restart the related server's logging. Next sets of links are what this document's author could find for proper server restart signals; hint nginx is easiest.

 - Web Server - [Nginx log rotation documentation](https://www.nginx.com/resources/wiki/start/topics/examples/logrotation/)
 Modify virtual host log access and log error lines to point to related named pipes, then use the following `kill`
 signal to restart the server's logging. Note `master.nginx.pid` should contain the full file path if not within
 Nginx's configuration directory.
```bash
kill -USR1 $(cat master.nginx.pid)
```

 - Web Server - [Apache 2.4 log rotation documentation](https://httpd.apache.org/docs/2.4/programs/rotatelogs.html)

 -Log Daemon/Server - [Rsyslog v8 `ompipe` plug-in documentation](http://www.rsyslog.com/doc/v8-stable/configuration/modules/ompipe.html)

	# Automation of named pipe log encryption for nginx

 - Add the following line just before `daemon-start-stop` line under web server's start action; on Debian based systems this is usually under `/etc/init.d/nginx` file path.
```bash
/jailer_scripts/website_host/Web_log_encrypter.sh
```

 - Add the following just after `daemon-start-stop` line under web server's stop action.
```bash
echo 'sOmErAnDoM_sTrInG_wItHoUt_SpAcEs_tHaT_iS_nOt_NoRmAlY_rEaD' > /jailed_servers/website_host/var/log/www/access.log.pipe
```

 - Test that all still works as desired by restarting the server with the following series of commands.
```bash
/etc/init.d/nginx stop &&\
 /etc/init.d/nginx start &&\
 tail -f /jailed_logs/website_host/www_access.gpg
```
	After clients reconnect you'll see the ~.gpg logs start filling up, use Ctrl^c keyboard short-cut to exit tail command and wait for emails to start rolling into the log rotation email's inbox.

	Now at some point in the future you or your web-admin will need access to the logs, first decrypt the rolled logs with the second key used to encrypt them and then run have your web-admin run something like the following to have encrypted data *chunks* shoved through decryption commands.

```bash
#!/usr/bin/env bash
## The following variable should be your encrypted file that has been appended to.
Var_input_file="${1?No input file to read?}"
## The following variable should be your named pipe for decrypting
Var_output_file="${2:-/tmp/out.log}"
## You may assign the above at run-time using the following example call to this script
#	script_name.sh "/path/to/input" "/path/to/output"
Var_search_output="$3"
Func_spoon_feed_pipe_decryption(){
	_input="${@?No input file or strings to parse}"
	_end_of_line=''
	## If input is a file then use standard redirection to mapfile command.
	##  Else use variable as file redirection trick to get mapfile to build an array from input.
	if [ -f "${_input}" ]; then
		mapfile -t _arr_input < "${_input}"
	else
		mapfile -t _arr_input <<<"${_input}"
	fi
	## Initialize internal count that is either reset or added to in the following loop.
	let _count=0
	until [ "${_count}" = "${#_arr_input[@]}" ]; do
		## If current index in array equals ${_end_of_line} value then append end of line
		##  to ${_arr_to_parse[@]} and reset ${_arr_input} to include everything not parsed
		##  and reset the counter. Else we should append the current index to ${_arr_to_parse}
		##  and loop again until the count and array amount are equal.
		if [ "${_end_of_line}" = "${_arr_input[${_count}]}" ]; then
			_arr_to_parse+=( "${_arr_input[${_count}]}" )
			_arr_input=( "${_arr_input[@]:$((${_count}+1))}" )
			let _count=0
		else
			_arr_to_parse+=( "${_arr_input[${_count}]}" )
			let _count++
		fi
	done
	unset _count
	## If above array has some values to parse then start feeding parsing
	##  function with an array of arrays, one array at a time.
	if ! [ -z "${_arr_to_parse[@]}" ]; then
		let _count=0
		until [ "${_count}" = "${#_arr_to_parse[@]}" ]; do
			Do_stuff_with_lines "${_arr_to_parse[${_count}]}"
			let _count++
		done
		unset _count
	fi
}
Do_stuff_with_lines(){
	_enc_input=( "$@" )
	_decryption_command="$(which gpg) -d"
	_search_command="$(which grep) -E \"${Var_search_output}\""
	## If using a named pipe to preform decryption then push encrypted array through
	##   named pipe's input for use, if output is a file then use above decrypting command
	##  and append to the file. Else output decryption to terminal.
	if [ -p "${Var_output_file}" ]; then
		cat <<<"${_enc_input[@]}" > ${Var_output_file}
	elif [ -f "${Var_output_file}" ]; then
		if [ -z "${#Var_search_output}" ]; then
			cat <<<"${_enc_input[@]}" | ${_decryption_command} >> ${Var_output_file}
		else
			cat <<<"${_enc_input[@]}" | ${_decryption_command} | ${_search_command} >> ${Var_output_file}
		fi
	else
		if [ -z "${#Var_search_output}" ]; then
			cat <<<"${_enc_input[@]}" | ${_decryption_command}
		else
			cat <<<"${_enc_input[@]}" | ${_decryption_command} | ${_search_command}
		fi
	fi
}
Main_func(){
	Func_spoon_feed_pipe_decryption "${Var_input_file}"
}
Main_func
```

	Above should (for medium to small log files) pull each encrypted section within a previously appended to encrypted log file out into an array of arrays, then push those arrays one by one through either; decryption command & out to clear text file, or, if a pipe is detected as above script's output path then the compound array will dump there instead and it'll be up to the listening pipe's script to output to it's destination. This allows, with proper custom settings, for piping through search parameters that save only relevant or requested information to a clear text file while ignoring everything else.

-----

	Scenario two:
	Logging output -> Pipe (encryption) input -> Encryption -> Pipe (decryption) input -> Log output (rotate) -> Encrypted email

-----

	Let's say you're web server's threat modal is different than that described by `Scenario one` and your
 server still needs to respond to threats in near real time via Fail2Ban but you still don't wish to make it easy
 on future attackers to access your server's logs. In the following example we'll be setting up a pipe to pipe
 encryption of logs such that they only exist in plan text long enough for monitoring software to do it's thing.

 - Generate server only key pare on host file system, not the chrooted web server's file system
```bash
gpg --homedir /tmp/.gnupg --gen-key
# Follow the prompts and set solid passphrase.
```

 - Export the server's revocation cert. Note you'll want to move this file off server if generating keys on the same server that will also service clients because when your server becomes compromised this cert will allow you to revoke these keys if they're ever uploaded to a key server.
```bash
gpg --homedir /tmp/.gnupg --gen-revoke --output /tmp/.gnupg/server_gpg_revoke.asci
```

 - Export the server's public key for importation within host server file system.
```bash
gpg --homedir /tmp/.gnupg --export --output /tmp/.gnupg/server_public.key
```

 - Export the server's privet key, back this up on another device using same transmission methods as transmitting revoke cert. But we'll also need to import this key to the server's host file system so don't shred it just yet.
```bash
gpg --homedir /tmp/.gnupg --export-secret-keys --output /tmp/.gnupg/server_secret.key
```

 - Import web server's private key to host's keyring, this will also import the public key so login to the user account you will have running the pipe listening scripts prior to the following command; ie the one defined by `--copy-save-ownership="notwwwuser:notwwwgroup"` command line option in next section.
```bash
gpg --import /tmp/.gnupg/server_secret.key
```

 - Or using `su` for `notwwwuser` user (the same as owner of parsing pipe listeners) command key import without having to login that user.
```bash
su notwwwuser -c "gpg --import /tmp/.gnupg/server_secret.key"
```

 - Once you have backed up the privet key and revoke cert to another device, remove the temp home directory GnuPG has been using for key generation.
```bash
rm -Irf /tmp/.gnupg
```

	# Now to write some scripts to different directories using the main script of this project.

	Be sure to pay attention to the differences in command line options used and not used between runs.

 - First is a pipe to pipe encryption named pipe listening script
```bash
/script/path/script_name.sh --copy-save-yn='yes'\
 --copy-save-name="/jailer_scripts/website_host/Web_log_pipe_to_pipe_encrypter.sh"\
 --copy-save-ownership="notwwwuser:notwwwgroup"\
 --copy-save-permissions='100'\
 --debug-level='6'\
 --listener-quit-string='sOmE_rAnDoM_sTrInG_wItHoUt_SpAcEs_tHaT_iS_nOt_NoRmAlY_rEaD'\
 --log-level='0'\
 --named-pipe-name="/jailed_servers/website_host/var/log/www/access.log.pipe"\
 --named-pipe-ownership='notwwwuser:wwwgroup'\
 --named-pipe-permissions='420'\
 --output-parse-name="/jailed_logs/website_host/www_access.pipe"\
 --output-parse-recipient="user@host.domain"\
 --output-rotate-yn='no'\
 --output-save-yn='yes'\
 --disown-yn='yes' --help
```

 - Second pipe will decrypt (with a little modification) anything written to it's listening pipe, and output to a log file that fail2ban and other log monitoring services may read. Note the log rotation settings as stated may fill your email's inbox but at least your logs only live in plan text for a short time on the public server.
```bash
/script/path/script_name.sh --copy-save-yn='yes'\
 --copy-save-name="/jailer_scripts/website_host/Web_log_pipe_to_pipe_decrypter.sh"\
 --copy-save-ownership="notwwwuser:notwwwgroup"\
 --copy-save-permissions='100'\
 --debug-level='6'\
 --listener-quit-string='SoMe_rAnDoM_sTrInG_wItHoUt_SpAcEs_tHaT_iS_nOt_NoRmAlY_rEaD'\
 --log-level='0'\
 --named-pipe-name="/jailed_logs/website_host/www_access.pipe"\
 --named-pipe-ownership='notwwwuser:wwwgroup'\
 --named-pipe-permissions='420'\
 --output-parse-name="/jailed_logs/website_host/www_access.log"\
 --output-parse-recipient="user@host.domain"\
 --output-rotate-actions='compress-encrypt,remove-old'\
 --output-rotate-check-requency='250'\
 --output-rotate-max-bites='8046'\
 --output-rotate-recipient="user@host.domain"\
 --output-rotate-yn='yes'\
 --output-save-yn='yes'\
 --disown-yn='yes' --help
```

 - Modify the second pipe listener's `Var_parsing_command` variable command to decrypt instead of encrypt
```bash
Var_parsing_command="gpg --decrypt"
```

 - or for specific user with their own key ring
```bash
Var_parsing_command='su notwwwuser -c "gpg --decrypt"'
```

	Automation is similar to `Scenario one`, however, order of operation is very important! The encryption pipe to pipe listener should be started **after** the decryption pipe listening script. Shutting down order is just as important as start order; stop encryption before stopping decryption to avoid writing logs to plan text file under the same name as named pipe.

 - Start stop lines for decryption pipe to log file.
```bash
# Start decryption pipe listener
/jailer_scripts/website_host/Web_log_pipe_to_pipe_decrypter.sh
# Stop decryption pipe listener
echo 'SoMe_rAnDoM_sTrInG_wItHoUt_SpAcEs_tHaT_iS_nOt_NoRmAlY_rEaD' > /jailed_logs/website_host/www_access.pipe
```

 - Start stop lines for encryption pipe to pipe files.
```bash
# Start encryption pipe listener
/jailer_scripts/website_host/Web_log_pipe_to_pipe_encrypter.sh
# Stop decryption pipe listener
echo 'sOmE_rAnDoM_sTrInG_wItHoUt_SpAcEs_tHaT_iS_nOt_NoRmAlY_rEaD' > /jailed_servers/website_host/var/log/www/access.log.pipe
```

	# Notes on differences between written script's options used above.

	 - Input -> output first script options
```bash
 --named-pipe-name="/jailed_servers/website_host/var/log/www/access.log.pipe"\
 --output-parse-name="/jailed_logs/website_host/www_access.pipe"\
```

	 - Input -> output second script options
```bash
 --named-pipe-name="/jailed_logs/website_host/www_access.pipe"\
 --output-parse-name="/jailed_logs/website_host/www_access.log"\
```

	Above outlines taking input written by web server logging service on pipe `/jailed_servers/website_host/var/log/www/access.log.pipe` putting through encryption before outputting to pipe `/jailed_logs/website_host/www_access.pipe` file that the second script is listening for lines to parse for decryption. Data is passed through the second script's decryption loops and output in clear text file under `/jailed_logs/website_host/www_access.log` path.

 Now some maybe wondering what the benefit of this type of set up is. Simply if the second script dies then the first script will just make an encrypted log under the same file path as the second script's listening pipe; much like in `Scenario one`'s usage example. And if at a latter time you wish to move decryption to a separate physical server, ie over an VPN or SSH connection, then you'll only need to move the second script and private key to begin setting up pipe to pipe encrypted (doubly at that point) centralized log proxy decrypter... the authors will cover this in another scenario further on.

	 - Input -> output pre-parsing and log rotation options in the first script
```bash
 --output-pre-parse-yn='yes'\
 --output-rotate-yn='no'\
 --output-save-yn='yes'\
```

	 - Input -> output pre-parsing and log rotation options in the second script
```bash
 --output-pre-parse-yn='no'\
 --output-rotate-actions='compress-encrypt,remove-old'\
 --output-rotate-check-requency='250'\
 --output-rotate-max-bites='8046'\
 --output-rotate-recipient="user@host.domain"\
 --output-rotate-yn='yes'\
 --output-save-yn='yes'\
```

	Above we're disabling the log rotation for the first script because it's *log* file is really the listening pipe of the second script, thus we really don't want the first script trying to preform log rotate actions on a named pipe. And we're setting low values for the log rotation of the second script to keep clear text versions of or logs from kicking around on the host's file system for any longer than they need to be, however, this will cause your web or sys admin's email to become quite full unless they've setup some form of auto retrieval script to handle the traffic automatically. This is a balance your team must strike between threat modal vs administrating the log shuffle over-head described. The `--output-pre-parse-yn='`*yes/no*`'` option differences between first and second scripts are; in the first script we set this to `yes` to restrict what input is read and encrypted, and in the second script to prevent GnuPG decryption from failing to decrypt we set this to `no` and read raw lines in.

-----

	Scenario three:
	Save custom script copy over SSH -> Target host's Logging output -> Pipe (encryption) input -> Encrypted Log output -> Rotate encrypt and email removing old

-----

	# Write customized pipe listener script over SSH 

	 - These are the options used from `Scenario one` so edit as needed and be aware that file paths will be relative to that of the SSH server being logged into. Note we're only saving these variables to make the final command easier to read.
```bash
Script_options="--copy-save-yn='yes' --copy-save-name='/jailer_scripts/website_host/Web_log_encrypter.sh' --copy-save-ownership='notwwwuser:notwwwgroup' --copy-save-permissions='100' --debug-level='6' --listener-quit-string='sOmErAnDoM_sTrInG_wItHoUt_SpAcEs_tHaT_iS_nOt_NoRmAlY_rEaD' --log-level='0' --named-pipe-name='/jailed_servers/website_host/var/log/www/access.log.pipe' --named-pipe-ownership='notwwwuser:wwwgroup' --named-pipe-permissions='420' --output-parse-name='/jailed_logs/website_host/www_access.gpg' --output-parse-recipient='user@host.domain' --output-pre-parse-yn='yes' --output-rotate-actions='compress-encrypt,remove-old' --output-rotate-check-requency='25000' --output-rotate-max-bites='8388608' --output-rotate-recipient='user@host.domain' --output-rotate-yn='yes' --output-save-yn='yes' --disown-yn='yes'"
```

	 - Run the main script from host using redirection and assigned variables.
```bash
ssh user@remote "$(</path/to/main/script.sh ${Script_options})"
```

	 - Restart named pipe listener script over SSH now that it is local to and configured for the target's file system.
```bash
## Send quit string to named pipe
ssh user@remote "echo 'sOmErAnDoM_sTrInG_wItHoUt_SpAcEs_tHaT_iS_nOt_NoRmAlY_rEaD' > /jailed_servers/website_host/var/log/www/access.log.pipe"
## Start script over SSH
ssh user@remote "/jailer_scripts/website_host/Web_log_encrypter.sh"
```

	The above steps maybe repeated for any other servers (or same server different log) that require setup of log encryption, however, if attempting to automate this for a large cluster it is advisable to define separate quit strings for each remote host. Bellow is a quick example script of what the authors would do to setup multiple remote hosts in quick succession that each only need one template written.

```bash
#!/usr/bin/env bash
### Define some variables for latter use.
## Comma separated list of SSH remote hosts to setup
Remote_hosts="webadmin@webhost:22,sqladmin@sqlhost:9823"
Remote_host_shell="/bin/bash"
##  note the user names from above will be used for script and pipe names
## Character lenght of quit string that will be made for each host
Quit_string_length='32'
## Log file path to save configuration to local file system
Log_file_path='/tmp/ssh_remote_encrypted_setup.log'
## Path to main script on host
Main_script_path='/path/to/writer_script.sh'
Script_save_dir='/usr/local/sbin'
Script_save_output_dir='/var/log'
Script_save_parse_recipient='user@host.suffix'
Script_save_rotate_recipient='user@host.suffix'
### Run commands in a loop with header and tail printed to above log file.
echo '# <Host> | <Quit string>' | tee -a "${Log_file_path}"
echo '#--------|--------------' | tee -a "${Log_file_path}"
for _host in ${Remote_hosts//,/ }; do
	_random_quit_string=$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c${Quit_string_length:-32})
	_host_name="${_host%@*}"
	Script_options="--copy-save-yn='yes' --copy-save-name='${Script_save_dir}/${_host_name}_log_encrypter.sh' --copy-save-ownership='${_host_name}:${_host_name}' --copy-save-permissions='100' --debug-level='6' --listener-quit-string='${_random_quit_string}' --log-level='0' --named-pipe-name='${Script_save_output_dir}/${_host_name}_access.log.pipe' --named-pipe-ownership='${_host_name}:${_host_name}' --named-pipe-permissions='420' --output-parse-name='${Script_save_output_dir}/${_host_name}_access.gpg' --output-parse-recipient='${Script_save_parse_recipient}' --output-pre-parse-yn='yes' --output-rotate-actions='compress-encrypt,remove-old' --output-rotate-check-requency='25000' --output-rotate-max-bites='8388608' --output-rotate-recipient='${Script_save_rotate_recipient}' --output-rotate-yn='yes' --output-save-yn='yes' --disown-yn='yes'"
	if [[ "${Script_save_parse_recipient}" == "${Script_save_rotate_recipient}" ]]; then
		ssh ${_host} -s ${Remote_host_shell} "gpg --import ${Script_save_parse_recipient} --recv-keys https://key-server.domain"
	else
		ssh ${_host} -s ${Remote_host_shell} "gpg --import ${Script_save_parse_recipient} --recv-keys https://key-server.domain"
		ssh ${_host} -s ${Remote_host_shell} "gpg --import ${Script_save_rotate_recipient} --recv-keys https://key-server.domain"
	fi

	ssh ${_host} -s ${Remote_host_shell} "$(<${Main_script_path} ${Script_options})"
	ssh ${_host} "echo '${_random_quit_string}' > ${Script_save_output_dir}/${_host_name}_access.log.pipe"
	echo "# ${_host} | ${_random_quit_string}" | tee -a "${Log_file_path}"
done
echo "## Finished above at $(date)" | tee -a "${Log_file_path}"
```

 # Important variables to modify in above example script

 - List 'remote user' `@` 'remote host' `:` 'listening server port' separated by `,` of servers that should receive a script copy for encrypting logs and files via named pipe
```bash
Remote_hosts="webadmin@webhost:22,sqladmin@sqlhost:9823"
```

 - Relative path on target server to Bash shell, the following default should work for most systems without modification.
```bash
Remote_host_shell="/bin/bash"
```

 - Generate random characters of given numerical length for use in making custom quit strings for each named pipe listener script that will be written. Note this will be logged on the relative local file system for all servers and each target should receive their own randomized quit string written to their script copy.
```bash
Quit_string_length='32'
```

 - Relative local file path to save the above script's logs out to. Note this maybe an encrypting pipe path on your local file system too if you wish to keep quit strings and servers setup private.
```bash
Log_file_path='/tmp/ssh_remote_encrypted_setup.log'
```

 - Path to main script downloaded (`clone`d) on local host, ei not on your target servers. If this is not set properly then the script's `ssh ${_host} -s ${Remote_host_shell} "$(<${Main_script_path} ${Script_options})"` command will miss-fire.
```bash
Main_script_path='/path/to/writer_script.sh'
```
 - Path relative to each target host's file system; target directory path to save script copy to.
```bash
Script_save_dir='/usr/local/sbin'
```
 - Path relative to each target host's file system; target directory to save listening script copy's output to 
```bash
Script_save_output_dir='/var/log'
```
 - First pub key's email address to import onto each target host and what each target host will use for line-by-line and recognized file type encryption.
```bash
Script_save_parse_recipient='user@host.suffix'
```
 - Second pub key's email address to import onto each target host and what each target host will use for log rotation encryption and emailing compressed logs actions.
```bash
Script_save_rotate_recipient='user@host.suffix'
```

	Above will save an encrypting script to each host defined by the `Remote_hosts` variable and import the gpg keys defined by `Script_save_parse_recipient and `Script_save_rotate_recipient variables to each of them. The scripts them selves will each have variable names for pipes, output files, and listening script by parsing the individual target host. Because the script copies are much smaller than the main script of this project, after running above, coping and modifying the individual target host's scripts on a case by case basis is the suggested next course of action.

	Bellow is a run-down of what changes per target host and what will remain constant.

 - Variable defined options that change per-host assigned to each script copy
```bash
--copy-save-name='${Script_save_dir}/${_host_name}_log_encrypter.sh'
--named-pipe-name='${Script_save_output_dir}/${_host_name}_access.log.pipe'
--named-pipe-ownership='${_host_name}:${_host_name}'
--copy-save-ownership='${_host_name}:${_host_name}'
--output-parse-name='${Script_save_output_dir}/${_host_name}_access.gpg'
```

 - Variable defined options that do not change per-host assigned to each script copy
```bash
--output-parse-recipient='${Script_save_parse_recipient}'
--output-rotate-recipient='${Script_save_rotate_recipient}'
```

 - List of options that do not change per-host assigned to each script copy
```bash
--copy-save-yn='yes'
--copy-save-permissions='100'
--debug-level='6'
--log-level='0'
--named-pipe-permissions='420'
--output-pre-parse-yn='yes'
--output-rotate-actions='compress-encrypt,remove-old'
--output-rotate-check-requency='25000'
--output-rotate-max-bites='8388608'
--output-rotate-yn='yes'
--output-save-yn='yes'
--disown-yn='yes'
```

	After modifying and running the above script you should have a log file on the local host of actions preformed as defined by `Log_file_path` variable that saves each script copy's quit string as defined by the following option used in above `for` loop
```bash
--listener-quit-string='${_random_quit_string}'
```

 - Sample output log file
```bash
# <Host> | <Quit string>
#--------|--------------
# webadmin@webhost | somerandomstring
# sqladmin@sqlhost | someotherrandomstring
## Finished above at Day Month Day# hh:mm:ss Zone Year 
```


-----


### Sources of info

[Grab last command used on Bash](http://stackoverflow.com/a/9502698)

[Methods of generating random strings of specified length](https://gist.github.com/earthgecko/3089509)

[Nginx log rotation documentation](https://www.nginx.com/resources/wiki/start/topics/examples/logrotation/)

[Appache2.4 log rotation documentation](https://httpd.apache.org/docs/2.4/programs/rotatelogs.html)

[Stack Exchange - Rsyslog to fifo answered](http://unix.stackexchange.com/questions/134896/how-to-redirect-logs-to-a-fifo-device)

[Server Fault - Run local script over SSH to remote](http://serverfault.com/a/595256)

[Fair Source License - Home page](https://fair.io/)

[Fair License](http://fairlicense.org/)

[Wiki - Derivative works defined](https://en.wikipedia.org/wiki/Derivative_work)

### Others seeking tools similar to this

[Security Stac Exchange - Write only one way encrypted directory](http://security.stackexchange.com/questions/6218/is-there-any-asymmetrically-encrypted-file-system)
 Currently only one tool offered seems to fit their requirements but accepted answer doesn't provide solution; just reasons as to why there's no solution.

[Serverfault - Asymmetric encrypt server logs that end up with sensitive data written to them](http://serverfault.com/questions/89126/asymmetrically-encrypted-filesystem)
 No solutions posted!

[Stack Overflow - Android asymmetric encryption line by line](http://stackoverflow.com/questions/29131427/efficient-asymmetric-log-encryption-in-android/29134101)
 No solutions posted!

### Similar tools & guides

[Guide to asymmetric encryption with OpenSSL](https://www.devco.net/archives/2006/02/13/public_-_private_key_encryption_using_openssl.php)
 Seems pretty snazzy but authors of this script have not tested it yet.

### Licensing & Usage agreement

 + Main script and the script's it writes are under the following license.

 > ```bash
Paranoid_Pipes, maker of named pipe parsing template Bash scripts.
 Copyright (C) 2016 S0AndS0

This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU Affero General Public License as
 published by the Free Software Foundation, version 3 of the
 License.

You should have received a copy of the GNU Afferno General Public License
 along with this program. If not, see <http://www.gnu.org/licenses/>.

Contact authors via email <strangerthanbland@gmail.com>
Acceptable GPG email public key for above <0x6e4c46da15b22310> 

Direct link to GNU AGPL v3 <https://www.gnu.org/licenses/agpl-3.0.html>
```

