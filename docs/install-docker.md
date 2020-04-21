# Installing Docker

##  Pre-requisite

To not fill up the root partition we will symlink dockers `/var/lib/docker` to
our `/data` mount.

```bash
cd /var/lib
sudo ln -sf /data/docker .
```

###  Install required repositories and packages

```bash
sudo apt-get update
sudo apt-get install \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
sudo apt-get update
sudo apt-get install docker-ce docker-compose
sudo systemctl enable docker
```

### Test installation

Run the following command to ensure the installation was successfull.

```bash
sudo docker run hello-world
```

### Add current user to the docker group and test it works

```bash
sudo usermod -aG docker $USER
docker run hello-world
```
