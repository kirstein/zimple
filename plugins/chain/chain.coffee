# Chain each 'chain-able' plugin together
#
# Chains value will be computed after the `#value` function is called.
# All chains are completely lazy. The chainable functions will be called only and only if the value is called.
#
# Each next chain link will have the context of previous links result
do (Z) ->

  # Chain wrapper class
  # each chain member is wrapped in Chain wrapper
  class Chain
    constructor : (@__root, @__context) ->
      @__links = []
      @_createLinks Z::__plugins

    # Wrap each defined function to closure and add it as Chain member
    _createLinks : (obj) ->
      for name, plugin of obj
        @[name] = @_link plugin.fn if @_isChainable name, plugin.options

    # Validate that the plugin is chainable.
    # Only chain plugins that do not have the same names as Chain prototyped methods
    # and plugins who have not set their chain value as false
    _isChainable : (name, options) ->
      not Chain::[name] and options.chain isnt false

    # Create a closure that will push the function to links list on calling
    _link : (func) -> (args...) ->
      @__links.push (context) => func.apply @__root, [ context ].concat args
      @

    # Trigger each link of the chain and returns a value
    # Each next link will have the same context as previous
    #
    # Will return the last context
    value : ->
      context = @__context
      context = link context for link in @__links
      context

  # Expose the chain plugin.
  # Make the chain plugin unchain able
  Z.fn 'chain', ((context) -> new Chain @, context), chain : false
