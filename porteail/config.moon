_M = {}

-- open configuration file
_M.open = (root, filename) ->
  filepath = root .. '/' .. filename
  file = io.open filepath, "r"
  if not file
    print "Failed to open #{filepath}."
    os.exit 1
  content = file\read "*a"
  if not content
    file\close!
    print "Failed to read #{filepath}. Is this file empty?"
    os.exit 1
  file\close!

  config = {}

  if setfenv and loadstring
    f = assert loadstring (content), "Wrong formed configuration file."
    setfenv f, config
    f!
  else
    assert(load content, nil, "t", config)!

  config

_M
