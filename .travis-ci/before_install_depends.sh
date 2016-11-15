#!/usr/bin/env bash
export Var_script_dir="${0%/*}"
export Var_script_name="${0##*/}"
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
echo "# ${Var_script_name} started at: $(date -u +%s)"
## Add up missing dependencies to an array
for _app in ${Var_dependency_list//,/ }; do
	## The following two lines may cause build to fail do to not capturing
	##  the exit status of grep properly. Thus have been disabled for auto
	##  building processes until authors find another simple way of checking
	##  for needed dependancies.
#	grep -q "${_app}" <<<"$(sudo apt-cache policy ${_app})"
#	_exit_status=$?
#	if [ "${_exit_status}" != "0" ]; then
		Arr_needed_dependencies+=( "${_app}" )
#	fi
done
## If array holds any values run it through 'apt-get install'
if [ "${#Arr_needed_dependencies[*]}" -gt "0" ]; then
	Func_run_sanely "apt-get update -qqq" "0"
	Func_run_sanely "apt-get install -qqq ${Arr_needed_dependencies[*]}" "0"
else
	echo "# ${Var_script_name}: reports no unmet dependencies."
fi
## Start/restart haveged for VMs
Func_run_sanely "/etc/init.d/haveged restart" "0"
## Report everything is OK if errors did not cause this script to exit out.
echo "# ${Var_script_name} reports: all checks passed"
echo "# ${Var_script_name} finished at: $(date -u +%s)"
