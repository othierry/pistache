# Pistache.js #

Light HTTP & Rest client library to easily bind your client application to your remote web services

## Overview ##

You can use Pistache to create simple HttpClient or more specific RestClient to connect your app with your remote server trough a very simple API. Pistache also propose a client-side caching system (still under development)

## Installation ##

You will need brunch in order to build the lib, you can (and should!) download brunch at http://brunch.io

```
$ cd {pistache-download-dir}
$ npm install
$ brunch build --minify
```
then import {pistache-download-dir}/build/lib/pistache.js and {pistache-download-dir}/build/lib/pistache-vendor.js to your project to start using Pistache!

## Running the tests ##

You will also need brunch to launch the tests of the lib, you can (and should!) download brunch at http://brunch.io
```
$ cd {pistache-download-dir}
$ brunch test
```

## Usage ##

### Simple Http Client ###

```coffeescript
# Create client
client = new Pistache.HttpClient url: 'http://your-server.com/api'

# You can set your custom request headers for the client (optional)
client.customRequestHeaders = {
  "X-Something-Required": 42
}

# Create a POST request on /users.json
client.post 'users.json', {some: 'parameters'},
  success: (response) ->
    console.log 'Houra! Request succeded with response: ', response
  error: (error) ->
    console.error 'Oops! Request failed with error: ', error

# You can also use other http methods
client.get ...
client.put ...
client.delete ...

# Or send a request manually
Pistache.HttpClient.request(url, params, httpMethod, callbacks)
```

### REST Client ###

```coffeescript
# You can create a client like this
client = new Pistache.RestClient url: 'http://your-server.com/api'
```

#### Binding resources ####

```coffeescript
# Simply add resources like this
client.resource 'users'
```

This will generate the following methods:
* client.users().fetch()
* client.users().create()
* client.users().update()
* client.users().delete()

#### Resource configuration ####
When you bind a new resource object, you can provide a customization block (anonymous function) to customize the resource behaviour and states (methods, bindings, embedded resources)
```coffeescript
client.resoures 'users', ->
  @only 'fetch', 'update' # Will only keep fetch() and update() methods, others will be stated as undefined

client.resoures 'pokes', ->
  @except 'delete' # Will state given methods as undefined and keep the others
```

#### Binding custom endpoints ####

```coffeescript
# Simply add resources like this
client.resource 'games', ->
  @only 'update', 'delete'
  @bind 'start', via: 'get'
  @bind 'finish', via: 'post'
```

This will generate the following methods:
* client.games().update()
* client.games().delete()
* client.games().start()
* client.games().finish()

#### Embedded resources ####

```coffeescript
client.resource 'users', ->
  @resource 'profile', ->
    @except 'create', 'delete'
  @resource 'contacts', ->
    @only 'create', 'fetch'
    @bind 'revoke', via: 'post'
```

This will generate the following methods:

* client.users().fetch()
* client.users().create()
* client.users().update()
* client.users().delete()
* client.users().profile().fetch()
* client.users().profile().update()
* client.users().contacts().fetch()
* client.users().contacts().create()
* client.users().contacts().revoke()

#### Sample usage ####

```coffeescript
# => POST http://your-server.com/api/users
client.users().create(user, callbacks)

# => PUT http://your-server.com/api/users/42
client.users(42).update(user, callbacks)

# => GET http://your-server.com/api/users
client.users().fetch(callbacks)

# => GET http://your-server.com/api/users/42
client.users(42).fetch(callbacks)

# => DELETE http://your-server.com/api/users/42
client.users(42).delete(callbacks)

# => GET http://your-server.com/api/users/42/contacts
client.users(42).contacts().fetch(callbacks)

# => POST http://your-server.com/api/users/42/contacts/55/revoke
client.users(42).contacts(55).revoke(callbacks)

# => GET http://your-server.com/api/users/42/profile
client.users(42).profile().fetch(callbacks)

# => PUT http://your-server.com/api/users/42/profile
client.users(42).profile().update(user, callbacks)

# ...
```

### Client Side Caching ###

#### Overview ####

A solution for simple client side caching is availabe and can be used (the feature is still under development).
The client side caching rules are defined by 2 things:

* Caching Policy - It defines how the cache is used. Possible values are defined in caching-policy.coffee

```coffeescript
CachingPolicy =
  # No cache
  CachingPolicyNone: 0

  # Cache ONLY if available, network otherwise but not both
  CachingPolicyCacheIfAvailable: 1

  # Network ONLY if available, cache otherwise but not both
  CachingPolicyNetworkThenCache: 2

  # Cache if available, plus refresh the cache in background
  CachingPolicyCacheThenNetwork: 3
```

* A Caching Strategy - Defines where and how elements are going to be cached.
The CachingStrategy class is an abstract class and cannot be used raw. Caching Strategies must derive from CachingStrategy class and overide abstract methods to perform caching.

For now only one caching strategy is bundled in the project (LocalStorageCachingStrategy which you can use directly), but you can easily provide your own implementation of a caching strategy (IndexedDB for example) by creating a sublass of CachingStrategy.

Do not hesitate to make pull requests to add new caching strategies (or simply add new features!). Contribution is welcome!

#### Sample usage ####

```coffeescript
# Create client
client = new Pistache.RestClient url: 'http://ws.liny.info'

# Define caching rules
client.cachingPolicy = Pistache.CachingPolicy.CachingPolicyCacheThenNetwork
client.cachingStrategy = new Pistache.LocalStorageCachingStrategy()
```

### Related Libraries ###

 * [brunch.io](http://brunch.io) - Brunch is an assembler for HTML5 applications. It‘s agnostic to frameworks, libraries, programming, stylesheet & templating languages and backend technology.
 * [cryptojs](http://code.google.com/p/crypto-js/) - Library of secure cryptographic algorithms implemented in JavaScript using best practices and patterns. They are fast, and they have a consistent and simple interface.

Let me know if there's any other related libraries not listed here.

## Contributions ##

Contribution is welcome. Do not hesitate to contact me (@othierry_) or make pull requests.
See section "Running the tests" to know how to run specification tests for Pistache.
