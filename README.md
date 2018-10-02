# concourse-pipelines

### Table of Contents
* <a href='#install'>Install Docker</a>
* <a href='#prepare'>Prepare Server</a>
* <a href='#concourse'>Install and configure concourse</a>
* <a href='#run'>Run Docker Concourse</a>
* <a href='#configure'>Configure Pipelines</a>
* <a href='#roles'>Pipelines roles</a>
* <a href='#support'>Supporting tools</a>

## <a name='install'></a>Install Docker

###  Pre-requisite

To not fill up the root partition we will symlink dockers /var/lib/docker to our /data mount

```bash
$ mkdir /data/docker
$ cd /var/lib
$ ln -sf /data/docker .
```

###  Install required repositories and packages

```bash
$ sudo apt-get update
$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo apt-key fingerprint 0EBFCD88

pub   4096R/0EBFCD88 2017-02-22
      Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid                  Docker Release (CE deb) <docker@docker.com>
sub   4096R/F273FCD8 2017-02-22
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
$ sudo apt-get update
$ sudo apt-get install docker-ce docker-compose
$ sudo systemctl enable docker
``` 

### Run docker to confirm it works

`$ sudo docker run hello-world`

### Add our user to the docker group and test it works

```bash
$ sudo usermod -aG docker $USER
$ docker run hello-world
```

## <a name='prepare'></a>Prepare Server

### Data directory

```bash
$ sudo chown joe:joe /data/logs
$ sudo chown joe:joe /data/repo
$ sudo chown joe:joe /data/scripts
```

### User

```bash
$ cd ~
$ mkdir .ssh
$ chmod 700 .ssh
$ cd .ssh
$ ssh-keygen -t rsa -b 4096 -C "joe"
```

## <a name='concourse'></a>Install and configure concourse

### Clone the concourse-docker repository

```bash
$ cd /data/scripts
$ git clone https://github.com/concourse/concourse-docker.git
```

### Setup Docker Concourse

```bash
$ cd /data/scripts/concourse-docker
$ ./generate-keys.sh
```

### Edit the docker-compose.yml

```bash
$ cd /data/scripts/concourse-docker
$ vim docker-compose.yml
```

Lines to changes:
- Append after 5
  - `restart: always`
- Append after 16
  - `restart: always`
- Edit 27
  - Change the test user to joe:<password from syspass>
- Append after 27
  - `- CONCOURSE_MAIN_TEAM_LOCALUSER=joe`
- Append after 36
  - `restart: always`
  
## <a name='run'></a>Run Docker Concourse

`$ docker-compose -f /data/scripts/concourse-docker/docker-compose.yml up -d`

## <a name='configure'></a>Configure Pipelines

### Get the `fly` binary

```bash
$ cd /data/scripts
$ curl -Lo fly https://github.com/concourse/concourse/releases/download/v4.1.0/fly_linux_amd64 
$ chmod +x fly 
$ sudo mv fly /usr/local/bin/
```

### Clone the pipelines and generate the credentials file

```bash
$ cd /data/scripts
$ git clone https://github.com/stevesmatts/concourse-pipelines.git
$ cd concourse-pipelines
$ vim credentials.yml
```

Credentials.yml content:

```text
sync_server: <VM IP>
rsync_user: joe
rsync_key: |
  <CONTENT OF ~/.ssh/id_rsa>
github_access_token: <A GIT PERSONAL ACCESS TOKEN>
slack_hook: <SLACK INCOMING WEB HOOK>
slack_disabled: false      # Notification ca be disabled with this flag
```

### Login to Concourse and push the pipelines

```bash
$ cd concourse-pipelines
$ fly -t mirror l -c http://127.0.0.1:8080 -u joe -p <ENTER PASSWORD>
$ ./set_pipelines.sh
```

## <a name='roles'></a>Pipelines roles

### Buildpacks

Pulls the following artifacts:
- Pivotal Network:
  - binary-buildpack
  - go-buildpack
  - nodejs-buildpack
  - php-buildpack
  - python-buildpack
  - ruby-buildpack
  - staticfile-buildpack

### CF

Pulls the required artifacts defined in the cf-deployment github repo. See scripts/process-cf-repo-update.sh

### Concourse

Pulls the required artifacts defined in the concourse-bosh-deployment github repo. See scripts/process-concourse-repo-update.sh

### Director

Pulls the required artifacts defined in the bosh-deployment github repo. See scripts/process-bosh-repo-update.sh

### Mattermost

Pulls the following artifacts:
- bosh.io:
  - cloudfoundry-community/mattermost-boshrelease
  
### Memcache

Pulls the following artifacts:
- bosh.io:
  - cloudfoundry-community/memcache-release
  
### Minio

Pulls the following artifacts:
- bosh.io:
  - minio/minio-boshrelease
  
### MySQL

Pulls the following artifacts:
- bosh.io:
  - cloudfoundry/cf-mysql-release

### RabbitMQ

Pulls the following artifacts:
- bosh.io:
  - pivotal-cf/cf-rabbitmq-release
  - pivotal-cf/cf-rabbitmq-multitenant-broker-release
  - bosh-packages/cf-cli-release

### Tools
Pulls the following artifacts:
- github.com releases:
  - cloudfoundry/bosh-cli
  - cloudfoundry/cli
  - cloudfoundry-incubator/credhub-cli
  - cloudfoundry-incubator/bosh-backup-and-restore
  
## <a name='support'></a>Supporting Tools

### Cronjobs

#### Cleanup downloaded artifacts

Run the following as `joe` to install a cron job that will clean up the repo directory on boot:

```bash
$ crontab <<EOF
@daily find /data/repo/ -type f -mtime +2 -delete
EOF
```
