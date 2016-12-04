#!/usr/bin/env bash
export Var_script_dir="${0%/*}"
export Var_script_name="${0##*/}"
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
echo "# ${Var_script_name} started at: $(date -u +%s)"
Var_install_v2_name="${Var_install_v2_name}"

_test_string="$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c"${Var_pass_length}")"
echo "${_test_string}" >> "${Var_raw_test_last_location}"
_current_string="$(tail -n1 "${Var_raw_test_last_location}")"
if [ -e "${Var_install_v2_name}" ]; then
	${Var_install_v2_name} --debug-level="0" --log-level="7" --enc-yn="yes" --enc-parsing-disown-yn="yes" --script-log-path="${Var_encrypt_pipe_last_log}" --enc-pipe-permissions="660" --enc-parsing-output-permissions="660" --enc-parsing-recipient="${Var_gnupg_email}" --enc-parsing-output-rotate-recipient="${Var_gnupg_email}" --enc-pipe-file="${Var_encrypt_pipe_last_location}" --enc-parsing-output-file="${Var_encrypted_last_location}" --enc-parsing-bulk-out-dir="${Var_encrypted_last_bulk_dir}" "${_current_string}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
elif [ -e "${Var_install_path}/${Var_install_v2_name}" ]; then
	${Var_install_path}/${Var_install_v2_name} --debug-level="0" --log-level="7" --enc-yn="yes" --enc-parsing-disown-yn="yes" --script-log-path="${Var_encrypt_pipe_last_log}" --enc-pipe-permissions="660" --enc-parsing-output-permissions="660" --enc-parsing-recipient="${Var_gnupg_email}" --enc-parsing-output-rotate-recipient="${Var_gnupg_email}" --enc-pipe-file="${Var_encrypt_pipe_last_location}" --enc-parsing-output-file="${Var_encrypted_last_location}" --enc-parsing-bulk-out-dir="${Var_encrypted_last_bulk_dir}" "${_current_string}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
else
	echo "# ${Var_script_name} could not find: ${Var_install_path}/${Var_install_v2_name}"
	exit 1
fi
if [ -p "${Var_encrypt_pipe_last_location}" ]; then
	if [ -d "${Var_encrypt_dir_last_path}" ]; then
		echo "# ${Var_script_name} running: echo \"${Var_encrypt_dir_last_path}\" > \"${Var_encrypt_pipe_last_location}\""
		echo "${Var_encrypt_dir_last_path}" > "${Var_encrypt_pipe_last_location}"
		_exit_status=$?
		Func_check_exit_status "${_exit_status}"
	else
		echo "# ${Var_script_name} running: mkdir -p \"${Var_encrypt_dir_last_path}\""
		mkdir -p "${Var_encrypt_dir_last_path}"
		echo "# ${Var_script_name} running: touch \"${Var_encrypt_dir_last_path}/test_file\""
		touch "${Var_encrypt_dir_last_path}/test_file"
		echo "# ${Var_script_name} running: chmod -R +r \"${Var_encrypt_dir_last_path}\""
		chmod -R +r "${Var_encrypt_dir_last_path}"
		echo "# ${Var_script_name} running: echo \"${Var_encrypt_dir_last_path}\" > \"${Var_encrypt_pipe_last_location}\""
		echo "${Var_encrypt_dir_last_path}" > "${Var_encrypt_pipe_last_location}"
		_exit_status=$?
		Func_check_exit_status "${_exit_status}"
	fi
	if [ -f "${Var_encrypt_file_last_path}" ]; then
		echo "# ${Var_script_name} running: echo \"${Var_encrypt_file_last_path}\" > \"${Var_encrypt_pipe_last_location}\""
		echo "${Var_encrypt_file_last_path}" > "${Var_encrypt_pipe_last_location}"
		_exit_status=$?
		Func_check_exit_status "${_exit_status}"
	else
		echo "# ${Var_script_name} running: touch \"${Var_encrypt_file_last_path}\""
		touch "${Var_encrypt_file_last_path}"
		echo "# ${Var_script_name} running: chmod +r \"${Var_encrypt_file_last_path}\""
		chmod +r "${Var_encrypt_file_last_path}"
		echo "# ${Var_script_name} running: echo \"${Var_encrypt_file_last_path}\" > \"${Var_encrypt_pipe_last_location}\""
		echo "${Var_encrypt_file_last_path}" > "${Var_encrypt_pipe_last_location}"
		_exit_status=$?
		Func_check_exit_status "${_exit_status}"
	fi
	Func_write_and_log_lines_to_pipe "${Var_raw_test_last_location}" "${Var_encrypt_pipe_last_location}" "64"
	Func_write_and_log_lines_to_pipe "${Var_raw_test_last_location}" "${Var_encrypt_pipe_last_location}" "32"
	Func_write_and_log_lines_to_pipe "${Var_raw_test_last_location}" "${Var_encrypt_pipe_last_location}" "16"
	echo "# ${Var_script_name} running as ${USER}: echo \"quit\" > \"${Var_encrypt_pipe_last_location}\""
	echo "quit" > "${Var_encrypt_pipe_last_location}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
