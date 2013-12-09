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
    @_attachPlugins @__plugins

  # Attach plugins to Z
  # Wrap each plugin in closure and add them as Z members
  #
  # We wont add the plugins to Z prototype because that would gimp our ability to call functions by reference.
  # Therefore we add all plugins as members.
  #
  # When plugin is called then the result will be ZWrapper type
  _attachPlugins : (plugins) ->
    @[name] = ZWrapper @__context, plugin.fn for name, plugin of plugins

  # Register Z plugin
  #
  # Z plugins will be exposed as
  #
  #   Z.<plugin name>(<context>, <arguments...>)
  #   Z(<context>).<plugin name>(<arguments...>)
  #
  # Plugins will be added as MEMBERS of Z class.
  # Plugins wont be added to prototype chain of Z class.
  # Plugins WILL be added to ZWrapper prototype class.
  Z.fn = (name, fn, options = {}) ->
    throw new Error 'No plugin name defined'                   if not name?
    throw new Error "No function defined for plugin '#{name}'" if typeof fn isnt 'function'

    # Attach the plugin to plugins list
    Z::__plugins[name] = fn : fn, options : options

    # Add wrapper function so we can later on access the plugins by calling Z.<plugin name>
    # ZWrapper prototype takes care of the direct this.<plugin name> calls in plugins allowing it to change the context
    Z[name] = (context, args...) ->
      instance = new Z(context)
      instance[name].apply instance, args

    ZWrapper::[name] = fn

    # Expose Z to make it chain-able
    Z

# Wrapper class for Z plugins
# Each plugin will be called with this wrapper.
#
# This is necessary for direct `this` access in plugins.
# When the wrapper functions are called it will modify the context of Z
class ZWrapper extends Z
  constructor : (context, fn) ->
    return new ZWrapper context, fn unless @ instanceof ZWrapper
    @__wrapper = true
    @__context = context
    @__fn      = fn
    return (args...) => fn.apply @, [ context ].concat args

# Expose the Z module
if module?.exports
  module.exports = Z
else if typeof define is 'function' and typeof define?.amd
  define -> Z
else
  global.Z = Z
