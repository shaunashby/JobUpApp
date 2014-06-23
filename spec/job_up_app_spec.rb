#!/usr/bin/env ruby
#____________________________________________________________________
# File: job_up_app_spec.rb
#____________________________________________________________________
#
# Author: Shaun Ashby <shaun@ashby.ch>
# Created: 2014-06-23 14:28:45+0200
# Revision: $Id$
# Description: The main spec file for testing the JobUpApp::Application app.
#
# Copyright (C) 2014 Shaun Ashby
#
#
#--------------------------------------------------------------------
require File.expand_path '../spec_helper.rb', __FILE__

describe "JobUp application" do

  it "should allow access to default route" do
    get "/"
    expect(last_response).to be_ok
  end

  it "should do something" do
    pending("not yet implemented")
    fail
  end

end
