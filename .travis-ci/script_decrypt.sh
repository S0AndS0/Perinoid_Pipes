#!/usr/bin/env bash
Var_script_dir="${0%/*}"
Var_script_name="${0##*/}"
## Source shared variables and functions into this script.
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
echo "# ${Var_script_name} started at: $(date -u +%s)"
## Setup a file to have helper script ouput to
echo "# ${Var_script_name} running: touch \"${Var_decrypted_location}\""
touch "${Var_decrypted_location}"
echo "# ${Var_script_name} running: chmod 660 \"${Var_decrypted_location}\""
chmod 660 "${Var_decrypted_location}"
## If above is removed the bellow will show in terminal instead of being saved
##  to a file. Or if a named pipe is at the output path then the named pipe
##  will be written to with the helper script.
echo "# ${Var_script_name} running: chmod u+x Script_Helpers/Paranoid_Pipes_Scenario_One.sh"
chmod u+x Script_Helpers/Paranoid_Pipes_Scenario_One.sh
echo "# ${Var_script_name} running: Script_Helpers/Paranoid_Pipes_Scenario_One.sh --input-file=\"${Var_encrypted_location}\" --output-file=\"${Var_decrypted_location}\" --pass=\"${Var_pass_location}\""
Script_Helpers/Paranoid_Pipes_Scenario_One.sh --input-file="${Var_encrypted_location}" --output-file="${Var_decrypted_location}" --pass="${Var_pass_location}"
_exit_status=$?
Func_check_exit_status "${_exit_status}"
## Test decryption output against non-encryted input from previous script.
chmod +r ${Var_decrypted_location}
chmod +r ${Var_raw_test_location}
if [ -r "${Var_decrypted_location}" ]; then
	echo "# ${Var_script_name} running: cat \"${Var_decrypted_location}\""
	cat "${Var_decrypted_location}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
	_decrypted_strings="$(cat "${Var_decrypted_location}")"
	if [ -r "${Var_raw_test_location}" ]; then
		echo "# ${Var_script_name} running: cat \"${Var_raw_test_location}\""
		cat "${Var_raw_test_location}"
		_exit_status=$?
		Func_check_exit_status "${_exit_status}"
		_raw_strings="$(cat "${Var_raw_test_location}")"
		if [[ "${_decrypted_strings}" == "${_raw_strings}" ]]; then
			echo "${Var_script_name} reports: all checks passed for log decryption"
		else
			echo "${Var_script_name} reports: failed checks?"
			diff "${Var_decrypted_location}" "${Var_raw_test_location}"
			_exit_status=$?
			Func_check_exit_status "${_exit_status}"
		fi
	else
		echo "# ${Var_script_name} could not read: ${Var_raw_test_location}"
		if [ -f "${Var_raw_test_location}" ]; then
			echo "# ${Var_script_name} reports it is a file though: ${Var_raw_test_location}"
		else
			echo "# ${Var_script_name} reports it not a file: ${Var_raw_test_location}"
		fi
	fi
else
	echo "# ${Var_script_name} could not read: ${Var_decrypted_location}"
	if [ -f "${Var_encrypted_location}" ]; then
		echo "# ${Var_script_name} reports it is a file though: ${Var_decrypted_location}"
	else
		echo "# ${Var_script_name} reports it not a file: ${Var_decrypted_location}"
	fi
fi
## Make a directory path for bulk decryption steps
if ! [ -d "${Var_bulk_decryption_dir}" ]; then
	echo "# ${Var_script_name} running: mkdir -vp \"${Var_bulk_decryption_dir}\""
	mkdir -vp "${Var_bulk_decryption_dir}"
else
	echo "# ${Var_script_name} detected: pre-exsisting bulk decryption directory ${Var_bulk_decryption_dir}"
