# Chain each 'chainable' plugin together
#
# Will skip plugins whose name are the members of Chain function, whos names start with _ and whos chainable value has set to false.
# Chaining is completely async. Functions will be called only and only when value is called.
#
# After the `value` function is called it will restore the original chain starting context.
do (Z) ->

  # Chain wrapper class
  # each chain member is wrapped in Chain wrapper
  class Chain
    constructor : (@_root) ->
      @_links = []

    # Trigger each link of the chain and returns a value
    value : ->
      context = @_root._context
      context = link context for link in @_links
      context

    # Validate the method name and type
    #
    # Only make functions chainable
    # Only allow functions with name begin with _
    # Only allow functions whos name are not on `Chain` prototype
    # Only allow functions whos `__chain` value is not false
    _isChainable : (name, fn) ->
      typeof fn is 'function' and
      name.charAt(0) isnt '_' and
      not Chain::[name]?      and
      fn.__chain isnt false

    # Return the link closure
    # Builds a closure that encapsulates the target function.
    #
    # All function calls will push the chain link to a list
    # on result it will replay all the values and call the real functions.
    _link : (func) ->
      (args...) ->
        @_links.push (context) -> func.apply context, [ context ].concat args
        @

  # Expose the chain plugin
  Z.fn 'chain', (context) ->
    chain = new Chain @
    # Wrap each member of Z prototype to `Chain`
    for name, func of Z::
      chain[name] = chain._link func if chain._isChainable name, func
    chain
