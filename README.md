# PushSomething Core

This is the server side component to the PushSomething
service.

Features implemented:

* Registering and authenticating users (via Google to start)
* Storing and delivering push notifications to devices

It will be responsible for:

* Coordinating notification revocation for multi-device
  users.


### Technologies used:

* Omniauth - Oauth authentication
* Figaro - clean application configuration
* gcm - GCM push messages
* Foundation - CSS framework
