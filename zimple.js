(function(global, undefined) {
var Z,
  __slice = [].slice;

Z = (function() {
  var attachOptions, wrapPartial, wrapWraped,
    _this = this;

  function Z(context) {
    if (context == null) {
      context = global;
    }
    if (!(this instanceof Z)) {
      return new Z(context);
    }
    this._context = context;
  }

  attachOptions = function(name, options) {
    var key, value, _results;
    _results = [];
    for (key in options) {
      value = options[key];
      Z[name][key] = value;
      _results.push(Z.prototype[name][key] = value);
    }
    return _results;
  };

  wrapWraped = function(name, fn) {
    return function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (this instanceof Z) {
        return fn.apply(this, [this._context].concat(args));
      } else {
        return Z[name].apply(this, args);
      }
    };
  };

  wrapPartial = function(name) {
    return function() {
      var args, context, instance;
      context = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if (context == null) {
        context = this;
      }
      instance = new Z(context);
      return instance[name].apply(instance, args);
    };
  };

  Z.fn = Z.prototype.fn = function(name, fn, options) {
    if (options == null) {
      options = {};
    }
    if (name == null) {
      throw new Error('No plugin name defined');
    }
    if (typeof fn !== 'function') {
      throw new Error("No function defined for plugin '" + name + "'");
    }
    Z.prototype[name] = wrapWraped(name, fn);
    Z[name] = wrapPartial(name);
    attachOptions(name, options);
    return Z;
  };

  return Z;

}).call(this);

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
    function Chain(_root) {
      this._root = _root;
      this._links = [];
    }

    Chain.prototype.value = function() {
      var context, link, _i, _len, _ref;
      context = this._root._context;
      _ref = this._links;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        link = _ref[_i];
        context = link(context);
      }
      return context;
    };

    Chain.prototype._isChainable = function(name, fn) {
      return typeof fn === 'function' && name.charAt(0) !== '_' && (Chain.prototype[name] == null) && fn.__chain !== false;
    };

    Chain.prototype._link = function(func) {
      return function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        this._links.push(function(context) {
          return func.apply(context, [context].concat(args));
        });
        return this;
      };
    };

    return Chain;

  })();
  return Z.fn('chain', function(context) {
    var chain, func, name, _ref;
    chain = new Chain(this);
    _ref = Z.prototype;
    for (name in _ref) {
      func = _ref[name];
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
      throw new Error('No function defined');
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
    __chain: false
  });
})(Z);

var __slice = [].slice;

(function(Z) {
  var onceFn;
  onceFn = function(fn, context) {
    var called, response;
    if (typeof fn !== 'function') {
      throw new Error('No function defined');
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
    __chain: false
  });
})(Z);

})(this);