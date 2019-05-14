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
echo Activating Brevent
%ADB% -d shell sh /data/data/me.piebridge.brevent/brevent.sh

%ADB% kill-server

pause