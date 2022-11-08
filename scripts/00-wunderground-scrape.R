##' ---
##' title: "Functions to Download and Clean Wunderground Data"
##' output: md_document
##' ---
##'
#+ echo=FALSE, include = FALSE
knitr::opts_chunk$set(warning=FALSE, echo=TRUE)
mypacks <- c("dplyr","curl", "jsonlite", "lubridate")  # what packages are needed?
lapply(mypacks, library, character.only=TRUE)  # load all packages

##' Adapted from script by Yash Patel found [here](https://github.com/yashpatel5400/stats604-project4/blob/main/raw_data/wunderground_download.py)

fetch_wunderground <- function(stationid = "KPDX", start_date = "20221001", end_date = NULL){
  
  if(is.null(end_date)){end_date = start_date}
  
  h <- new_handle()
  handle_setheaders(h, "accept"= "application/json, text/plain, */*",
                    "sec-ch-ua"="\"Google Chrome\";v=\"107\", \"Chromium\";v=\"107\", \"Not=A?Brand\";v=\"24\"",
                    "sec-ch-ua-mobile"= "?0",
                    "sec-ch-ua-platform"= "\"macOS\"")
  
  url <- paste0("https://api.weather.com/v1/location/",
                stationid,
                ":9:US/observations/historical.json?apiKey=e1f10a1e78da46f5b10a1e78da96f525&units=e&startDate=",
                start_date,
                "&endDate=",
                end_date
  )
  
  json.dat <- curl_fetch_memory(url, handle = h) %$%
    content %>%
    rawToChar %>%
    prettify() %>%
    fromJSON()
  
  return(json.dat$observations)
}

summarize_wunderground <- function(raw.table){
  
  stopifnot("temp" %in% colnames(raw.table),
            "valid_time_gmt" %in% colnames(raw.table))
  
  #wunderground includes the temperatures starting from 8am on the date of interest until
  #8am of the following calendar day
  
  dat <- raw.table %>%
    select(valid_time_gmt, temp) %>%
    mutate(date_time = as_datetime(valid_time_gmt),
           day = date(date_time),
           tod = hour(date_time)) %>%
    mutate(date_group = case_when(tod < 8 ~ day - days(1),
                                  TRUE ~ day)) %>%
    group_by(date_group) %>%
    summarize(min.temp = min(temp), max.temp = max(temp), mean.temp = mean(temp))
  
  return(dat)
  
}



##' Now, let's test it out
weather.dat <- fetch_wunderground(start_date = "20221106", end_date = "20221107")

weather.dat %>%
  knitr::kable(format = "markdown")

summarize_wunderground(weather.dat)




