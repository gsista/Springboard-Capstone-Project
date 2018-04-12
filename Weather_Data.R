#API call for weather data from Weather Underground site for the Henry Hub location
library(lubridate)
library(jsonlite)

d <- as.Date('20150205', format = '%Y%m%d')
for(i in 1:100){
  date(d) <- date(d) + 1
  intdate <-as.integer(format(date(d), "%Y%m%d"))
  url <-paste0("http://api.wunderground.com/api/0def10027afaebb7/history_",intdate,"/q/CA/San_Francisco.json")
  raw.result <- fromJSON(url,flatten = TRUE)
  df_weatherdata <- raw.result$history$observations
  
  #Write to individual files for each day
  write.csv(df_weatherdata,file = paste0("/Users/gsista/Desktop/Springboard/DataScience/Data/Weather/Weather history_",intdate,".csv"))
  
  #Weather Underground has a restriction on the number of calls per minute - so built a pause          
  Sys.sleep(5)
}

#Read data in individual files into df
library(data.table)
filelist <-list.files(path = "Files", pattern = ".csv", full.names = TRUE)
temp <- lapply(filelist, fread, sep=",")
weatherdata <- rbindlist(temp)

