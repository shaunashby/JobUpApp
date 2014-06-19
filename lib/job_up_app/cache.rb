#!/usr/bin/env ruby
#____________________________________________________________________
# File: cache.rb
#____________________________________________________________________
#
# Author: Shaun Ashby <shaun@ashby.ch>
# Created: 2014-06-19 11:52:39+0200
# Revision: $Id$
# Description: Utilities and constants for cache access.
#
# Copyright (C) 2014 Shaun Ashby
#
#
#--------------------------------------------------------------------

module JobUpApp
  module Cache
    RESULTS_SEARCH_KEY_FORMAT="result:search:%d"
    REFRESH_TIME = 4 * 60 * 60 # 4 hrs
  end
end
