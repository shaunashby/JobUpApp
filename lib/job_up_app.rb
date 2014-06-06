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

    before '/' do
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

    # API methods to access results by search ID:
    get "/api/jobs/:search_id" do
    end

    # API methods to access search configuration data:
    get "/api/searches" do
      @searches.to_json
    end

    get "/api/search/:id" do
      search = @searches.select { |jobsearch| jobsearch.id == params[:id].to_i }
      if search.empty?
        logger.warn "Unable to find search with id #{params[:id]}"
        halt 400, {'Content-Type' => 'application/json'}, 'nil'
      end
      search.to_json
    end

  end

end
