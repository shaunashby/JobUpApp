require 'job_up_app/version'
require 'job_up/search'
require 'job_up'

require 'json'
require 'redis'
require 'sinatra'

module JobUpApp

  class Application < Sinatra::Base

    REDIS_HOST='10.1.38.2'
    REDIS_DB=10
    REDIS_SEARCH_KEY_FORMAT="result:search:%d"

    set :environment, :development

    def initialize
      super
      @redis = Redis.new(:host => REDIS_HOST, :password => REDIS_PASSWD, :db => REDIS_DB)
      @configuration = JobUp::Configuration.new({})
      @searches = @configuration.jobsearches
      @version = JobUpApp::VERSION
    end

    configure :development do
      enable :logging
      set :sessions, :domain => '.ashby.ch'
      # Change the location of the templates which is otherwise obtained
      # from the file containing the application class:
      set :views, settings.root + '/../templates'
    end

    before '/api/*' do
      headers "X-JobUpApp-API-Version" => JobUpApp::VERSION
      @searches.each do |search|
        redis_search_key = sprintf(REDIS_SEARCH_KEY_FORMAT, search.id)
        if !@redis.exists(redis_search_key)
          headers "X-JobUpApp-Search-Time" => "#{Time.now.to_i}"
          @json = JobUp::Search.getJSON(@configuration.base_url, search.query_params)
          @redis.set(redis_search_key, @json)
        else
          @json = JSON.parse(@redis.get(redis_search_key))
        end
      end
    end

    after do
    end

    get "/" do
      erb "index.html".to_sym
    end

    # API methods:
    get "/api/searches" do
      @searches.to_json
    end

  end

end
