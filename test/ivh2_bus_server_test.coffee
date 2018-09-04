should = (require 'chai').should()

Ivh2BusServer = require '../src/Ivh2BusServer'
busServer = null


describe 'ivh2 bus server', ->

	describe 'constructor', ->
		before ->
			busServer = new Ivh2BusServer { multicastPort: 10002 }

		it 'must have a multicast port', -> busServer.should.include.keys 'multicastPort'
		it 'can have a multicast address to bind to [optional]', -> busServer.should.include.keys 'multicastAddress'


	describe 'instantiation', ->
		after ->
			busServer = null

		it 'should throw an error if no multicastPort is provided', ->
			(() ->
				busServer = new Ivh2BusServer
			).should.throw(Error)


	describe 'create', ->
		it 'should emit the event `connected` when the server is listening', (done) ->
			busServer = new Ivh2BusServer { multicastPort: 10002 }
			busServer.create()
			busServer.on 'connected', ->
				busServer.close()
				done()

		it 'should emit the event `error` if there is an error during the connection', (done) ->
			busServer  = new Ivh2BusServer { multicastPort: 10003 }
			busServer2 = new Ivh2BusServer { multicastPort: 10003 }
			busServer.create()
			busServer2.create()
			busServer2.on 'error', (error) ->
				busServer.close()
				busServer2.close()
				done()
