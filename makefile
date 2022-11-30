.PHONY: predictions-naive predictions-hist-mean predictions-hist-mod

predictions-naive:
	 @cd scripts && R -e 'rmarkdown::render("02-download-current-temp.Rmd")' 1> /dev/null 2> /dev/null
	 @cd scripts && R -e 'rmarkdown::render("03a-make-naive-predictions.Rmd")' 1> /dev/null 2> /dev/null
	 @cat "output/temp-pred.txt"

predictions-hist-mean:
	@cd scripts && R -e 'rmarkdown::render("02-download-current-temp.Rmd")' 1> /dev/null 2> /dev/null
	@cd scripts && R -e 'rmarkdown::render("03b-make-predictions-hist-mean.Rmd")' 1> /dev/null 2> /dev/null
	@cat "output/temp-pred.txt"

predictions-hist-mod:
	@cd scripts && R -e 'rmarkdown::render("02-download-current-temp.Rmd")' 1> /dev/null 2> /dev/null
	@cd scripts && R -e 'rmarkdown::render("03c-make-predictions-hist-mod.Rmd")' 1> /dev/null 2> /dev/null
	@cat "output/temp-pred.txt"

observed-temps:
	@cd scripts && R -e 'rmarkdown::render("05-observed-temps.Rmd")' 1> /dev/null 2> /dev/null
	@cat "output/obs-temps.txt"
