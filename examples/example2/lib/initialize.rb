require 'scheduler/scheduler'
require 'scheduler/workflow'
require 'yaml'
require 'rack/jsonp'
require 'log4r'

# Setup the environment
ENV['RACK_ENV'] = settings.environment.to_s || ENV['RACK_ENV']
ENV['RAILS_ENV'] = ENV['RACK_ENV']
raise "Unknown environment" unless ENV['RACK_ENV'].length > 0
env =ENV['RACK_ENV'].to_sym

# initialize necessary directories
['db', 'log', 'tmp', 'tmp/pids'].each do |dir|
  Dir.mkdir(dir) unless File.exist?(dir)
end

# Add javascript callbacks for cross domain requests
use Rack::JSONP

set :public_folder, Proc.new { File.join(root, "public") }

case env
  when :test
    mylog = Log4r::Logger.new 'scheduler'
    mylog.outputters << Log4r::Outputter.stdout
  when :development
    mylog = Log4r::Logger.new 'scheduler'
    mylog.outputters << Log4r::Outputter.stdout
    mylog.outputters << Log4r::FileOutputter.new('scheduler-development', :filename =>  'log/scheduler-development.log')
    set :port, 1884
  when :production
    mylog = Log4r::Logger.new 'scheduler'
    mylog.outputters << Log4r::FileOutputter.new('scheduler-production', :filename =>  'log/scheduler-production.log')
    set :port, 1884
  else
end

options = {:env => env}
Scheduler.start(options)
Workflow.start(options)

at_exit do
    ::Scheduler.stop()
    ::Workflow.stop()
end

#Load all app partials, without having to do it manually.
ROOT = File.expand_path(File.dirname(__FILE__))
Dir.glob("#{ROOT}/app/**/*").each{ |d| 
  next if File.directory?(d)
  require d 
}
