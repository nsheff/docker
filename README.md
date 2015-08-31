# Dockerfiles
A repository of Dockerfiles for building various docker containers. The different contains are described below.

In this repo is a [Makefile](Makefile) which stores instructions for how to build each Dockerfile. You can clone this repository, and then type `make CONTAINER`, where `CONTAINER` is one of:

* rim - R image
* rdev - R development
* rmlr - R `mlr` package depedencies for machine learning.
* jim - Jekyll image
* vis - graphics; under construction
* igv - under contruction

Built containers can (sometimes) also be downloaded from [Dockerhub](https://hub.docker.com/u/sheffien/).

Detailed container descriptions follow:

# R containers

## rim
My R production environment, based on the bioconductor Docker containers, then installs a bunch of packages I use regularly (the packages lists are, for example, in [Rsetup/rpack_basic.txt](Rsetup/rpack_basic.txt))

## rdev

My R development environment, for building packages. Comes with everything you need to run `R CMD check` and `R CMD BiocCheck` -- and a couple of helper scripts in `bin/`:

This will build, RCheck, and BiocCheck the package, all in a docker container with all dependencies already required.
```
dockrpack /path/to/R/package
```
This will run your unit tests in a docker container:
```
dockrtest /path/to/R/package
```

# Other containers
# jim
Jekyll-image: Docker jekyll

A container with Ruby, Jekyll, and friends, so I can serve up local jekyll sites for testing without installing Ruby and so forth.

 It comes with a couple of wrapper scripts to make it super simple to serve and manage multiple sites for testing. The `dserve` is an internal script used within the Docker container, but you'll want the `djserve` script somewhere...

Copy the bin/ script to your bin and then you can serve up any jekyll site with a quick command:

```
djserve path/to/blog
```

Then visit the site at `http://localhost:4000/`

## vis

My docker container to convert Inkscape SVG figures into PDF, and other graphics processing tasks. Under construction.

TODO:
* put svg2pdfpng in here
* write a wrapper script (a la djserve) to run the conversion in a container


# TO DO:

I'm working on a script to be able to run any of these `script/drun` followed by the name of the image.

