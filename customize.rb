#!/usr/bin/env ruby
require 'fileutils'
require './clean'

def clone_tree(src, dst)
  puts "Applying customizations from #{src}"

  FileUtils.mkdir_p dst
  FileUtils.cp_r File.join(src, '.'), dst
end

def customize
  clean

  FileUtils.cp(
    File.join(__dir__, 'custom', 'Capfile'),
    File.join(__dir__, 'consul', 'Capfile')
  )

  FileUtils.cp(
    File.join(__dir__, 'custom', 'Gemfile'),
    File.join(__dir__, 'consul', 'Gemfile')
  )

  FileUtils.cp(
    File.join(__dir__, 'custom', 'Gemfile_custom'),
    File.join(__dir__, 'consul', 'Gemfile_custom')
  )

  FileUtils.cp(
    File.join(__dir__, 'custom', 'Gemfile.lock'),
    File.join(__dir__, 'consul', 'Gemfile.lock')
  )

  clone_tree(
    File.join(__dir__, 'custom', 'config'),
    File.join(__dir__, 'consul', 'config')
  )

  clone_tree(
    File.join(__dir__, 'custom', 'helpers'),
    File.join(__dir__, 'consul', 'app', 'helpers')
  )

  clone_tree(
    File.join(__dir__, 'custom', 'controllers'),
    File.join(__dir__, 'consul', 'app', 'controllers', 'custom')
  )

  clone_tree(
    File.join(__dir__, 'custom', 'assets', 'javascripts'),
    File.join(__dir__, 'consul', 'app', 'assets', 'javascripts')
  )

  clone_tree(
    File.join(__dir__, 'custom', 'assets', 'stylesheets'),
    File.join(__dir__, 'consul', 'app', 'assets', 'stylesheets')
  )

  clone_tree(
    File.join(__dir__, 'custom', 'components'),
    File.join(__dir__, 'consul', 'app', 'components', 'custom')
  )

  clone_tree(
    File.join(__dir__, 'custom', 'db', 'migrate'),
    File.join(__dir__, 'consul', 'db', 'migrate')
  )

  clone_tree(
    File.join(__dir__, 'custom', 'models'),
    File.join(__dir__, 'consul', 'app', 'models', 'custom')
  )

  clone_tree(
    File.join(__dir__, 'custom', 'views'),
    File.join(__dir__, 'consul', 'app', 'views', 'custom')
  )

  clone_tree(
    File.join(__dir__, 'custom', 'lib', 'tasks'),
    File.join(__dir__, 'consul', 'lib', 'tasks')
  )
end

customize if $PROGRAM_NAME == __FILE__
