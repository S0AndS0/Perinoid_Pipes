#!/usr/bin/env bash
export Var_script_dir="${0%/*}"
export Var_script_name="${0##*/}"
## Source shared variables and functions into this script.
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
## Generate temp-key pare for testing encryption with public key operations.
##  Note that using 'Func_run_sanely' with bellow 'echo' and 'Func_gen_gnupg_test_keys'
##  will revial temperary passphrase used **and** must be run as the same user
##  that called this script.
#_pass_phrase=$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c"${Var_pass_length}")
#echo "${_pass_phrase}" > ${Var_pass_location}
#Func_gen_gnupg_test_keys "$(cat ${Var_pass_location})"
#echo "# ${Var_script_name} finished at: $(date -u +%s)"
## Modified above to use helper script with customized options from shared
##  variables for auto builds.
echo "# ${Var_script_name} started at: $(date -u +%s)"
echo "# ${Var_script_name} running: chmod u+x Script_Helpers/GnuPG_Gen_Key.sh"
chmod u+x Script_Helpers/GnuPG_Gen_Key.sh
echo "# ${Var_script_name} running: Script_Helpers/GnuPG_Gen_Key.sh --prompt-for-pass-yn='no' --auto-pass-length=\"${Var_pass_length}\" --save-pass-yn='yes' --save-pass-location=\"${Var_pass_location}\" --gnupg-email=\"${Var_gnupg_email}\""
Script_Helpers/GnuPG_Gen_Key.sh --prompt-for-pass-yn='no' --auto-pass-length="${Var_pass_length}" --save-pass-yn='yes' --save-pass-location="${Var_pass_location}" --gnupg-email="${Var_gnupg_email}"
echo "# ${Var_script_name} finished at: $(date -u +%s)"
