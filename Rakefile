# encoding: utf-8

ROOT = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(ROOT, 'lib')
Dir.glob('lib/**').each{ |d| $LOAD_PATH.unshift(File.join(ROOT, d)) }

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
  gem.summary = %Q{A REST API documentation engine}
  gem.description = %Q{Amy helps us to get a nice web docs, rdoc alike, of our REST API, that we can use as a main reference for users.}
  gem.email = "pere.urbon@gmail.com"
  gem.authors = ["Pere Urbon-Bayes"]
  # dependencies defined in Gemfile
  gem.files = Dir['lib/**/*.rb', 'views/**/*']
  gem.executables = ["amy"]

end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec'
require 'rspec/core/rake_task'

desc "Specs all at ones."
RSpec::Core::RakeTask.new(:spec) do |t|
  t.fail_on_error = true
  t.verbose = false
end

# Load custom tasks for this gem
Dir.glob('lib/amy/tasks/*.rake').each { |r| load r}

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "amy #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
