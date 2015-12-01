# Just a convenient builder makefile to make it easy to build
# these docker images

all: rim rdev rmlr igv jim

rim:
	docker build -t sheffien/rim -f Dockerfile.rprod .

rdev:
	docker build -t sheffien/rdev -f Dockerfile.rdevel .

rmlr:
	docker build -t sheffien/drmlr -f Dockerfile.mlr .

igv:
	docker build -t sheffien/igv -f Dockerfile.igv .

jim:
	docker build -t sheffien/jim -f Dockerfile.jekyll .


linkchecker:
	docker build -t sheffien/linkchecker -f Dockerfile.linkchecker .

lola:
	docker build -t sheffien/lola -f Dockerfile.lola .

