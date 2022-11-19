# teleserv

A small python server sending VDT/VTX pages to a Minitel through a websocket.

WIP

### Requirements

If you don't plan to use Docker, the only requirements are python3 and a network
interface. See `requirements.txt` for python3 dependencies.

```
git clone https://github.com/bill-of-materials/teleserv.git
/usr/bin/env python3 -m pip install -r requirements.txt
```

### Usage

Teleserv is made to runs in alpine docker container. Dockerfile and
docker-compose files are provided, with a Makefile to build, run and publish
the docker image.

```bash
make run
```

### Development

```
make build
make run
```
