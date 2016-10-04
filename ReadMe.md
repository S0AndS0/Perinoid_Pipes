# Quick start (see full guides under the `Documentation/` directory)

## Step 1; 

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

## Step(s) 2; 

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

## Step(s) 3

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

## Step 4

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
