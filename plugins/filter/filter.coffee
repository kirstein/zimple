Z.fn 'filter', (arr, fn, thisArg) ->
  res = []
  for item in arr
    result = if thisArg then fn.call thisArg, item else fn item
    res.push item if result
  res
