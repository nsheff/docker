SHELL:=/bin/bash

# Just a convenient builder makefile to make it easy to build
# these docker images

IMAGES := $(shell ls Dockerfile_* | sed 's/Dockerfile_//g')
.PHONY: $(IMAGES)

define build_image
	time docker build -t nsheff/$(1) -f Dockerfile_$(1) . | tee logs/log_$(1).txt
endef

# This piece of work is assigning the make variable to a bash variable, using
# bash variable replacement to create a new variable that lacks the '-nocache'
# flag, and then uses that new variable (as a bash variable). Wow, what a pain,
# but I could not figure out how to get string replacements working directly
# on make variables...
define build_image_nocache
	longtgt=$(1); tgt=$${longtgt/-nocache/}; time docker build --no-cache -t nsheff/$$tgt -f Dockerfile_$$tgt . | tee logs/log_$$tgt.txt
endef


# This will create generic recipes following the build_image functions above
# for each entry in the IMAGES list

# Then it will also create new recipes for each of these, with "-nocache" added.
# if you call that nocache recipe, it will call the build_image_nocache function
# instead, which just adds the --nocache to the docker build call... it looks 
# a lot more complicated than it really is.

$(IMAGES):
	$(call build_image,$@)

NOCACHE_TARGETS=$(addsuffix -nocache, $(IMAGES))

$(NOCACHE_TARGETS):
	$(call build_image_nocache,$@)


# All of these other recipes can theoretically be eliminmated now,
# as long as they follwo the standard naming convention:

# Dockerfile is named: Dockerfile_IMAGE
# image is named: nsheff/IMAGE


# Use this to update to latest R.
rupdate:
	# First pull the latest base image
	docker pull bioconductor/devel_core2
	# Rebuild our image with no cache.
	time docker build --no-cache -t nsheff/rdev -f Dockerfile_rdev . | tee logs/log_rdevel.txt 
	docker push nsheff/rdev

