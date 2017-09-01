library(httr)

load("keys.RData")


initYoutube <- function() {
  playlistdat<-GET("https://www.googleapis.com/youtube/v3/playlists?part=snippet&mine=true",config(token=google_token))
  print(data.frame(Playlists = sapply(content(playlistdat)$items, function(x)x$snippet$title)))
  prompt<-as.numeric(readline("Pick the corresponding number to the playlist: "))
  playlistId<<- content(playlistdat)$items[[prompt]]$id
}

initGroupme <- function() {
  groupdat<-GET(paste0("https://api.groupme.com/v3/groups?token=",gm.at))
  print(data.frame(Groups = sapply(content(groupdat)$response, function(x)x$name)))
  prompt<-as.numeric(readline("Pick the corresponding number to the group: "))
  group_id<<-content(groupdat)$response[[prompt]]$group_id
  after_id<<-content(groupdat)$response[[prompt]]$messages$last_message_id
}

concatTrue <- function(x) {
  y<-grep("^[Aa]dd",x$text,value=TRUE)
  y<-gsub("^[Aa]dd\\s","",y)
  y<-gsub(" ","+",y)
}

addVideo<-function(x){
    POST("https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&fields=snippet",
                            config(token=google_token),add_headers("Content-Type"="application/json"),
                            body=paste0("{
                                'snippet': {
                                'playlistId': '",playlistId,"',
                                'resourceId': {
                                    'kind': 'youtube#video',
                                    'videoId': '",x,"'
                                    }
                                }
                            }")
)}

instanceAdd <- function() {
  
  msgs <- GET(paste0("https://api.groupme.com/v3/groups/",group_id,"/messages?token=",gm.at,"&limit=100&after_id=",after_id))

  texting <- lapply(content(msgs)$response$messages, concatTrue)
  texting <- Filter(Negate(function(x)length(x)==0),texting)

  if(length(texting)!= 0){
    after_id<<-content(msgs)$response$messages[[length(content(msgs)$response$messages)]]$id

    req2<-lapply(texting, function(x)GET(paste0("https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=1&type=video&q=",x,"&key=",apiKey)))
    query <-lapply(req2, function(x)addVideo(content(x)$items[[1]]$id$videoId))
  }
}

gmyt <- function(refresh) {
  if(!exists("group_id")|!exists("after_id"))
    initGroupme()
  if(!exists("playlistId"))
    initYoutube()
  message("Esc to quit")
  repeat{
  try(instanceAdd(), silent = TRUE)
  Sys.sleep(refresh)
  }
}

refresh <- 30
gmyt(refresh)
