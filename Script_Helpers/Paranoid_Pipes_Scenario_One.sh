#!/usr/bin/env bash
## The following variable should be your encrypted file that has been appended to.
Var_input_file="${1?No input file to read?}"
## The following variable should be your named pipe for decrypting
Var_output_file="${2:-/tmp/out.log}"
## You may assign the above at run-time using the following example call to
##  this script: script_name.sh "/path/to/input" "/path/to/output"
Var_search_output="$3"
Func_spoon_feed_pipe_decryption(){
	_input=( "${@}" )
	_end_of_line='-----END PGP MESSAGE-----'
	## If input is a file then use standard redirection to mapfile command.
	##  Else use variable as file redirection trick to get mapfile to build an array from input.
	if [ -f "${_input[@]}" ]; then
		mapfile -t _arr_input < "${_input[@]}"
	else
		mapfile -t _arr_input <<<"${_input[@]}"
	fi
	## Initialize internal count that is either reset or added to in the following loop.
	let _count=0
	until [ "${_count}" = "${#_arr_input[@]}" ]; do
		## If current index in array equals ${_end_of_line} value then
		##  append end of line to ${_arr_to_parse[@]} and reset
		##  ${_arr_input} to include everything not parsed and reset the
		##  counter. Else we should append the current index to
		##  ${_arr_to_parse} and loop again until the count and array
		##  amount are equal.
		if [ "${_end_of_line}" = "${_arr_input[${_count}]}" ]; then
			_arr_to_parse+=( "${_arr_input[${_count}]}" )
			let _count++
			_arr_input=( "${_arr_input[@]:${_count}}" )
			let _count=0
		else
			_arr_to_parse+=( "${_arr_input[${_count}]}" )
			let _count++
		fi
	done
	unset _count
	## If above array has some values to parse then start feeding parsing
	##  function with an array of arrays, one array at a time.
	if [ -n "${_arr_to_parse[@]}" ]; then
		let _count=0
		until [ "${_count}" = "${#_arr_to_parse[@]}" ]; do
			Do_stuff_with_lines "${_arr_to_parse[${_count}]}"
			let _count++
		done
		unset _count
	fi
}
Do_stuff_with_lines(){
	_enc_input=( "$@" )
	## If using a named pipe to preform decryption then push encrypted array
	##  through named pipe's input for use, if output is a file then use
	##  above decrypting command and append to the file. Else output
	##  decryption to terminal.
	if [ -p "${Var_output_file}" ]; then
		cat <<<"${_enc_input[@]}" > "${Var_output_file}"
	elif [ -f "${Var_output_file}" ]; then
		if [ -z "${Var_search_output}" ]; then
			cat <<<"${_enc_input[@]}" | gpg -d >> "${Var_output_file}"
		else
			cat <<<"${_enc_input[@]}" | gpg -d | grep -E "${Var_search_output}" >> "${Var_output_file}"
		fi
	else
		if [ -z "${#Var_search_output}" ]; then
			cat <<<"${_enc_input[@]}" | gpg -d
		else
			cat <<<"${_enc_input[@]}" | gpg -d | grep -E "${Var_search_output}"
		fi
	fi
}
Main_func(){
	Func_spoon_feed_pipe_decryption "${Var_input_file}"
}
Main_func
