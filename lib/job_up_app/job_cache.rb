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
    # Temporary context object
    class MyContext
      def initialize(context=[])
        @context=context
      end
      attr_reader :context
    end

    def initialize(app, *options)
      @app = app
      @configuration = JobUp::Configuration.new(options['config'])
      @searches = @configuration.jobsearches
    end

    def call(env)
      # Initialize the context and store an access
      # point to a redis instance:
      redis_opts = {
        :host     => '10.1.38.2',
        :password => '',
        :db       => 10
      }

      cache_handle = Redis.new(:host => :redis_host, :password => :redis_passwd, :db => :redis_db)
      env['jobupapp.cache_handle'] = cache_handle
      @app.call(env)
    end
  end
end
