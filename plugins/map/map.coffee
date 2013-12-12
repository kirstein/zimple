Z.fn 'map', (arr, fn, thisArg) ->
  for item in arr
    if thisArg then fn.call thisArg, item else fn item

