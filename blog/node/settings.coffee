module.exports = {
	# couch db settings
	couchdb: {
		dbServer: 'http://localhost'
		dbPort: 5984
		dbName: 'blog1'
		# create up to date couchdb views at every server start
		overwriteViews: false
	}

	# default local app port
	defaultport: 3000
	# client facing url
	clientURL: 'http://localhost:index.html'

}