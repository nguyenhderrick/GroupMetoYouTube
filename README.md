GroupMetoYouTube
===============

Turn GroupMe messages into Youtube playlist videos

After connecting to the GroupMe and Youtube APIs, the savekeys.R script will allow you to save your API keys in a seperate file named keys.RData.  

Then, running gmyt.R will allow you to listen to a Groupme group every 30 seconds. If a GroupMe message starts with the string "add ", the string will be searched in Youtube and the first video will be added into the playlist.
