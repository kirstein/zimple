class Chain
  constructor : (@_context, { @async }) ->
    @async ?= true

  # Return the result
  result : ->
    if @async
      @_context = link() for link in @_links
    @_context

  _isValidMethodName : (name) ->
    name.charAt(0) isnt '_' and not Chain::[name]?

  _linkSync : (func) ->
    (args...) =>
      @_context = func.apply @_context, args
      @

  _linkAsync : (func) ->
    (args...) =>
      @_links ?= []
      @_links.push => func.apply @_context, args
      @

  _link : (func) ->
    unless @async
      @_linkSync func
    else
      @_linkAsync func


Z.fn 'chain', (context, options = {}) ->
  chain = new Chain context, options
  for name, func of Z::
    chain[name] = chain._link func if chain._isValidMethodName name

  chain



