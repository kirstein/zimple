# Expose the Z module
if module?.exports
  module.exports = Z
else if typeof define is 'function' and define.amd
  define -> Z
else
  global.Z = Z
