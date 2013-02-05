Pistache = require 'pistache'

describe 'Pistache', ->
  it 'Should work :D', ->
    client = new Pistache.HttpClient url: 'www.google.com'
    client.get '/',
      success: -> 'done.'
