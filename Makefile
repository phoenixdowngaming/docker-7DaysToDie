all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  This is merely a base image for usage read the README file
	@echo ""   1. make run       - build and run docker container

build: builddocker beep

run: steam_username steam_password builddocker rundocker beep

rundocker:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	$(eval NAME := $(shell cat NAME))	
	$(eval TAG := $(shell cat TAG))
	$(eval STEAM_USERNAME := $(shell cat STEAM_USERNAME))
	$(eval STEAM_PASSWORD := $(shell cat STEAM_PASSWORD))
	$(eval IP := $(shell cat IP))
	$(eval TARGET_IP := $(shell cat TARGET_IP))
	$(eval SERVER_PASSWORD := $(shell cat SERVER_PASSWORD))
	chmod 777 $(TMP)
	@docker run --name=$(NAME) \
	--cidfile="cid" \
	-v $(TMP):/tmp \
	-v /var/run/docker.sock:/run/docker.sock \
	-v $(shell which docker):/bin/docker \
	-v /exports/gamedata/7dtd:/home/steam/.local/share/ \
	-v /home/steam/.steam/:/home/steam/.steam \
	-p 4.31.168.84:26900:26900/udp \
	-p 4.31.168.84:26901:26901/udp \
	-p 4.31.168.84:10080:10080/tcp \
	-p 4.31.168.84:10081:10081/tcp \
	--env STEAM_USERNAME=`cat steam_username` \
	--env STEAM_PASSWORD=`cat steam_password` \
	--env STEAM_GUARD_CODE=`cat steam_guard_code` \
	-t thalhalla/7daystodie


builddocker:
	/usr/bin/time -v docker build -t thalhalla/7daystodie .

beep:
	@echo "beep"
	@aplay /usr/share/sounds/alsa/Front_Center.wav

kill:
	@docker kill `cat cid`

rm-steamer:
	rm  steamer.txt

rm-name:
	rm  name

rm-image:
	@docker rm `cat cid`
	@rm cid

cleanfiles:
	rm name
	rm steam_username
	rm steam_password

rm: kill rm-image

clean: cleanfiles rm

enter:
	docker exec -i -t `cat cid` /bin/bash

steam_username:
	@while [ -z "$$STEAM_USERNAME" ]; do \
		read -r -p "Enter the steam username you wish to associate with this container [STEAM_USERNAME]: " STEAM_USERNAME; echo "$$STEAM_USERNAME">>steam_username; cat steam_username; \
	done ;

steam_guard_code:
	@while [ -z "$$STEAM_GUARD_CODE" ]; do \
		read -r -p "Enter the steam guard code you wish to associate with this container [STEAM_GUARD_CODE]: " STEAM_GUARD_CODE; echo "$$STEAM_GUARD_CODE">>steam_guard_code; cat steam_guard_code; \
	done ;

steam_password:
	@while [ -z "$$STEAM_PASSWORD" ]; do \
		read -r -p "Enter the steam password you wish to associate with this container [STEAM_PASSWORD]: " STEAM_PASSWORD; echo "$$STEAM_PASSWORD">>steam_password; cat steam_password; \
	done ;

