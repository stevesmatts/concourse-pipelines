# Installing Concourse

## Clone the concourse-docker repository

```bash
cd /data/scripts
git clone https://github.com/trecnoc/concourse-docker.git
```

## Configure docker

Follow the instructions in `/data/scripts/concourse-docker/README-CUSTOM.md`

## Run Docker Concourse

### From `/data/scripts/concourse-docker` directory

`docker-compose up -d`

### From any directory

`docker-compose -f /data/scripts/concourse-docker/docker-compose.yml up -d`
