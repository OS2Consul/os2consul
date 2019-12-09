#!/usr/bin/env ruby
require './clean'

def update
  clean

  Dir.chdir(File.join(__dir__, 'consul')) do
    system 'git checkout master'
    system 'git pull'
  end
end

update if $PROGRAM_NAME == __FILE__
