# Create the Z class
#
# Each member of the Z family that is prefixed with `__` is a private NOT-A-FUNCTION member
# Each member of the Z family that is prefixed with `_` is a private FUNCTION.
#
# There can be undesired side-effects when using private members.
class Z

  # List of plugins to be added to Z on initiation
  __plugins : {}

  # Z constructor.
  # If Z is called without a `new` keyword then it will return a new instance of Z
  #
  # Calling Z with and without `new` keyword will have no effect of the functionality.
  # After the initiation will add plugins as members.
  constructor: (context) ->
    return new Z context unless @ instanceof Z
    @__context = context or null
    @__wrapper = true
    @_attachPlugins @__plugins

  # Wrap a function in closure
  # set __wrapper value as true
  _wrap : (fn) ->
    wrapper = (args...) => fn.apply @, [ @__context ].concat args
    wrapper.__wrapper = true
    wrapper

  # Attach plugins to Z
  # Wrap each plugin in closure and add them as Z members
  #
  # We wont add the plugins to Z prototype because that would gimp our ability to call functions by reference.
  # Therefore we add all plugins as members.
  _attachPlugins : (plugins) ->
    @[name] = @_wrap plugin.fn for name, plugin of plugins

  # Register Z plugin
  #
  # Z plugins will be exposed as
  #
  #   Z.<plugin name>(<context>, <arguments...>)
  #   Z(<context>).<plugin name>(<arguments...>)
  #
  # Plugins will be added as MEMBERS of Z class.
  # Plugins wont be added to prototype chain.
  #
  # Plugin options will be added to Z.prototype.__plugins[<plugin name>].options
  # They will be only used by other plugins. Not by Z itself.
  #
  # Chaining of plugins works two ways:
  #
  #   1. Call the plugin directly from other plugin.
  #      With this case the called plugins context wont mutate.
  #
  #    Z.fn('sum', function(context, val) {
  #      return context + val;
  #    });
  #
  #    Z.fn('addOne', function(context) {
  #      this.sum(1);
  #    });
  #
  #  2. Start a new Z chain
  #
  #    Z.fn('sum', function(context, val) {
  #      return context + val;
  #    });
  #
  #    Z.fn('addOne', function(context) {
  #      Z.sum(context, 1);
  #    });
  #
  Z.fn = (name, fn, options = {}) ->
    throw new Error 'No plugin name defined'                   if not name?
    throw new Error "No function defined for plugin '#{name}'" if typeof fn isnt 'function'

    # Attach the plugin to plugins list
    Z::__plugins[name] = fn : fn, options : options

    # Add wrapper function so we can later on access the plugins by calling Z.<plugin name>
    Z[name] = (context, args...) ->
      instance = new Z context
      instance[name].apply instance, args

    # Expose Z to make it chain able
    Z

# Expose the Z module
if module?.exports
  module.exports = Z
else if typeof define is 'function' and typeof define?.amd
  define -> Z
else
  global.Z = Z
