#### Scenario three:

 > Save custom script copy over SSH -> Target host's Logging output -> Pipe (encryption) input -> Encrypted Log output -> Rotate encrypt and email removing old

-----

#### Write customized pipe listener script over SSH 

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

 > The above steps maybe repeated for any other servers (or same server different log) that require setup of log encryption, however, if attempting to automate this for a large cluster it is advisable to define separate quit strings for each remote host. Bellow is a quick example script of what the authors would do to setup multiple remote hosts in quick succession that each only need one template written.

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

#### Important variables to modify in above example script

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

 > Above will save an encrypting script to each host defined by the `Remote_hosts` variable and import the gpg keys defined by `Script_save_parse_recipient and `Script_save_rotate_recipient variables to each of them. The scripts them selves will each have variable names for pipes, output files, and listening script by parsing the individual target host. Because the script copies are much smaller than the main script of this project, after running above, coping and modifying the individual target host's scripts on a case by case basis is the suggested next course of action.

 > Bellow is a run-down of what changes per target host and what will remain constant.

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

 > After modifying and running the above script you should have a log file on the local host of actions preformed as defined by `Log_file_path` variable that saves each script copy's quit string as defined by the following option used in above `for` loop

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

