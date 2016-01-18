_M = {}

fs = require "porteail.fs"

_M.create_homepage = (root, config) ->
  -- initialisation
  tmpl_indexname = config.tmpl_index or 'index.html'
  src_dirname = config.sourceDir or 'src'
  result_dirname = config.resultDir or 'result'
  tmpl_dirname = config.templateDir or 'templates'
  templatename = config.template or 'base'
  -- composed
  src = "#{root}/#{src_dirname}"
  result = "#{root}/#{result_dirname}"
  template = "#{root}/#{tmpl_dirname}/#{templatename}"
  tmpl_index = "#{template}/#{tmpl_indexname}"
  result_index = "#{result}/index.html"
  -- TODO: CHECK DIRECTORIES PRESENCE: use fs.exists method
  -- read source content
  file = io.open tmpl_index, 'r'
  if not file
    print "Reading '#{tmpl_index}' failed!"
    os.exit 1
  content = file\read "*a"
  file\close!
  if not content
    print "Empty file: #{tmpl_index}."
    os.exit 1
  -- create result page
  index = io.open result_index, "wb"
  -- TODO: prepare replace method (in page.moon) and add substitutions table
  index\write content
  index\close!
  return true

_M
