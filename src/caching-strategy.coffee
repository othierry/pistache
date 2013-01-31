module.exports = class CachingStrategy

  # Returns a unique hash based on the
  # given request url
  # ----------------------------
  getRequestHash: (request) ->
    CryptoJS.MD5 request if request?

  cacheResponse: (response, request) ->
    console.error 'CachingStrategy subclasses must provide an implemention for cacheResponse: (response, request)'

  cachedResponseForRequest: (request) ->
    console.error 'CachingStrategy subclasses must provide an implemention for cachedResponseForRequest: (response, request)'
