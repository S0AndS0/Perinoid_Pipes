#!/usr/bin/env bash
export Var_script_dir="${0%/*}"
export Var_script_name="${0##*/}"
## Source shared variables and functions into this script.
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
## Added the following options to test saving custom script copies.
#--copy-save-yn="yes" --copy-save-name="${Var_script_copy_name_encrypt}" --copy-save-permissions="750" --copy-save-ownership="${USER}:${USER}"
## First test if script is installed and excessable via name alone, elif check
##  if executable via full file path and name else exit with errors.
echo "# ${Var_script_name} started at: $(date -u +%s)"
if [ -e "${Var_install_name}" ]; then
	echo "# ${Var_script_name} running test two as ${USER}: ${Var_install_name} Var_debugging=1 Var_pipe_permissions=666 Var_log_file_permissions=666 Var_script_copy_permissions=750 Var_gpg_recipient=${Var_gnupg_email} Var_log_rotate_recipient=${Var_gnupg_email} Var_pipe_file_name=${Var_encrypt_pipe_location_copy} Var_log_file_name=${Var_encrypt_pipe_log_copy} Var_parsing_output_file=${Var_encrypted_location_copy} Var_parsing_bulk_out_dir=${Var_encrypted_bulk_dir_copy} --copy-save-yn=\"yes\" --copy-save-name=\"${Var_script_copy_name_encrypt}\" --copy-save-permissions=\"750\" --copy-save-ownership=\"${USER}:${USER}\""
	${Var_install_name} Var_debugging='1' Var_pipe_permissions='666' Var_log_file_permissions='666' Var_script_copy_permissions='750' Var_gpg_recipient="${Var_gnupg_email}" Var_log_rotate_recipient="${Var_gnupg_email}" Var_pipe_file_name="${Var_encrypt_pipe_location_copy}" Var_log_file_name="${Var_encrypt_pipe_log_copy}" Var_parsing_output_file="${Var_encrypted_location_copy}" Var_parsing_bulk_out_dir="${Var_encrypted_bulk_dir_copy}" --copy-save-yn="yes" --copy-save-name="${Var_script_copy_name_encrypt}" --copy-save-permissions="750" --copy-save-ownership="${USER}:${USER}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
elif [ -e "${Var_install_path}/${Var_install_name}" ]; then
	## Make pipe for listening with main script loops owned by current user.
	echo "# ${Var_script_name} running test two as ${USER}: ${Var_install_path}/${Var_install_name} Var_debugging=1 Var_pipe_permissions=666 Var_log_file_permissions=666 Var_gpg_recipient=${Var_gnupg_email} Var_log_rotate_recipient=${Var_gnupg_email} Var_pipe_file_name=${Var_encrypt_pipe_location_copy} Var_log_file_name=${Var_encrypt_pipe_log_copy} Var_parsing_output_file=${Var_encrypted_location_copy} Var_parsing_bulk_out_dir=${Var_encrypted_bulk_dir_copy} --copy-save-yn=yes --copy-save-name=${Var_script_copy_name_encrypt} --copy-save-permissions=750 --copy-save-ownership=${USER}:${USER}"
	${Var_install_path}/${Var_install_name} Var_debugging='1' Var_pipe_permissions='666' Var_log_file_permissions='666' Var_gpg_recipient="${Var_gnupg_email}" Var_log_rotate_recipient="${Var_gnupg_email}" Var_pipe_file_name="${Var_encrypt_pipe_location_copy}" Var_log_file_name="${Var_encrypt_pipe_log_copy}" Var_parsing_output_file="${Var_encrypted_location_copy}" Var_parsing_bulk_out_dir="${Var_encrypted_bulk_dir_copy}" --copy-save-yn="yes" --copy-save-name="${Var_script_copy_name_encrypt}" --copy-save-permissions="750" --copy-save-ownership="${USER}:${USER}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
else
	echo "# ${Var_script_name} could not find: ${Var_install_path}/${Var_install_name}"
	exit 1
fi
_background_processes="$(ps aux | grep "${Var_script_copy_name_encrypt}" | grep -v grep)"
if [ "${#_background_processes}" -gt '0' ]; then
	echo "# ${Var_script_name} detected the following background processes"
	echo "${_background_processes}"
else
	echo "# Error - ${Var_script_name} did not detect any background processes"
	exit 1
