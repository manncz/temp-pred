## Generate Temperature Predictions

### Overview

This repository contains the R code for generating baseline predictions of the temperature for comparison
with student's temperature prediction models in STATS 604 at University of Michigan (Fall 2022, instructor Dr. Johann Gagnon-Bartsch).
It also sets up a Docker image, which automatically generates temperature predictions using yesterday's temperature, scraped from [Weather Underground](https://www.wunderground.com).

Students were tasked to predict the mean, minimum and maximum temperatures at 20 different weather stations each day, for the 5 days following, from November 28 and December 6, 2022. I implemented three different baseline models for comparison, ran cross validation to evaluate the models, and calculated the final prediction accuracy for the class.

### Contents

- `data`
  - `processed`
   - data processed by `scripts/01-process-dat.Rmd`
 - `raw-data`
   - historical data for the weather stations of interest downloaded from [NOAA](https://www.ncei.noaa.gov/cdo-web/search?datasetid=GHCND), in two files due to data size.
 - `temp`
   - manually coded crosswalk between weather station names and station IDs ("station_xwalk.csv") and template for observed data file ("observed_template.csv")

- `docker`
 - files to set up docker image

- `output`
 - output from prediction functions, which is then printed to the terminal

- `scripts`
  - all analytical scripts, labeled in the order they are run

- `makefile`: file referenced by Docker image to make predictions

- "604 Weather Predictions.xlsx": workbook of predictions from STATS 604 final projects and observed temperatures for comparison.

### Docker Image

The associated Docker image allows one to run the code in exactly the computing environment in which the predictions were generated in December 2022. The image is shared on DockerHub as [manncz/temp-pred](https://hub.docker.com/r/manncz/temp-pred). To use the image, first install [Docker](https://docs.docker.com/get-docker/) and make sure it is running.

To interact with the image, you can initiate a GUI with the following in command line:

`docker run -it --rm -p 127.0.0.1:80:80 manncz/temp-pred:final`


To directly output predictions, use the following command line:

`docker run -it --rm manncz/temp-pred:final make [[MAKE-COMMAND]]`

The `[[MAKE-COMMAND]]` options follow (and can be found in the `makefile`):

 - `predictions-naive` : predicts next 5 day's temperatures with yesterday's temperatures
 - `predictions-hist-mean`: predicts next 5 day's temperatures with the historical mean on that day
 - `predictions-hist-mod`: predicts next 5 day's temperatures with a simple OLS model fit on historical data
 - `observed-temps`: fills in a data frame of observed temperatures between 11/29/22-12/02/22, used to evaluate the prediction accuracy of student's models
