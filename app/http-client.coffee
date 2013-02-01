CachingPolicy = require 'caching-policy'

module.exports = class HttpClient

  defaults:
    cachingStrategy: null
    cachingPolicy: CachingPolicy.CachingPolicyNone
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
