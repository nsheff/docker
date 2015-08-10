# Dockerfiles
My repository of Dockerfiles for building various docker containers.

In this repo is a `Makefile` which stores instructions for how to build each Dockerfile. Built containers can be downloaded from [Dockerhub](https://hub.docker.com/u/sheffien/).

Containers can then be run with a `script/drun` followed by the name of the image.

# rim
A repository for my Dockerfile that produces a docker image to produce containers with my dev environment with R set up how I want it, with packages, etc.


# jim
Jekyll-image: Docker jekyll

Here's Dockerfile that can create a container with Ruby, Jekyll, and friends, so I can serve up local jekyll sites for testing without installing Ruby and so forth.

 It comes with a couple of wrapper scripts to make it super simple to serve and manage multiple sites for testing. The `dserve` is an internal script used within the Docker container, but you'll want the `djserve` script somewhere...

Copy the bin/ script to your bin and then you can serve up any jekyll site with a quick command:

```
djserve path/to/blog
```

Then visit the site at `http://localhost:4000/`
