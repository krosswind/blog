moment = require 'moment'
async = require 'async'
dbinit = require './lib/dbinit2'
settings = require './settings'
util = require 'util'
fs = require 'fs'
express = require("express")
app = express()
server = require("http").createServer(app)

app.get "/node/test", (req,res) ->
	res.send 

io = require('socket.io').listen(server)
io.set 'resource', '/node/socket.io'

db = null



###Might not be needed.....
app.configure () ->

	app.use(express.static(__dirname, + '/public'));
	console.log __dirname
###

async.series([
	(callback) ->
		# setup couchdb database connection
		dbinit settings.couchdb, (err, database) ->
			if err
				callback err
			else
				db = database


				callback null

	,(callback) -> 
		# start connect
		server.listen 3000


	], (err) ->
	# callback error handler
	if err
		console.log "Problem with starting core services; "
		console.log err
		process.exit err
)

io.sockets.on "connection", (socket) ->
	socket.on "getTitle" , (callback) ->
		db.view "blog/bytitle", (err, res) ->
			if err
				console.log "cannot query view!" + err
				callback null
			else	
				callback(res)

	socket.on "saveEntry", (data) ->
		timeStamp = Date.now()
		db.save
			title: data[0].value
			body: data[1].value
			key: timeStamp
			date: moment(timeStamp).format('MMMM Do YYYY')
			type: 'entry' 
		,(err, res) ->
			if err
				console.log "error saving" + err
			else
				console.log "success" + res
			
		

###			

CouchDB examples from James G

db.save ( (err,response) -> 
	if err 
		console.log 'could not delete document '
	else 
		console.log 'document deleted ' + response


db.get ('f1f7a345e7ca9f4ab33ff3d3c4000f92', (err,doc) ->
	console.log doc

	)

###
