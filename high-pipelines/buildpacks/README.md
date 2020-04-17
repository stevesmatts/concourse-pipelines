# Buildpacks pipeline

This pipeline can be used to update and build a Buildpack Bosh release. It is used
to bump the included buildpack blob to the latest version and create a new bosh
release for it.

The pipeline is triggered from a new buildpack artifact discovered in Nexus.

Outputs will be the updated Buildpack Bosh release repository and the new Bosh release
uploaded to Nexus.

## Setup

### Common settings

#### Credentials

Currently the `reconfigure-pipeline` script looks for a file called `creds.yml`
in the pipeline folder. This file needs to contain the following list of credentials
for the pipeline to run successfully. These credentials are common for all buildpacks
pipelines.

* `bot-email`: Email used for the git commit author.
* `bot-user`: Name used for the git commit author.
* `bucket-access-key`: Buildpack Bosh release blobstore `access_key_id` which will
  be place in the `config/private.yml` file.
* `bucket-secret-key`: Buildpack Bosh release blobstore `secret_access_key` which
  will be place in the `config/private.yml` file.
* `buildpack-git-username`: Git user for doing the push on the repository.
* `buildpack-git-password`: Git user password for doing the push on the repository.
* `nexus-username`: Nexus user for accessing/uploading to the repository.
* `nexus-password`: Nexus password for accessing/uploading to the repository.
* `slack-webhook`: Slack webhook for notifications.

#### Common parameters

Common parameters are stored in the `vars-common.yml` file and include the following:

* `tasks-repository`: Git repository containing our common pipeline tasks.
* `tasks-branch`: Git repository branch containing our common pipeline tasks.
* `nexus-url`: The Nexus server URL for fetching the buildpack artifact and uploading
  the bosh release.
* `nexus-debug`: Can be set to `true` to enable debugging of the [nexus-resource](https://github.com/trecnoc/nexus-resource).
* `nexus-repository`: The Nexus repository containing the buildpacks and bosh releases.
* `nexus-buildpack-group`: The Nexus repository group containing the buildpacks.
* `nexus-bosh-group`: The Nexus repository group for uploading the Bosh releases.

### Individual pipeline

To deploy a new Buildpack pipeline simply create a `vars-${pipeline-name}.yml`
with the required parameters for the Buildpack.

* `nexus-buildpack-regexp`: The regular expression used to find a new version of
  a buildpack in Nexus. This regular expression must contain one capture group which
  is used to extract the version (see [nexus-resource](https://github.com/trecnoc/nexus-resource)).
* `nexus-bosh-regexp`: The regular expression used to find a new version of the
  bosh release of the buildpack in Nexus. This regular expression must contain
  one capture group which is used to extract the version (see [nexus-resource](https://github.com/trecnoc/nexus-resource)).
* `buildpack-git-repository`: Buidpack Bosh release Git repository (https only).
* `buildpack-git-branch`: Buidpack Bosh release Git repository branch.
* `buildpack-blob-name`: Blob name in the Bosh release, this corresponds to the
  prefix of the blob path.
* `buildpack-blob-regexp`: Regex to find the matching buildpack blob (based on
  the path) and extract the current version.

And then to deploy the pipeline run:

`./reconfigure-pipeline <FLY TARGET> <PIPELINE NAME>`
