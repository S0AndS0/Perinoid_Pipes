#!/usr/bin/env bash
Fold_Message(){
	_message=( "${@}" )
	_column_width='76'
	_folded_message=$(fold -sw ${_column_width} <<<"${_message[*]}")
	echo -e "${_folded_message}"
}
if [ "${#@}" -gt "0" ]; then
	Fold_Message "${@}"
fi
