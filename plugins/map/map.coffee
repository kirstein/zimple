do ->
  Z.fn 'map', (arr, fn, thisArg) ->
    throw new Error 'Z.map: No array defined'    unless Array.isArray arr
    throw new Error 'Z.map: No function defined' unless typeof fn is 'function'

    for item in arr
      if thisArg then fn.call thisArg, item else fn item

