#!/usr/bin/env bash
Var_script_dir="${0%/*}"
Var_script_name="${0##*/}"
## Internal script variables that can also be set by users
Var_debug_level="0"
Var_log_level="0"
Var_script_log_path="${PWD}/${Var_script_name%.sh*}.log"
Var_columns="${COLUMNS:-$(tput cols)}"
Var_columns="${Var_columns:-80}"
Var_authors_contact='strangerthanbland@gmail.com'
Var_authors_name='S0AndS0'
Var_script_description='Does some spicific tasks'
Var_source_var_file=""
Var_script_version_main="0"
Var_script_version_sub="1111111"
Var_script_version_full="${Var_script_version_main}.${Var_script_version_sub}"
## Assigne other default variables

## Assigne default functions for handling messages,
##  user input and outputting help/documentation.
## Note the following two functions are placed here to qucker editing
Func_check_args(){
	_arr_input=( "${@}" )
	Func_message "# ${Var_script_name} parsing: ${_arr_input[*]}" '2' '3'
	let _arr_count=0
	until [ "${#_arr_input[@]}" = "${_arr_count}" ]; do
		_arg="${_arr_input[${_arr_count}]}"
		case "${_arg%=*}" in
			--debug-level|Var_debug_level)
				Func_assign_arg "Var_debug_level" "${_arg#*=}"
			;;
			--log-level|Var_log_level)
				Func_assign_arg "Var_log_level" "${_arg#*=}"
			;;
			--script-log-path|Var_script_log_path)
				Func_assign_arg "Var_script_log_path" "${_arg#*=}"
			;;
			--columns|Var_columns)
				Func_assign_arg "Var_columns" "${_arg#*=}"
			;;
			--source-var-file|Var_source_var_file)
				Func_assign_arg "Var_source_var_file" "${_arg#*=}"
				if [ -f "${Var_source_var_file}" ]; then
					Func_message "# ${Var_script_name} running: source \"${Var_source_var_file}\"" '2' '3'
					source "${Var_source_var_file}"
				fi
			;;
			---*)
				_extra_var="${_arg%=*}"
				_extra_arg="${_arg#*=}"
				Func_assign_arg "${_extra_var/---/}" "${_arg#*=}"
			;;
			--help|help)
				Func_message "# Func_check_args read variable [${_arg%=*}] with value [${_arg#*=}]" '2' '3'
				Func_help
				exit 0
			;;
			--license)
				Func_script_license_customizer
				exit 0
			;;
			--version)
				echo "# ${Var_script_name} version: ${Var_script_version_full}"
				exit 0
			;;
			*)
				Func_message "# " '2' '3'
				declare -ag "Arr_extra_input+=( ${_arg} )"
			;;
		esac
		let _arr_count++
	done
	unset _arr_count
}
Func_help(){
	echo "# ${Var_script_dir}/${Var_script_name} knows the following command line options"
	echo "# --columns		Var_columns=\"${Var_columns}\""
	echo "# --debug-level		Var_debug_level=\"${Var_debug_level}\""
	echo "# --log-level		Var_log_level=\"${Var_log_level}\""
	echo "# --script-log-level	Var_script_log_path=\"${Var_script_log_path}\""
	echo "# --source-var-file	Var_source_var_file=\"${Var_source_var_file}\""
	echo "# --license		Display the license for this script."
	echo "# --help			Display this message."
	echo "# --version		Display version for this script."
}
## Note the following three functions should not need much editing
Func_script_license_customizer(){
	Func_message "## Salutations ${Var_script_current_user:-${USER}}, the following license" '0' '42'
	Func_message "#  only applies to this script [${Var_script_title}]. Software external to but" '0' '42'
	Func_message '#  used by [${Var_script_name}] are protected under their own licensing' '0' '42'
	Func_message "#  usage agreements. The authors of this project assume **no** rights" '0' '42'
	Func_message '#  to modify software licensing agreements external to [${Var_script_name}]' '0' '42'
	Func_message '## GNU AGPL v3 Notice start' '0' '42'
	Func_message "# ${Var_script_name}, ${Var_script_description}" '0' '42'
	Func_message "#  Copyright (C) 2016 ${Var_authors_name}" '0' '42'
	Func_message '# This program is free software: you can redistribute it and/or modify' '0' '42'
	Func_message '#  it under the terms of the GNU Affero General Public License as' '0' '42'
	Func_message '#  published by the Free Software Foundation, version 3 of the' '0' '42'
	Func_message '#  License.' '0' '42'
	Func_message '# You should have received a copy of the GNU Afferno General Public License' '0' '42'
	Func_message '# along with this program. If not, see <http://www.gnu.org/licenses/>.' '0' '42'
	Func_message "#  Contact authors of [${Var_script_name}] at: ${Var_authors_contact}" '0' '42'
	Func_message '# GNU AGPL v3 Notice end' '0' '42'
	if [ -r "${Var_script_dir}/Licenses/GNU_AGPLv3_Code.md" ]; then
		Func_message '## Found local license file, prompting to display...' '0' '42'
		Func_prompt_continue "Func_script_license_customizer"
		less -R5 "${Var_script_dir}/Licenses/GNU_AGPLv3_Code.md"
	else
		${Var_echo_exec_path} -en "Please input the downloaded source directory for ${Var_script_name}: "
		read -r _responce
		if [ -d "${_responce}" ] && [ -r "${_responce}/Licenses/GNU_AGPLv3_Code.md" ]; then
			Func_message '## Found local license file, prompting to display...' '0' '42'
			Func_prompt_continue "Func_script_license_customizer"
			fold -sw $((${Var_columns_width}-8)) "${_responce}/Licenses/GNU_AGPLv3_Code.md" | less -R5
		else
			Func_message '## Unable to find full license, see linke in above short version or find full license under downloaded source directory for this script.' '0' '42'
		fi
	fi
}
Func_message(){
	_message="${1}"
	_debug_level="${2:-${Var_debug_level}}"
	_log_level="${3:-${Var_log_level}}"
	if [ "${#_message}" != "0" ]; then
		if [ "${_debug_level}" = "${Var_debug_level}" ] || [ "${Var_debug_level}" -gt "${_debug_level}" ]; then
			_folded_message="$(fold -sw $((${Var_columns}-6)) <<<"${_message}" | sed -e "s/^.*$/$(echo -n "#DBL-${_debug_level}") &/g")"
			cat <<<"${_folded_message}"
		fi
	fi
	if [ "${#_message}" != "0" ]; then
		if [ "${Var_log_level}" -gt "${_log_level}" ]; then
			cat <<<"${_message}" >> "${Var_script_log_path}"
		fi
	fi
}
Func_assign_arg(){
	_variable="${1}"
	_value="${2}"
	Func_message "# ${Var_script_name} running: declare -g \"${_variable}=${_value}\"" '3' '4'
	Func_message "# Func_assign_arg running: declare -g \"${_variable}=${_value}\"" '3' '4'
	declare -g "${_variable}=${_value}"
}
## Write functions to do stuff with assigned variables

## Do stuff with input and above functions inside bellow function
Func_main(){
	_input=( "$@" )
	if [ "${#_input[@]}" = "0" ]; then
		Func_message "# ${Var_script_name} running: Func_check_args \"--help\"" '1' '2'
		Func_check_args "--help"
	else
		Func_message "# ${Var_script_name} running: Func_check_args \"${_input[@]}\"" '1' '2'
		Func_check_args "${_input[@]}"
	fi
	unset -v _input[@]
	## Do stuff with assigned variables

}
Func_message "# ${Var_script_name} running: Func_main \"\$@\"" '0' '1'
Func_main "$@"
Func_message "# ${Var_script_name} finished at: $(date)" '0' '1'
