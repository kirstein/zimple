root = @

# Create the Z class
class Z
  constructor: (context) ->
    return new Z context unless @ instanceof Z
    @_context = context

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
  Z.fn = Z::fn = (name, fn) =>
    throw new Error 'No plugin name defined'                   if not name?
    throw new Error "No function defined for plugin '#{name}'" if typeof fn isnt 'function'

    # Attach the function wrapper to prototype
    @::[name] = (args...) ->
      # If this value happens to be a instance of Z
      # then this means that we don't have to worry about leakage
      # we can safely call the function with the added _context
      if @ instanceof Z
        fn.apply @, [ @_context ].concat args

      else
        Z[name] @, args

    # If we are dealing with syntax like Z.<cmd> then we must wrap it
    # in order to get the right context.
    #
    # If there is no context defined then the default context will be the current `this` value.
    Z[name] = (context = @, args...) ->
      instance = new Z context
      instance[name].apply instance, args

# Expose the Z module
if module?.exports
  module.exports = Z
else if typeof define is 'function' and typeof define?.amd
  define -> Z
else
  root.Z = Z
