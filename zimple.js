(function(global, undefined) {
var Z, ZWrapper,
  __slice = [].slice,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Z = (function() {
  Z.prototype.__plugins = {};

  function Z(context) {
    if (context == null) {
      context = null;
    }
    if (!(this instanceof Z)) {
      return new Z(context);
    }
    this.__context = context;
    this._attachPlugins(this.__plugins);
  }

  Z.prototype._attachPlugins = function(plugins) {
    var name, plugin, _results;
    _results = [];
    for (name in plugins) {
      plugin = plugins[name];
      _results.push(this[name] = new ZWrapper(this.__context, plugin.fn));
    }
    return _results;
  };

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
    Z[name] = function() {
      var args, context;
      context = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      return new Z(context)[name].apply(null, args);
    };
    Z.prototype[name] = fn;
    return Z;
  };

  return Z;

})();

ZWrapper = (function(_super) {
  __extends(ZWrapper, _super);

  function ZWrapper(context, fn) {
    var _this = this;
    this.__wrapper = true;
    return function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return fn.apply(_this, [context].concat(args));
    };
  }

  return ZWrapper;

})(Z);

if (typeof module !== "undefined" && module !== null ? module.exports : void 0) {
  module.exports = Z;
} else if (typeof define === 'function' && typeof (typeof define !== "undefined" && define !== null ? define.amd : void 0)) {
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

    Chain.prototype._isChainable = function(name, options) {
      return !Chain.prototype[name] && options.chain !== false;
    };

    Chain.prototype._link = function(func) {
      return function() {
        var args,
          _this = this;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        this.__links.push(function(context) {
          return func.apply(_this.__root, [context].concat(args));
        });
        return this;
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