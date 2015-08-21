# Just a convenient builder makefile to make it easy to build
# these docker images

all: rdev rmlr igv rim jim

rdev:
	docker build -t sheffien/rdev .

rmlr:
	docker build -t sheffien/drmlr -f Dockerfile.mlr .

igv:
	docker build -t sheffien/igv -f Dockerfile.igv .

rim:
	docker build -t sheffien/rim -f Dockerfile.rprod .

jim:
	docker build -t sheffien/jim -f Dockerfile.jekyll .

