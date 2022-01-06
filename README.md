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

### Prerequisites
* Prepare destination environment. See [Deployment configuration](https://github.com/OS2Consul/os2consul#deployment-configuration)
* [Install ruby](https://www.ruby-lang.org/en/documentation/installation/)
* Add following environment variables to your machine.
  ```
  export GEM_HOME=[/path/to/home/folder]/.gems
  export PATH=$PATH:[/path/to/home/folder]/.gems/bin
  ```

### Run deployment process

```
./deploy.rb
```

### Troubleshooting

#### 1. Handling correct capistrano version.
  If you get following error:
  ```
  Capfile locked at ~> 3.10.1, but 3.16.0 is loaded
  ```
  Remove capistrano v3.16.0 with command `gem uninstall capistrano -v 3.16.0`

#### 2. Build gem native extensions failed
  If you get following error:
  ```
  ERROR:  Error installing capistrano3-puma:
    ERROR: Failed to build gem native extension.
  ```
Install develoment verison of ruby with generic command `sudo apt-get install ruby-dev`


## update.rb

Run this script to update the CONSUL submodule to the latest commit from the upstream
`master` branch.
