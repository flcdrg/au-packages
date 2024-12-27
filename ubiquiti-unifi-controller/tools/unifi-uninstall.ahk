#Requires AutoHotkey 2
if WinWait("UniFi Network Server Uninstall", , 30)
    ControlSend "!y", "Button1", "UniFi Network Server Uninstall"
else
    exit 1
