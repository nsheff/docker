# Dockerfile for R environment:

FROM ubuntu:14.04

MAINTAINER John Doe <jdoe@example.com>


# Each RUN command creates a new layer; Dockerfiles are limited to 127 layers
# RUNning multiple commands in a single RUN statement reduces the number of layers.
# Alternatively, build an image until it reaches the maximum and then use docker export to create an un-layered copy. Then docker import to turn it back into an image, this time with just one layer, and continue building. You lose the history that way.

RUN sudo echo "deb http://cran.at.r-project.org/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list
# add CRAN key
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

RUN sudo apt-get update

RUN sudo apt-get install -y --force-yes r-base

ADD Rsetup.R Rsetup.R
ADD .Rprofile .Rprofile
RUN Rscript Rsetup.R

# You can also use the VOLUME instruction in a Dockerfile to add one or more new volumes to any container created from that image.
