#! /bin/bash

# Portions Copyright (c) 2022 HudsonOnHere
# Portions Copyright (c) 2022 pesqair

# Forked from pesqair/network-check - https://github.com/pesqair/network-check
# Originally released under the MIT License
# This software is provided "as-is", with no warranties or guarantees of any kind


readonly WIFI_INTERFACE=$(
	networksetup -listallhardwareports \
	| grep -A 1 "Wi-Fi" \
	| grep "Device:" \
	| awk '{print $2}'
	)

# readonly WIRED_INTERFACE=$(
# 	networksetup -listallhardwareports \
# 	| grep -A 1 "Ethernet" \
# 	| grep "Device:" \
# 	| awk '{print $2}'
# 	) # Doesn't work as intended with a docking station, see comment below

readonly WIRED_INTERFACE=$(
	networksetup -listallhardwareports \
	| grep -A 1 "LAN" \
	| grep "Device:" \
	| awk '{print $2}'
	)

readonly WIFI_STATUS=$(
	ifconfig $WIFI_INTERFACE \
	| grep "status" \
	| awk '{print $2}'
	)

readonly WIRED_STATUS=$(
	ifconfig $WIRED_INTERFACE \
	| grep status \
	| awk '{print $2}'
	)


wiredIsConnected() {

	if [[ "${WIRED_STATUS}" == "active" ]];then
		return 1

	# elif [[ "${WIRED_STATUS}" == "inactive" ]]; then
	# it would be nice if it worked this way, but ifconfig will not return the above expected result when disconnected
	# tested on a docking station, may be different in other cases.
	# the open ended return 0 should work across a variety of hardware configs.

	else
		return 0

	fi
}

wifiIsConnected() {

	if [[ "${WIFI_STATUS}" == "active" ]]; then
		return 1

	elif [[ "${WIFI_STATUS}" == "inactive" ]]; then
		return 0

	else
		exit 1

	fi
}

turnOffWifi() {

	# Comment out the below osascript if you want to disable the notification toasts
	osascript -e 'display notification "Ethernet connected, turning off Wi-Fi..." with title "Network Status" sound name "Glass.aiff"'
	networksetup -setairportpower $WIFI_INTERFACE off
}

turnOnWifi() {

	networksetup -setairportpower $WIFI_INTERFACE on
	# Comment out the below osascript if you want to disable the notification toasts
	osascript -e 'display notification "Ethernet disconnected, turning on Wi-Fi..." with title "Network Status" sound name "Glass.aiff"'
}

main() {

	if ! wiredIsConnected && ! wifiIsConnected; then
		turnOffWifi

	elif wiredIsConnected && wifiIsConnected; then
		turnOnWifi

	fi

}

main