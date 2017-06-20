should = (require 'chai').should()

Ivh2BusClient = require '../src/Ivh2BusClient'
Ivh2BusServer = require '../src/Ivh2BusServer'
busClient = null
busServer = null

describe 'ivh2 bus client', ->
	before ->
		busClient = new Ivh2BusClient { clientId: 'test', multicastPort: 10002 }

	after ->
		busClient = null



	describe 'constructor', ->
		it 'must have a multicast port property', -> busClient.should.include.keys('multicastPort')
		it 'must have a clientId property to identify the peer in the multicast group', -> busClient.should.include.keys('clientId')
		it 'can have a multicast address to bind to [optional]', -> busClient.should.include.keys('multicastAddress')



	describe 'instantiation', ->
		after ->
			busClient = null

		it 'should throw an error if no clientId is provided', ->
			(() ->
				busClient = new Ivh2BusClient { multicastPort: 2000 }
			).should.throw(Error)



	describe 'sendMessage', ->
		before ->
			busServer = new Ivh2BusServer { multicastPort: 10002 }
			busClient = new Ivh2BusClient { clientId: 'test', multicastPort: 10002 }
			busServer.create()

		after ->
			busServer.close()
			busServer = null
			busClient = null

		it 'should return an error if the format is not { type: ..., payload: ... }', (done) ->
			message = Buffer.from('test')
			busClient.sendMessage message, (error) ->
				return done() if error

		it 'should send a message correctly', (done) ->
			testMessage = { type: 'test', payload: 'test_payload' }
			responseMessage = Object.assign {}, testMessage, { from: busClient.clientId }

			busServer.on 'message', (message) ->
				done() if message.should.be.deep.equal responseMessage

			busClient.sendMessage testMessage, console.error
