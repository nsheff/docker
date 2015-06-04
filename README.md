 # rim
A repository for my Dockerfile that produces a docker image to produce containers with my dev environment with R set up how I want it, with packages, etc. 

Build it with:

```
cd rdev
docker build -t sheffien/rdev .
docker build -t sheffien/rdevel -f Dockerfile.rdevel .
```
