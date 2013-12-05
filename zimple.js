(function(global, undefined) {
var Z,
  __slice = [].slice;

Z = (function() {
  var _this = this;

  function Z(context) {
    if (context == null) {
      context = global;
    }
    if (!(this instanceof Z)) {
      return new Z(context);
    }
    this._context = context;
  }

  Z.fn = Z.prototype.fn = function(name, fn) {
    if (name == null) {
      throw new Error('No plugin name defined');
    }
    if (typeof fn !== 'function') {
      throw new Error("No function defined for plugin '" + name + "'");
    }
    Z.prototype[name] = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (this instanceof Z) {
        return fn.apply(this, [this._context].concat(args));
      } else {
        return Z[name].apply(this, args);
      }
    };
    return Z[name] = function() {
      var args, context, instance;
      context = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if (context == null) {
        context = this;
      }
      instance = new Z(context);
      return instance[name].apply(instance, args);
    };
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

var Chain,
  __slice = [].slice;

Chain = (function() {
  function Chain(_context) {
    this._context = _context;
    this._initial = this._context;
    this._links = [];
  }

  Chain.prototype.result = function() {
    var link, ret, _i, _len, _ref;
    _ref = this._links;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      link = _ref[_i];
      ret = this._context = link();
    }
    this._context = this._initial;
    return ret;
  };

  Chain.prototype._isValidMethodName = function(name) {
    return name.charAt(0) !== '_' && (Chain.prototype[name] == null);
  };

  Chain.prototype._link = function(func) {
    var _this = this;
    return function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      _this._links.push(function() {
        return func.apply(_this._context, [_this._context].concat(args));
      });
      return _this;
    };
  };

  return Chain;

})();

Z.fn('chain', function(context) {
  var chain, func, name, _ref;
  chain = new Chain(context);
  _ref = Z.prototype;
  for (name in _ref) {
    func = _ref[name];
    if (chain._isValidMethodName(name)) {
      chain[name] = chain._link(func);
    }
  }
  return chain;
});

var __slice = [].slice;

Z.fn('once', function(fn, context) {
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
});

})(this);