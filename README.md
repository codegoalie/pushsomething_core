# PushSomething Core

This is the server side component to the PushSomething
service.

It will be responsible for:

* Registering and authenticating users (via Google to start)
* Storing and delivering push notifications to devices
* Coordinating notification revocation for multi-device
  users.


### Technologies used:

* Omniauth - Oauth authentication
* Figaro - clean application configuration
