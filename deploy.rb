#!/usr/bin/env ruby
require 'yaml'
require 'fileutils'
require './customize'

CONFIG_FILE = File.join(__dir__, 'config.deploy.yml')
DEPLOY_SECRETS_FILE = File.join(__dir__, 'consul', 'config', 'deploy-secrets.yml')

def ask_for_config
  config = {}
  puts 'Enter production server IP:'
  config['server'] = gets.chomp
  config
end

def read_config
  write_config(File.exist?(CONFIG_FILE) ? YAML.safe_load(File.read(CONFIG_FILE)) : ask_for_config)
end

def write_config(config)
  File.open(CONFIG_FILE, 'w') { |file| file.write(config.to_yaml) }
  config
end

def augment_deploy_secrets(config)
  deploy_secrets = YAML.safe_load(File.read(DEPLOY_SECRETS_FILE))
  deploy_secrets['production']['server1'] = config['server']
  File.open(DEPLOY_SECRETS_FILE, 'w') { |file| file.write(deploy_secrets.to_yaml) }
end

def deploy
  customize
  augment_deploy_secrets(read_config)

  system 'gem install --conservative whenever -v "~> 0.10.0"'
  system 'gem install --conservative capistrano -v 3.10.1'
  system 'gem install --conservative capistrano-archive -v 1.0.0'
  system 'gem install --conservative capistrano-bundler -v "~> 1.2"'
  system 'gem install --conservative capistrano-rails -v "~> 1.4.0"'
  system 'gem install --conservative capistrano3-delayed-job -v "~> 1.7.3"'
  system 'gem install --conservative capistrano3-puma -v "~> 4.0.0"'
  system 'gem install --conservative rvm1-capistrano3 -v "~> 1.4.0"'

  FileUtils.rm_f(File.join(__dir__, 'consul', 'dist.tar.bz2'))
  FileUtils.mkdir_p(File.join(__dir__, 'consul', 'tmp'))

  Dir.chdir(File.join(__dir__, 'consul')) do
    system 'echo `git rev-parse HEAD` > REVISION'
    system 'tar -cjf tmp/dist.tar.bz2 --exclude .git --exclude config/database.yml --exclude config/secrets.yml --exclude log --exclude tmp --exclude public/assets --exclude public/ckeditor_assets --exclude public/system .'
    FileUtils.mv(
      File.join(__dir__, 'consul', 'tmp', 'dist.tar.bz2'),
      File.join(__dir__, 'consul', 'dist.tar.bz2')
    )
    system 'cap production deploy'
  end

  FileUtils.rm_f(File.join(__dir__, 'consul', 'dist.tar.bz2'))
end

deploy if $PROGRAM_NAME == __FILE__