else
	echo "# Error - ${Var_script_name} could not find: ${Var_encrypt_pipe_last_location}"
	exit 1
fi
if ! [ -p "${Var_encrypt_pipe_last_location}" ]; then
	echo "# ${Var_script_name} detected pipe corectly removed: ${Var_encrypt_pipe_last_location}"
else
	echo "# ${Var_script_name} detected pipe still exsists: ${Var_encrypt_pipe_last_location}"
	ls -hal "${Var_encrypt_pipe_last_location}"
	echo "# ${Var_script_name} will cleanup: ${Var_encrypt_pipe_last_location}"
	rm -v "${Var_encrypt_pipe_last_location}"
fi
_background_processes="$(ps aux | grep "${Var_install_v2_name}" | grep -v grep)"
if [ "${#_background_processes}" -gt '0' ]; then
	echo -e "# ${Var_script_name} reports background processes still running:\n#\n$(ps aux | grep "${Var_install_v2_name}" | grep -v grep)\n#"
	_background_pid="$(ps aux | grep "${Var_install_v2_name}" | grep -v grep | awk '{print $2}')"
	for _pid in ${_background_pid}; do
		echo "# ${Var_script_name} killing: ${_pid}"
		kill ${_pid}
	done
else
	echo "# ${Var_script_name} did not detect any background processes"
	echo "# ${Var_script_name} reports auto-quit: Passed"
fi
if [ -r "${Var_encrypted_last_location}" ]; then
	echo "# ${Var_script_name} running: ls -hal \"${Var_encrypted_last_location}\""
	ls -hal "${Var_encrypted_last_location}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
else
	echo "# ${Var_script_name} could not read: ${Var_encrypted_last_location}"
	if [ -f "${Var_encrypted_last_location}" ]; then
		echo "# ${Var_script_name} reports it is a file though: ${Var_encrypted_last_location}"
	else
		echo "# ${Var_script_name} reports it not a file: ${Var_encrypted_last_location}"
	fi
fi
if [ -d "${Var_encrypted_last_bulk_dir}" ]; then
	echo "# ${Var_script_name} running: ls -hal ${Var_encrypted_last_bulk_dir}"
	ls -hal "${Var_encrypted_last_bulk_dir}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
	echo "# ${Var_script_name} reports: all encryption checks passed"
else
	echo "# ${Var_script_name} reports: FAILED to find ${Var_encrypted_last_bulk_dir}"
