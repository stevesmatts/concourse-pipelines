# Installing Concourse

## Clone the concourse-docker repository

```bash
cd /data/scripts
git clone https://github.com/concourse/concourse-docker.git
```

## Generate Concourse keys

```bash
cd /data/scripts/concourse-docker
./keys/generate
```

## Edit the docker-compose.yml

In `/data/script/concourse-docker`

### Add the restart policy

For each services add the following restart policy:

`restart: unless-stopped`

### Change local user

In the web service update the following 2 environment variables by first making
the necessary substitutions.

`CONCOURSE_ADD_LOCAL_USER: <user running concourse>:<password from syspass>`
`CONCOURSE_MAIN_TEAM_LOCAL_USER: <user running concourse>`

### *OPTIONAL* Add a local volume for the Postgres database

Adding a local volume to the Postgres database will allow that data in concourse to persist over `docker-compose -d`.

To add the volume add the following line in the db service:

`volumes: ["concourse-db:/var/lib/postgresql/data"]`

And add a volumes section:

```yml
volumes:
  concourse-db: {}
```

## Run Docker Concourse

### From `/data/scripts/concourse-docker` directory:

`docker-compose up -d`

### From any directory:

`docker-compose -f /data/scripts/concourse-docker/docker-compose.yml up -d`
