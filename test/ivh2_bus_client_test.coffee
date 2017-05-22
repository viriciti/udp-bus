should = (require 'chai').should()

Ivh2BusClient = require '../src/Ivh2BusClient'
Ivh2BusServer = require '../src/Ivh2BusServer'
busClient = null
busServer = null

describe 'ivh2 bus client', ->
	before ->
		busClient = new Ivh2BusClient { peerId: 'test', multicastPort: 10002 }

	describe 'constructor', ->
		it 'must have a multicast port', -> busClient.should.include.keys('multicastPort')
		it 'must have a peerId to identify the peer in the multicast group', -> busClient.should.include.keys('peerId')
		it 'can have a multicast address to bind to [optional]', -> busClient.should.include.keys('multicastAddress')
		it 'can have a reconnect timeout to set in case of connection failures [optional]', -> busClient.should.include.keys('reconnectTimeout')


	describe 'sendMessage', ->
		before ->
			busServer = new Ivh2BusServer { multicastPort: 10002 }
			busServer.create()

		after ->
			busServer.close()

		it 'should return an error if the format is not { type: ..., payload: ... }', (done) ->
			message = Buffer.from('test')
			busClient.sendMessage message, (error) ->
				return done() if error

		it 'should send a message correctly', (done) ->
			testMessage = { type: 'test', payload: 'test_payload' }
			responseMessage = Object.assign {}, testMessage, { from: busClient.peerId }

			busServer.on 'message', (message) ->
				done() if message.should.be.deep.equal responseMessage

			busClient.sendMessage testMessage, console.error
