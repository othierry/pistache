module.exports = class RestResource

  defaults =
    name: null
    client: null
    member: null
    parent: null

  constructor: (@name, @client) ->

  create: (object, callbacks) ->
    @client.post @getPath(), object, callbacks

  update:  (object, callbacks) ->
    @client.put @getPath(), object, callbacks

  fetch:  (callbacks) ->
    @client.get @getPath(), {}, callbacks

  delete: (callbacks) ->
    @client.delete @getPath()

  getPath: ->
    (if @parent then "#{@parent}/" else '') + @name + (if @member then "/#{@member}" else '')

  # Bind remote sub-resource access routes
  # (create, update, delete, show)
  # ----------------------------
  resource: (name, configuration = null) ->
    RestResource.bindResource(@, @client, name, configuration)

  only: (methods = []) ->
    @[method] = undefined for method in ['create', 'update', 'delete', 'update'] when methods.indexOf(method) is -1

  except: (methods = []) ->
    @[method] = undefined for method in methods

  # Bind REST a endpoint.
  # Suited for action web services instead of plain resource
  # (e.g: /games/start.json, /users/42/who_is_arround_me)
  # ---------------------------------------------
  bind: (name, options = null) ->
    HTTPMethod = options?.via or 'get'
    path = options?.to or name
    path = '' if path == '/'
    @[name] = (params, callbacks) =>
      @client[HTTPMethod] "#{@getPath()}/#{path}", params, callbacks

  # Bind new resource with accessor [name] to {object}
  # Additional conf. can be provided (subresources, bindings...)
  # ------------------------------------------------
  @bindResource: (object, client, name, configuration = null) ->
    resource = new RestResource name, client
    # Bind resource to object instance with [name] for accessor
    object[name] = (member = '') =>
      resource.member = member
      resource.parent = object.getPath() if object instanceof RestResource
      resource
    configuration.apply(resource) if configuration
    resource
