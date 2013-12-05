# Call a function only once.
# If a function is called more than once then saves the response and returns it on each other call
#
# throws if no function is defined
Z.fn 'once', (fn, context) ->
  throw new Error 'No function defined' if typeof fn isnt 'function'

  called   = false
  response = null
  (args...) ->
    unless called
      called   = true
      response = fn.apply context, args
    response
