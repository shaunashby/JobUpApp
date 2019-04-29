#!/usr/bin/env ruby
#____________________________________________________________________
# File: mongo-connection-test.rb
#____________________________________________________________________
#
# Author: Shaun Ashby <shaun@ashby.ch>
# Created: 2014-08-14 17:24:39+0200 (Time-stamp: <2014-08-14 20:42:07 sashby>)
# Revision: $Id$
# Description: A simple test script to access a MongoDB server.
#
# Copyright (C) 2014 Shaun Ashby
#
#
#--------------------------------------------------------------------

require 'mongo'

MONGODB_SERVER="10.1.38.2"

begin
  m_db_conn = Mongo::MongoClient.new(MONGODB_SERVER).db("test2")
  m_db_conn.authenticate("admin","xxxxxxx",nil,"admin")

  collection_names=["a","b","c"]
  collection_names.each do |coll_name|
    m_collection = m_db_conn.create_collection(coll_name)
    100.times.each do |i|
      m_collection.insert({ :number => i })
    end
  end

rescue Mongo::AuthenticationError => err
  $stderr.print(err)
rescue Mongo::ConnectionError => err
  $stderr.print(err)
end
