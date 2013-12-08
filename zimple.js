(function(global, undefined) {
var Z, ZWrapper,
  __slice = [].slice,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Z = (function() {
  Z.prototype.__plugins = {};

  function Z(context) {
    if (!(this instanceof Z)) {
      return new Z(context);
    }
    this.__context = context || null;
    this._attachPlugins(this.__plugins);
  }

  Z.prototype._attachPlugins = function(plugins) {
    var name, plugin, wrapper, _results;
    _results = [];
    for (name in plugins) {
      plugin = plugins[name];
      wrapper = new ZWrapper(this.__context, plugin.fn);
      _results.push(this[name] = wrapper._fn);
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
    ZWrapper.prototype[name] = Z[name] = function() {
      var args, context, instance;
      context = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      instance = new Z(context);
      return instance[name].apply(instance, args);
    };
    return Z;
  };

  return Z;

})();

ZWrapper = (function(_super) {
  __extends(ZWrapper, _super);

  function ZWrapper(__context, __fn) {
    this.__context = __context;
    this.__fn = __fn;
    this._fn = __bind(this._fn, this);
    this.__wrapper = true;
  }

  ZWrapper.prototype._fn = function() {
    var args;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return this.__fn.apply(this, [this.__context].concat(args));
  };

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

    Chain.prototype._isChainable = function(name) {
      var options, _ref;
      options = ((_ref = this.__root.__plugins[name]) != null ? _ref.options : void 0) || {};
      return typeof this.__root[name] === 'function' && name.charAt(0) !== '_' && (Chain.prototype[name] == null) && options.chain !== false;
    };

    Chain.prototype._link = function(func) {
      return function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        this.__links.push(function(context) {
          return func.apply(this.__root, [context].concat(args));
        });
        return this;
      };
    };

    return Chain;

  })();
  return Z.fn('chain', function(context) {
    var chain, func, name;
    chain = new Chain(this);
    for (name in this) {
      func = this[name];
      if (chain._isChainable(name)) {
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