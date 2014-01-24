# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "amy"
  gem.homepage = "http://github.com/purbon/amy"
  gem.license = "MIT"
  gem.summary = %Q{Amy is the REST api stenographer}
  gem.description = %Q{Our REST API stenographer}
  gem.email = "pere.urbon@gmail.com"
  gem.authors = ["Pere Urbon-Bayes"]
  # dependencies defined in Gemfile
  gem.files = Dir['lib/**/*.rb', 'views/**/*']
  gem.executables = ["amy"]
  gem.add_dependency 'json'
  gem.add_dependency 'maruku'

end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec'
require 'rspec/core/rake_task'

desc "Specs all at ones."
RSpec::Core::RakeTask.new(:spec) do |t|
  t.fail_on_error = true
  t.verbose = false
end

ROOT = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(ROOT, 'lib')
Dir.glob('lib/**').each{ |d| $LOAD_PATH.unshift(File.join(ROOT, d)) }

namespace :dev do
  desc "Build and run the current gem version, no need to install it"
  task :build, [:source] do |t, args|
    require 'amy'
    parser = Amy::Parser.new
    parser.execute args[:source]
  end
  desc "Compile and minimize the generated js files"
  task :compilejs do
    puts "Compiling JS using the coffeescript compiler"
    `coffee -j views/js/amy.js -c views/js`
    require 'uglifier'
    File.open("views/js/amy.min.js", "w") do |file| 
      file.write Uglifier.compile(File.read("views/js/amy.js"))
    end
  end
  task :build => :compilejs
end

task :build => 'dev:compilejs'
task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "amy #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
