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

module JobUpApp
  class JobCache
    def initialize(app,*options)
      @app = app
      @options = options || { }
      @options.each do |o|
        $stderr.print("initialize -- Got option #{o}\n")
      end
    end

    def call(env)
      $stderr.print("Got an app of type #{@app.class}\n")
      @app.call(env)
    end
  end
end
