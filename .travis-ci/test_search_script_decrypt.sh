#!/usr/bin/env bash
Var_script_dir="${0%/*}"
Var_script_name="${0##*/}"
## Source shared variables and functions into this script.
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
echo "# ${Var_script_name} started at: $(date -u +%s)"
## Setup string to search for with helper script
## Line number to read down to in raw strings file
_line_num='2'
_search_string=$(head -n${_line_num} "${Var_raw_test_location}" | tail -n1)
echo "# ${Var_script_name} read line [${_line_num}] to search for as: ${_search_string}"
## Setup a file to have helper script ouput to
echo "# ${Var_script_name} running: touch \"${Var_search_out_location}\""
touch "${Var_search_out_location}"
echo "# ${Var_script_name} running: chmod 660 \"${Var_search_out_location}\""
chmod 660 "${Var_search_out_location}"
## If above is removed the bellow will show in terminal instead of being saved
##  to a file. Or if a named pipe is at the output path then the named pipe
##  will be written to with the helper script instead.
echo "# ${Var_script_name} running: chmod u+x Script_Helpers/Paranoid_Pipes_Scenario_One.sh"
chmod u+x Script_Helpers/Paranoid_Pipes_Scenario_One.sh
echo "# ${Var_script_name} running: Script_Helpers/Paranoid_Pipes_Scenario_One.sh --search-output=\"${_search_string}\" --input-file=\"${Var_encrypted_location}\" --output-file=\"${Var_search_out_location}\" --pass=\"${Var_pass_location}\""
Script_Helpers/Paranoid_Pipes_Scenario_One.sh --search-output="${_search_string}" --input-file="${Var_encrypted_location}" --output-file="${Var_search_out_location}" --pass="${Var_pass_location}"
_exit_status=$?
Func_check_exit_status "${_exit_status}"
## Test decryption output against non-encryted input from previous script.
chmod +r ${Var_search_out_location}
chmod +r ${Var_raw_test_location}
if [ -r "${Var_search_out_location}" ]; then
	echo "# ${Var_script_name} running: cat \"${Var_decrypted_location}\""
	cat "${Var_decrypted_location}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
	_decrypted_strings="$(cat "${Var_search_out_location}")"
	if [ "${_search_string}" = "${_decrypted_strings}" ]; then
		echo "# ${Var_script_name} reports: Good [${_search_string}] = [${_decrypted_strings}]"
		echo "## Note for readers: if reading this on output this means that the helper script"
		echo "##  is able to search decrypted output before saving/printing results; great for saving space!"
	else
		echo "# ${Var_script_name} reports: Error [${_search_string}] != [${_decrypted_strings}]"
		exit 1
	fi
else
	echo "# ${Var_script_name} could not read: ${Var_decrypted_location}"
	if [ -f "${Var_encrypted_location}" ]; then
		echo "# ${Var_script_name} reports it is a file though: ${Var_decrypted_location}"
	else
		echo "# ${Var_script_name} reports it not a file: ${Var_decrypted_location}"
		exit 2
	fi
	exit 1
fi
## Report encryption pipe tests success if we have gotten this far
echo "# ${Var_script_name} finished at: $(date -u +%s)"
#export Var_gnupg_decrypt_opts="--always-trust --yes --bulk --passphrase-fd 0 --decrypt"
