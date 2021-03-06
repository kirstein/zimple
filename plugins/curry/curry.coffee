# Curries function parameters
#
# Will evaluate function definition to figure out the `expected` parameter count for this function.
# Then on each call it will try to evaluate the function with given parameters.
# If the parameter count is lower than the expected or `expected` parameter count then it return a new curried function.
#
# Curry does not directly work in `chains`, however it can be used in plugin (that can be also in chains).
#
# The first parameter of curry optional and marks the `expected` parameter count.
# If the parameter is defined then it will consider that count as its `expected` count.
# If the parameter is defined then it will NOT evaluate function definition for arg count
do (Z) ->
  COUNT_REGEX = /\((.*)\)/

  curryFn = (fn, maxCount) ->
    throw new Error 'Z.curry: No function defined' if typeof fn isnt 'function'
    maxCount ?= getArgumentCount fn

    # Return a wrapper that returns a new wrapper if the maxCount has not been reached
    curryWrapper = (args...) ->
      if maxCount > args.length
        (wrapperargs...) -> curryWrapper.apply @, args.concat wrapperargs
      else
        fn.apply @, args

  # Parses the function name and fetches the count of arguments from it
  getArgumentCount = (fn) ->
    args = fn.toString().match(COUNT_REGEX)[1]
    args.split(',').length

  # Expose the curry plugin
  # Make the curry plugin unchainable.
  Z.fn 'curry', curryFn, chain : false
