# concourse-pipelines

## Pipelines

### Mattermost

`fly -t mirror set-pipeline --pipeline mattermost --config pipelines/mattermost.yml --load-vars-from pipelines/credentials.yml`

- mattermost

### RabbitMQ

`fly -t mirror set-pipeline --pipeline rabbitmq --config pipelines/rabbitmq.yml --load-vars-from pipelines/credentials.yml`

- rabbitmq
- rabbitmq-broker
- cf-cli
