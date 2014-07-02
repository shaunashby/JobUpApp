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

  it "should render content containing known text" do
    get "/"
    expect(last_response.body).to match(/JobUpApp/)
  end

  it "should route /api/searches correctly" do
    get "/api/searches"
    expect(last_response['X-JobUpApp-API-Version']).to eq("0.0.1")
    expect(last_response['Content-Type']).to eq("application/json")
    expect(last_response.body).to match(/data/)
  end

  it "should route /api/jobs/:search_id correctly" do
    get "/api/jobs/354346"
    expect(last_response['X-JobUpApp-API-Version']).to eq("0.0.1")
    expect(last_response['Content-Type']).to eq("application/json")
    expect(last_response.body).to match(/data/)
  end

  it "should route /api/search/:id correctly" do
    get "/api/search/354346"
    expect(last_response['X-JobUpApp-API-Version']).to eq("0.0.1")
    expect(last_response['Content-Type']).to eq("application/json")
    expect(last_response.body).to match(/data/)
  end

end
