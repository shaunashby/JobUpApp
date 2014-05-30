require 'job_up_app/version'
require 'job_up/search'
require 'job_up'

require 'sinatra'

module JobUpApp

  class Application < Sinatra::Base
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
      logger.info "This is JobUpApp Web Interface Version #{JobUpApp::VERSION}."
      logger.info "Setup: #{@config[:searches].length} searches configured."
      erb "index.html".to_sym
    end

  end

end
