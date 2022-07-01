# network-check
If WiFi is connected after connecting wired network, disconnect from SSID. Once wired network is disconnected, connect WIFI to last SSID.

Tested on macOS Monterey 12.4

local.network_check.plist runs by watching path /private/var/run/resolv.conf for changes. Once a change is detected (network devices changed) it runs the network_check script. 

