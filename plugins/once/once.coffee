# Call a function only once.
# If a function is called more than once then saves the response and returns it on each other call
#
# Will set property chaining to false
# throws if no function is defined
Z.fn 'once', (fn, context) ->
  throw new Error 'Z.once: No function defined' if typeof fn isnt 'function'

  called   = false
  response = null
  ->
    unless called
      called   = true
      response = fn.apply context, arguments
    response

# Make the once function unchainable
, chain : false
