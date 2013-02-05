# Pistache.js #

Light HTTP & Rest client library to easily bind your client application to your remote web services

## No installation ##

A build is versionned so you don't need to build le project yourself (CoffeeScript) in order to use it. If you want to be able to easily change the code base, you can check the "Manual Installation" section to easily rebuild the project using brunch!

* Just import {pistache-download-dir}/build/lib/pistache.js and {pistache-download-dir}/build/lib/pistache-vendor.js to your project to start using Pistache!

## Manual Installation ##

You will need brunch in order to build the lib, you can (and should) download brunch at http://brunch.io. Brunch rocks!

```
cd {pistache-download-di}
brunch build --minify
```
then import {pistache-download-dir}/build/lib/pistache.js and {pistache-download-dir}/build/lib/pistache-vendor.js to your project to start using Pistache!

## Overview ##

You can use Pistache to create simple HttpClient or more specific RestClient to connect your app with your remote server trough a very simple API. Pistache also propose a client-side caching system (still under development)

## Usage ##

### Simple Http Client ###

```coffeescript
    # Create client
    client = new Pistache.HttpClient url: 'http://your-server.com/api'

    # Create a POST request on /users.json
    client.post 'users.json', {some: 'parameters'},
      success: (response) ->
        console.log 'Houra! Request succeded whith response: ', response
      error: (error) ->
        console.error 'Oops! Request failed whith error: ', error

    # You can also use other http methods
    client.get ...
    client.put ...
    client.delete ...

```

### REST Client ###

```coffeescript
# You can create a client like this
client = new Pistache.RestClient url:  'http://your-server.com/api'
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
When you bind a new resource object, you can profile a customization block (or anonymous function) to customize the resource behaviour and states (methods, bindings, embedded resources)
```coffeescript
client.resoures 'users', ->
  @only ['fetch', 'update'] # Will only keep fetch() and update() methods, others will be stated as undefined

client.resoures 'pokes', ->
  @except ['delete'] # Will state given methods as undefined and keep the others
```

#### Binding custom endpoints ####

```coffeescript
# Simply add resources like this
client.resoures 'games', ->
  @bind 'start', via: 'get'
  @bind 'finish', via: 'post'
```

This will generate the following methods:
* client.games().start()
* client.games().stop()

#### Embedded resources ####

```coffeescript
client.resoures 'users', ->
  @resources 'profile', ->
    @except ['create', 'delete']
  @resources 'contacts', ->
    @only ['create', 'fetch']
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


```coffeescript
client.users().create()                           # => POST http://your-server.com/api/users
client.users(42).update()                      # => PUT http://your-server.com/api/users/42
client.users().fetch()                            # => GET http://your-server.com/api/users
client.users(42).fetch()                        # => GET http://your-server.com/api/users/42
client.users(42).delete()                       # => DELETE http://your-server.com/api/users/42

client.users(42).contacts().fetch()         # => GET http://your-server.com/api/users/42/contacts
client.users(42).contacts(55).revoke()   # => POST http://your-server.com/api/users/42/contacts/55/revoke

client.users(42).profile().fetch()             # => GET http://your-server.com/api/users/42/profile
client.users(42).profile().update()           # => PUT http://your-server.com/api/users/42/profile

# ...

```

### Client Side Caching ###

#### Overview ####

A solution for simple client side caching is availabe and can be used (the feature is still under development).
The client side caching rules are defined by 2 things:

* Caching Policy
It defines how the cache is used. Possible values are defined in caching-policy.coffee

```coffeescript
CachingPolicy =
  CachingPolicyNone: 0                           # No cache
  CachingPolicyCacheIfAvailable: 1           # Cache ONLY if available, network otherwise but not both
  CachingPolicyNetworkThenCache: 2      # Network ONLY if available, cache otherwise but not both
  CachingPolicyCacheThenNetwork: 3      # Cache if available, plus refresh the cache in background
```

* A Caching Strategy
Where and how elements are going to be cached.
The CachingStrategy class is an abstract class and cannot be used raw. Caching Strategies must derive from CachingStrategy class and overide abstract methods to perform caching.

For now only one caching strategy is bundled in the project (LocalStorageCachingStrategy which you can use directly), but you can easily provide your own implementation of a caching strategy (IndexDB) by creating a sublass of CachingStrategy.

Do not hesitate to make pull requests to add new caching strategies (or simply add new features!). Contribution is welcome!

#### Example ####

```coffeescript
    # Create client
    client = new Pistache.RestClient url: 'http://ws.liny.info'

    # Define caching rules
    client.cachingPolicy = Pistache.CachingPolicy.CachingPolicyCacheThenNetwork
    client.cachingStrategy = new Pistache.LocalStorageCachingStrategy()
```

### Related Libraries ###

 * [cryptojs](http://code.google.com/p/crypto-js/) - Library of secure cryptographic algorithms implemented in JavaScript using best practices and patterns. They are fast, and they have a consistent and simple interface.

Let me know if there's any other related libraries not listed here.

## Contributions ##

Contribution is welcome. Do not hesite to contact me (@othierry) or make pull requests.
See section "Tests" to know how to run specifications tests for Pistache.
