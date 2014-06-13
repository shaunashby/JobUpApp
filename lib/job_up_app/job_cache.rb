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

module JobUpApp
  class JobCache

    CACHE_SEARCH_KEY_FORMAT="result:search:%d"
    CACHE_REFRESH_TIME = 4 * 60 * 60 # 4 hrs

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
        return (Time.now.to_i - @timestamp > CACHE_REFRESH_TIME) ? true : false
      end
    end

    def call(env)
      env['jobupapp.cache_handle'] = @cache_handle
      env['jobupapp.searches'] = @searches

      if cache_stale?
        env['rack.errors'].puts("JobUpApp::JobCache#call: refreshing cache.")
        # Do whatever is required to populate the cache:

        # Reset the timestamp for the cache:
        @timestamp = Time.now.to_i
      else
        env['rack.errors'].puts("JobUpApp::JobCache#call: cache state OK.")
      end

      @app.call(env)
    end
  end
end
