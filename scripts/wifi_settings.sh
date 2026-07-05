# Get a list of available wifi connections and morph it into a nice-looking list
wifi_raw=$(nmcli -t -f "IN-USE,SECURITY,SSID,BSSID,SIGNAL,CHAN" device wifi list | sed 's/\\:/__COLON__/g; s/:/|/g; s/__COLON__/:/g')
wifi_entries=$(echo "$wifi_raw" | while IFS="|" read -r in_use security ssid bssid signal channel; do
	if [ -z "$ssid" ]; then
		ssid="<hidden>"
	fi

	if [ "$in_use" = "*" ]; then
		current="●"
		sort_key="0"
	else
		current=" "
		sort_key="1"
	fi

	display=$(printf "%-2s %-32s %4s%%" "$current" "$ssid" "$signal")
	echo "$sort_key|$display|$ssid|$bssid|$security"
done | sort -s -t "|" -k1,1n | cut -d "|" -f 2-)
wifi_list=$(echo "$wifi_entries" | cut -d "|" -f 1)

connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
	toggle="   󰖪  Disable Wi-Fi"
elif [[ "$connected" =~ "disabled" ]]; then
	toggle="   󰖩  Enable Wi-Fi"
fi

# Use rofi to select wifi network
chosen_network=$(echo -e "$toggle\n$wifi_list" | rofi -dmenu -i -selected-row 1 -p "Wi-Fi SSID: " )
# Get name of connection
chosen_entry=$(echo "$wifi_entries" | awk -F "|" -v display="$chosen_network" '$1 == display {print; exit}')
chosen_id=$(echo "$chosen_entry" | awk -F "|" '{print $2}')
chosen_bssid=$(echo "$chosen_entry" | awk -F "|" '{print $3}')
chosen_security=$(echo "$chosen_entry" | awk -F "|" '{print $4}')

if [ "$chosen_network" = "" ]; then
	exit
elif [ "$chosen_network" = "   󰖩  Enable Wi-Fi" ]; then
	nmcli radio wifi on
elif [ "$chosen_network" = "   󰖪  Disable Wi-Fi" ]; then
	nmcli radio wifi off
elif [ -z "$chosen_entry" ]; then
	exit
else
	# Message to show when connection is activated successfully
  	success_message="Connected to \"$chosen_id\""
	# Get saved connections
	saved_connections=$(nmcli -g NAME connection)
	if [[ $(echo "$saved_connections" | grep -Fx "$chosen_id") = "$chosen_id" ]]; then
		nmcli device wifi connect "$chosen_id" bssid "$chosen_bssid" | grep "successfully" && notify-send "Network" "$success_message" --icon ~/.config/eww/icons/wifi-solid.svg
	else
		if [ -n "$chosen_security" ] && [ "$chosen_security" != "--" ]; then
			wifi_password=$(rofi -dmenu -config ~/.config/rofi/config-password.rasi -p "∂")
		fi
		nmcli device wifi connect "$chosen_id" password "$wifi_password" bssid "$chosen_bssid" | grep "successfully" && notify-send "Network" "$success_message" --icon ~/.config/eww/icons/wifi-solid.svg    
  fi
fi