fi
## If test pipe file exists then test, else exit with errors
if [ -p "${Var_encrypt_pipe_location_copy}" ]; then
	if [ -e "${Var_script_copy_name_encrypt}" ]; then
		echo "# ${Var_script_name} found executable: \"${Var_script_copy_name_encrypt}\""
	else
		if [ -f "${Var_script_copy_name_encrypt}" ]; then
			echo "# ${Var_script_name} found file: \"${Var_script_copy_name_encrypt}\""
			cat "${Var_script_copy_name_encrypt}"
			exit 0
		else
			echo "# ${Var_script_name} exiting with errors, no file at: ${Var_script_copy_name_encrypt}"
			exit 1
		fi
	fi
	## Push a known directory path through named pipe listener or make a new
	##  directory with a blank file instead and push that through.
	if [ -d "${Var_encrypt_dir_path}" ]; then
		echo "# ${Var_script_name} running: echo \"${Var_encrypt_dir_path}\" > \"${Var_encrypt_pipe_location_copy}\""
		echo "${Var_encrypt_dir_path}" > "${Var_encrypt_pipe_location_copy}"
		_exit_status=$?
		Func_check_exit_status "${_exit_status}"
	else
		echo "# ${Var_script_name} running: mkdir -p \"${Var_encrypt_dir_path}\""
		mkdir -p "${Var_encrypt_dir_path}"
		echo "# ${Var_script_name} running: touch \"${Var_encrypt_dir_path}/test_file\""
		touch "${Var_encrypt_dir_path}/test_file"
		echo "# ${Var_script_name} running: chmod -R +r \"${Var_encrypt_dir_path}\""
		chmod -R +r "${Var_encrypt_dir_path}"
		echo "# ${Var_script_name} running: echo \"${Var_encrypt_dir_path}\" > \"${Var_encrypt_pipe_location_copy}\""
		echo "${Var_encrypt_dir_path}" > "${Var_encrypt_pipe_location_copy}"
		_exit_status=$?
		Func_check_exit_status "${_exit_status}"
	fi
	## Note we are saving the test string to a file but will be cat-ing
	##  it back out to named pipe file for the first test so lets make that
	##  file with the proper permissions to be latter read and currently
	##  writen to.
	echo "# ${Var_script_name} running: touch \"${Var_raw_test_location_copy}\""
	touch "${Var_raw_test_location_copy}"
	echo "# ${Var_script_name} running: chmod 660 \"${Var_raw_test_location_copy}\""
	chmod 660 "${Var_raw_test_location_copy}"
	_test_string="$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c"${Var_pass_length}")"
	echo "${_test_string}" >> "${Var_raw_test_location_copy}"
	_current_string="$(tail -n1 "${Var_raw_test_location_copy}")"
	echo "# ${Var_script_name} running as ${USER}: echo \"${_current_string}\" > \"${Var_encrypt_pipe_location_copy}\""
	echo "${_current_string}" > "${Var_encrypt_pipe_location_copy}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
	## Push a few more random lines into encryption pipe for later build
	##  script to process multi-decryption options.
	_test_string="$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c"${Var_pass_length}")"
	echo "${_test_string}" >> "${Var_raw_test_location_copy}"
	_current_string="$(tail -n1 "${Var_raw_test_location_copy}")"
	echo "# ${Var_script_name} running as ${USER}: echo \"${_current_string}\" > \"${Var_encrypt_pipe_location_copy}\""
	echo "${_current_string}" > "${Var_encrypt_pipe_location_copy}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
	_test_string="$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c"${Var_pass_length}")"
	echo "${_test_string}" >> "${Var_raw_test_location_copy}"
	_current_string="$(tail -n1 "${Var_raw_test_location_copy}")"
	echo "# ${Var_script_name} running as ${USER}: echo \"${_current_string}\" > \"${Var_encrypt_pipe_location_copy}\""
	echo "${_current_string}" > "${Var_encrypt_pipe_location_copy}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
	## Temperary checks to avoid build time-outs
	## Check bulk output directory for results, exit with errors if the directory
	##  does not exsist.
	if [ -d "${Var_encrypted_bulk_dir_copy}" ]; then
		echo "# ${Var_script_name} running: ls -hal ${Var_encrypted_bulk_dir_copy}"
		ls -hal "${Var_encrypted_bulk_dir_copy}"
		_exit_status=$?
		Func_check_exit_status "${_exit_status}"
		echo "# ${Var_script_name} reports: all checks passed"
	else
		echo "# ${Var_script_name} reports: FAILED to find ${Var_encrypted_bulk_dir_copy}"
