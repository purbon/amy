require 'helpers/helpers'
require 'scheduler/scheduler'
require 'scheduler/workflow'


class App < Sinatra::Application
 
  include Helpers

  before do
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Methods"] = "PUT, GET, POST, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"

    http_accept = request.env['HTTP_ACCEPT'].downcase
    validation = ['*/*', 'application/json', 'text/event-stream'].map do |header_field|
      http_accept.include?(header_field)
    end
    halt 406 unless validation.uniq.include?(true)

    content_type 'application/json'
  end

  get '/' do
   log 'documentation request'
   redirect 'docs/index.html'
  end

  ##
  # @name registry
  # @title Get's info about all registered jobs
  # @description List of available jobs under the registry
  ##
  get '/registry' do
    respond_with ::Scheduler.get_registry().to_hash
  end

  ##
  # @name registry_collection
  # @title Get a job from the registry
  # @params
  #   collection string
  #   name string
  # @description Operates jobs within the registry
  ##
  get '/registry/:collection/:name' do |collection, name|
    registry = ::Scheduler.get_registry().to_hash
    respond_with registry[collection][name]
  end

  ##
  # @name registry_collection
  # @title Add a job from the registry
  # @params
  #   collection string
  #   name string
  ##
  post '/registry/:collection/:name' do |collection, name| 
    params = read_parameters request
    config = params['config']
    respond_with ::Scheduler.registry(collection, name, config)
  end

  ##
  # @name registry_collection
  # @title Remove a collection of jobs from the registry
  # @params
  #   collection string
  # @description Operates collection within the registry
  ##
  delete "/registry/:collection" do | collection|
    respond_with ::Scheduler.unregister(collection, '')
  end

  ##
  # @name registry_collection
  # @title Remove a job from the registry
  # @params
  #   collection string
  #   name string
  ##
  delete "/registry/:collection/:name" do |collection, name|
    respond_with ::Scheduler.unregister(collection, name)
  end

  ##
  # @name jobs_collection
  # @title Get the list of scheduled jobs from a given collection
  # @params
  #   collection string
  # @description Run job collections within the scheduler
  ##
  get "/jobs/:collection" do |collection|
    respond_with ::Scheduler.list_jobs_from(collection)
  end

  ##
  # @name jobs_collection
  # @title Get the list of scheduled jobs of a given kind
  # @params
  #   collection string
  #   name string
  # @description Operates jobs with the scheduler
  ##
  get "/jobs/:collection/:name" do |collection, name|
    respond_with ::Scheduler.list_jobs_from(collection, name)
  end
  
  ##
  # @name jobs_collection
  # @title Schedule a given job
  # @params
  #   collection string
  #   name string
  ##
  post "/jobs/:collection/:name" do |collection, name|
    params  = read_parameters request
    pattern = get_param params, 'pattern', true
    run     = get_param params, 'run', true
    if not run then
      respond_with ::Scheduler.schedule(collection, name, pattern, params)
    else
      respond_with ::Scheduler.run(collection, name, params)
    end
  end

  put "/jobs/:collection/:name/:job_id/pause" do |collection, name, job_id|
    respond_with ::Scheduler.pause(job_id)
  end

  put "/jobs/:collection/:name/:job_id/resume" do |collection, name, job_id|
    respond_with ::Scheduler.resume(job_id)
  end

  get "/jobs/:collection/:name/:job_id/status" do |collection, name, job_id|
    status = ::Scheduler.status(job_id)
    config = ::Scheduler.info(job_id)
    respond_with({ "config" => config, "status" => status })
  end

  get "/jobs" do
    respond_with ::Scheduler.dump
  end

  get "/inspect/jobs" do 
    respond_with ::Scheduler.get_inspector()
  end

  get "/inspect/jobs/:collection/:name" do |collection, name|
    data = ::Scheduler.get_inspector_from(collection, name)
    data = {} unless data
    respond_with data
  end

  get "/systems/reporters/:collection/:name/memory" do |collection, name|
    reporter = Scheduler::Reporter.instance
    meminfo  = reporter.get_memory_report(collection, name)
    respond_with meminfo
  end

  get "/systems/reporters/:collection/:name/memory/:type" do |collection, name, type|
    reporter = Scheduler::Reporter.instance
    meminfo  = reporter.get_memory_report(collection, name, type)
    respond_with meminfo
  end

  get "/systems/reporters/:collection/:name/time" do |collection, name|
    reporter = Scheduler::Reporter.instance
    timeinfo = reporter.get_time_report(collection, name)
    respond_with timeinfo
  end

  get "/systems/reporters/:collection/:name/time/jobs" do |collection, name|
    reporter = Scheduler::Reporter.instance
    timeinfo = reporter.get_time_report_for_jobs(collection, name)
    respond_with timeinfo
  end

   get "/systems/reporters/:collection/:name/time/jobs/:job" do |collection, name, job|
    reporter = Scheduler::Reporter.instance
    timeinfo = reporter.get_time_report_for_jobs(collection, name, job)
    respond_with timeinfo
  end

  get "/systems/config/memory" do
    reporter = Scheduler::Reporter.instance
    respond_with reporter.list_memory_keys
  end

  get "/systems/config/collections" do
    reporter = Scheduler::Reporter.instance
    respond_with reporter.list_collections
  end

  get "/systems/config/collections/:collection" do |collection|
    reporter = Scheduler::Reporter.instance
    respond_with reporter.list_names(collection)
  end

  get "/systems/config/collections/:collection/names/:name/jobs" do |collection, name|
    reporter = Scheduler::Reporter.instance
    respond_with reporter.list_jobs_for(collection, name)
  end

  get "/monitor/jobs" do
    dump = Scheduler.dump
    aa = dump.keys.map! do |key|
      a = []
      collection = "", name = "";
      dump[key].keys.each do |skey|
        dump[key][skey].each_pair do |tkey, value|
          if value.is_a?(Hash) then
            a << value.to_a
          else
            a << value
            collection = value if (:collection == tkey)
            name       = value if (:name == tkey)
          end
        end
      end
      a.unshift("<a href='../jobs/#{collection}/#{name}/#{key}/status'>#{key}</a>")
      a[0..5]
    end
    respond_with({ :aaData => aa })
  end


  delete "/jobs/:collection/:name/:job_id" do |collection, name, job_id|
    status = ::Scheduler.unschedule(job_id)
    respond_with status
  end

  get '/monitor' do
    content_type 'text/html'
    erb :status
  end

  get '/viz' do
    halt 405 unless Workflow.enabled?
    content_type 'text/html'
    erb :viz
  end

  get '/charts' do
    content_type 'text/html'
    erb :charts
  end

  get '/workflow' do
    halt 405 unless Workflow.enabled?
    respond_with Workflow.find_all
  end

  get '/workflow/:code' do |code|
    halt 405 unless Workflow.enabled?
    respond_with Workflow.find_flow(code)
  end


  private

  def respond_with(resultset, options={})
    unless resultset
      halt 404
    end
    status (options[:status] || 200)
    resultset.to_json if resultset
  end

end
