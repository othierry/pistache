window.Pistache or = {}

# Caching rules
# -----------

Pistache.CachingPolicy =
  CachingPolicyNone: 0                            # No cache
  CachingPolicyCacheIfAvailable: 1          # Cache ONLY if available, network otherwise but not both
  CachingPolicyNetworkThenCache: 2      # Network ONLY if available, cache otherwise but not both
  CachingPolicyCacheThenNetwork: 3      # Cache if available, plus refresh the cache in background

# ------------------------------

class Pistache.CachingStrategy

  # Returns a unique hash based on the
  # given request url
  # ----------------------------
  getRequestHash: (request) ->
    CryptoJS.MD5 request if request?

  cacheResponse: (response, request) ->
    console.error 'CachingStrategy subclasses must provide an implemention for cacheResponse: (response, request)'

  cachedResponseForRequest: (request) ->
    console.error 'CachingStrategy subclasses must provide an implemention for cachedResponseForRequest: (response, request)'

# ------------------------------

class Pistache.LocalStorageCacheStrategy extends Pistache.CachingStrategy

  # Flush the entire local storage cache
  # ----------------------------
  clearCache: ->
    window.localStorage.clear()

  # Cache the request response under json format
  # -------------------------------------
  cacheResponse: (response, request) ->
    hash = @getRequestHash request
    window.localStorage.setItem hash, JSON.stringify(response) if response and hash

  # Returns the cache response for given request
  # if found in the cache, null otherwise.
  # Returned object is deserialized from its JSON structure
  # -------------------------------------------
  cachedResponseForRequest: (request) ->
    hash = @getRequestHash request
    return unless hash? and window.localStorage.getItem(name) != null
    JSON.parse LocalStorageHelper.get(hash)

# ------------------------------

class Pistache.HttpClient

  defaults:
    cachingStrategy: null
    cachingPolicy: Pistache.CachingPolicy.CachingPolicyNone
    customRequestHeaders: null
    url: null

  constructor: (options = null) ->
    @url = options?.url
    @cachingPolicy = options?.cachingPolicy
    @cachingStrategy = options?.cachingStrategy
    @customRequestHeaders = options?.customRequestHeaders

  # Cache the request response if caching rules match
  # ----------------------------------------
  cacheResponse:(response, request) ->
    return if @cachingStrategy is null or request is null
    @cachingStrategy.cacheResponse response, request

  post: (path, params, callbacks) ->
    HttpClient.request "#{@url}/#{path}", params, 'POST',
      headers: => @customRequestHeaders
      success: (object) ->
        callbacks?.success object if callbacks?.success
      error: (error) ->
        callbacks?.error error if callbacks?.error

  get: (path, params, callbacks) ->
    url = "#{@url}/#{path}"

    # If cache enabled
    if @cachingPolicy is CachingPolicy.CachingPolicyCacheThenNetwork or @cachingPolicy is CachingPolicy.CachingPolicyCacheIfAvailable
      cachedResponse = @cachingStrategy?.cachedResponseForRequest url
      # Fire the success callback with cached response now before we refresh
      callbacks?.success cachedResponse
      # Stop here if cache only (not network)
      return if cachedResponse and @cachingPolicy is CachingPolicy.CachingPolicyCacheIfAvailable

    HttpClient.request url, params, 'GET',
      headers: => @customRequestHeaders
      success: (object) =>
        # Cache the response
        @cacheResponse(object, url)
        callbacks?.success object if callbacks?.success
      error: (error) ->
        callbacks?.error error if callbacks?.error


  put: (path, params, callbacks) ->
    HttpClient.request "#{@url}/#{path}", params, 'PUT',
      headers: => @customRequestHeaders
      success: (object) ->
        callbacks?.success object if callbacks?.success
      error: (error) ->
        callbacks?.error error if callbacks?.error

  delete: (path, params, callbacks) ->
    HttpClient.request "#{@url}/#{path}", params, 'DELETE',
      headers: => @customRequestHeaders
      success: (object) ->
        callbacks?.success object if callbacks?.success
      error: (error) ->
        callbacks?.error error  if callbacks?.error

  @request: (url, params, httpMethod, callbacks, apiVersion = 1) =>
    $.ajax
      type   : httpMethod
      url    : url
      data   : params
      headers: callbacks.headers() if callbacks and callbacks.headers
      success: (response) ->
        callbacks.success(response) if callbacks and callbacks.success
      error: (response) ->
        callbacks.error(response) if callbacks and callbacks.error

# ------------------------------

class Pistache.RestClient extends Pistache.HttpClient

  # Bind remote resource access routes
  # (create, update, delete, show)
  # ----------------------------
  resource: (name, options = null) ->
   RestResource.bindResource(@, @, name, options)

# ------------------------------

class Pistache.RestResource

  defaults =
    name: null
    client: null

  constructor: (@name, @client) ->

  create: (user, callbacks) ->
    @client.post "#{@name}.json", {user}, callbacks

  update:  (object_id, user, callbacks) ->
    @client.put  "#{@name}/#{object_id}.json", {user}, callbacks

  show:  (object_id, full, callbacks) ->
    @client.get  (if full then "#{@name}/#{object_id}/full.json" else "#{@name}/#{object_id}.json"), {}, callbacks

  delete: (object_id, callbacks) ->
    @client.delete "#{@name}/#{object_id}.json"

  # Bind remote sub-resource access routes
  # (create, update, delete, show)
  # ----------------------------
  resource: (name, options = null) ->
    RestResource.bindResource(@, @client, name, options)

  # Bind REST a endpoint (used for actions web to this resource node
  # Suited for action web services instead of plain resource
  # (e.g: /games/start.json, /users/42/who_is_arround_me)
  # ---------------------------------------------
  bind: (name, options = null) ->
    HTTPMethod = options?.via || 'get'
    @[name] = (params, callbacks) =>
      @client[HTTPMethod] "#{name}.json", params, callbacks
    @[name]

  # Bind new resource with accessor [name] to {object}
  # Additional conf. can be provided (subresources, bindings...)
  # ------------------------------------------------
  @bindResource: (object, client, name, configuration) ->
    resource = new RestResource(name, client)
    # Bind resource to object insteance with [name] for accessor
    object[name] = resource
    configuration(resource) if configuration
    resource

# ------------------------------

module.exports.CachingPolicy = Pistache.CachingPolicy
module.exports.CachingStrategy = Pistache.CachingStrategy
module.exports.LocalStorageCacheStrategy = Pistache.LocalStorageCacheStrategy
module.exports.HttpClient = Pistache.HttpClient
module.exports.RestClient = Pistache.RestClient
module.exports.RestResource = Pistache.RestResource
