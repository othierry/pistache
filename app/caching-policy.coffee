# Caching rules
# -----------

CachingPolicy =
  CachingPolicyNone: 0                            # No cache
  CachingPolicyCacheIfAvailable: 1          # Cache ONLY if available, network otherwise but not both
  CachingPolicyNetworkThenCache: 2      # Network ONLY if available, cache otherwise but not both
  CachingPolicyCacheThenNetwork: 3      # Cache if available, plus refresh the cache in background

module.exports = CachingPolicy