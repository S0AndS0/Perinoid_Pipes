#!/usr/bin/env bash
## The following variable should be your encrypted file that has been appended to.
Var_input_file="${1?No input file to read?}"
## The following variable should be your named pipe for decrypting
Var_output_file="${2:-/tmp/out.log}"
## You may assign the above at run-time using the following example call to
##  this script: script_name.sh "/path/to/input" "/path/to/output"
Var_search_output="$3"
Arr_gpg_opts=( --decrypt )
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
		##  append end of line to ${_arr_to_parse[@]} and push it though
		##  parsing function. Else append the next line read to
		##  ${_arr_to_parse[@]} and loop agian. This stops when the total
		##  number of read lines equals the number of countable lines
		##  enteracted with.
		if [ "${_end_of_line}" = "${_arr_input[${_count}]}" ]; then
			_arr_to_parse+=( "${_arr_input[${_count}]}" )
			let _count++
			Do_stuff_with_lines "${_arr_to_parse[@]}"
			unset -v _arr_to_parse[@]
		else
			## If current index is greater then '0' then append to
			##  the array, else make/re-make array.
			if [ "${#_arr_to_parse[@]}" -gt "0" ]; then
				_arr_to_parse+=( "${_arr_input[${_count}]}" )
				let _count++
			else
				_arr_to_parse=( "${_arr_input[${_count}]}" )
				let _count++
			fi
		fi

	done
	unset _count
}
Expand_array_to_block(){
	_input=( "$@" )
	let _count=0
	until [ "${_count}" = "${#_input[@]}" ]; do
		echo "${_input[${_count}]}"
		let _count++
	done
	unset _count
}
Do_stuff_with_lines(){
#	_enc_input=( "$@" )
	_enc_block=( "$@" )
	_enc_input=$(Expand_array_to_block "${_enc_block[@]}" )
	
	## TO-DO -- Remove following output line after remote tests
	echo "${_enc_input[@]}"
	## If using a named pipe to preform decryption then push encrypted array
	##  through named pipe's input for use, if output is a file then use
	##  above decrypting command and append to the file. Else output
	##  decryption to terminal.
	if [ -p "${Var_output_file}" ]; then
		cat <<<"${_enc_input[@]}" > "${Var_output_file}"
	elif [ -f "${Var_output_file}" ]; then
		if [ "${#Var_search_output}" = "0" ]; then
			cat <<<"${_enc_input[@]}" | gpg ${Arr_gpg_opts[*]} >> "${Var_output_file}"
		else
			cat <<<"${_enc_input[@]}" | gpg ${Arr_gpg_opts[*]} | grep -E "${Var_search_output}" >> "${Var_output_file}"
		fi
	else
		if [ "${#Var_search_output}" = "0" ]; then
			cat <<<"${_enc_input[@]}" | gpg ${Arr_gpg_opts[*]}
		else
			cat <<<"${_enc_input[@]}" | gpg ${Arr_gpg_opts[*]} | grep -E "${Var_search_output}"
		fi
	fi
}
Main_func(){
	Func_spoon_feed_pipe_decryption "${Var_input_file}"
}
Main_func
