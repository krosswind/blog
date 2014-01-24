express = require 'express'
async = require 'async'
dbinit = require './lib/dbinit2'
settings = require './settings'

appserver = require('http').createServer(app)
#io = require('socket.io').listen(app)
fs = require('fs')

app = express();


#App Configuration
app.use '/', express.static __dirname + '/public',
  maxAge: 86400000


 





async.series([
	(callback) ->
		# setup couchdb database connection
		dbinit settings.couchdb, (err, database) ->
			if err
				callback err
			else
				db = database


				callback null

	, (callback) -> 
		# start express
		appserver.listen settings.defaultport
		console.log 'Listening on port ' + settings.defaultport
		callback null

], (err) ->
	# callback error handler
	if err
		console.log "Problem with starting core services; "
		console.log err
		process.exit err
)



	


###io.sockets.on 'connection', (socket) ->
	socket.emit 'news',
		hello: 'world' 
	socket.on 'my other event', (data) ->
	console.log data
###
###


db.view 'blog/bydate', (err,result) ->
	if err console.log "oh shit, view is busted"
	else 
		result.forEach (row)->
			console.log row.title
			console.log row._id
			console.log row._rev


db.save ( (err,response) -> 
	if err 
		console.log 'could not delete document '
	else 
		console.log 'document deleted ' + response


db.get ('f1f7a345e7ca9f4ab33ff3d3c4000f92', (err,doc) ->
	console.log doc

	)

###
