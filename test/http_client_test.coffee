RestClient = require 'rest-client'

describe 'RestClient', ->
  beforeEach ->
    @client = new RestClient url: 'http://ws.liny.info'

  it 'Should generate rest methods for resources', ->
    # Build resource bindings
    @client.resource 'users', (r) ->
      r.resource 'profile'
    @client.resource 'leaderboards'
    @client.resource 'shop'

    # Methods should be generated
    expect(@client.users).to.not.be.undefined
    expect(@client.users.profile).to.not.be.undefined
    expect(@client.leaderboards).to.not.be.undefined
    expect(@client.shop).to.not.be.undefined
