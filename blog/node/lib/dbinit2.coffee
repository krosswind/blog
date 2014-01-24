async = require 'async'
cradle = require 'cradle'
designs = ['blog']

addViews = (db, cb) ->
	async.series([

		
		(callback) ->

			# order must match that of designs array
			newdesigns = [
				# All view
				{	all:
						map: "function(doc) {if (doc.type === 'all') {emit([doc.group, doc.modified], doc);}}"
				}

			]

			saveDesign = (design, subcallback) ->
				designName = '_design/'+design
				i = designs.indexOf design
				console.log "Saving design for " + designName
				db.save designName, newdesigns[i], subcallback				

			async.forEach designs, saveDesign, callback

	# and pass back any errors to the callback			
	], cb)


# main function exported to server.coffee
module.exports = (couchdb, callback) ->
	c = new(cradle.Connection)(couchdb.dbServer, couchdb.dbPort,
			cache: true
			raw: false
		)
	db = c.database couchdb.dbName

	# couchdb connection
	db.exists (err, exists) ->
		# check we can connect to database!
		if err
			callback err
		else if exists
			# db exists, so 
			# add design document views, and return db object
			console.log 'Connected to database "' + couchdb.dbName + '" on ' + couchdb.dbServer
			# remove old view data
			db.viewCleanup()
			# check if we wish to create views 
			if couchdb.overwriteViews
				console.log "Adding design documents"
				addViews db, (err) ->
					callback err, db
			else 
				callback null, db

		else
			# db doesn't exist yet, so we create it and add the design document views
			db.create()
			console.log 'Created database ' + couchdb.dbName + ' on ' + couchdb.dbServer
			console.log "Adding design documents"
			addViews db, (err) ->
				callback err, db


				


