@echo off

set ADB=files\adb
set LISTFOLDER=files
set TMPFOLDER=/data/local/tmp

%ADB% kill-server
%ADB% start-server
%ADB% wait-for-device

for /F "delims=" %%a in ('%ADB% shell getprop ro.product.device') do set DEVICE=%%a
for /F "delims=" %%a in ('%ADB% shell getprop ro.build.product') do set PRODUCT=%%a
for /F "delims=" %%a in ('%ADB% shell getprop ro.build.id') do set ID=%%a

echo.
echo Detected: %DEVICE% (%PRODUCT%)
echo Firmware: %ID%

echo.
echo Copying files. . .


%ADB% shell rm -f %TMPFOLDER%/aapt_arm_pie > NUL 2> NUL
%ADB% shell rm -f %TMPFOLDER%/list_apps_info.sh > NUL 2> NUL
%ADB% shell rm -f %TMPFOLDER%/installed-apps-info.txt > NUL 2> NUL
del installed-apps-info.txt > NUL 2> NUL

%ADB% push %LISTFOLDER%/aapt_arm_pie %TMPFOLDER% > NUL 2> NUL
%ADB% push %LISTFOLDER%/list_apps_info.sh %TMPFOLDER% > NUL 2> NUL

%ADB% shell chmod 0755 %TMPFOLDER%/aapt_arm_pie
%ADB% shell chmod 0777 %TMPFOLDER%/list_apps_info.sh

echo.
echo Generating installed apps info list (wait a minute or two). . .
%ADB% shell sh %TMPFOLDER%/list_apps_info.sh
%ADB% pull %TMPFOLDER%/installed-apps-info.txt > NUL 2> NUL
If NOT exist installed-apps-info.txt (
	echo.
	echo Error!
	echo "installed-apps-info.txt" file could not be created!!
	
	%ADB% kill-server

	echo.
	pause
	exit
)
echo Done!

echo.
echo "installed-apps-info.txt" file created successfully!!

echo.
echo Cleaning. . .
%ADB% shell rm -f %TMPFOLDER%/aapt_arm_pie > NUL 2> NUL
%ADB% shell rm -f %TMPFOLDER%/list_apps_info.sh > NUL 2> NUL
%ADB% shell rm -f %TMPFOLDER%/installed-apps-info.txt > NUL 2> NUL

echo.
echo Finished!

%ADB% kill-server

echo.
pause
