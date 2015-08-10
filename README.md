 # rim
A repository for my Dockerfile that produces a docker image to produce containers with my dev environment with R set up how I want it, with packages, etc.

Build it with:

```
cd rdev
docker build -t sheffien/rdev .
docker build -t sheffien/rdevel -f Dockerfile.rdevel .
```


# jim
Jekyll-image: Docker jekyll

Here's a git repository holding a dockerfile that can create a container with Ruby, Jekyll and friends, so I can serve up local jekyll sites for testing without installing Ruby and so forth.

I'm autobuilding this dockerfile with a matched repository name on [dockerhub](https://registry.hub.docker.com/repos/sheffien/). It comes with a couple of wrapper scripts to make it super simple to serve and manage multiple sites for testing. The `dserve` is an internal script used within the Docker container, but you'll want the `djserve` script somewhere...

Copy the bin/ script to your bin and then you can serve up any jekyll site with a quick command:

```
djserve path/to/blog
```

Then visit the site at `http://localhost:4000/`
