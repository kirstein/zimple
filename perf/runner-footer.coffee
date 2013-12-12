do ->
  cycle    = (event) -> console.log " \u221A #{String event.target}" unless event.target.aborted
  complete =         -> console.log "\n Suite finished:\n\tFastest is #{this.filter('fastest').pluck('name')}\n"
  error    = (err)   -> console.log " \u00d7 #{err.target.name}: #{err.target.error}"

  start = ->
    console.log '\nStarting performance tests. This will take some time:\n'

    for suiteObj in __suites
      suite = suiteObj.suite
      suite.on 'cycle'    , cycle
      suite.on 'error'    , error
      suite.on 'complete' , complete
      suite.run suiteObj.options

  if typeof document isnt 'undefined'
    window.__runTests = start
  else if process.argv.splice(2)[0] == 'start'
    start()
