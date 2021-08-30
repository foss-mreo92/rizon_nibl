# rizon_nibl

A simple Bash script to download anime from Rizon #nibl using Irssi chat client.

---

**Sample run of the script pasted below** -

1. Get Input

   > Enter Search Query [Example, One Piece 1080p]: Arakawa

   > Enter Episode Number [Example, 15]: 6

2. Fetching Packages

   > URL = https://api.nibl.co.uk/nibl/search?query=Arakawa&episodeNumber=6

   > Status = OK

   > Available Packages = 4

3. Select Package

   > Package Number [1] = 774

   > Package Name = (Hi10)_Arakawa_Under_the_Bridge_-_06_(BD_720p)_(ANE)_(C5BFED95).mkv

   > Package Size (Bytes) = 121634816

   > Package Size (MBs) = 116

   > Bot ID = 962
 
     Would you like to proceed with above package [1]: ? [Y/n] n

   > Package Number [2] = 789

   > Package Name = (Hi10)_Arakawa_Under_the_Bridge_x_Bridge_-_06_(BD_720p)_(ANE)_(2573E1D7).mkv

   > Package Size (Bytes) = 122683392

   > Package Size (MBs) = 117

   > Bot ID = 962

     Would you like to proceed with above package [2]: ? [Y/n] y

4. Fetching Bot Details

   > URL = https://api.nibl.co.uk/nibl/bots/962

   > Status = OK

   > Bot Name = Chinese-Cartoons

5. Generating Bot Message

   > Success!

   > Message = /msg Chinese-Cartoons xdcc send #789

6. Starting Irssi client

   > Download directory = /home/user/Downloads

   > Nick dl_13179

   > Connecting to Rizon #nibl

   > Messaging Bot = /msg Chinese-Cartoons xdcc send #789
   
7. Downloading

   > (Hi10)_Arakawa_Under_the_Bridg... - 117MB - 2M 20S [100%]

   > Waiting for 5 seconds for file to save

Press any key to kill irssi and close this terminal

Enjoy your content!

---

It will then auto-open your default media player and start playing the content.

Irssi being a command line client does all the magic here so you can reuse the script for any XDCC download needs that you may have.

---

**Dependancies (Linux)** -
> sudo apt-get install tmux irssi bc jq -y

**Dependancies (Android)** -
Install [Termux](https://termux.com/). Open Termux and run these lines -
> termux-setup-storage
> pkg install tmux irssi bc jq -y

---

**Disclaimer / Notice**: 
Not encouraging piracy. Just demonstrating a simple bash script one can use to download files on IRC with just a couple of clicks.

I am new to Bash scripting and this script is probably as ineffecient as it can get (but it does the job for me) :slightly_smiling_face: I would love to hear from someone experienced in Bash scripting to point me in the right direction!
