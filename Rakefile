require "bundler/setup"
require 'rake'
require 'date'

task :default => :preview

$: << File.dirname(__FILE__)
if defined?(Encoding)
  Encoding.default_external = 'UTF-8'
  Encoding.default_internal = 'UTF-8'
end

desc "Build everything."
task :build => [:site, :yardoc]

#mostly from https://github.com/middleman/middleman/blob/master/middleman-core/bin/middleman
def middleman(command)
  require 'middleman-core/profiling'
  Middleman::Profiling.start
  require 'middleman-core/load_paths'
  Middleman.setup_load_paths
  require 'middleman-core/cli'
  Middleman::Cli::Base.start([command])
end

desc "Use Middleman to build the site."
task(:site => :haml) { middleman 'build' } 

desc "Preview the site with Middleman."
task(:preview => :haml) { middleman 'server' }

desc "Sync files to web server"
task(:sync) { sh "rsync -e 'ssh -p 2233' -avz build/ haml.info:/var/sites/haml.info/"}

desc "Build the YARD documentation."
task :yardoc => :haml do
  require 'fileutils'
  Dir.chdir(".haml") {sh %{bundle exec rake doc ANALYTICS=UA-3592613-6 YARD_TITLE="Haml Documentation"}}
  FileUtils.mkdir_p("build/docs")
  FileUtils.rm_rf("build/docs/yardoc")
  FileUtils.mv(".haml/doc", "build/docs/yardoc")
end

task :haml => ".haml" do
  Dir.chdir(".haml") do
    sh %{git fetch}
    sh %{git checkout origin/stable}
    # Check out the most recent released stable version
    File.read("lib/haml/version.rb").strip =~ /VERSION = (.*)\n/
    sh %{git checkout #{$1}}
  end
end

file ".haml" do
  sh %{git clone git://github.com/haml/haml.git .haml}
  Dir.chdir(".haml") do
    sh %{git checkout origin/stable}
  end
end