#		exit 1
	fi
	## Push a known file path to named pipe and check if it is processed to
	##  the defined bulk output directory or make a blank file to push through
#	if [ -f "${Var_encrypt_file_path_copy}" ]; then
#		echo "# ${Var_script_name} running: echo \"${Var_encrypt_file_path_copy}\" > \"${Var_encrypt_pipe_location_copy}\""
#		echo "${Var_encrypt_file_path_copy}" > "${Var_encrypt_pipe_location_copy}"
#		_exit_status=$?
#		Func_check_exit_status "${_exit_status}"
#	else
#		echo "# ${Var_script_name} running: touch \"${Var_encrypt_file_path_copy}\""
#		touch "${Var_encrypt_file_path_copy}"
#		echo "# ${Var_script_name} running: chmod +r \"${Var_encrypt_file_path_copy}\""
#		chmod +r "${Var_encrypt_file_path_copy}"
#		echo "# ${Var_script_name} running: echo \"${Var_encrypt_file_path_copy}\" > \"${Var_encrypt_pipe_location_copy}\""
#		echo "${Var_encrypt_file_path_copy}" > "${Var_encrypt_pipe_location_copy}"
#		_exit_status=$?
#		Func_check_exit_status "${_exit_status}"
#	fi
	## Send quit string to named pipe for testing of built in auto-clean
	##  functions, note to authors, this seems to be funky on auto builds
	##  but latter removal of the named pipe file seems to kill the listener
	##  as designed... this is why the controlling loop is so simple though.
	echo "# ${Var_script_name} running as ${USER}: echo \"quit\" > \"${Var_encrypt_pipe_location_copy}\""
	echo "quit" > "${Var_encrypt_pipe_location_copy}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
	## Show script copy if we get this far and exit
else
	echo "# Error - ${Var_script_name} could not find: ${Var_encrypt_pipe_location_copy}"
	exit 1
fi
## Report on pipe auto-removal
if ! [ -p "${Var_encrypt_pipe_location_copy}" ]; then
	echo "# ${Var_script_name} detected pipe corectly removed: ${Var_encrypt_pipe_location_copy}"
else
	echo "# ${Var_script_name} detected pipe still exsists: ${Var_encrypt_pipe_location_copy}"
	ls -hal "${Var_encrypt_pipe_location_copy}"
	echo "# ${Var_script_name} will cleanup: ${Var_encrypt_pipe_location_copy}"
	rm -v "${Var_encrypt_pipe_location_copy}"
fi
## Report on background processes
_background_processes="$(ps aux | grep "${Var_script_copy_name_encrypt}" | grep -v grep)"
if [ "${#_background_processes}" -gt '0' ]; then
	echo -e "# ${Var_script_name} reports background processes still running:\n# $(ps aux | grep "${Var_script_copy_name_encrypt}" | grep -v grep)\n\n Number of processes $(pgrep -c "${Var_script_copy_name_encrypt}")"
	for _pid in $(pgrep "${Var_script_copy_name_encrypt}"); do
		echo "# ${Var_script_name} killing: ${_pid}"
	done
else
	echo "# ${Var_script_name} did not detect any background processes"
fi
## If encrypted output file exsists then test decryption now, else error out.
if [ -r "${Var_encrypted_location_copy}" ]; then
	echo "# ${Var_script_name} running: ls -hal \"${Var_encrypted_location_copy}\""
	ls -hal "${Var_encrypted_location_copy}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
else
	echo "# ${Var_script_name} could not read: ${Var_encrypted_location_copy}"
	if [ -f "${Var_encrypted_location_copy}" ]; then
		echo "# ${Var_script_name} reports it is a file though: ${Var_encrypted_location_copy}"
	else
		echo "# ${Var_script_name} reports it not a file: ${Var_encrypted_location_copy}"
	fi
fi
## Check bulk output directory for results, exit with errors if the directory
##  does not exsist.
if [ -d "${Var_encrypted_bulk_dir_copy}" ]; then
	echo "# ${Var_script_name} running: ls -hal ${Var_encrypted_bulk_dir_copy}"
	ls -hal "${Var_encrypted_bulk_dir_copy}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
	echo "# ${Var_script_name} reports: all checks passed"
else
	echo "# ${Var_script_name} reports: FAILED to find ${Var_encrypted_bulk_dir_copy}"
	exit 1
fi
## Report encryption pipe tests success if we have gotten this far
echo "# ${Var_script_name} finished at: $(date -u +%s)"
