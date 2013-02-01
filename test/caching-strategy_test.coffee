CachingStrategy = require 'caching-strategy'

describe 'CachingStrategy', ->

  beforeEach ->
    @strategy = new CachingStrategy()

  it 'Should generate a unique hash for a given url or string', ->
    hash = @strategy.getRequestHash 'http://test.com/lol?id=42'
    hash2 = @strategy.getRequestHash 'http://test.com/lol?id=43'

    # Hash should have been generated
    expect(hash).to.not.be.null
    expect(hash).to.not.equal 'http://test.com/lol?id=42'

    # Hash2 should have been generated
    expect(hash2).to.not.be.null
    expect(hash2).to.not.equal 'http://test.com/lol?id=43'

    # Hash1 and hash2 should be different
    expect(hash2).to.not.equal hash

  it 'Should generate the same hash of the exact same url', ->
    url = 'http://test.com/lol?id=42&t=true'
    hash = @strategy.getRequestHash url
    hash2 = @strategy.getRequestHash url
    expect(hash).to.not.equal hash2
