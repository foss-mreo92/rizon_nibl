<pre>
# rizon_nibl

A simple Bash script to download anime from Rizon #nibl using NodeJS packages such as irc, xdcc and progress. You can batch your downloads as well.

<hr/>
<b>Sample run of the script pasted below</b> -

<b>0. Checking dependencies</b>

Dependencies check <b><span style="color🥬">passed!</span></b>

<b>1. Fetching Bots</b>

   > URL = https://api.nibl.co.uk/nibl/bots/
   > Status = OK
   > Available Bots = 58

<b>2. Get Input</b>

<b><span style="color🥬">Enter Search Query</span></b> [Example, One Piece 1080p]: One Piece
<b><span style="color🥬">Enter Episode Number</span></b> [Example, 15 or 15-20 or 15,17,21]: 7-9 

<b>3. Fetching Packages (per episode)</b>

#ID| Size | #Episode| Package Name
--------------------------------------------------
  1| 180M |        7| [K-F&AKUPX]_One_Piece_007_[CFA2D23E].avi
  2| 830M |        7| [K-F]_One_Piece_Movie_7_[7B3B34C5].mp4
  3| 466M |        7| [Kousei]_One_Piece-SE_007_[720p] [9766F9C1].mkv
  4| 573M |        7| [HorribleSubs] One Piece - 07 [1080p].mkv
  5| 340M |        7| [HorribleSubs] One Piece - 07 [720p].mkv
  6| 147M |        7| [AnimeRG] One Piece - 007 [720p] [Dual-Audio] [Multi-Sub] [x265] [pseudo].mkv
  7| 573M |        7| [HorribleSubs] One Piece - 07 [1080p].mkv
  8| 155M |        7| [HorribleSubs] One Piece - 07 [480p].mkv
  9| 180M |        7| [K-F_AKUPX]_One_Piece_007_[CFA2D23E].avi
 10| 830M |        7| [K-F]_One_Piece_Movie_7_[7B3B34C5].mp4
 11| 188M |        8| [K-F&AKUPX]_One_Piece_008_[F6B7A11A].avi
 12| 1.2G |        8| [K-F]_One_Piece_Movie_08_[9DB3BA85].mp4
 13| 399M |        8| [Kousei]_One_Piece-SE_008_[720p] [50945C0D].mkv
 14| 571M |        8| [HorribleSubs] One Piece - 08 [1080p].mkv
 15| 340M |        8| [HorribleSubs] One Piece - 08 [720p].mkv
 16| 128M |        8| [AnimeRG] One Piece - 008 [720p] [Dual-Audio] [Multi-Sub] [x265] [pseudo].mkv
 17| 571M |        8| [HorribleSubs] One Piece - 08 [1080p].mkv
 18| 155M |        8| [HorribleSubs] One Piece - 08 [480p].mkv
 19| 188M |        8| [K-F_AKUPX]_One_Piece_008_[F6B7A11A].avi
 20| 1.2G |        8| [K-F]_One_Piece_Movie_08_[9DB3BA85].mp4
 21| 176M |        9| [K-F&AKUPX]_One_Piece_009_[4984356F].avi
 22| 1.4G |        9| [yibis]_One_Piece_Movie_9_[720p][780350D8].mkv
 23| 573M |        9| [HorribleSubs] One Piece - 09 [1080p].mkv
 24| 341M |        9| [HorribleSubs] One Piece - 09 [720p].mkv
 25| 121M |        9| [AnimeRG] One Piece - 009 [720p] [Dual-Audio] [Multi-Sub] [x265] [pseudo].mkv
 26| 573M |        9| [HorribleSubs] One Piece - 09 [1080p].mkv
 27| 155M |        9| [HorribleSubs] One Piece - 09 [480p].mkv
 28| 176M |        9| [K-F_AKUPX]_One_Piece_009_[4984356F].avi
 29| 1.4G |        9| [yibis]_One_Piece_Movie_9_[720p][780350D8].mkv

<b>4. Select Packages</b>

<b><span style="color🥬">Select from List</span></b> [Example, 3,6,10]: 9,19,28

<b>5. Downloading Packages</b>

1. [K-F_AKUPX]_One_Piece_007_[CFA2D23E].avi
   [========================================] 100%, 0.0s remaining

2. [K-F_AKUPX]_One_Piece_008_[F6B7A11A].avi
   [========================================] 100%, 0.0s remaining
   
3. [K-F_AKUPX]_One_Piece_009_[4984356F].avi
   [========================================] 100%, 0.0s remaining
   
Press <b><span style="color🥬">any key</span></b> to exit
<hr/>
It will then auto-open your downloads folder upon completion.
<hr/>
<b>Dependencies (Linux)</b> -

download both irssi_nibl_batch.sh, irc-download.js files in same directory
> sudo apt install curl jq grep node
> sudo npm install -g irc xdcc progress
<hr/>
<b>Usage</b> -

Open your linux terminal and run ./irssi_nibl_batch.sh
<hr/>
<b>Credits</b>:

To the developer who built the [APIs](https://api.nibl.co.uk/swagger-ui.html)

<b>Disclaimer / Notice</b>: 

Not encouraging piracy. Just demonstrating a simple bash script to download files on IRC.
</pre>
