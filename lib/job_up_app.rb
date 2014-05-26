require 'job_up_app/version'
require 'job_up/search'
require 'job_up'

require 'sinatra'

module JobUpApp

  def self.setup
    configuration = JobUp::Configuration.new({})
    searches = configuration.jobsearches
    return {
      :configuration => configuration,
      :searches      => searches
    }
  end

  class Application < Sinatra::Base
    config=JobUpApp.setup()

    configure :development do
      enable :logging
      enable :sessions
      # Change the location of the templates which is otherwise obtained
      # from the file containing the application class:
      set :views, settings.root + '/../templates'
    end

    get "/" do
      logger.info "This is JobUpApp Web Interface Version #{JobUpApp::VERSION}."
      logger.info "Setup: #{config[:searches].length} searches configured."
    end

  end

end
