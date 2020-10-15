# Preparing the Server

The server needs to be an Ubuntu server with a `/data` partition for storing the mirrored artifacts.

## User

| Environment | User |
| ----------- | ---- |
| BW | joe |
| AVA | concourse |
| Local |whatever you want |

As the correct user running concourse and the pipelines, run the following to prepare the user for running the pipelines

```bash
cd ~
mkdir -p .ssh
chmod 700 .ssh
cd .ssh
ssh-keygen -t rsa -b 4096 -C "$USER"
cat id_rsa.pub >> authorized_keys
chmod 640 authorized_keys
```

Note: The `cat` of the id_rsa_pub is required for the rsync tasks running inside the pipelines to be able to copy the artifacts locally.

## Data directory

Run the following to pre-seed the data directory

```bash
sudo mkdir -p /data/docker
sudo chown $USER:$USER /data/docker
sudo mkdir -p /data/logs
sudo chown $USER:$USER /data/logs
sudo mkdir -p /data/repo
sudo chown $USER:$USER /data/repo
sudo mkdir -p /data/scripts
sudo chown $USER:$USER /data/scripts
```

## Maintenance Cronjobs

Add the following lines to our users crontab:

```bash
# Cleanup downloaded artifacts
@daily find /data/repo/ -type f -mtime +2 -delete
```