#	exit 1
fi
## Check decryption within version two of main script processes
Var_search_string_four="$(head -n2 "${Var_raw_test_last_location}" | tail -n1)"
${Var_install_v2_name} --debug-level="0" --log-level="8" --dec-yn="yes" --dec-parsing-disown-yn="no" --dec-bulk-check-sleep="5" --dec-bulk-check-count-max='1' --script-log-path="${Var_decrypt_last_log}" --dec-pass="${Var_pass_location}" --dec-parsing-save-output-yn="yes" --dec-parsing-output-file="${Var_decrypt_raw_last_location}" --enc-parsing-output-file="${Var_encrypted_last_location}" --dec-parsing-bulk-out-dir="${Var_bulk_decryption_last_dir}" --enc-parsing-bulk-out-dir="${Var_encrypted_last_bulk_dir}"
_exit_status=$?
Func_check_exit_status "${_exit_status}"
if [ -r "${Var_decrypt_raw_last_location}" ] && [ -r "${Var_raw_test_last_location}" ] && [ -d "${Var_bulk_decryption_last_dir}" ]; then
	_decrypted_strings="$(cat "${Var_decrypt_raw_last_location}")"
	_raw_strings="$(cat "${Var_raw_test_last_location}")"
	_diff_results="$(diff <(cat "${Var_decrypt_raw_last_location}") <(cat "${Var_raw_test_last_location}"))"
	_bulk_dec_dir_listing="$(ls "${Var_bulk_decryption_last_dir}")"
	echo -e "# Contence of decrypted strings #\n${_decrypted_strings}"
	echo -e "# Contence of un-encrypted strings #\n${_raw_strings}"
	if [ "${#_diff_results}" != "0" ]; then
		echo -e "# Diff results #\n${_diff_results}"
	else
		echo "# ${Var_script_name} reports: no differance between strings!"
		echo "# ${Var_script_name} reports diff checks: Passed"
	fi
	for _file in ${_bulk_dec_dir_listing}; do
		_path="${Var_bulk_decryption_last_dir}/${_file}"
		if [ -f "${_path}" ]; then
			echo -e "# ${Var_script_name} reports file detected #\n#${_path}"
		elif [ -d "${_path}" ]; then
			echo -e "# ${Var_script_name} reports directory detected #\n#${_path}"
		else
			echo "# ${Var_script_name} did not understand path: ${_path}"
		fi
	done
	_background_processes="$(ps aux | grep "${Var_install_v2_name}" | grep -v grep)"
	if [ "${#_background_processes}" -gt '0' ]; then
		echo -e "# ${Var_script_name} reports background processes still running:\n#\n$(ps aux | grep "${Var_install_v2_name}" | grep -v grep)\n#"
		_background_pid="$(ps aux | grep "${Var_install_v2_name}" | grep -v grep | awk '{print $2}')"
		for _pid in ${_background_pid}; do
			echo "# ${Var_script_name} killing: ${_pid}"
			kill ${_pid}
		done
	else
		echo "# ${Var_script_name} did not detect any background processes"
		echo "# ${Var_script_name} reports: all internal decryption checks: Passed"
	fi
elif ! [ -r "${Var_decrypt_raw_last_location}" ]; then
	echo "# ${Var_script_name} could not read file: ${Var_decrypt_raw_last_location}"
	exit 1
elif ! [ -r "${Var_raw_test_last_location}" ]; then
	echo "# ${Var_script_name} could not read file: ${Var_raw_test_last_location}"
	exit 1
elif ! [ -d "${Var_bulk_decryption_last_dir}" ]; then
	echo "# ${Var_script_name} could not read directory: ${Var_bulk_decryption_last_dir}"
#	exit 1
else
	echo "# ${Var_script_name} could not proceed"
	exit 2
fi
## Check decryption within version two of main script processes
Var_search_string_four="$(head -n2 "${Var_raw_test_last_location}" | tail -n1)"
${Var_install_v2_name} --debug-level="0" --log-level="8" --dec-yn="yes" --dec-parsing-disown-yn="no" --dec-bulk-check-sleep="5" --dec-bulk-check-count-max='1' --script-log-path="${Var_decrypt_last_log}" --dec-pass="${Var_pass_location}" --dec-parsing-save-output-yn="yes" --dec-parsing-output-file="${Var_decrypt_raw_last_location}" --enc-parsing-output-file="${Var_encrypted_last_location}" --dec-parsing-bulk-out-dir="${Var_bulk_decryption_last_dir}" --enc-parsing-bulk-out-dir="${Var_encrypted_last_bulk_dir}" --dec-search-string="${Var_search_string_four}"
_exit_status=$?
Func_check_exit_status "${_exit_status}"
Var_results_string_four="$(tail -n1 "${Var_decrypt_raw_last_location}")"
if [ "${Var_search_string_four}" = "${Var_results_string_four}" ]; then
	echo "# ${Var_script_name} reports: search tests Passed!"
	echo "# [${Var_search_string_four}] = [${Var_results_string_four}]"
else
	echo "# ${Var_script_name} reports: search tests Failed!"
	echo "# [${Var_search_string_four}] != [${Var_results_string_four}]"
fi
if [ -r "${Var_encrypt_pipe_last_log}" ]; then
	cat "${Var_encrypt_pipe_last_log}"
fi
if [ -r "${Var_decrypt_last_log}" ]; then
	cat "${Var_decrypt_last_log}"
fi
echo "# ${Var_script_name} finished at: $(date -u +%s)"
