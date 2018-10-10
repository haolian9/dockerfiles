
source := ${PWD}/docker-compose.sh
target := /usr/local/bin/docker-compose

install:
	@ [ ! -f "${target}" ]
	sudo ln -s ${source} ${target}

clean:
	@ [ -L "${target}" ] && [ "$$(ls -l ${target} | awk '{ print $$NF }')" = "${source}" ]
	sudo rm ${target}
