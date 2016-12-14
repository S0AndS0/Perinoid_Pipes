#!/usr/bin/env bash
Var_script_dir="${0%/*}"
Var_script_name="${0##*/}"
Var_old_pwd="${PWD}"
Var_start_date="$(date -u +%s)"
Var_project_url="https://github.com/S0AndS0/Perinoid_Pipes"
Var_project_main_script_name="Paranoid_Pipes.sh"
## Atempt to correct slash direction differances between OS enviroments
Var_target="${1//\\//}"
Var_destination="${2//\\//}"
Var_pipe_name="${3:-encrypter.pipe}"
## Set veriables for where public key files can be found
Var_parsing_pub_key="${Var_script_dir}/parser.asc"
Var_rotate_pub_key="${Var_script_dir}/rotate.asc"
## Set veriables of where files and directories will be generated
Var_log_file="${Var_destination}/${Var_start_date}_encrypter.log"
Var_parsing_recipient=""
Var_rotate_recipient=""
Var_script_copy_destination="${Var_destination}/${Var_start_date}_encrypter.sh"
Var_pipe_location="${Var_destination}/${Var_pipe_name}"
Var_bulk_dir="${Var_destination}/${Var_start_date}_encrypter_bulk"
Var_output_file="${Var_destination}/${Var_start_date}_encrypter_results.gpg"
Var_quit_string="quit"
## Download project if non-exsistant
if ! [ -f "${Var_script_dir}/${Var_project_main_script_name}" ]; then
	cd "${Var_script_dir}"
	git clone ${Var_project_url}
	cp "${Var_project_url##*/}/${Var_project_main_script_name}" "${Var_script_dir}/"
else
	cd "${Var_script_dir}"
fi
## Fix executable permissions if neaded
if ! [ -e "${Var_project_main_script_name}" ]; then
	chmod u+x "${Var_project_main_script_name}"
fi
## Import public keys for encryption processes
for _key in ${Var_parsing_pub_key} ${Var_rotate_pub_key}; do
	if [ -f "${_key}" ]; then
		gpg --no-tty --command-fd 0 --import ${_key} <<EOF
trust
5
quit
EOF
	fi
done
## Write custom script copy within Var_target directory and start it
if [ -e "${Var_project_main_script_name}" ]; then
	./${Var_project_main_script_name}\
 --log-level='9'\
 --script-log-path="${Var_log_file}"\
 --enc-copy-save-yn='yes'\
 --enc-parsing-disown-yn='yes'\
 --enc-copy-save-path="${Var_script_copy_destination}"\
 --enc-pipe-file="${Var_pipe_location}"\
 --enc-parsing-bulk-out-dir="${Var_bulk_dir}"\
 --enc-parsing-output-file="${Var_output_file}"\
 --enc-parsing-recipient="${Var_parsing_recipient}"\
 --enc-parsing-output-rotate-recipient="${Var_rotate_recipient}"\
 --enc-parsing-quit-string="${Var_quit_string}"
fi
if [ -p "${Var_pipe_location}" ]; then
	echo "${Var_target}" > "${Var_pipe_location}"
	echo "${Var_quit_string}" > "${Var_pipe_location}"
fi
