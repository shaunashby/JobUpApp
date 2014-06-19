#!/usr/bin/env ruby
#____________________________________________________________________
# File: cache.rb
#____________________________________________________________________
#
# Author: Shaun Ashby <shaun@ashby.ch>
# Created: 2014-06-04 18:46:07+0200
# Revision: $Id$
# Description: Middleware to handle access to data cached in a Redis store.
#
# Copyright (C) 2014 Shaun Ashby
#
#
#--------------------------------------------------------------------
require 'redis'
require 'job_up/search'
require 'job_up'

require 'job_up_app/cache'

module JobUpApp
  class JobCache

    def initialize(app, options)
      @app = app
      @timestamp = nil
      @configuration = JobUp::Configuration.new(options[:config])
      @searches = @configuration.jobsearches

      redis_opts = {
        :host     => '10.1.38.2',
        :password => '',
        :db       => 10
      }

      @cache_handle = Redis.new(redis_opts)
    end

    def cache_stale?
      if @timestamp.nil?
        return true
      else
        return (Time.now.to_i - @timestamp > JobUpApp::Cache::REFRESH_TIME) ? true : false
      end
    end

    def call(env)
      req = Rack::Request.new(env)

      if req.get?
        env['rack.errors'].puts("JobUpApp::JobCache: GET request on path #{req.path_info}.")
      end

      env['jobupapp.cache_handle'] = @cache_handle
      env['jobupapp.searches'] = @searches

      if cache_stale?
        env['rack.errors'].puts("JobUpApp::JobCache: Refreshing cache.")
        # Do whatever is required to populate the cache:
        @searches.each do |search|
          cache_search_key = sprintf(JobUpApp::Cache::RESULTS_SEARCH_KEY_FORMAT, search.id)
          if @cache_handle.exists(cache_search_key)
            # Save current data or simply delete and re-run search (TBD):
            env['rack.errors'].puts("JobUpApp::JobCache: Key #{cache_search_key} exists. Deleting before refreshing cache.")
            @cache_handle.del(cache_search_key)
          end
          # Store updated JSON string:
          @json_data = JobUp::Search.getJSON(@configuration.base_url, search.query_params)
          @cache_handle.set(cache_search_key, @json_data)
        end
        # Reset the timestamp for the cache:
        @timestamp = Time.now.to_i
      end

      res = Rack::Response.new
      res.set_cookie("cache_updated", @timestamp)
      res.finish

      @app.call(env)
    end
  end
end
