# Dockerfile for my R DEVELOPMENT environment:

# I originally used as base my own R docker image, but then I found Dirk's
# excellent Rocker project, and the bioconductor images based on these, and it
# makes more sense for me to just use these instead...

# FROM sheffien/rim
# Switch to using the bioconductor maintained docker images
FROM bioconductor/devel_core

#FROM rocker/r-devel


MAINTAINER Nathan Sheffield <nathan@code.databio.org>

# Updating is required before any apt-gets
RUN sudo apt-get update

################################################################################
# Some of these dependencies will be already installed by the parent images;
# But just to make sure, run these installs here:

# Required for R Package XML
RUN sudo apt-get install -y --force-yes libxml2-dev

# Curl; required for RCurl
#RUN apt-get install -y --force-yes libcurl4-gnutls-dev

# GNU Scientific Library; required by MotIV
RUN apt-get install -y --force-yes libgsl0-dev

# Open SSL is used, for example, devtools dependency git2r
RUN apt-get install -y --force-yes libssl-dev

################################################################################
ADD Rsetup/Rdev.R Rsetup/Rdev.R
RUN Rscript Rsetup/Rdev.R

# I put these COPY statements in separately, so that the whole thing
# isn't invalidated (causing unnecessary cache rebuilds)
# with an unrelated change in Rsetup/

#ADD Rsetup/install_bioconductor.R Rsetup/install_bioconductor.R
#RUN Rscript Rsetup/install_bioconductor.R





# I put these COPY statements in separately, so that the whole thing
# isn't invalidated (causing unnecessary cache rebuilds)
# with an unrelated change in Rsetup/
COPY Rsetup/install_fonts.R Rsetup/install_fonts.R
COPY Rsetup/fonts Rsetup/fonts
RUN Rscript Rsetup/install_fonts.R


ADD Rsetup Rsetup
ADD Rprofile .Rprofile
RUN Rscript Rsetup/Rsetup.R
RUN Rscript Rsetup/Rsetup.R --packages=Rsetup/rpack_basic.txt
RUN Rscript Rsetup/Rsetup.R --packages=Rsetup/rpack_bio.txt

# If you want to develop R packages on this machine (need biocCheck):
RUN Rscript Rsetup/Rsetup.R --packages=Rsetup/rpack_biodev.txt



# CMD Check requires to check pdf size
RUN sudo apt-get install -y --force-yes qpdf


# I think it's good to have this one last, so if you change anything in the bin,
# it won't make you reinstall all the packages.

COPY Rpack/ bin/
