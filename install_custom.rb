#!/usr/bin/env ruby
require 'fileutils'
require './clean_consul'

def install_custom_tree(src, dst)
  puts "Applying customizations from #{src}"

  FileUtils.mkdir_p dst
  FileUtils.cp_r File.join(src, '.'), dst
end

def install_custom
  clean_consul

  FileUtils.cp(
    File.join(__dir__, 'custom', 'Capfile'),
    File.join(__dir__, 'consul', 'Capfile')
  )

  install_custom_tree(
    File.join(__dir__, 'custom', 'config'),
    File.join(__dir__, 'consul', 'config')
  )

  install_custom_tree(
    File.join(__dir__, 'custom', 'controllers'),
    File.join(__dir__, 'consul', 'app', 'controllers', 'custom')
  )

  install_custom_tree(
    File.join(__dir__, 'custom', 'db', 'migrate'),
    File.join(__dir__, 'consul', 'db', 'migrate')
  )

  install_custom_tree(
    File.join(__dir__, 'custom', 'models'),
    File.join(__dir__, 'consul', 'app', 'models', 'custom')
  )

  install_custom_tree(
    File.join(__dir__, 'custom', 'views'),
    File.join(__dir__, 'consul', 'app', 'views', 'custom')
  )
end

install_custom if $PROGRAM_NAME == __FILE__
