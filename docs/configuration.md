# Configure the mirroring pipelines

## Install the `fly` binary

At the time of write these instructions v6.6.0 of Concourse was the latest, always download the latest `fly` CLI.

The latest version can be found [here](https://github.com/concourse/concourse/releases/latest).

```bash
cd
mkdir -p .local/bin
cd .local/bin
curl -Lo fly.tgz https://github.com/concourse/concourse/releases/download/v6.6.0/fly-6.6.0-linux-amd64.tgz
tar -xvf fly.tgz
```

Make sure that the `$HOME/.local/bin` folder is on you path in your `.bashrc` file:

```bash
export PATH=$PATH:$HOME/.local/bin
```

Updating the CLI to the current version of Concourse will now be as simple as running `fly -t mirror sync`, _mirror_ being the target name we will use later in the configuration.

## Install the pipelines

### Get the repository

```bash
cd /data/scripts
git clone https://github.com/trecnoc/concourse-pipelines.git
```

### Generate a credentials file

Use the `generate_credentials.sh` script to generate a credential file.

Open the generated file and validate the content. If the content is correct run `ln -sf credentials_$(date +"%m%d%Y").yml credentials.yml`.

### Login to Concourse and set the Pipelines

```bash
cd concourse-pipelines
fly -t mirror l -c http://127.0.0.1:8080 -u <user running the pipelines> -p <password from syspass>
./set_pipelines.sh
```

## Automate pipelines management

A cronjob can be defined to automate pipeline management, ie. when changes are pushed to the master branch pipelines will automaticly be updated.

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
