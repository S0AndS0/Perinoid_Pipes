#!/usr/bin/env bash
export Var_script_dir="${0%/*}"
export Var_script_name="${0##*/}"
## Source shared variables and functions into this script.
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
## First test if script is installed and excessable via name alone, elif check
##  if executable via full file path and name else exit with errors.
echo "# ${Var_script_name} started at: $(date -u +%s)"
if [ -e "${Var_install_name}" ]; then
	echo "# ${Var_script_name} running test one as ${USER}: ${Var_install_name} Var_debugging=1 Var_pipe_permissions=666 Var_log_file_permissions=666 Var_script_copy_permissions=750 Var_gpg_recipient=${Var_gnupg_email} Var_log_rotate_recipient=${Var_gnupg_email} Var_pipe_file_name=${Var_encrypt_pipe_location} Var_log_file_name=${Var_encrypt_pipe_log} Var_parsing_output_file=${Var_encrypted_location} Var_parsing_bulk_out_dir=${Var_encrypted_bulk_dir}"
	${Var_install_name} Var_debugging='1' Var_pipe_permissions='666' Var_log_file_permissions='666' Var_script_copy_permissions='750' Var_gpg_recipient="${Var_gnupg_email}" Var_log_rotate_recipient="${Var_gnupg_email}" Var_pipe_file_name="${Var_encrypt_pipe_location}" Var_log_file_name="${Var_encrypt_pipe_log}" Var_parsing_output_file="${Var_encrypted_location}" Var_parsing_bulk_out_dir="${Var_encrypted_bulk_dir}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
elif [ -e "${Var_install_path}/${Var_install_name}" ]; then
	## Make pipe for listening with main script loops owned by current user.
	echo "# ${Var_script_name} running test one as ${USER}: ${Var_install_path}/${Var_install_name} Var_debugging=1 Var_pipe_permissions=666 Var_log_file_permissions=666 Var_gpg_recipient=${Var_gnupg_email} Var_log_rotate_recipient=${Var_gnupg_email} Var_pipe_file_name=${Var_encrypt_pipe_location} Var_log_file_name=${Var_encrypt_pipe_log} Var_parsing_output_file=${Var_encrypted_location} Var_parsing_bulk_out_dir=${Var_encrypted_bulk_dir}"
	${Var_install_path}/${Var_install_name} Var_debugging='1' Var_pipe_permissions='666' Var_log_file_permissions='666' Var_gpg_recipient="${Var_gnupg_email}" Var_log_rotate_recipient="${Var_gnupg_email}" Var_pipe_file_name="${Var_encrypt_pipe_location}" Var_log_file_name="${Var_encrypt_pipe_log}" Var_parsing_output_file="${Var_encrypted_location}" Var_parsing_bulk_out_dir="${Var_encrypted_bulk_dir}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
else
	echo "# ${Var_script_name} could not find: ${Var_install_path}/${Var_install_name}"
	exit 1
fi
_background_processes="$(ps aux | grep "${Var_install_name}" | grep -v grep)"
if [ "${#_background_processes}" -gt '0' ]; then
	echo "# ${Var_script_name} detected the following background processes"
	echo "${_background_processes}"
else
	echo "# Error - ${Var_script_name} did not detect any background processes"
	exit 1
fi
#echo -e "# ${Var_script_name} checking background processes:\n# "
#echo "\n\n Number of processes $(pgrep -c "${Var_install_name}")"
## If test pipe file exists then test, else exit with errors
if [ -p "${Var_encrypt_pipe_location}" ]; then
	## Note we are saving the test string to a file but will be cat-ing
	##  it back out to named pipe file for the first test so lets make that
	##  file with the proper permissions to be latter read and currently
	##  writen to.
	echo "# ${Var_script_name} running: touch \"${Var_raw_test_location}\""
	touch "${Var_raw_test_location}"
	echo "# ${Var_script_name} running: chmod 660 \"${Var_raw_test_location}\""
	chmod 660 "${Var_raw_test_location}"
	_test_string="$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c"${Var_pass_length}")"
	echo "${_test_string}" >> "${Var_raw_test_location}"
	_current_string="$(tail -n1 "${Var_raw_test_location}")"
	echo "# ${Var_script_name} running as ${USER}: echo \"${_current_string}\" > \"${Var_encrypt_pipe_location}\""
	echo "${_current_string}" > "${Var_encrypt_pipe_location}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
	## Push a few more random lines into encryption pipe for later build
	##  script to process multi-decryption options.
	_test_string="$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c"${Var_pass_length}")"
	echo "${_test_string}" >> "${Var_raw_test_location}"
	_current_string="$(tail -n1 "${Var_raw_test_location}")"
	echo "# ${Var_script_name} running as ${USER}: echo \"${_current_string}\" > \"${Var_encrypt_pipe_location}\""
	echo "${_current_string}" > "${Var_encrypt_pipe_location}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
	_test_string="$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c"${Var_pass_length}")"
	echo "${_test_string}" >> "${Var_raw_test_location}"
	_current_string="$(tail -n1 "${Var_raw_test_location}")"
	echo "# ${Var_script_name} running as ${USER}: echo \"${_current_string}\" > \"${Var_encrypt_pipe_location}\""
	echo "${_current_string}" > "${Var_encrypt_pipe_location}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
	## Push a known file path to named pipe and check if it is processed to
	##  the defined bulk output directory
	echo "# ${Var_script_name} running: echo \"${Var_raw_test_location}\" > \"${Var_encrypt_pipe_location}\""
	echo "${Var_raw_test_location}" > "${Var_encrypt_pipe_location}"
	## Make a test directory with an empty file if non-exsistant
	if ! [ -d "${Var_encrypt_dir_path}" ]; then
		echo "# ${Var_script_name} running: mkdir -p \"${Var_encrypt_dir_path}\""
		mkdir -p "${Var_encrypt_dir_path}"
		echo "# ${Var_script_name} running: touch \"${Var_encrypt_dir_path}/test_file\""
		touch "${Var_encrypt_dir_path}/test_file"
		echo "# ${Var_script_name} running: chmod -R +r \"${Var_encrypt_dir_path}\""
		chmod -R +r "${Var_encrypt_dir_path}"
	fi
	## Test encryption of directory options
	_output_path="${Var_encrypted_bulk_dir}/$(date -u +%s)_dir.tgz.gpg"
	if [ -d "${Var_encrypt_dir_path}" ] && [ -d "${Var_encrypted_bulk_dir}" ]; then
		echo "# ${Var_script_name} running: tar -cz ${Var_encrypt_dir_path} | gpg -r ${Var_gnupg_email} --armor --batch --output ${_output_path}"
		tar -cz ${Var_encrypt_dir_path} | gpg -r ${Var_gnupg_email} --armor --batch --output ${_output_path}
	elif ! [ -d "${Var_encrypted_bulk_dir}" ]; then
		echo "# ${Var_script_name} reports: following directory does not exsit ${Var_encrypted_bulk_dir}"
	elif ! [ -d "${Var_encrypt_dir_path}" ]; then
		echo "# ${Var_script_name} reports: following directory does not exsit ${Var_encrypt_dir_path}"
	fi
	if  [ -f "${_output_path}" ]; then
		echo "# ${Var_script_name} running: ls -hal ${_output_path}"
		ls -hal "${_output_path}"
	else
		echo "# ${Var_script_name} reports: FAILED to find ${_output_path}"
	fi
