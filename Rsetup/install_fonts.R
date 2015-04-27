#! Rscript
# Install Arial into R:

if(require("extrafont")) {
	if ("Arial" %in% fonts()) {
		message("Arial already installed.")
	}
}

local({r <- getOption("repos");
       r["CRAN"] <- "http://cran.at.r-project.org";  #AUSTRIA mirror
       options(repos=r)})

install.packages(c("extrafont"))
library("extrafont")

# importing takes awhile but only has to be done once.
font_import("Rsetup/fonts/", prompt=FALSE)
loadfonts()
