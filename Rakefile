require 'rubygems'
require "bundler/setup"
require 'rake'
require 'date'

$: << File.dirname(__FILE__)
if defined?(Encoding)
  Encoding.default_external = 'UTF-8'
  Encoding.default_internal = 'UTF-8'
end

def staticmatic(command)
  require '.haml/lib/haml'
  require 'staticmatic'
  configuration = StaticMatic::Configuration.new
  eval(File.read("config/site.rb"))
  StaticMatic::Base.new(".", configuration).run(command)
end

desc "Build everything."
task :build => [:site, :yardoc]

desc "Use StaticMatic to build the site."
task(:site => :haml) {staticmatic "build"}

desc "Preview the site with StaticMatic."
task(:preview => :haml) {staticmatic "preview"}

desc "Sync files to web server"
task(:sync) { sh "rsync -e 'ssh -p 2233' -avz site/ rubysouth.org:/var/sites/haml-lang.com/"}

desc "Build the YARD documentation."
task :yardoc => :haml do
  require 'fileutils'
  Dir.chdir(".haml") {sh %{rake doc ANALYTICS=UA-535380-9 YARD_TITLE="Haml Documentation"}}
  FileUtils.mkdir_p("site/docs")
  FileUtils.rm_rf("site/docs/yardoc")
  FileUtils.mv(".haml/doc", "site/docs/yardoc")
end

task :haml => ".haml" do
  Dir.chdir(".haml") do
    sh %{git fetch}
    sh %{git checkout origin/stable}
    # Check out the most recent released stable version
    sh %{git checkout #{File.read("VERSION").strip}}
  end
end

file ".haml" do
  sh %{git clone --depth 1 git://github.com/haml/haml.git .haml}
  Dir.chdir(".haml") do
    sh %{git checkout origin/stable}
  end
end
