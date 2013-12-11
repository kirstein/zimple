do ->
  cycle = (event) -> console.log String event.target
  complete = -> console.log "Fastest is #{this.filter('fastest').pluck('name')}"
  start = ->
   console.log 'Starting performance tests. This will take some time'

   for suiteObj in __suites
      suite = suiteObj.suite
      suite.on 'cycle', cycle
      suite.on 'complete', complete
      suite.run suiteObj.options

  if typeof document isnt 'undefined'
    window.__runTests = start
  else if process.argv.splice(2)[0] == 'start'
    start()

