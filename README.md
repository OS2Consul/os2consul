# bellcom-consul

This repository contains customizations for [CONSUL](https://github.com/consul/consul)
to use [NemLog-in](https://digst.dk/it-loesninger/nemlog-in/) for authentication.

In order to avoid maintaining a separate fork of the application, it is retrieved
as a git submodule and subsequently customized using the scripts in the repository root.

## List of customizations

- Default to log in using NemLog-in, unless requesting a page in the `/admin` namespace
- Disable OAuth authentication
- Disable user registration
- Disable password recovery
- Disable user account deletion
- Add support for storing and displaying full names of users

## Deployment configuration

The production deployment target is a single `Debian Stretch` host, bootstrapped using the
[CONSUL installer](https://github.com/consul/installer).

# Workflow scripts

## local.rb

Invokes the local development server through Docker Compose. Before invocation, the
customizations are installed and the database is configured. This is the starting point
for doing development on the customizations locally.

Upon first invocation, the developer will be prompted to enter the configuration options
necessary for NemLog-in to function.

## deploy.rb

Runs a production deployment based on the current contents of the working directory.

## update.rb

Run this script to update the CONSUL submodule to the latest commit from the upstream
`master` branch.
