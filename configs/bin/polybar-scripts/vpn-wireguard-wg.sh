#!/usr/bin/env sh

CONFIG_PATH=~/wg/wg-aruba.conf

SHOW_NAME=false #Show connection name instead of CONNECTED_TEXT

CONNECTED_ICON="%{T7}%{T-}"
CONNECTED_TEXT=""

DISCONNECTED_ICON="%{T7}劣%{T-}"
DISCONNECTED_TEXT=""

if [ ! -f $CONFIG_PATH ]; then
	echo "$DISCONNECTED_ICON Config file not found"
	exit 0
fi

CONFIG_NAME=$(basename "${CONFIG_PATH%.*}")
WG_RESULT=$(sudo wg show "$CONFIG_NAME" 2>/dev/null | head -n 1 | awk '{print $NF }')

if [ "$WG_RESULT" = "$CONFIG_NAME" ]; then
	CONNECTED=true
else
	CONNECTED=false
fi

case "$1" in
--toggle)
	FULL_CONFIG_PATH="$(readlink -f "$CONFIG_PATH")"

	if $CONNECTED; then
		sudo wg-quick down "$FULL_CONFIG_PATH" 2>/dev/null
	else
		sudo wg-quick up "$FULL_CONFIG_PATH" 2>/dev/null
	fi
	;;
*)
	if $CONNECTED; then
		if $SHOW_NAME; then
			CONNECTED_TEXT=$CONFIG_NAME
		fi
		echo "$CONNECTED_ICON""$CONNECTED_TEXT"
	else
		echo "$DISCONNECTED_ICON""$DISCONNECTED_TEXT"
	fi
	;;
esac
