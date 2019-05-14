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
%ADB% shell "settings put global captive_portal_https_url https://captive.v2ex.co/generate_204";
%ADB% reboot

%ADB% kill-server