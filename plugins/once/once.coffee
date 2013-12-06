# Call a function only once.
# If a function is called more than once then saves the response and returns it on each other call
#
# Will set property chaining to false
# throws if no function is defined
do (Z) ->
  once = (fn, context) ->
    throw new Error 'No function defined' if typeof fn isnt 'function'

    called   = false
    response = null
    (args...) ->
      unless called
        called   = true
        response = fn.apply context, args
      response

  # Expose the plugin
  Z.fn 'once', once , chain : false
