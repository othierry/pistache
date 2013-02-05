HttpClient = require 'http-client'
RestResource = require 'rest-resource'

module.exports = class RestClient extends HttpClient

  routes: ->
    # TODO: Pretty print all routes like rake routes task

  # Bind remote resource access routes
  # (create, update, delete, show)
  # ----------------------------
  resource: (name, configuration = null) ->
    RestResource.bindResource(@, @, name, configuration)
