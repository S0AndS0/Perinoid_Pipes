#!/usr/bin/env bash
export Var_script_dir="${0%/*}"
export Var_script_name="${0##*/}"
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
Func_run_sainly "apt-get update" "0"
## Add up missing dependencies to an array
for _app in ${Var_dependency_list//,/ }; do
	grep -qiE "${_app}" <<<"$(apt-cache policy "${_app}")"
	if [ "$?" != "0" ]; then
		Arr_needed_dependencies+=( "${_app}" )
	fi
done
## If array holds any values run it through 'apt-get install'
if [ "${#Arr_needed_dependencies[*]}" -gt "0" ]; then
	Func_run_sanely "apt-get install -qq ${Arr_needed_dependencies[*]}" "0"
else
	echo "# ${Var_script_name}: reports no unmet dependencies."
fi
echo "# ${Var_script_name} finished at: $(date -u +%s)"
