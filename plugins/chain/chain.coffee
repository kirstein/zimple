class Chain
  constructor : (@_root) ->
    @_links   = []

  # Return the result
  result : ->
    context = @_root._context
    context = link context for link in @_links
    context

  # Validate the method name
  # Do not allow methods that begin with _
  # or are the methods of Chain prototype
  _isValidMethodName : (name) ->
    name.charAt(0) isnt '_' and not Chain::[name]?

  # Return the link closure
  # Builds a closure that encapsulates the target function.
  #
  # All function calls will push the chain link to a list
  # on result it will replay all the values and call the real functions.
  _link : (func) ->
    (args...) ->
      @_links.push (context) -> func.apply context, [ context ].concat args
      @

Z.fn 'chain', (context) ->
  chain = new Chain @
  for name, func of Z::
    chain[name] = chain._link func if chain._isValidMethodName name
  chain
