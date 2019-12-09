#!/usr/bin/env ruby
require './clean_consul'

def update_consul
  clean_consul

  Dir.chdir(File.join(__dir__, 'consul')) do
    system 'git checkout master'
    system 'git pull'
  end
end

update_consul if $PROGRAM_NAME == __FILE__
