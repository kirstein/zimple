do (Z) ->
  COUNT_REGEX = /\((.*)\)/

  curryFn = (fn, args...) ->
    throw new Error 'Z.curry: No function defined' if typeof fn isnt 'function'
    count = getArgumentCount fn

    curryWrapper = (partialargs...) =>
      args = args.concat partialargs
      if count > args.length
        curryWrapper
      else
        fn.apply @, args

  # Parses the function name and fetches the count of arguments from it
  getArgumentCount = (fn) ->
    args = fn.toString().match(COUNT_REGEX)
    args[1].split(',').length

  # Expose the curry plugin
  Z.fn 'curry', curryFn, chain : false
