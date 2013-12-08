# Create the Z class
class Z

  # List of plugins to be added to Z on initiation
  __plugins : {}

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

  Z.fn = (name, fn, options = {}) ->
    throw new Error 'No plugin name defined'                   if not name?
    throw new Error "No function defined for plugin '#{name}'" if typeof fn isnt 'function'

    # Attach the plugin to plugins list
    Z::__plugins[name] = fn : fn, options : options

    # Add wrapper function so we can later on access the plugins by calling Z.<plugin name>
    Z[name] = (context, args...) ->
      instance = new Z context
      instance[name].apply instance, args

    # Expose Z to make it chainable
    Z

# Expose the Z module
if module?.exports
  module.exports = Z
else if typeof define is 'function' and typeof define?.amd
  define -> Z
else
  global.Z = Z
