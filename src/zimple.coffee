# Create the Z class
class Z
  constructor: (context = global) ->
    return new Z context unless @ instanceof Z
    @_context = context

  # Attaches options to a named function
  # of function members and function prototype
  attachOptions = (name, options) ->
    for key, value of options
      Z[name][key] = value
      Z::[name][key] = value

  # Wrap the wraped function syntax.
  #
  # if the `this` value of the called function happens to be Z then just directly call the function
  # otherwise call the partial wrapper with the given context
  wrapWraped = (name, fn) ->
    (args...) ->
      # If this value happens to be a instance of Z
      # then this means that we don't have to worry about leakage
      # we can safely call the function with the added _context
      if @ instanceof Z
        fn.apply @, [ @_context ].concat args
      else
        Z[name].apply @, args

  # Return the wrapper of a partial function
  #
  # The partial function will return a wrapped function (FUNCTIONCEPTION?!)
  wrapPartial = (name) ->
    (context = @, args...) ->
      instance = new Z context
      instance[name].apply instance, args

  # Add plugin support
  # Plugins can be added to `Zimple` by triggering the `#fn` function, passing the plugin name and fn.
  # Plugins will be added to Z prototype and as a member of Z function.
  #
  # Mainly there are two ways to trigger plugins
  #   1. Initiated Z:
  #     Z(<context>).<plugin name>(<plugin arguments>)
  #   2. partial:
  #     Z.<plugin name>(<context>, <plugin arguments)
  #
  # All initiated plugins are initiated in the context of `Zimple` and can therefore directly trigger other plugins.
  Z.fn = Z::fn = (name, fn, options = {}) =>
    throw new Error 'No plugin name defined'                   if not name?
    throw new Error "No function defined for plugin '#{name}'" if typeof fn isnt 'function'

    Z::[name] = wrapWraped  name, fn
    Z[name]   = wrapPartial name

    attachOptions name, options
    Z

# Expose the Z module
if module?.exports
  module.exports = Z
else if typeof define is 'function' and typeof define?.amd
  define -> Z
else
  global.Z = Z
