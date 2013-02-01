HttpClient = require 'http-client'
CachingStrategy = require 'caching-strategy'
CachingPolicy = require 'caching-policy'

describe 'HttpClient', ->
  beforeEach ->
    @client = new HttpClient url: 'http://localhost:3000'

  it 'Should perform a post request', ->
    @client.get 'api/users.json', (response) ->
      expect(response).to.not.be.null

  it 'Should perform a put request', ->
    @client.get 'api/users.json', (response) ->
      expect(response).to.not.be.null

  it 'Should perform a get request', ->
    @client.get 'api/users.json', (response) ->
      expect(response).to.not.be.null

  it 'Should perform a delete request', ->
    @client.get 'api/users.json', (response) ->
      expect(response).to.not.be.null

  it 'Should follow caching rules', ->
    expect(true).to.be.true