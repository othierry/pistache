module.exports = class RestResource

  defaults =
    name: null
    client: null

  constructor: (@name, @client) ->

  create: (user, callbacks) ->
    @client.post "#{@name}", {user}, callbacks

  update:  (object_id, user, callbacks) ->
    @client.put "#{@name}/#{object_id}", {user}, callbacks

  show:  (object_id, callbacks) ->
    @client.get "#{@name}/#{object_id}", {}, callbacks

  delete: (object_id, callbacks) ->
    @client.delete "#{@name}/#{object_id}"

  # Bind remote sub-resource access routes
  # (create, update, delete, show)
  # ----------------------------
  resource: (name, options = null) ->
    RestResource.bindResource(@, @client, name, options)

  # Bind REST a endpoint.
  # Suited for action web services instead of plain resource
  # (e.g: /games/start.json, /users/42/who_is_arround_me)
  # ---------------------------------------------
  bind: (name, options = null) ->
    HTTPMethod = options?.via or 'get'
    path = options?.to or name
    if options.member?
      @[name] = (id, params, callbacks) =>
        @client[HTTPMethod] "#{path}/#{id}", params, callbacks
      @[name]
    else
      @[name] = (params, callbacks) =>
        @client[HTTPMethod] "#{path}", params, callbacks
      @[name]

  # Bind new resource with accessor [name] to {object}
  # Additional conf. can be provided (subresources, bindings...)
  # ------------------------------------------------
  @bindResource: (object, client, name, configuration) ->
    resource = new RestResource(name, client)
    # Bind resource to object insteance with [name] for accessor
    object[name] = resource
    configuration.apply(resource) if configuration
    resource
