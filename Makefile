# Just a convenient builder makefile to make it easy to build
# these docker images

# To save the log of the build process, I execute it in the background and then
# use tail --follow to spit this also to the screen.

jabref:
	docker build -t nsheff/jabref -f Dockerfile.jabref .

shiny:
	docker build -t nsheff/shiny -f Dockerfile.shiny .

pandocker:
	docker build -t nsheff/pandocker -f Dockerfile_pandocker .

jim:
	docker build -t nsheff/jim -f Dockerfile_jim .

liquify:
	docker build -t nsheff/liquify -f Dockerfile_liquify .

ffmpeg:
	docker build -t nsheff/ffmpeg -f Dockerfile_ffmpeg .

vis:
	docker build -t nsheff/vis -f Dockerfile_vis .


all: rim rdev rmlr igv jim


rim:
	docker build -t nsheff/rim -f Dockerfile.rprod .

rdev:
	docker build -t nsheff/rdev -f Dockerfile.rdevel . | tee logs/log_rdevel.txt


# Use this to update to latest R.
rdev-nocache:
	time docker build --no-cache -t nsheff/rdev -f Dockerfile.rdevel . | tee logs/log_rdevel.txt 
	docker push nsheff/rdev


rmlr:
	docker build -t nsheff/drmlr -f Dockerfile.mlr .

igv:
	docker build -t nsheff/igv -f Dockerfile.igv .


linkchecker:
	docker build -t nsheff/linkchecker -f Dockerfile.linkchecker .

lola:
	docker build -t nsheff/lola -f Dockerfile.lola .

refgenie:
	docker build -t nsheff/refgenie -f Dockerfile_refgenie .
