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
    return if @cachingPolicy is CachingPolicy.CachingPolicyNone
    return if @cachingStrategy is undefined or request is undefined
    @cachingStrategy.cacheResponse response, request

  post: (path, params, callbacks) ->
    HttpClient.request "#{@url}/#{path}", params, 'POST',
      headers: => @customRequestHeaders || callbacks?.headers
      success: (object) ->
        callbacks?.success object if callbacks?.success
      error: (error) ->
        callbacks?.error error if callbacks?.error

  get: (path, params, callbacks) ->
    url = "#{@url}/#{path}"

    # If cache enabled
    unless @cachingPolicy is CachingPolicy.CachingPolicyNone
      cachedResponse = @cachingStrategy?.cachedResponseForRequest url
      # Fire the success callback with cached response now before we refresh
      callbacks?.success cachedResponse if cachedResponse
      # Stop here if cache only (not network)
      return if cachedResponse and @cachingPolicy is CachingPolicy.CachingPolicyCacheIfAvailable

    HttpClient.request url, params, 'GET',
      headers: => @customRequestHeaders || callbacks?.headers
      success: (object) =>
        # Cache the response
        @cacheResponse(object, url)
        callbacks?.success object if callbacks?.success
      error: (error) ->
        callbacks?.error error if callbacks?.error

  put: (path, params, callbacks) ->
    HttpClient.request "#{@url}/#{path}", params, 'PUT',
      headers: => @customRequestHeaders || callbacks?.headers
      success: (object) ->
        callbacks?.success object if callbacks?.success
      error: (error) ->
        callbacks?.error error if callbacks?.error

  delete: (path, params, callbacks) ->
    HttpClient.request "#{@url}/#{path}", params, 'DELETE',
      headers: => @customRequestHeaders || callbacks?.headers
      success: (object) ->
        callbacks?.success object if callbacks?.success
      error: (error) ->
        callbacks?.error error  if callbacks?.error

  @request: (url, params, httpMethod, callbacks) =>
    $.ajax
      type   : httpMethod
      url     : url
      data   : params
      headers: callbacks.headers() if callbacks?.headers
      success: (response) ->
        callbacks.success(response) if callbacks?.success
      error: (response) ->
        callbacks.error(response) if callbacks?.error

  @client