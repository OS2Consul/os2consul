#!/usr/bin/env ruby
require 'yaml'
require 'fileutils'
require 'securerandom'
require './customize'

CONFIG_FILE = File.join(__dir__, 'config.local.yml')
CONFIG_KEYS = %w[NEMLOGIN_WSDL_URI NEMLOGIN_LOGIN_URI NEMLOGIN_LOGOUT_URI NEMLOGIN_MNEMO].freeze

DOCKER_COMPOSE_FILE = File.join(__dir__, 'consul', 'docker-compose.yml')

def ask_for_config(keys)
  config = { 'environment' => {} }
  keys.each do |key|
    puts "Enter #{key}:"
    config['environment'][key] = gets.chomp
  end
  config['environment']['RAILS_SECRET_KEY_BASE'] = SecureRandom.hex(64)
  config['db_migrated'] = false
  config
end

def read_config
  write_config(File.exist?(CONFIG_FILE) ? YAML.safe_load(File.read(CONFIG_FILE)) : ask_for_config(CONFIG_KEYS))
end

def write_config(config)
  File.open(CONFIG_FILE, 'w') { |file| file.write(config.to_yaml) }
  config
end

def augment_docker_compose_file(config)
  compose_config = YAML.safe_load(File.read(DOCKER_COMPOSE_FILE))

  config['environment'].each do |k, v|
    next if compose_config['services']['app']['environment'].any? { |v| v.start_with? "#{k}=" }

    compose_config['services']['app']['environment'] << "#{k}=#{v}"
  end

  File.open(DOCKER_COMPOSE_FILE, 'w') { |file| file.write(compose_config.to_yaml) }
end

def local
  customize
  config = read_config
  augment_docker_compose_file(config)

  FileUtils.rm_f(File.join(__dir__, 'consul', 'tmp', 'pids', 'server.pid'))

  Dir.chdir(File.join(__dir__, 'consul')) do
    unless config['db_migrated']
      system 'docker compose run --rm app /usr/local/bin/rake db:create'
      system 'docker compose run --rm app /usr/local/bin/rake db:migrate'
      system 'docker compose run --rm app /usr/local/bin/rake db:dev_seed'

      config['db_migrated'] = true
      write_config(config)
    end

    exec 'docker compose up'
  end
end

local if $PROGRAM_NAME == __FILE__
