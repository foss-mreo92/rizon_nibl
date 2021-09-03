#!/bin/bash
# 0. Initialize
mytitle="Rizon #NIBL Downloader"
echo -e '\033]2;'$mytitle'\007'
red="$(tput setaf 1)"
green="$(tput setaf 2)"
bold="$(tput bold)"
reset="$(tput sgr0)"
# Error Handling: Fail the script as soon as an invalid password has been entered
function exitNow {
	echo
	read -n 1 -s -r -p "Press ${green}${bold}any key${reset} to exit"
	exit
}
set -eE
trap 'exitNow' ERR


# 0. Check dependencies
clear
echo "${bold}0. Checking dependencies${reset}"
echo
missing="no"
dependencies=("curl" "jq" "grep" "node")
for dependencies_i in $(seq 0 $((${#dependencies[@]}-1)))
do
	exists=$(type ${dependencies[$dependencies_i]} &>/dev/null || echo "no")
	if [[ "$exists" == "no" ]]; then
		echo "Missing ${dependencies[$dependencies_i]}:"
		echo "   > sudo apt install ${dependencies[$dependencies_i]} -y"
		missing="yes"
	fi
done
# Check node package dependencies
if [[ "$missing" == "no" ]]; then
	nodeDependencies=("irc" "xdcc" "progress")
	for nodeDependencies_i in $(seq 0 $((${#nodeDependencies[@]}-1)))
	do
		exists=$(npm list -g | grep ${nodeDependencies[$nodeDependencies_i]} || echo "no")
		if [[ "$exists" == "no" ]]; then
			echo "Missing npm package ${nodeDependencies[$nodeDependencies_i]}:"
			echo "   > sudo npm install -g ${nodeDependencies[$nodeDependencies_i]}"
			missing="yes"
		fi
	done
fi
# Check for node.js file
downloadFile="./irc-download.js"
if [ ! -f "$downloadFile" ]; then
	echo "Download 'irc-download.js' file and drop it in $PWD directory"
	missing="yes"
fi
if [[ "$missing" == "yes" ]]; then
	exitNow
else
	echo "Dependencies check ${green}${bold}passed!${reset}"
fi
echo


# 1. Fetch Bots
echo "${bold}1. Fetching Bots${reset}"
echo
botRequest_url="https://api.nibl.co.uk/nibl/bots/"
botRequest=$(curl -s -X GET --header 'Accept: application/json' "$botRequest_url")
botRequest_status=$(echo $botRequest | jq -r '.status')
botRequest_contents=$(echo $botRequest | jq -r '.content')
botCount=$(echo $botRequest_contents | jq -r 'length')
if [[ "$botCount" == 0 ]]; then
	echo "${red}${bold}No Bots were returned from Rizon #nibl${reset}"
	echo "${red}${bold}Check URL: ${reset}$botRequest_url"
	exitNow
fi
botIDs=($(echo $botRequest_contents | jq -r '.[].id'))
botNames=($(echo $botRequest_contents | jq -r '.[].name'))
# Usage: botName=$(fetchBotName "16" "$botRequest_contents" "$botCount")
fetchBotName () {
	local findId=$1
	local contents=$2
	local count=$3
	local return_botName="not_found"
	for bot_i in $(seq 0 $count)
	do
		botId=$(echo $contents | jq -r --argjson bot_i "$bot_i" '.[$bot_i].id')
		botName=$(echo $contents | jq -r --argjson bot_i "$bot_i" '.[$bot_i].name')
		if [[ "$findId" ==  "$botId" ]]
		then
			return_botName=$botName
			break
		fi
	done
	echo $return_botName
}
echo "   > URL = $botRequest_url"
echo "   > Status = $botRequest_status"
echo "   > Available Bots = $botCount"
echo


# 2. Get Input
echo "${bold}2. Get Input${reset}"
echo
read -p "${green}${bold}Enter Search Query${reset} [Example, One Piece 1080p]: " input_query
input_query=${input_query// /"%20"}
read -p "${green}${bold}Enter Episode Number${reset} [Example, 15 or 15-20 or 15,17,21]: " input_episodeNumber
input_episodeNumber=${input_episodeNumber// /""}
episodeArray=()
if [[ $input_episodeNumber == *","* ]] || [[ $input_episodeNumber == *"-"* ]]; then
	# Convert (,) seperated string to episodeArray
	if [[ "$input_episodeNumber" == *","* ]]; then
		input_episodeNumber=${input_episodeNumber//,/" "}
		episodeArray=($input_episodeNumber)
		
	# Convert (-) seperated range to episodeArray
	elif [[ "$input_episodeNumber" == *"-"* ]]; then
		input_episodeNumber=${input_episodeNumber//-/" "}
		episodeArray=($input_episodeNumber)
		episodeArray=( $(seq $((${episodeArray[0]})) $((${episodeArray[1]}))) )
	fi
else
	episodeArray=($input_episodeNumber)
fi
echo


# 3. Fetch Packages for each Episode (and display in table-like format)
echo "${bold}3. Fetching Packages (per episode)${reset}"
echo
printf "%-3s| %-5s| %-8s| %-s\n" "#ID" "Size" "#Episode" "Package Name"
printf "%.50s\n" "--------------------------------------------------"
rowNumber=0
packageNames=("not_applicable")
packageNumbers=("not_applicable")
botNames=("not_applicable")
botMessages=("not_generated")
for episode_i in $(seq 0 $((${#episodeArray[@]}-1)))
do
	# Fetch packages from API (using $input_query & $episodeArray)
	checkEpisode=${episodeArray[$episode_i]}
	packageRequest_url="https://api.nibl.co.uk/nibl/search?query=$input_query&episodeNumber=$checkEpisode"
	packageRequest=$(curl -s -X GET --header 'Accept: application/json' "$packageRequest_url")
	packageRequest_status=$(echo $packageRequest | jq -r '.status')
	packageRequest_contents=$(echo $packageRequest | jq -r '.content')
	packageCount=$(echo $packageRequest_contents | jq 'length')
	if [[ "$packageCount" == 0 ]]; then
		continue
	fi
	
	for package_i in $(seq 0 $((packageCount-1)))
	do
		# Collect attributes for each "row" of packages
		row=$(echo $packageRequest_contents | jq -r --argjson package_i "$package_i" '.[$package_i]')
		size=$(echo $row | jq -r '.size')
		episodeNumber=$(echo $row | jq -r '.episodeNumber')
		packageName=$(echo $row | jq -r '.name')
		botID=$(echo $row | jq -r '.botId')
		botName=$(fetchBotName "$botID" "$botRequest_contents" "$botCount")
		packageNumber=$(echo $row | jq -r '.number')
	
		if [[ "$botName" != "not_found" ]]; then
			# Display attributes
			rowNumber=$(($rowNumber+1))
			printf "%3d| %-5s| %8d| %-s\n" "$rowNumber" "$size" "$episodeNumber" "$packageName"
			
			# Collect Messages
			packageNames[rowNumber]=$(echo "$packageName")
			packageNumbers[rowNumber]=$(echo "$packageNumber")
			botNames[rowNumber]=$(echo "$botName")
			botMessages[rowNumber]=$(echo "/msg $botName xdcc send #$packageNumber")
		else
			botMessages[rowNumber]=$(echo "not_generated")
		fi
	done
done
if [[ "$rowNumber" == 0 ]]; then
	echo "${red}${bold}No Packages were returned from Rizon #nibl${reset}"
	echo "${red}${bold}Check URL: ${reset}https://api.nibl.co.uk/nibl/search?query=$input_query&episodeNumber="
	exitNow
fi
echo


# 4. Select Packages
echo "${bold}4. Select Packages${reset}"
echo
read -p "${green}${bold}Select from List${reset} [Example, 3,6,10]: " selected_listIDs
selected_listIDs=${selected_listIDs// /""}
selected_listIDs=${selected_listIDs//,/" "}
selected_listIDs=($selected_listIDs)
echo


# 5. Download Selected Packages
echo "${bold}5. Downloading Packages${reset}"
echo
server="irc.rizon.net"
channel="nibl"
for selected_i in $(seq 0 $((${#selected_listIDs[@]}-1)))
do
	selected_rowNumber=${selected_listIDs[$selected_i]}
	echo "$(($selected_i+1)). ${packageNames[$selected_rowNumber]}" 
	node irc-download.js "$server" "$channel" "${botNames[$selected_rowNumber]}" "${packageNumbers[$selected_rowNumber]}" "$HOME/Downloads/"
done

# 6. Open ~/Downloads folder
read -n 1 -s -r -p "Press ${green}${bold}any key${reset} to exit"
xdg-open "$HOME/Downloads/" & exit
