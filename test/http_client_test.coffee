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
    expect(@client.users.create).to.not.be.undefined
    expect(@client.users.update).to.not.be.undefined
    expect(@client.users.delete).to.not.be.undefined
    expect(@client.users.show).to.not.be.undefined

    expect(@client.users.profile.create).to.not.be.undefined
    expect(@client.users.profile.update).to.not.be.undefined
    expect(@client.users.profile.delete).to.not.be.undefined
    expect(@client.users.profile.show).to.not.be.undefined

    expect(@client.leaderboards.create).to.not.be.undefined
    expect(@client.leaderboards.update).to.not.be.undefined
    expect(@client.leaderboards.delete).to.not.be.undefined
    expect(@client.leaderboards.show).to.not.be.undefined

    expect(@client.shop.create).to.not.be.undefined
    expect(@client.shop.update).to.not.be.undefined
    expect(@client.shop.delete).to.not.be.undefined
    expect(@client.shop.show).to.not.be.undefined
