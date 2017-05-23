# API

## Client

* **constructor** arguments:
  * *multicastPort*: required
  * *clientId*: required
  * *multicastAddress*: optional (default 'localhost')


* **sendMessage(message, cb)** arguments:
  * *message*: format { type: '', payload: '' }
  * *cb*: (error)

## Server

* **constructor** arguments:
	* *multicastPort*: required
	* *multicastAddress*: optional (default 'localhost')


* **create()** no arguments (Initialize server)

* **close()** no arguments (Close server connection)

* **events**:
	* *connected*, triggered when the server starts listen
	* *message*, triggered when the server receives a message
	* *error*, triggered when there is an error. If there is no listener, the error will be thrown.
