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
## If bulk encryption directory path exsists run checks for files and/or
##  compressed directories that where processed by main script named pipe parser
if [ -d "${Var_encrypted_bulk_dir}" ]; then
	_encrypted_file_path="${Var_encrypted_bulk_dir}/$(ls "${Var_encrypted_bulk_dir}" | grep -iE "md" | head -n1)"
	_encrypted_dir_path="${Var_encrypted_bulk_dir}/$(ls "${Var_encrypted_bulk_dir}" | grep -iE "dir" | head -n1)"
	## If there be a valid file that matches expected bulk operations for
	##  file paths writen to named pipes, then say so, else pop an error
	if [ -f "${_encrypted_file_path}" ]; then
		echo "# ${Var_script_name} reports: file detected ${_encrypted_file_path}"
		echo "# ${Var_script_name} running: exec 9<\"${Var_pass_location}\""
		exec 9<"${Var_pass_location}"
		echo "# ${Var_script_name} running: cat \"${_encrypted_file_path}\" | gpg ${Var_gnupg_decrypt_opts} > \"${Var_bulk_decryption_dir}/${_encrypted_file_path##*/}\""
		cat "${_encrypted_file_path}" | gpg ${Var_gnupg_decrypt_opts} > "${Var_bulk_decryption_dir}/${_encrypted_file_path##*/}"
		echo "# ${Var_script_name} running: exec 9>&-"
		exec 9>&-
	else
		echo "# ${Var_script_name} reports: FAILED no file detected ${_encrypted_file_path}"
	fi
	## If there be a valid file that matches expected bulk operations for
	##  directory paths writen to named pipes, then say so, else pop an error
	if [ -f "${_encrypted_dir_path}" ]; then
		echo "# ${Var_script_name} reports: file detected ${_encrypted_dir_path}"
		echo "# ${Var_script_name} running: exec 9<\"${Var_pass_location}\""
		exec 9<"${Var_pass_location}"
		_old_pwd=${PWD}
		echo "# ${Var_script_name} running: cd \"${Var_bulk_decryption_dir}\""
		cd "${Var_bulk_decryption_dir}"
		echo "# ${Var_script_name} running: cat \"${_encrypted_dir_path}\" | gpg ${Var_gnupg_decrypt_opts} | tar xz"
		cat "${_encrypted_dir_path}" | gpg ${Var_gnupg_decrypt_opts} | tar xz
		echo "# ${Var_script_name} running: cd \"${_old_pwd}\""
		cd "${_old_pwd}"
		echo "# ${Var_script_name} running: exec 9>&-"
		exec 9>&-
	else
		echo "# ${Var_script_name} reports: FAILED no file detected ${_encrypted_dir_path}"
	fi

	echo "${Var_script_name} reports: all checks passed for bulk decryption"
fi
echo "# ${Var_script_name} finished at: $(date -u +%s)"
