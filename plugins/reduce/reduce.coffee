do ->
  Z.fn 'reduce', (arr, cb, result) ->
    start = 0

    unless result?
      start  = 1
      result = arr[0]

    result = cb result, arr[i] for i in [start..arr.length - 1]
    result
