dgram        = require 'dgram'
EventEmitter = require 'events'

class Ivh2BusServer extends EventEmitter


	constructor: ({ @multicastAddress = 'localhost', @multicastPort = 9999}) ->

		super()
		@server = dgram.createSocket 'udp4'


	create: ->
		@server.bind @multicastPort, @multicastAddress

		@server
			.once 'listening', =>
				@emit 'connected'

			.once 'error', (error) =>
				if @_events["error"]
					@_handleServerError error
				else
					throw error

			.on 'message', @_handleMessage

	close: ->
		@server.close()


	_handleServerError: (error) =>
		@emit 'error', error
		@close()

	_handleMessage: (message) =>
		try
			@emit 'message', JSON.parse message.toString()
		catch error
			@emit error


module.exports = Ivh2BusServer
