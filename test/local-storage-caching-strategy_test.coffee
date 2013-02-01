LocalStorageCacheStrategy = require 'local-storage-caching-strategy'

describe 'LocalStorageCachingStrategy', ->

  beforeEach ->
    @strategy = new LocalStorageCacheStrategy()

  # Todo: check why localstorage is not initialized property
  it 'Should be tested in a browser so localstorage can be initialized!', ->
    expect true

  # it 'Should cache objects in localstorage', ->
  #   @strategy.cacheResponse 'results:1', 'http://www.results.com/1'
  #   @strategy.cacheResponse 'results:2', 'http://www.results.com/2'
  #   @strategy.cacheResponse 'results:3', 'http://www.results.com/3'
  #   @strategy.cacheResponse 'results:4', 'http://www.results.com/4'

  #   expect(@strategy.cachedResponseForRequest 'http://www.results.com/1').to.not.be.null
  #   expect(@strategy.cachedResponseForRequest 'http://www.results.com/2').to.not.be.null
  #   expect(@strategy.cachedResponseForRequest 'http://www.results.com/3').to.not.be.null
  #   expect(@strategy.cachedResponseForRequest 'http://www.results.com/4').to.not.be.null

  # it 'Should clear the localstorage', ->
  #   @strategy.clearCache()
  #   expect(@strategy.cachedResponseForRequest 'http://www.results.com/1').to.be.null
  #   expect(@strategy.cachedResponseForRequest 'http://www.results.com/2').to.be.null
  #   expect(@strategy.cachedResponseForRequest 'http://www.results.com/3').to.be.null
  #   expect(@strategy.cachedResponseForRequest 'http://www.results.com/4').to.be.null
