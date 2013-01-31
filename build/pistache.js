var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

window.Pistache || (window.Pistache = {});

Pistache.CachingPolicy = {
  CachingPolicyNone: 0,
  CachingPolicyCacheIfAvailable: 1,
  CachingPolicyNetworkThenCache: 2,
  CachingPolicyCacheThenNetwork: 3
};

Pistache.CachingStrategy = (function() {

  function CachingStrategy() {}

  CachingStrategy.prototype.getRequestHash = function(request) {
    if (request != null) {
      return CryptoJS.MD5(request);
    }
  };

  CachingStrategy.prototype.cacheResponse = function(response, request) {
    return console.error('CachingStrategy subclasses must provide an implemention for cacheResponse: (response, request)');
  };

  CachingStrategy.prototype.cachedResponseForRequest = function(request) {
    return console.error('CachingStrategy subclasses must provide an implemention for cachedResponseForRequest: (response, request)');
  };

  return CachingStrategy;

})();

Pistache.LocalStorageCacheStrategy = (function(_super) {

  __extends(LocalStorageCacheStrategy, _super);

  function LocalStorageCacheStrategy() {
    return LocalStorageCacheStrategy.__super__.constructor.apply(this, arguments);
  }

  LocalStorageCacheStrategy.prototype.clearCache = function() {
    return window.localStorage.clear();
  };

  LocalStorageCacheStrategy.prototype.cacheResponse = function(response, request) {
    var hash;
    hash = this.getRequestHash(request);
    if (response && hash) {
      return window.localStorage.setItem(hash, JSON.stringify(response));
    }
  };

  LocalStorageCacheStrategy.prototype.cachedResponseForRequest = function(request) {
    var hash;
    hash = this.getRequestHash(request);
    if (!((hash != null) && window.localStorage.getItem(name) !== null)) {
      return;
    }
    return JSON.parse(LocalStorageHelper.get(hash));
  };

  return LocalStorageCacheStrategy;

})(Pistache.CachingStrategy);

Pistache.HttpClient = (function() {

  HttpClient.prototype.defaults = {
    cachingStrategy: null,
    cachingPolicy: Pistache.CachingPolicy.CachingPolicyNone,
    customRequestHeaders: null,
    url: null
  };

  function HttpClient(options) {
    if (options == null) {
      options = null;
    }
    this.url = options != null ? options.url : void 0;
    this.cachingPolicy = options != null ? options.cachingPolicy : void 0;
    this.cachingStrategy = options != null ? options.cachingStrategy : void 0;
    this.customRequestHeaders = options != null ? options.customRequestHeaders : void 0;
  }

  HttpClient.prototype.cacheResponse = function(response, request) {
    if (this.cachingStrategy === null || request === null) {
      return;
    }
    return this.cachingStrategy.cacheResponse(response, request);
  };

  HttpClient.prototype.post = function(path, params, callbacks) {
    var _this = this;
    return HttpClient.request("" + this.url + "/" + path, params, 'POST', {
      headers: function() {
        return _this.customRequestHeaders;
      },
      success: function(object) {
        if (callbacks != null ? callbacks.success : void 0) {
          return callbacks != null ? callbacks.success(object) : void 0;
        }
      },
      error: function(error) {
        if (callbacks != null ? callbacks.error : void 0) {
          return callbacks != null ? callbacks.error(error) : void 0;
        }
      }
    });
  };

  HttpClient.prototype.get = function(path, params, callbacks) {
    var cachedResponse, url, _ref,
      _this = this;
    url = "" + this.url + "/" + path;
    if (this.cachingPolicy === CachingPolicy.CachingPolicyCacheThenNetwork || this.cachingPolicy === CachingPolicy.CachingPolicyCacheIfAvailable) {
      cachedResponse = (_ref = this.cachingStrategy) != null ? _ref.cachedResponseForRequest(url) : void 0;
      if (callbacks != null) {
        callbacks.success(cachedResponse);
      }
      if (cachedResponse && this.cachingPolicy === CachingPolicy.CachingPolicyCacheIfAvailable) {
        return;
      }
    }
    return HttpClient.request(url, params, 'GET', {
      headers: function() {
        return _this.customRequestHeaders;
      },
      success: function(object) {
        _this.cacheResponse(object, url);
        if (callbacks != null ? callbacks.success : void 0) {
          return callbacks != null ? callbacks.success(object) : void 0;
        }
      },
      error: function(error) {
        if (callbacks != null ? callbacks.error : void 0) {
          return callbacks != null ? callbacks.error(error) : void 0;
        }
      }
    });
  };

  HttpClient.prototype.put = function(path, params, callbacks) {
    var _this = this;
    return HttpClient.request("" + this.url + "/" + path, params, 'PUT', {
      headers: function() {
        return _this.customRequestHeaders;
      },
      success: function(object) {
        if (callbacks != null ? callbacks.success : void 0) {
          return callbacks != null ? callbacks.success(object) : void 0;
        }
      },
      error: function(error) {
        if (callbacks != null ? callbacks.error : void 0) {
          return callbacks != null ? callbacks.error(error) : void 0;
        }
      }
    });
  };

  HttpClient.prototype["delete"] = function(path, params, callbacks) {
    var _this = this;
    return HttpClient.request("" + this.url + "/" + path, params, 'DELETE', {
      headers: function() {
        return _this.customRequestHeaders;
      },
      success: function(object) {
        if (callbacks != null ? callbacks.success : void 0) {
          return callbacks != null ? callbacks.success(object) : void 0;
        }
      },
      error: function(error) {
        if (callbacks != null ? callbacks.error : void 0) {
          return callbacks != null ? callbacks.error(error) : void 0;
        }
      }
    });
  };

  HttpClient.request = function(url, params, httpMethod, callbacks, apiVersion) {
    if (apiVersion == null) {
      apiVersion = 1;
    }
    return $.ajax({
      type: httpMethod,
      url: url,
      data: params,
      headers: callbacks && callbacks.headers ? callbacks.headers() : void 0,
      success: function(response) {
        if (callbacks && callbacks.success) {
          return callbacks.success(response);
        }
      },
      error: function(response) {
        if (callbacks && callbacks.error) {
          return callbacks.error(response);
        }
      }
    });
  };

  return HttpClient;

}).call(this);

