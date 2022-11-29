Process Historical Temp Data
================
Charlotte Mann GSI
2022-11-28

## Predict from yesterday’s temperature for all given future times

## Predict from historical mean statistic for the given day

## Predict from historical data - 2 weeks around today’s date (local=T) or all days (local = F)

Function to fit a model either on all historical data, or for historical
data 2 weeks surrounding date of interest for prediction.

Models are of the form:

$$Y_{s,t,d} = \alpha + \beta Y_{s,t,(d-\ell)} + \alpha_{s}I_s + \beta_{s}Y_{s,t,(d-\ell)}I_s + \epsilon_{s,t,d}$$
Where $s$ is the station id, $t$ is the year, $d$ is the day of the
year, and $\ell$ is the number of lag days. $I_s$ is an indicator for
the station. This is equivalent to fitting 20 different models - it just
makes things easier with the data setup.

Make predictions based on historical data. When predicting only using
the weeks surrounding the date, fit that model. When using all
historical data, give the function those model fits (they don’t need to
be run over and over)
