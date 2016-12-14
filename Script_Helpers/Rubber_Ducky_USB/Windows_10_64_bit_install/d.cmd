@echo off
@cls
REM To turn on and off capslock LED to notify user that stager script has started
REM by sending : $wsh.SendKeys('{CAPSLOCK}');sleep -m 250;
REM Both "NUMLOCK" & "SCROLLOCK" *should* work on supported devices too
REM The state of the LED is stored on the host and not on the keyboard ;-)
start /b /wait powershell.exe -nologo -WindowStyle Hidden -sta -command "$wsh = New-Object -ComObject WScript.Shell;$wsh.SendKeys('{CAPSLOCK}');sleep -m 250;$wsh.SendKeys('{CAPSLOCK}');sleep -m 250;$wsh.SendKeys('{CAPSLOCK}');sleep -m 250;$wsh.SendKeys('{CAPSLOCK}');sleep -m 250;"
REM Example bellow runs following script that auto backgrounds the e.cmd script
cscript %~d0\i.vbs %~d0\e.cmd
REM the above %~d0\ is required for portability
@exit
