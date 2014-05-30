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

    set :environment, :development

    def initialize
      super
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
