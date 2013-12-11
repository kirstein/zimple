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

    # We need to wrap each plugin as a member function
    # otherwise we cannot deal with calling members by their references. This is a huge performance hit
    @[name] = new ZWrapper plugin.fn, context for name, plugin of @__plugins

  # Register Z plugin
  #
  # Z plugins will be exposed as
  #
  #   Z.<plugin name>(<context>, <arguments...>)
  #   Z(<context>).<plugin name>(<arguments...>)
  #
  # Plugins will be added as MEMBERS of Z class.
  # Plugins will be added to prototype chain of Z class without a wrapper
  Z.fn = (name, fn, options = {}) ->
    throw new Error 'No plugin name defined'                   if not name?
    throw new Error "No function defined for plugin '#{name}'" if typeof fn isnt 'function'

    # Attach the plugin to plugins list
    Z::__plugins[name] = fn : fn, options : options
    ZWrapper::[name] = fn

    # Add wrapper function so we can later on access the plugins by calling Z.<plugin name>
    Z[name] = new ZWrapper fn
    Z

# Wrapper class for Z plugins
# Each plugin will be called with this wrapper.
#
# This is necessary for direct `this` access in plugins.
# When the wrapper functions are called it will modify the context of Z
class ZWrapper
  # Create a wrapper for a function
  # When plugin is called then the result will be ZWrapper type
  _wrap : (fn, context) -> new ZWrapper fn, context
  constructor : (fn, context) ->
    hasContext = arguments.length == 1
    return =>

      # Only splice the arguments if we really need to
      # grants us quite a lot of speed
      unless hasContext
        args = Array::slice.call arguments
        args.unshift context

      # Make sure that we keep the context
      fn.apply @, args or arguments

# Expose the Z module
if module?.exports
  module.exports = Z
else if typeof define is 'function' and define.amd
  define -> Z
else
  global.Z = Z
