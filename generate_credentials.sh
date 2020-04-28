#!/usr/bin/env bash

function cleanup {
  rm -f temp.yml
}
trap cleanup EXIT

printf "Welcome to the credentials file generator\n\n"

printf "The following questions relates to the mirroring server rsync information\n"
read -p "Enter the rsync server host or ip: " rsyncServer
read -p "Enter the rsync server user: " rsyncUsername
read -p "Enter the rsync user private key file file path ex: /home/user/.ssh/id_rsa: " -e rsyncPrivateKey
printf "\nThe following question relates to the notification resources\n"
read -p "Enter the Slack webhook: " slackWebhook
printf "\nThe following question relates to the Git/Github resources\n"
read -p "Enter the Github access token: " githubToken

if [[ ! -f "${rsyncPrivateKey}" ]]; then
  printf "\nRsync private key file doesn't exist (%s)\n" ${rsyncPrivateKey}
  exit 1
fi

export rsyncServer
export rsyncUsername
export rsyncPrivateKey
export slackWebhook
export githubToken

generatedCredentials=credentials_$(date +"%m%d%Y").yml

rm -f temp.yml
( echo "cat <<EOF >$generatedCredentials";
  cat credentials.yml.template;
  echo "EOF";
) >temp.yml
. temp.yml

chmod 660 $generatedCredentials

printf "\nGenerated credential file '%s'\n" $generatedCredentials
