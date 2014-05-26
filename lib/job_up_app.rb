require "job_up_app/version"
require "sinatra"

module JobUpApp

  class Application < Sinatra::Base
    configure :development do
      enable :logging
    end

    get "/" do
      logger.info "This is JobUpApp Web Interface Version #{JobUpApp::VERSION}."
    end

  end

end
