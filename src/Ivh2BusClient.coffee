dgram = require 'dgram'

class Ivh2BusClient

	constructor: ({ @multicastPort = 9999, @multicastAddress = 'localhost', @clientId }) ->
		throw new Error 'A client id port is required' if !@clientId

		@client = dgram.createSocket('udp4')

	sendMessage: (message, cb) =>

		return cb? new Error 'Message format is not correct. It should be { type: ..., payload:... }' if !@_isMessageFormatCorrect message

		messageWithFrom = Object.assign {}, message, { from: @clientId }
		bufferizedMessage = Buffer.from(JSON.stringify messageWithFrom)

		@client.send bufferizedMessage, 0, bufferizedMessage.length, @multicastPort, @multicastAddress, (error, bytes) =>
			if error
				@client.close()
				return cb? error

	_isMessageFormatCorrect: (message) ->
		return false if (not message.type or not message.payload)

		return true

module.exports = Ivh2BusClient
