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
echo "# ${Var_script_name} running: Script_Helpers/Paranoid_Pipes_Scenario_One.sh --input-file=\"${Var_encrypted_location}\" --output-file=\"${Var_decrypted_location}\" --pass=\"${Var_pass_location}\" --debug-level='5' --bulk-input-dir=\"${Var_encrypted_bulk_dir}\" --bulk-output-dir=\"${Var_bulk_decryption_dir}\""
Script_Helpers/Paranoid_Pipes_Scenario_One.sh --input-file="${Var_encrypted_location}" --output-file="${Var_decrypted_location}" --pass="${Var_pass_location}" --debug-level='5' --bulk-input-dir="${Var_encrypted_bulk_dir}" --bulk-output-dir="${Var_bulk_decryption_dir}"
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
## If bulk encryption directory path exsists run checks for files and/or
##  compressed directories that where processed by main script named pipe parser
if [ -d "${Var_encrypted_bulk_dir}" ]; then
	_encrypted_file_path="${Var_encrypted_bulk_dir}/$(ls "${Var_encrypted_bulk_dir}" | grep -iE "md" | head -n1)"
	_decrypted_file_path="${Var_bulk_decryption_dir}/${_encrypted_file_path##*/}"
	_decrypted_file_path="${_decrypted_file_path%.gpg*}"
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
