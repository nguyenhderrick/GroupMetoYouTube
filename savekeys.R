library(httr)


#get clientId and clientSecret by registering an application with Google's developers console
#make sure you allow Youtube Data API v3
#make sure to select Installed application as Application Type to get a refresh token

savekeys <- function() {

    oauth_endpoints("google")

    clientId <- readline("Enter Google/Youtube Client ID: ")
    clientSecret <- readline("Enter Google/Youtube Client Secret: ")

    myapp <- oauth_app("google", clientId, secret = clientSecret)

    google_token <- oauth2.0_token(oauth_endpoints("google"), myapp,
                               scope = "https://www.googleapis.com/auth/youtube")

    #get public API access from Google/Youtube
    apiKey <- readline("Enter Youtube API Key")

    #get groupme Access Token by creating an application with GroupMe
    gm.at <- readline("Enter GroupMe Access Token: ")

    save(clientId, clientSecret, google_token, apiKey, gm.at, file="key.RData")
}

savekeys()
