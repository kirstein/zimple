(function(global, undefined) {
var Z, ZWrapper;

Z = (function() {
  Z.prototype.__plugins = {};

  function Z(context) {
    var name, plugin, _ref;
    if (!(this instanceof Z)) {
      return new Z(context);
    }
    _ref = this.__plugins;
    for (name in _ref) {
      plugin = _ref[name];
      this[name] = new ZWrapper(plugin.fn, context);
    }
  }

  Z.fn = function(name, fn, options) {
    if (options == null) {
      options = {};
    }
    if (name == null) {
      throw new Error('No plugin name defined');
    }
    if (typeof fn !== 'function') {
      throw new Error("No function defined for plugin '" + name + "'");
    }
    Z.prototype.__plugins[name] = {
      fn: fn,
      options: options
    };
    ZWrapper.prototype[name] = fn;
    Z[name] = new ZWrapper(fn);
    return Z;
  };

  return Z;

})();

ZWrapper = (function() {
  ZWrapper.prototype._wrap = function(fn, context) {
    return new ZWrapper(fn, context);
  };

  function ZWrapper(fn, context) {
    var hasContext,
      _this = this;
    hasContext = arguments.length === 1;
    return function() {
      var args;
      if (!hasContext) {
        args = Array.prototype.slice.call(arguments);
        args.unshift(context);
      }
      return fn.apply(_this, args || arguments);
    };
  }

  return ZWrapper;

})();

if (typeof module !== "undefined" && module !== null ? module.exports : void 0) {
  module.exports = Z;
} else if (typeof define === 'function' && define.amd) {
  define(function() {
    return Z;
  });
} else {
  global.Z = Z;
}

var __slice = [].slice;

(function(Z) {
  var Chain;
  Chain = (function() {
    function Chain(__root, __context) {
      this.__root = __root;
      this.__context = __context;
      this.__links = [];
      this._createLinks(Z.prototype.__plugins);
    }

    Chain.prototype._createLinks = function(obj) {
      var name, plugin, _results;
      _results = [];
      for (name in obj) {
        plugin = obj[name];
        if (this._isChainable(name, plugin.options)) {
          _results.push(this[name] = this._link(plugin.fn));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Chain.prototype._isChainable = function(name, _arg) {
      var chain;
      chain = _arg.chain;
      return !Chain.prototype[name] && chain !== false;
    };

    Chain.prototype._link = function(func) {
      var _this = this;
      return function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        _this.__links.push(function(context) {
          return _this.__root._wrap(func, context).apply(null, args);
        });
        return _this;
      };
    };

    Chain.prototype.value = function() {
      var context, link, _i, _len, _ref;
      context = this.__context;
      _ref = this.__links;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        link = _ref[_i];
        context = link(context);
      }
      return context;
    };

    return Chain;

  })();
  return Z.fn('chain', (function(context) {
    return new Chain(this, context);
  }), {
    chain: false
  });
})(Z);

var __slice = [].slice;

(function(Z) {
  var COUNT_REGEX, curryFn, getArgumentCount;
  COUNT_REGEX = /\((.*)\)/;
  curryFn = function(fn, maxCount) {
    var curryWrapper;
    if (typeof fn !== 'function') {
      throw new Error('Z.curry: No function defined');
    }
    if (maxCount == null) {
      maxCount = getArgumentCount(fn);
    }
    return curryWrapper = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (maxCount > args.length) {
        return function() {
          var wrapperargs;
          wrapperargs = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
          return curryWrapper.apply(this, args.concat(wrapperargs));
        };
      } else {
        return fn.apply(this, args);
      }
    };
  };
  getArgumentCount = function(fn) {
    var args;
    args = fn.toString().match(COUNT_REGEX)[1];
    return args.split(',').length;
  };
  return Z.fn('curry', curryFn, {
    chain: false
  });
})(Z);

(function() {
  return Z.fn('map', function(arr, fn, thisArg) {
    var item, _i, _len, _results;
    if (!Array.isArray(arr)) {
      throw new Error('Z.map: No array defined');
    }
    if (typeof fn !== 'function') {
      throw new Error('Z.map: No function defined');
    }
    _results = [];
    for (_i = 0, _len = arr.length; _i < _len; _i++) {
      item = arr[_i];
      if (thisArg) {
        _results.push(fn.call(thisArg, item));
      } else {
        _results.push(fn(item));
      }
    }
    return _results;
  });
})();

var __slice = [].slice;

(function(Z) {
  var onceFn;
  onceFn = function(fn, context) {
    var called, response;
    if (typeof fn !== 'function') {
      throw new Error('Z.once: No function defined');
    }
    called = false;
    response = null;
    return function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (!called) {
        called = true;
        response = fn.apply(context, args);
      }
      return response;
    };
  };
  return Z.fn('once', onceFn, {
    chain: false
  });
})(Z);

})(this);