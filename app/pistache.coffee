namespace 'Pistache', (exports) ->
  exports.CachingStrategy = require 'caching-strategy'
  exports.CachingPolicy = require 'caching-policy'
  exports.LocalStorageCachingStrategy = require 'local-storage-caching-strategy'
  exports.HttpClient = require 'http-client'
  exports.RestClient = require 'rest-client'
  exports.RestResource = require 'rest-resource'

module.exports = Pistache