Pistache.RestClient = (function(_super) {

  __extends(RestClient, _super);

  function RestClient() {
    return RestClient.__super__.constructor.apply(this, arguments);
  }

  RestClient.prototype.resource = function(name, options) {
    if (options == null) {
      options = null;
    }
    return RestResource.bindResource(this, this, name, options);
  };

  return RestClient;

})(Pistache.HttpClient);

Pistache.RestResource = (function() {
  var defaults;

  defaults = {
    name: null,
    client: null
  };

  function RestResource(name, client) {
    this.name = name;
    this.client = client;
  }

  RestResource.prototype.create = function(user, callbacks) {
    return this.client.post("" + this.name + ".json", {
      user: user
    }, callbacks);
  };

  RestResource.prototype.update = function(object_id, user, callbacks) {
    return this.client.put("" + this.name + "/" + object_id + ".json", {
      user: user
    }, callbacks);
  };

  RestResource.prototype.show = function(object_id, full, callbacks) {
    return this.client.get((full ? "" + this.name + "/" + object_id + "/full.json" : "" + this.name + "/" + object_id + ".json"), {}, callbacks);
  };

  RestResource.prototype["delete"] = function(object_id, callbacks) {
    return this.client["delete"]("" + this.name + "/" + object_id + ".json");
  };

  RestResource.prototype.resource = function(name, options) {
    if (options == null) {
      options = null;
    }
    return RestResource.bindResource(this, this.client, name, options);
  };

  RestResource.prototype.bind = function(name, options) {
    var HTTPMethod,
      _this = this;
    if (options == null) {
      options = null;
    }
    HTTPMethod = (options != null ? options.via : void 0) || 'get';
    this[name] = function(params, callbacks) {
      return _this.client[HTTPMethod]("" + name + ".json", params, callbacks);
    };
    return this[name];
  };

  RestResource.bindResource = function(object, client, name, configuration) {
    var resource;
    resource = new RestResource(name, client);
    object[name] = resource;
    if (configuration) {
      configuration(resource);
    }
    return resource;
  };

  return RestResource;

})();

window.Pistache.CachingPolicy = Pistache.CachingPolicy;
window.Pistache.CachingStrategy = Pistache.CachingStrategy;
window.Pistache.LocalStorageCacheStrategy = Pistache.LocalStorageCacheStrategy;
window.Pistache.HttpClient = Pistache.HttpClient;
window.Pistache.RestClient = Pistache.RestClient;
window.Pistache.RestResource = Pistache.RestResource;
