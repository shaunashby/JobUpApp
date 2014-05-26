# -*- ruby -*-
#____________________________________________________________________
# File: config.ru
#____________________________________________________________________
#
# Author: Shaun Ashby <shaun@ashby.ch>
# Created: 2014-05-26 19:32:10+0200
# Revision: $Id$
# Description: Rackup startup file for JobUpApp::Application
#
# Copyright (C) 2014 Shaun Ashby
#
#
#--------------------------------------------------------------------
require 'rubygems'
require 'bundler'

Bundler.require

require 'job_up_app'

use Rack::Static,
:urls => ["/images", "/js", "/css"],
:root => "public"

run JobUpApp::Application
