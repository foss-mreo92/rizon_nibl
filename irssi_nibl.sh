#!/bin/bash
# 0. Initialize
mytitle="Downloading from irc.rizon.net #NIBL"
echo -e '\033]2;'$mytitle'\007'
cd ~/Downloads/
red="$(tput setaf 1)"
green="$(tput setaf 2)"
bold="$(tput bold)"
reset="$(tput sgr0)"

# 1. Get Input
clear
echo "${bold}1. Get Input${reset}"
read -p "${green}${bold}Enter Search Query${reset} [Example, One Piece 1080p]: " input_query
input_query=$(echo ${input_query// /"%20"})
read -p "${green}${bold}Enter Episode Number${reset} [Example, 15]: " input_episodeNumber
echo

# 2. Fetch Packages
echo "${bold}2. Fetching Packages${reset}"
packageRequest_url=$(echo "https://api.nibl.co.uk/nibl/search?query=$input_query&episodeNumber=$input_episodeNumber")
packageRequest=$(curl -s -X GET --header 'Accept: application/json' "$packageRequest_url")
packageRequest_status=$(echo $packageRequest | jq -r '.status')
packageRequest_contents=$(echo $packageRequest | jq -r '.content')
packageRequest_length=$(echo $packageRequest_contents | jq 'length')
echo "   > URL = $packageRequest_url"
echo "   > Status = $packageRequest_status"
echo "   > Available Packages = $packageRequest_length"
echo

# 3. Select Package
echo "${bold}3. Select Package${reset}"
echo
packageRequest_arrayLength=$((packageRequest_length-1))
for package_i in $(seq 0 $packageRequest_arrayLength)
do
	packageRequest_botId=$(echo $packageRequest_contents | jq -r --argjson package_i "$package_i" '.[$package_i].botId')
	packageRequest_number=$(echo $packageRequest_contents | jq -r --argjson package_i "$package_i" '.[$package_i].number')
	packageRequest_name=$(echo $packageRequest_contents | jq -r --argjson package_i "$package_i" '.[$package_i].name')
	packageRequest_sizekbits=$(echo $packageRequest_contents | jq -r --argjson package_i "$package_i" '.[$package_i].sizekbits')
	packageRequest_sizeMB=$((packageRequest_sizekbits/(1024*1024)))
	echo "   > Package Number ["$((package_i+1))"] = $packageRequest_number"
	echo "   > Package Name = $packageRequest_name"
	echo "   > Package Size (Bytes) = $packageRequest_sizekbits"
	echo "   > Package Size (MBs) = $packageRequest_sizeMB"
	echo "   > Bot ID = $packageRequest_botId"
	read -r -p "     ${bold}Would you like to proceed with above package ["$((package_i+1))"]: ? ${red}[Y/n]${reset} " input
    	case $input in
		[yY][eE][sS]|[yY])
	     	break;
	;;
	esac
	echo
done
echo

# 4. Find Bot Name
echo "${bold}4. Fetching Bot Details${reset}"
botRequest_url=$(echo "https://api.nibl.co.uk/nibl/bots/$packageRequest_botId")
botRequest=$(curl -s -X GET --header 'Accept: application/json' "$botRequest_url")
botRequest_status=$(echo $botRequest | jq -r '.status')
botRequest_name=$(echo $botRequest | jq -r '.content.name')
echo "   > URL = $botRequest_url"
echo "   > Status = $botRequest_status"
echo "   > Bot Name = $botRequest_name"
echo

# 5. Generate XDCC command
echo "${bold}5. Generating Bot Message${reset}"
command=$(echo "/msg $botRequest_name xdcc send #$packageRequest_number")
if [[ $packageRequest_status == "OK" ]] && [[ "$botRequest_status" == "OK" ]];
then
	echo "   > ${green}${bold}Success!${reset}"
	echo "   > Message = $command"
else
	echo "   > ${red}${bold}Error!${reset}"
	echo
	echo "   > packageRequest_url = $packageRequest_url"
	echo "   > botRequest_url = $botRequest_url"
	echo
	read -n 1 -s -r -p "Press any key to exit!"
	exit 1
fi
echo

# 6. Download from Irssi (IRC XDCC)
echo "${bold}6. Starting Irssi client${reset}"
tmux_window=$(echo "irssi_$RANDOM")
nick=$(echo "dl_$RANDOM")
tmux new-session -d -t $tmux_window
tmux send-keys "irssi" Enter
sleep 1
echo "   > Download directory = $PWD"
echo "   > Nick $nick"
echo "   > Connecting to Rizon #nibl"
tmux send-keys "/SET dcc_download_path $PWD" Enter
tmux send-keys "/SET dcc_autoget ON" Enter
tmux send-keys "/SET nick $nick" Enter
tmux send-keys "/SET alternate_nick dl_$RANDOM" Enter
tmux send-keys "/SET user_name $nick" Enter
tmux send-keys "/SET real_name $nick" Enter
tmux send-keys "/connect irc.rizon.net" Enter
sleep 2
tmux send-keys "/join #nibl" Enter
sleep 2
echo "   > Messaging Bot = $command"
tmux send-keys "$command" Enter
echo

# 7. Monitor Download progress
echo "${bold}7. Downloading${reset}"
sleep 5
SECONDS=0
downloadedFile_sizekbits="0"
downloadedFile_sizeMB=$((downloadedFile_sizekbits/(1024*1024)))
downloadedFile_percent="0"
previous_downloadedFile_sizekbits=$downloadedFile_sizekbits
nochange_counter="0"
while [[ "$downloadedFile_sizekbits" != "$packageRequest_sizekbits" && "$downloadedFile_percent" != "100" ]]
do
	# Fetch Elapsed Time
	elapsed=$SECONDS
	downloadedFile_elapsedTime=$((elapsed/60))"M "$((elapsed%60))"S "
	
	# Fetch Progress Details
	previous_downloadedFile_sizekbits=$downloadedFile_sizekbits
	previous_downloadedFile_sizekbits="${previous_downloadedFile_sizekbits:-0}" # Set Default as 0
	downloadedFile_sizekbits=$(ls -lt "$packageRequest_name" 2>/dev/null | awk '{print $5}') # Fetch only the Bytes column from output
	downloadedFile_sizekbits="${downloadedFile_sizekbits:-0}" # Set Default as 0
	downloadedFile_sizeMB=$((downloadedFile_sizekbits/(1024*1024)))
	downloadedFile_percent=$(echo "scale=0; ($downloadedFile_sizekbits*100)/$packageRequest_sizekbits" | bc)
	downloadedFile_percent="${downloadedFile_percent:-0}" # Set Default as 0
	
	# Check if Download is still in progress?
	if [[ "$previous_downloadedFile_sizekbits" ==  "$downloadedFile_sizekbits" ]]
	then
		nochange_counter=$((nochange_counter + 1))
		if [[ "$nochange_counter" == "10" ]]
		then
			echo
			echo -n "   > ${green}${bold}No change in Download progress for past 10 checks! Skipping Monitoring!${reset}"
			break
		fi
	else
		nochange_counter="0"
	fi
	
	# Display progress message
	echo -ne "\r   > ${packageRequest_name:0:30}... - $((downloadedFile_sizeMB))MB - $downloadedFile_elapsedTime [${green}${bold}$((downloadedFile_percent))%${reset}]     "
	sleep 1
done
echo
echo "   > Waiting for 5 seconds for file to save"
sleep 5
echo

# 8. Exit (after confirmation)
read -n 1 -s -r -p "Press ${bold}any key${reset} to kill irssi and close this terminal"
echo
tmux send-keys "/quit" Enter
sleep 1
tmux send-keys "xdg-open \"$packageRequest_name\" && exit" Enter
#tmux kill-session -t $tmux_window
echo "Enjoy the content!"