fi
Func_decrypt_bulk_dir(){
	## Set internal variable based off eventual command line option
	_decrypt_base_dir="${Var_bulk_decryption_dir}"
	_decryption_opts="${Var_gnupg_decrypt_opts}"
	_passphrase="${Var_pass_location}"
	## Capture list of file paths to check
	_arr_listed_paths=( "${@}" )
	let _path_counter=0
	until [ "${_arr_listed_paths[${_path_counter}]}" = "${_path_counter}" ]; do
		_current_path="${_arr_listed_paths[${_path_counter}]}"
		_file_name="${_current_path##*/}"
		_file_dir="${_current_path%/*}"
		if [ -f "${_current_path}" ]; then
			## Match type of encrypted file we are dealing with
			##  for this iteration of the loop
			case "${_current_path}" in
				*.tar.gpg)
					_destination_name="${_file_name%.tar.gpg*}"
					_destination_dir="${_decrypt_base_dir}/${_destination_name}"
					_decryption_bulk_command="gpg ${_decryption_opts} ${_encrypted_dir_path} | tar -xvf -"
				;;
				*.tgz.gpg)
					_destination_name="${_file_name%.tgz.gpg*}"
					_destination_dir="${_decrypt_base_dir}/${_destination_name}"
					_decryption_bulk_command="gpg ${_decryption_opts} ${_encrypted_dir_path} | tar -xvf -"
				;;
				*.gpg)
					_destination_name="${_file_name%.gpg*}"
					_destination="${_decrypt_base_dir}/${_destination_name}"
					_destination_dir="${_destination%/*}"
					_decryption_file_command="gpg ${_decryption_opts} ${_encrypted_dir_path} > \"${_destination}\""
				;;
			esac
			if [ -f "${_passphrase}" ]; then
				exec 9<"${_passphrase}"
			else
				exec 9<(echo "${_passphrase}")
			fi
			## Make a destination directory for decryption
			if [ "${#_destination_dir}" != "0" ] && ! [ -d "${_destination_dir}" ]; then
				mkdir -vp "${_destination_dir}"
			fi
			_old_pwd="${PWD}"
			cd "${_destination_dir}"
			if [ "${#_decryption_bulk_command}" != "0" ]; then
				echo "# ${Var_script_name} running: ${_decryption_bulk_command}"
				${_decryption_bulk_command}
				unset _decryption_bulk_command
			elif [ "${#_decryption_file_command}" != "0" ]; then
				echo "# ${Var_script_name} running: ${_decryption_file_command}"
				${_decryption_file_command}
				unset _decryption_file_command
			fi
			if [ -d "${_old_pwd}" ]; then
				cd "${_old_pwd}"
			fi
		fi
		exec 9>&-
		let _path_counter++
	done
	unset _passphrase
}
## If bulk encryption directory path exsists run checks for files and/or
##  compressed directories that where processed by main script named pipe parser
if [ -d "${Var_encrypted_bulk_dir}" ]; then
	_encrypted_file_path="${Var_encrypted_bulk_dir}/$(ls "${Var_encrypted_bulk_dir}" | grep -iE "md" | head -n1)"
	_decrypted_file_path="${Var_bulk_decryption_dir}/${_encrypted_file_path##*/}"
	_decrypted_file_path="${_decrypted_file_path%.gpg*}"
	_encrypted_dir_path="${Var_encrypted_bulk_dir}/$(ls "${Var_encrypted_bulk_dir}" | grep -iE "dir" | head -n1)"
	_decrypted_dir_path="${Var_bulk_decryption_dir}/$(ls "${Var_encrypted_bulk_dir}" | grep -iE "dir" | head -n1)"
	_decrypted_dir_path="${_decrypted_dir_path%.tar.gpg*}"
	
	## Trying a function for bulk decryption. If this test results in similar output
	##  then this sort of structure maybe added into helper script with some new
	##  command line options.
	for _file in $(ls "${Var_encrypted_bulk_dir}"); do
		Func_decrypt_bulk_dir "${Var_encrypted_bulk_dir}/${_file}"
	done
	## Commented out bellow to test above without doubling up on efforts
	
	## If there be a valid file that matches expected bulk operations for
	##  file paths writen to named pipes, then say so, else pop an error
#	if [ -f "${_encrypted_file_path}" ]; then
#		echo "# ${Var_script_name} reports: file detected ${_encrypted_file_path}"
#		echo "# ${Var_script_name} running: exec 9<\"${Var_pass_location}\""
#		exec 9<"${Var_pass_location}"
#		echo "# ${Var_script_name} running: cat \"${_encrypted_file_path}\" | gpg ${Var_gnupg_decrypt_opts} > \"${_decrypted_file_path}\""
#		cat "${_encrypted_file_path}" | gpg ${Var_gnupg_decrypt_opts} > "${_decrypted_file_path}"
#		_exit_status=$?
#		Func_check_exit_status "${_exit_status}"
#		echo "# ${Var_script_name} running: exec 9>&-"
#		exec 9>&-
#	else
#		echo "# ${Var_script_name} reports: FAILED no file detected ${_encrypted_file_path}"
#	fi
	## If there be a valid file that matches expected bulk operations for
	##  directory paths writen to named pipes, then say so, else pop an error
#	if [ -f "${_encrypted_dir_path}" ]; then
		## Make a directory for extraction of spicific backup
#		if ! [ -d "${_decrypted_dir_path}" ]; then
#			echo "# ${Var_script_name} running: mkdir -p \"${_decrypted_dir_path}\""
#			mkdir -p "${_decrypted_dir_path}"
#		fi
#		echo "# ${Var_script_name} reports: file detected ${_encrypted_dir_path}"
#		echo "# ${Var_script_name} running: exec 9<\"${Var_pass_location}\""
#		exec 9<"${Var_pass_location}"
#		_old_pwd=${PWD}
#		echo "# ${Var_script_name} running: cd \"${_decrypted_dir_path}\""
#		cd "${_decrypted_dir_path}"
		## Trying manual approch found within 'gpg-zip' source code
#		echo "# ${Var_script_name} running: cat \"${_encrypted_dir_path}\" | gpg ${Var_gnupg_decrypt_opts} -d ${_encrypted_dir_path} | tar -xvf"
#		cat "${_encrypted_dir_path}" | gpg ${Var_gnupg_decrypt_opts} | tar -xvf -
#		_exit_status=$?
#		Func_check_exit_status "${_exit_status}"
#		echo "# ${Var_script_name} running: cd \"${_old_pwd}\""
#		cd "${_old_pwd}"
#		echo "# ${Var_script_name} running: exec 9>&-"
#		exec 9>&-
#	else
#		echo "# ${Var_script_name} reports: FAILED no file detected ${_encrypted_dir_path}"
#	fi
	echo "# ${Var_script_name} running: ls -hal \"${Var_bulk_decryption_dir}\""
	ls -hal "${Var_bulk_decryption_dir}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
	if [ -f "${_decrypted_file_path}" ]; then
		echo "# ${Var_script_name} reports: decrypted file detected ${_decrypted_file_path}"
		echo '# ${Var_script_name} running: diff <(cat "${_decrypted_file_path}") <(cat "${Var_encrypt_file_path}")'
		diff <(cat "${_decrypted_file_path}") <(cat "${Var_encrypt_file_path}")
		_exit_status=$?
		Func_check_exit_status "${_exit_status}"
	else
		echo "# ${Var_script_name} reports: no file found at ${_decrypted_file_path}"
	fi
	echo "# ${Var_script_name} reports: all checks passed for bulk decryption"
	echo "# Note if above 'ls' output shows a file and a directory, then celebrate with a sip or shot of a drink of your choice :-D"
fi
echo "# ${Var_script_name} finished at: $(date -u +%s)"
