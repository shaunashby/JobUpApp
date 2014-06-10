//____________________________________________________________________
// File: jobupapp.js
//____________________________________________________________________
//
// Author: Shaun Ashby <shaun@ashby.ch>
// Created: 2014-06-01 22:01:13+0200
// Revision: $Id$
// Description: The main Javascript file for loading the Backbone app environment.
//
// Copyright (C) 2014 Shaun Ashby
//
//
//--------------------------------------------------------------------

var jobsearch = {
	models: {},
	views: {},
};

// Models:
jobsearch.Search = Backbone.Model.extend({
	urlRoot:"/api/searches",
	initialize: function() {
		this.searches = new jobsearch.SearchCollection();
		this.searches.url = this.urlRoot +"/" + this.id;
	},
});
// Views:
// Collections:
jobsearch.SearchCollection = Backbone.Collection.extend({
	model: jobsearch.Search,
	url:"/api/searches",
});
