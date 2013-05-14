#!/usr/bin/env lua

-- display.lua
-- Display content of a file and attempt to match some specific words
-- author: Olivier DOSSMANN (olivier+lua@dossmann.net)

--[[ requirement ]]--
require 'lfs' -- apt-get install liblua5.1-filesystem0 || luarocks install luafilesystem

function process(filepath)
  -- parse given file
  for line in io.lines(filepath) do
    -- check if this line is a comment ("# my comment"), a category ("[[My category]]Its description") or an element ("Title##Description##URL##Image")
    is_comment = string.find(line, '^#+.*')
    is_title = string.find(line, '%[%[(.*)%]%](.*)')
    is_element = string.find(line, '(.*)##(.*)##(.*)##(.*)')
    if is_comment then
      -- do nothing because it's a comment
    elseif is_title then
      title = ''
      for t in string.gmatch(line, '%[%[(.*)%]%].*') do title = title .. t end
      description =''
      for d in string.gmatch(line, '%[%[.*%]%](.*)') do description = description .. d end
      print("TITLE: " .. '\n\t' .. title .. '\n\t' .. description)
    elseif is_element then
      title = ''
      description = ''
      url = ''
      img = ''
      for t in string.gmatch(line, '(.*)##.*##.*##.*') do title = title .. t end
      for d in string.gmatch(line, '.*##(.*)##.*##.*') do description = description .. d end
      for u in string.gmatch(line, '.*##.*##(.*)##.*') do url = url .. u end
      for i in string.gmatch(line, '.*##.*##.*##(.*)') do img = img .. i end
      print("ELEMENT: " .. '\n\t' .. title .. '\n\t' .. description .. '\n\t' .. url .. '\n\t' .. img)
    end
  end
end

function help()
  print('Usage: ' .. arg[0] .. ' FILE...')
end

if arg and table.getn(arg) > 0 then
  for i, file in pairs(arg) do
    if i > 0 then
      attr = lfs.attributes(file)
      if attr and attr.mode == 'file' then
        process(file)
      else
        print('INFO: ' .. file .. ' is not a file or doesn\'t exists.')
      end
    end
  end
else
  print('WARNING: No argument given.')
  help()
  os.exit(1)
end
