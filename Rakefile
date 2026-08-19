require "bundler/setup"
require 'rake'

task :default => :preview

def staticmatic(command)
  require_relative 'config/boot'
  HamlSite.staticmatic.run(command)
end

desc "Checkout haml.github.io submodule"
task :submodules do
  sh %{git submodule sync}
  sh %{git submodule update --init --recursive}
  Dir.chdir('site') do
    sh "git checkout master"
    sh "git pull"
  end
end

desc "Build everything."
task :build => [:submodules, :site, :yardoc]

desc "Use StaticMatic to build the site."
task(:site => :haml) {staticmatic "build"}

desc "Preview the site with a local web server."
task(:preview => :haml) { exec "bundle", "exec", "puma", "-p", ENV.fetch("PORT", "3000") }

desc "Sync files to web server"
task(:sync => :submodules) do
  Dir.chdir('site') do
    sh "git add ."
    sh "git commit -m 'Regenerated website'"
    sh "git push"
  end
end

desc "Build the YARD documentation."
task :yardoc => :haml do
  require 'fileutils'
  Dir.chdir(".haml") {sh %{rake doc ANALYTICS=UA-3592613-6 YARD_TITLE="Haml Documentation"}}
  FileUtils.mkdir_p("site/docs")
  FileUtils.rm_rf("site/docs/yardoc")
  FileUtils.mv(".haml/doc", "site/docs/yardoc")
end

task :haml => ".haml" do
  Dir.chdir(".haml") do
    sh %{git fetch}
    sh %{git checkout origin/main}
  end
end

file ".haml" do
  sh %{git clone git://github.com/haml/haml.git .haml}
  Dir.chdir(".haml") do
    sh %{git checkout origin/main}
  end
end
