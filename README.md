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


### Testing and Interaction

Using the [Postman Chrome
extension/application](http://www.getpostman.com/), you can easily interact
with the PushSomething API. The receiver API collection can be found
[here](https://www.getpostman.com/collections/3a3ebba06d459f41bfe8) and
the services API collection is
[here](https://www.getpostman.com/collections/b11084fec39690ec7b44F).
