Z.fn 'pluck', (target, property) ->
  if target? and property?
    this.map target, (val) -> val[property]
  else
    result = []
    result[target.length - 1] = undefined if target?.length
    result
