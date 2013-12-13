Z.fn 'invoke', (arr, method, args...) ->
  for item in arr
    unless args.length
      item[method]()
    else
      item[method].apply item, args
