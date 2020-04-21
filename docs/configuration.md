# Configure the mirroring pipelines

## Install the `fly` binary

At the time of write these instructions v6.0.0 of Concourse was the latest,
always download the latest `fly` CLI.

The latest version can be found [here](https://github.com/concourse/concourse/releases/latest).

```bash
cd
mkdir -p .local/bin
cd .local/bin
curl -Lo fly.tgz https://github.com/concourse/concourse/releases/download/v6.0.0/fly-6.0.0-linux-amd64.tgz
tar -xvf fly.tgz
```

Make sure that the `$HOME/.local/bin` folder is on you path in your `.bashrc` file:

```bash
export PATH=$PATH:$HOME/.local/bin
```

Updating the CLI to the current version of Concourse will now be as simple as
running `fly -t mirror sync`, _mirror_ being the target name we will use later in
the configuration.

## Install the pipelines

### Get the repository

```bash
cd /data/scripts
git clone https://github.com/trecnoc/concourse-pipelines.git
```

### Generate a credentials file

In `/data/scripts/concourse-pipelines` create a file called credentials.yml and
add the following entries:

```yml
rsync_server: <VM IP>
rsync_user: <user running the pipelines>
github_access_token: <a github personal access token otherwise API calls are throttled>
slack_disabled: <true|false to disable the Slack notifications>
slack_hook: <Slack notification webhook>
```

Now add the base64 encoded value of the private key of the user running the pipelines:

```bash
printf "rsync_key_base64: " >> credentials.yml
base64 ~/.ssh/id_rsa | tr -d '\n' >> credentials.yml
printf "\n" >> credentials.yml
```

Make sure the file is secure `chmod 660 credentials.yml`

### Login to Concourse and set the Pipelines

```bash
cd concourse-pipelines
fly -t mirror l -c http://127.0.0.1:8080 -u <user running the pipelines> -p <password from syspass>
./set_pipelines.sh
```

## Automate pipelines management

A cronjob can be defined to automate pipeline management, ie. when changes are
pushed to the master branch pipelines will automaticly be updated.

### Update script

Create a script in `/data/scripts` called `update_pipelines.sh`:

```bash
cd /data/scripts/concourse-pipelines
git pull
fly -t mirror l -c http://127.0.0.1:8080 -u <user running the pipelines> -p <password from syspass>
./set_pipelines.sh
```

Make the script executable: `chmod 770 update_pipelines.sh`

### Cronjob

Add the following lines to our users crontab:

```bash
# Update pipelines
@hourly /data/scripts/update_pipelines.sh
```
