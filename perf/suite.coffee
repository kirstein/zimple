# Filters out suite tests that do not match the regexp
filter = (obj, regexp) ->
  obj.filter (test) ->
    regexp.test test.name

cycle    = (event) -> console.log " \u221A #{String event.target}" unless event.target.aborted
complete =         -> console.log "\n Suite finished:\n\tFastest is #{this.filter('fastest').pluck('name')}\n"
error    = (err)   -> console.log " \u00d7 #{err.target.name}: #{err.target.error}"

printStart = (suite) ->
  tests = suite.pluck 'name'
  console.log "\nsuite started:"
  console.log "\t#{tests.join '\n\t'}\n"

class Suite
  constructor: (@opts, @suites = []) ->
  run        : ->
    grepReg = new RegExp @opts.grep
    console.log "Starting performance tests. Grep value is #{@opts.grep}"

    for suiteObj in @suites
      suite = filter suiteObj, grepReg

      suite.on 'cycle'    , cycle
      suite.on 'error'    , error
      suite.on 'complete' , complete

      if suite.length
        printStart suite
        suite.run suiteObj.options

# Start a new suite
module.exports = (opts, suite) -> new Suite opts, suite
