# Network AutoSwitcher

Automatically power off WiFi when connected to Ethernet, power back on when disconnected from Ethernet -- Tested on macOS Monterey 12.4

Forked from [pesqair/network-check](https://github.com/pesqair/network-check), check out his [blog post](https://it.digitaino.com/network-check/) that inspired this project.

### Getting Started

***Some assembly may be required*** -- Depending on your hardware configuration (what you use to connect to ethernet), your LAN interface may have a different name, and may need tweaking for this to work. This iteration was tested using a Lenovo docking station, which macOS recognizes as `Hardware Port: ThinkPad TBT3 LAN` rather than a more traditional `Hardware Port: Ethernet` you may see on a desktop with dedicated ethernet ports.

1. Clone this repo and `cd` into it.
2. run `./setup.sh --install` to install the script to `/Users/Shared/network_autoswitcher.sh` and load the .plist in `launchctl`.
3. That's it!

Assuming all goes according to plan, the script should automatically run whenever a change is detected in the following locations:
* `/etc/resolv.conf`
* `/Library/Preferences/SystemConfiguration/NetworkInterfaces.plist`
* `/Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist`

If you're connected to Ethernet & WiFi, WiFi will be turned off. When you disconnect from Ethernet, WiFi will be turned back on.

### Uninstall

If this isn't for you, or you just need to uninstall it, you can use the `setup.sh --uninstall` to remove the script and launch agents.