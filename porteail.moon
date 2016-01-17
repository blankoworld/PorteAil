#!/usr/bin/env moon

argparse = require "argparse"
config = require "porteail.config"
lfs = require "lfs"

root = lfs.currentdir!

-- Prepare parser
parser = argparse arg[0], "PorteAil, portal web builder"
local command

parser\option "-c --config-file", "Use a specific configuration file.",
  "confs/default"

command = parser\command "build", "Build portal"
command\argument "config", "configuration file", "confs/default"

-- Retrieve user given command
opt = parser\parse arg

-- Open configuration
cfg = config.open root, opt.config_file
if not cfg
  print "Failed to load #{opt.config_file}. Check it."
  os.exit 1

-- What's going on?
if opt.build
  print "je compile"
else
  print "Use --help instead"
  os.exit 1
