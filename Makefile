IMAGE := azmo/lutris
NAME := lutris

PWD := $(shell pwd)
USER_UID := $(shell id -u)
USER_GID := $(shell id -g)
VIDEO_GID := $(shell echo $(shell getent group video) | cut -d: -f3)

build:
	docker build --pull -t $(IMAGE) .

run:
	xhost +local:parsec
	docker run --rm --name $(NAME) --hostname $(NAME) \
		-e USER_UID=$(USER_UID) \
		-e USER_GID=$(USER_GID) \
		-e VIDEO_GID=$(VIDEO_GID) \
		-e DISPLAY=unix$(DISPLAY) \
		-e USER=runuser \
		-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
		-v /run/user/$(USER_UID)/pulse:/run/pulse:ro \
		-v /home/azmo/.lutris:/home/runuser \
		--device=/dev/dri \
		-it \
		$(IMAGE)
	xhost -local:$(NAME)

shell:
	 docker exec -it -u parsec -e COLUMNS="`tput cols`" \
	 	 -e LINES="`tput lines`" $(NAME) /bin/bash

push:
	docker push $(IMAGE)
