#!/usr/bin/env bash
Var_script_dir="${0%/*}"
Var_script_name="${0##*/}"
## Source shared variables and functions into this script.
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
echo "# ${Var_script_name} started at: $(date -u +%s)"
echo "# ${Var_script_name} running: chmod u+x Script_Helpers/GnuPG_Gen_Key.sh"
chmod u+x Script_Helpers/GnuPG_Gen_Key.sh
echo "# ${Var_script_name} running: Script_Helpers/GnuPG_Gen_Key.sh --prompt-for-pass-yn='no' --auto-pass-length=\"${Var_pass_length}\" --save-pass-yn='yes' --save-pass-location=\"${Var_pass_location}\" --gnupg-conf-save-yn='yes' --gnupg-email=\"${Var_gnupg_email}\" --gnupg-export-private-key-yn='yes'"
Script_Helpers/GnuPG_Gen_Key.sh --prompt-for-pass-yn='no' --auto-pass-length="${Var_pass_length}" --save-pass-yn='yes' --save-pass-location="${Var_pass_location}" --gnupg-conf-save-yn='yes' --gnupg-email="${Var_gnupg_email}" --gnupg-export-private-key-yn='yes'
echo "# ${Var_script_name} finished at: $(date -u +%s)"
