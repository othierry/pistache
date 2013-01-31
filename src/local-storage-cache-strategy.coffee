CachingStrategy = require 'helpers/heyphay/caching-strategy'

module.exports = class LocalStorageCacheStrategy extends CachingStrategy

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
    JSON.parse window.localStorage.getItem(name) if hash