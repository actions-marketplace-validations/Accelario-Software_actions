# Accelario Virtualization Create VDB action

Accelario Virtualization can be integrated natively into GitHub workflow.

The action helps to create a VDB as part of GitHub workflow.

#### How to use

The action relies on pre-defined **variables**:
* `VIRTUALIZATION_IP` - the IP/hostname of an Accelario Virtualization central server
* `SNAPSHOT_ID` - snapshot id to create VDB from
* `TGT_HOME_ID` - target home id to start the VDB in

The action relies on pre-defined **secrets**:
* `VIRTUALIZATION_LOGIN` - username to Accelario Virtualization
* `VIRTUALIZATION_PASSWORD` - password to Accelario Virtualization

Define the variables and secrets in your repository > Settings > Secrets and variables

#### Prerequisites
* Working Accelario Virtualization product
* A pre-configured source GI (Golden Image)
* A pre-configured target server to start the VDB on
