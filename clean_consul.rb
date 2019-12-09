#!/usr/bin/env ruby
def clean_consul
  Dir.chdir(__dir__) do
    system 'git submodule update --init'
  end

  Dir.chdir(File.join(__dir__, 'consul')) do
    system 'git reset --hard'
    system 'git clean -fd'
  end
end

clean_consul if $PROGRAM_NAME == __FILE__
