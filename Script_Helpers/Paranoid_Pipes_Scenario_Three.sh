#!/usr/bin/env bash
### Define some variables for latter use.
## Comma separated list of SSH remote hosts to setup
Remote_hosts="webadmin@webhost:22,sqladmin@sqlhost:9823"
##  note the user names from above will be used for script and pipe names
## Shell to invoke on remote hosts
Remote_host_shell="/bin/bash"
## GPG/PGP key server that remote hosts will use for importing your public key
GnuPG_keyserv_URL=""
## Character length of quit string that will be made for each host
Quit_string_length='32'
## Log file path to save configuration to local file system
Log_file_path='/tmp/ssh_remote_encrypted_setup.log'
## Path to main script on local host
Main_script_path='/path/to/writer_script.sh'
## Paths for remote script customized named pipe listener
Script_save_dir='/usr/local/sbin'
Script_save_output_dir='/var/log'
Script_save_parse_recipient='user@host.suffix'
Script_save_rotate_recipient='user@host.suffix'
## Building up following variable with options that will not change
##  between writing operations. Note the use of '+=' and trailing space (' ')
##  this is to aid you (the reader) in editing and/or understanding this script

Script_opts_unchanging+=( "--output-parse-recipient=${Script_save_parse_recipient}" )
Script_opts_unchanging+=( "--output-rotate-recipient=${Script_save_rotate_recipient}" )
Script_opts_unchanging+=( "--copy-save-yn='yes' --debug-level='6' --log-level=7" )
Script_opts_unchanging+=( "--copy-save-permissions='100' --named-pipe-permissions=420" )
Script_opts_unchanging+=( "--output-pre-parse-yn='no' --disown-yn=yes" )
Script_opts_unchanging+=( "--output-rotate-yn='yes' --output-save-yn=yes" )
Script_opts_unchanging+=( "--output-rotate-actions=compress-encrypt,remove-old" )
Script_opts_unchanging+=( "--output-rotate-check-frequency=25000" )
Script_opts_unchanging+=( "--output-rotate-max-bites=8388608" )

Run_via_ssh(){
	_host="$1"
	_command="$2"
	_shell="${Remote_host_shell}"
	ssh "${_host}" -s ${_shell} "${_command}"
}
### Run commands in a loop with header and tail printed to above log file.
echo '# <Host> | <Quit string>' | tee -a "${Log_file_path}"
echo '#--------|--------------' | tee -a "${Log_file_path}"
for _host in ${Remote_hosts//,/ }; do
	_random_quit_string=$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9_' | head -c${Quit_string_length:-32})
	_host_name="${_host%@*}"
	## Build up options to use when writing script copies. This is done
	## much like the unchanging script options found above and used bellow.
	Script_options+=( "${Script_opts_unchanging[*]}" )
	Script_options+=( "--copy-save-name=${Script_save_dir}/${_host_name}_log_encrypter.sh" )
	Script_options+=( "--copy-save-ownership=${_host_name}:${_host_name}" )
	Script_options+=( "--named-pipe-name=${Script_save_output_dir}/${_host_name}_access.log.pipe" )
	Script_options+=( "--named-pipe-ownership=${_host_name}:${_host_name}" )
	Script_options+=( "--output-parse-name=${Script_save_output_dir}/${_host_name}_access.gpg" )
	Script_options+=( "--listener-quit-string=${_random_quit_string}" )
	if [[ "${Script_save_parse_recipient}" == "${Script_save_rotate_recipient}" ]]; then
		Run_via_ssh "${_host}" "gpg --import ${Script_save_parse_recipient} --recv-keys ${GnuPG_keyserv_URL}"
	else
		Run_via_ssh "${_host}" "gpg --import ${Script_save_parse_recipient} --recv-keys ${GnuPG_keyserv_URL}"
		Run_via_ssh "${_host}" "gpg --import ${Script_save_rotate_recipient} --recv-keys ${GnuPG_keyserv_URL}"
	fi

	Run_via_ssh "${_host}" "$(<${Main_script_path} ${Script_options[*]})"
	Run_via_ssh "${_host}" "echo '${_random_quit_string}' > ${Script_save_output_dir}/${_host_name}_access.log.pipe"
	echo "# ${_host} | ${_random_quit_string}" | tee -a "${Log_file_path}"
done
echo "## Finished above at $(date)" | tee -a "${Log_file_path}"