#	if [ -d "${Var_encrypt_dir_path}" ]; then
#		echo "# ${Var_script_name} running: echo \"${Var_encrypt_dir_path}\" > \"${Var_encrypt_pipe_location}\""
#		echo "${Var_encrypt_dir_path}" > "${Var_encrypt_pipe_location}"
#	else
#		echo "# ${Var_script_name} running: mkdir -p \"${Var_encrypt_dir_path}\""
#		mkdir -p "${Var_encrypt_dir_path}"
#		echo "# ${Var_script_name} running: touch \"${Var_encrypt_dir_path}/test_file\""
#		touch "${Var_encrypt_dir_path}/test_file"
#		echo "# ${Var_script_name} running: chmod -R +r \"${Var_encrypt_dir_path}\""
#		chmod -R +r "${Var_encrypt_dir_path}"
#		echo "# ${Var_script_name} running: echo \"${Var_encrypt_dir_path}\" > \"${Var_encrypt_pipe_location}\""
#		echo "${Var_encrypt_dir_path}" > "${Var_encrypt_pipe_location}"
#	fi
	if [ -d "${Var_encrypted_bulk_dir}" ]; then
		echo "# ${Var_script_name} running: ls -hal ${Var_encrypted_bulk_dir}"
		ls -hal "${Var_encrypted_bulk_dir}"
	else
		echo "# ${Var_script_name} reports: FAILED to find ${Var_encrypted_bulk_dir}"
		exit 1
	fi
	## Send quit string to named pipe for testing of built in auto-clean
	##  functions, note to authors, this seems to be funky on auto builds
	##  but latter removal of the named pipe file seems to kill the listener
	##  as designed... this is why the controlling loop is so simple though.
	echo "# ${Var_script_name} running as ${USER}: echo \"quit\" > \"${Var_encrypt_pipe_location}\""
	echo "quit" > "${Var_encrypt_pipe_location}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
else
	echo "# Error - ${Var_script_name} could not find: ${Var_encrypt_pipe_location}"
	exit 1
fi
## Report on pipe auto-removal
if ! [ -p "${Var_encrypt_pipe_location}" ]; then
	echo "# ${Var_script_name} detected pipe corectly removed: ${Var_encrypt_pipe_location}"
else
	echo "# ${Var_script_name} detected pipe still exsists: ${Var_encrypt_pipe_location}"
	ls -hal "${Var_encrypt_pipe_location}"
	echo "# ${Var_script_name} will cleanup: ${Var_encrypt_pipe_location}"
	rm -v "${Var_encrypt_pipe_location}"
fi
## Report on background processes
_background_processes="$(ps aux | grep "${Var_install_name}" | grep -v grep)"
if [ "${#_background_processes}" -gt '0' ]; then
	echo -e "# ${Var_script_name} reports background processes still running:\n# $(ps aux | grep "${Var_install_name}" | grep -v grep)\n\n Number of processes $(pgrep -c "${Var_install_name}")"
	for _pid in $(pgrep "${Var_install_name}"); do
		echo "# ${Var_script_name} killing: ${_pid}"
	done
else
	echo "# ${Var_script_name} did not detect any background processes"
fi
## If encrypted output file exsists then test decryption now, else error out.
if [ -r "${Var_encrypted_location}" ]; then
	echo "# ${Var_script_name} running: ls -hal \"${Var_encrypted_location}\""
	ls -hal "${Var_encrypted_location}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
	echo "# ${Var_script_name} reports: all checks passed"
else
	echo "# ${Var_script_name} could not read: ${Var_encrypted_location}"
	if [ -f "${Var_encrypted_location}" ]; then
		echo "# ${Var_script_name} reports it is a file though: ${Var_encrypted_location}"
	else
		echo "# ${Var_script_name} reports it not a file: ${Var_encrypted_location}"
	fi
fi
## Report encryption pipe tests success if we have gotten this far
echo "# ${Var_script_name} finished at: $(date -u +%s)"
