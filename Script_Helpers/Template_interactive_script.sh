#!/usr/bin/env bash
Var_script_dir="${0%/*}"
Var_script_name="${0##*/}"
## Internal script variables that can also be set by users
Var_debug_level="0"
Var_log_level="0"
Var_script_log_path="${PWD}/${Var_script_name%.sh*}.log"
Var_columns="${COLUMNS:-80}"
## Assigne other default variables

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
Func_help(){
	echo "# ${Var_script_dir}/${Var_script_name} knows the following command line options"
	echo "# --columns		Var_columns${Var_columns}"
	echo "# --debug-level		Var_debug_level=${Var_debug_level}"
	echo "# --log-level		Var_log_level=${Var_log_level}"
	echo "# --script-log-level	Var_script_log_path=${Var_script_log_path}"
	echo "# "
}
Func_assign_arg(){
	_variable="${1}"
	_value="${2}"
	Func_message "# ${Var_script_name} running: declare -g \"${_variable}=${_value}\"" '3' '4'
	Func_message "# Func_assign_arg running: declare -g \"${_variable}=${_value}\"" '3' '4'
	declare -g "${_variable}=${_value}"
}
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
			--help|help|*)
				Func_message "# Func_check_args read variable [${_arg%=*}] with value [${_arg#*=}]" '2' '3'
				Func_help
			;;
		esac
		let _arr_count++
	done
	unset _arr_count
}
## Write functions to do stuff with assigned variables

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
