# Just a convenient builder makefile to make it easy to build
# these docker images

# To save the log of the build process, I execute it in the background and then
# use tail --follow to spit this also to the screen.


all: rim rdev rmlr igv jim

rim:
	docker build -t sheffien/rim -f Dockerfile.rprod .

rdev:
	docker build -t sheffien/rdev -f Dockerfile.rdevel . > log_rdevel.txt

rdev-nocache:
	time docker build --no-cache -t sheffien/rdev -f Dockerfile.rdevel . > log_rdevel.txt &
	tail --follow log_rdevel.txt


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

