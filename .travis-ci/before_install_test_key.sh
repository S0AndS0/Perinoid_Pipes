#!/usr/bin/env bash
export Var_script_dir="${0%/*}"
export Var_script_name="${0##*/}"
## Source shared variables and functions into this script.
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
_test_string=$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c"${Var_pass_length}")
_test_encryption_opts="--recipient ${Var_gnupg_email} --encrypt <<<${_test_string} --output ${Var_test_gpg_location}"
_test_decryption_opts="--passphrase-file ${Var_pass_location} --decrypt ${Var_test_gpg_location} --output ${Var_test_raw_location}"
# ${Var_gnupg_email}
# ${Var_test_gpg_location}
# ${Var_test_raw_location}
# ${Var_pass_location}
## Try encrypting text to new key
Func_run_sanely "gpg ${_test_encryption_opts}" "${USER}"
Func_run_sanely "gpg ${_test_decryption_opts}" "${USER}"
_test_string_decrypted=$(cat ${Var_test_raw_location})
if [[ "${_test_string}" == "${_test_string_decrypted}" ]]; then
	echo "# ${Var_script_name} reports all checks: OK"
	echo "# ${Var_script_name}: [${_test_string}] = [${_test_string_decrypted}]"
else
	echo "# ${Var_script_name} reports all checks: Not ok"
	echo "# ${Var_script_name} could not finde equivalance between: [${_test_string}] & [${_test_string_decrypted}]"
fi
echo "# ${Var_script_name} finished at: $(date -u +%s)"
