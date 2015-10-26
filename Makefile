.PHONY: all help build run builddocker rundocker kill rm-image rm clean enter logs
all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  This is merely a base image for usage read the README file
	@echo ""   1. make run       - build and run docker container

build: builddocker

run: ksppath rm NAME TAG builddocker rundocker

## useful hints
## specifiy ports
#-p 44180:80 \
#-p 27005:27005/udp \
## link another container
#--link some-mysql:mysql \
## assign environmant variables
#--env STEAM_USERNAME=`cat steam_username` \
#--env STEAM_PASSWORD=`cat steam_password` \

rundocker:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	chmod 777 $(TMP)
	@docker run --name=`cat NAME` \
	--cidfile="cid" \
	-d \
	-p 15900:5900 \
	-p 15900:5900/udp \
	-p 16099:6099 \
	-p 16099:6099/udp \
	-v $(TMP):$(TMP) \
	-v ~/.mono:/home/ckan/.mono \
	-v ~/.local:/home/ckan/.local \
	-v ~/.config:/home/ckan/.config \
	-v $(shell cat ksppath):/home/ckan/KSP \
	-v /var/run/docker.sock:/run/docker.sock \
	-v $(shell which docker):/bin/docker \
	-t `cat TAG`

builddocker:
	/usr/bin/time -v docker build -t `cat TAG` .

kill:
	-@docker kill `cat cid`

rm-image:
	-@docker rm `cat cid`
	-@rm cid

rm: kill rm-image

clean: cleanfiles rm

enter:
	docker exec -i -t `cat cid` /bin/bash

logs:
	docker logs -f `cat cid`

NAME:
	@while [ -z "$$NAME" ]; do \
		read -r -p "Enter the name you wish to associate with this container [NAME]: " NAME; echo "$$NAME">>NAME; cat NAME; \
	done ;

TAG:
	@while [ -z "$$TAG" ]; do \
		read -r -p "Enter the name you wish to associate with this container [TAG]: " TAG; echo "$$TAG">>TAG; cat TAG; \
	done ;

# will skip over this step if the name file is left from previous run 'make clean' to remove
ksppath:
	@while [ -z "$$KSPPATH" ]; do \
		read -r -p "Enter the path to the ksp folder you wish to sync with [KSPPATH]: " KSPPATH; echo "$$KSPPATH">>ksppath; cat ksppath; \
	done ;

vnc:
	xtightvncviewer 127.0.0.1:15900
