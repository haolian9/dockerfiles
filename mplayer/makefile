
image ?= sangwo/misc:mplayer

build:
	@ docker build -t ${image} .

clean:
	# todo rm derived container
	@ docker rmi ${image}
