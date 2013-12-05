class Chain
  constructor : (@_context) ->
    @_initial = @_context
    @_links   = []

  # Return the result
  result : ->
    ret = @_context = link() for link in @_links
    @_context = @_initial
    ret

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
    (args...) =>
      @_links.push => func.apply @_context, [ @_context ].concat args
      @

Z.fn 'chain', (context) ->
  chain = new Chain context
  for name, func of Z::
    chain[name] = chain._link func if chain._isValidMethodName name
  chain
