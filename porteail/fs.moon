_M = {}

lfs = require "lfs"

_M.exists = (path) ->
  attr = lfs.attributes path
  if not attr or not attr.mode != 'file'
    return nil, "#{path} doesn't exist or is not a file!"
  return true

_M
