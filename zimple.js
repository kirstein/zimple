(function(global, undefined) {
var Z,
  __slice = [].slice;

Z = (function() {
  Z.prototype.__plugins = {};

  function Z(context) {
    if (!(this instanceof Z)) {
      return new Z(context);
    }
    this.__context = context || null;
    this.__wrapper = true;
    this._attachPlugins(this.__plugins);
  }

  Z.prototype._wrap = function(fn) {
    var wrapper,
      _this = this;
    wrapper = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return fn.apply(_this, [_this.__context].concat(args));
    };
    wrapper.__wrapper = true;
    return wrapper;
  };

  Z.prototype._attachPlugins = function(plugins) {
    var name, plugin, _results;
    _results = [];
    for (name in plugins) {
      plugin = plugins[name];
      _results.push(this[name] = this._wrap(plugin.fn));
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
      var args, context, instance;
      context = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      instance = new Z(context);
      return instance[name].apply(instance, args);
    };
    return Z;
  };

  return Z;

})();

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
    function Chain(__root) {
      this.__root = __root;
      this.__links = [];
    }

    Chain.prototype.value = function() {
      var context, link, _i, _len, _ref;
      context = this.__root.__context;
      _ref = this.__links;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        link = _ref[_i];
        context = link(context);
      }
      return context;
    };

    Chain.prototype._isChainable = function(name, fn) {
      var options, _ref;
      options = ((_ref = Z.prototype.__plugins[name]) != null ? _ref.options : void 0) || {};
      return typeof fn === 'function' && name.charAt(0) !== '_' && (Chain.prototype[name] == null) && options.chain !== false;
    };

    Chain.prototype._link = function(func) {
      return function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        this.__links.push(function(context) {
          return func.apply(context, [context].concat(args));
        });
        return this;
      };
    };

    return Chain;

  })();
  return Z.fn('chain', function(context) {
    var chain, func, name;
    chain = new Chain(this);
    for (name in Z) {
      func = Z[name];
      if (chain._isChainable(name, func)) {
        chain[name] = chain._link(func);
      }
    }
    return chain;
  });
})(Z);

var __slice = [].slice;

(function(Z) {
  var COUNT_REGEX, curryFn, getArgumentCount;
  COUNT_REGEX = /\((.*)\)/;
  curryFn = function() {
    var args, count, curryWrapper, fn,
      _this = this;
    fn = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    if (typeof fn !== 'function') {
      throw new Error('Z.curry: No function defined');
    }
    count = getArgumentCount(fn);
    return curryWrapper = function() {
      var partialargs;
      partialargs = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      args = args.concat(partialargs);
      if (count > args.length) {
        return curryWrapper;
      } else {
        return fn.apply(_this, args);
      }
    };
  };
  getArgumentCount = function(fn) {
    var args;
    args = fn.toString().match(COUNT_REGEX);
    return args[1].split(',').length;
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