#!/usr/bin/env ruby
#____________________________________________________________________
# File: job_up_app.rb
#____________________________________________________________________
#
# Author: Shaun Ashby <shaun@ashby.ch>
# Created: 2014-05-14 23:23:05+0200
# Revision: $Id$
# Description: Sinatra application to run a UI for job search results.
#
# Copyright: 2014 (C) Shaun Ashby
#
#--------------------------------------------------------------------
require 'job_up_app/version'

require 'json'
require 'sinatra'

module JobUpApp

  class Application < Sinatra::Base

    CACHE_SEARCH_KEY_FORMAT="result:search:%d"

    set :environment, :development

    def initialize
      super
      @version = JobUpApp::VERSION
      @json = nil
    end

    configure :development do
      enable :logging
      enable :sessions
      set :sessions, :domain => '.ashby.ch'
      # Change the location of the templates which is otherwise obtained
      # from the file containing the application class:
      set :views, settings.root + '/../templates'
    end

    # Set headers on all calls to API methods which return JSON:
    before '/api/jobs/:search_id' do
      headers "X-JobUpApp-API-Version" => JobUpApp::VERSION
      headers "Content-Type"           => "application/json"
    end

    after do
    end

    get "/" do
      erb "index.html".to_sym
    end

    # API methods to access results by search ID:
    get "/api/jobs/:search_id" do
      cache_search_key = sprintf(CACHE_SEARCH_KEY_FORMAT, params[:searchid])
      @json = JSON.parse( env['jobupapp.cache_handle'].get(cache_search_key) )
      @json
    end

    # API methods to access search configuration data:
    get "/api/searches" do
      @searches = env['jobupapp.searches']
      headers "Content-Type" => "application/json"
      @searches.to_json
    end

    get "/api/search/:id" do
      @searches = env['jobupapp.searches']
      search = @searches.select { |jobsearch| jobsearch.id == params[:id].to_i }
      if search.empty?
        logger.warn("Unable to find search with id #{params[:id]}")
        halt 400, {'Content-Type' => 'application/json'}, 'nil'
      end
      search.to_json
    end

  end

end
