#Requires AutoHotkey 2
; Do you want to upgrade your UniFi 5.3.8 to 5.4.9?
if WinWait("UniFi Network Server Setup", , 90) {
    ControlSend "{Enter}", "Button1", "UniFi Network Server Setup"
    WinWaitClose()
    ; It is recommended that you create a backup before installing a new version. Do you have a backup?
    if WinWait("UniFi Network Server Setup", , 90) {
        ControlSend "{Enter}", "Button1", "UniFi Network Server Setup"
        WinWaitClose()
    } else {
        exit 0
    }
} else {
    exit 0
}