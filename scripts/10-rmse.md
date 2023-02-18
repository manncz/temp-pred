RMSE Calculation
================
Charlotte Mann
2023-02-18

## read in predictions

``` r
path <- "../604 Weather Predictions.xlsx"
sheets <- excel_sheets(path = path)
dat.list <- list()
for(x in sheets){
  dat.list[[x]] <- read_xlsx(path, sheet = x)[,-1] %>%
  mutate(across(everything(), ~round(as.numeric(.x),1)))
}
```

    ## New names:
    ## New names:
    ## New names:
    ## New names:
    ## New names:
    ## New names:
    ## New names:
    ## New names:
    ## New names:
    ## • `` -> `...1`

Fix column names for my (reference) predictions

``` r
station_xwalk <- read.csv("../data/temp/station_xwalk.csv")
station_order <- station_xwalk$id


colnms<- paste0(rep(paste0(rep(station_order,each = 5),1:5), each = 3),c("min","avg","max"))

colnames(dat.list[["CharA"]]) <- colnames(dat.list[["CharB"]]) <- colnames(dat.list[["CharC"]]) <- colnms
```

Reshape observed data to merge

``` r
observed.long <- dat.list[["observed"]] %>%
   mutate(date = row_number()) %>%
  pivot_longer(!date, names_to = "label",values_to = "obs_val") %>%
  mutate(station_code = str_extract(label, "([A-Z]+)"),
         days_lag = str_extract(label, "\\d"),
         stat = str_extract(label, "[a-z]+"))
```

Merge observed data onto each dataset of student predictions on date,
station, days log, and statistic (all included in label as well), to
ensure that everything is aligned.

``` r
dat.list.long <- list()

for(x in names(dat.list)){
  dat.list.long[[x]] <- dat.list[[x]] %>%
  mutate(date = row_number()) %>%
  pivot_longer(!date, names_to = "label",values_to = "val") %>%
  mutate(station_code = str_extract(label, "([A-Z]+)"),
         days_lag = str_extract(label, "\\d"),
         stat = str_extract(label, "[a-z]+")) %>%
  select(everything(),val) %>%
  left_join(observed.long,by =c("date","label","station_code","days_lag","stat"))
}
```

## RMSE

Look at the overall root mean squared error for student & reference
predictions.

``` r
rmse <- c()

for(x in names(dat.list)){
  
  rmse[x] <- dat.list.long[[x]]%>%
    filter(!is.na(obs_val)) %>%
    mutate(sq_err = (obs_val - val)^2) %>%
    summarize(rmse = sqrt(mean(sq_err)))
  
}

rmse
```

    ## $edenx
    ## [1] 8.077021
    ## 
    ## $AJAbkemeier
    ## [1] 6.971864
    ## 
    ## $yashpatel5400
    ## [1] 7.471027
    ## 
    ## $AlexanderKagan
    ## [1] 8.102784
    ## 
    ## $eastonhuch
    ## [1] 11.58579
    ## 
    ## $CharA
    ## [1] 8.763977
    ## 
    ## $CharB
    ## [1] 7.824402
    ## 
    ## $CharC
    ## [1] 7.224889
    ## 
    ## $observed
    ## [1] 0

Now look at the RMSE, depending on the number of days lag.

``` r
rmse.days <- foreach(x = names(dat.list), .combine = rbind) %do% {
  
  rmse <- dat.list.long[[x]]%>%
    filter(!is.na(obs_val)) %>%
    mutate(sq_err = (obs_val - val)^2) %>%
    group_by(days_lag) %>%
    summarize(rmse = sqrt(mean(sq_err)))
  
  it.ob <- rmse$rmse
  names(it.ob) <-rmse$days_lag
  
  it.ob
}

rownames(rmse.days) <- names(dat.list.long)
rmse.days
```

    ##                        1         2         3         4         5
    ## edenx           7.185105  8.197357  8.412909  8.347973  8.179439
    ## AJAbkemeier     7.337174  6.725601  6.888829  7.043196  6.848652
    ## yashpatel5400   7.654527  7.252357  7.206910  7.690568  7.537133
    ## AlexanderKagan  7.428297  7.861833  8.036751  8.529702  8.598975
    ## eastonhuch     12.359231 11.631831 11.492666 11.279351 11.126441
    ## CharA           9.220862  7.455979  8.344719  9.463927  9.177163
    ## CharB           7.815976  7.693031  7.839753  7.990932  7.779294
    ## CharC           7.528153  6.845148  7.135902  7.433241  7.161830
    ## observed        0.000000  0.000000  0.000000  0.000000  0.000000
