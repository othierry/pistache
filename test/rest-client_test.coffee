RestClient = require 'rest-client'

describe 'RestClient', ->
  beforeEach ->
    @client = new RestClient url: 'http://ws.liny.info'
    @userId = '510be45a87e32a02b3000001'

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

  it 'Should create a user resource', ->
    @client.resource 'users'
    @client.users.create
      email: 'test@test.test'
      password: 'secret'
    , success: (response) =>
        expect(response.user).to.not.be.undefined

  it 'Should read a user resource', ->
    @client.resource 'users'
    @client.users.show @userId,
      success: (response) =>
        console.log response
        expect(response.user).to.not.be.undefined

  it 'Should update a user resource', ->
    @client.resource 'users'
    @client.users.update @userId, {email: 'somethingelse@test.com'}
      success: (response) =>
        expect(response.user).to.not.be.undefined

  it 'Should delete a user resource', ->
    @client.resource 'users'
    @client.users.delete @userId,
      success: (response) =>
        expect(response.user).to.not.be.undefined
