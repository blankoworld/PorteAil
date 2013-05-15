#!/usr/bin/env lua

-- porteail.lua

--[[ Requirements ]]--

require 'lfs'

--[[ Variables ]]--

-- Mandatories files
local configFile = './' .. 'configrc'
-- Default directories values
local currentpath = os.getenv('CURDIR') or '.'
local default_dir_category = 'categ'
local default_dir_component = 'composants'
local default_dir_destination = 'porteail'
local default_dir_img_destination = 'image'
local default_dir_img_source = 'img'
local default_dir_css_source = 'style'
-- Default files values
local default_img_filename = 'generique.png'
local default_index_filename = 'index.html'
local default_template_index_filename = 'index.html'
local default_template_categ_filename = 'categ.html'
local default_template_element_filename = 'one_element.html'
local default_css_filename = 'noir.css'
local default_css_menu_without = 'sans_menu.css'
local default_css_menu_with = 'avec_menu.css'
-- Other defaults values
local default_categ_extension = 'txt'
local DIR_SEP = '/'
local default_css_name = 'Défaut'

--[[ Functions ]]--

function getConfig(file)
  result = {}
  f = assert(io.open(file, 'r'))
  while true do
    line = f.read(f)
    if not line then break end
    local key = line:match('([^#].-)[ ]+=')
    local val = line:match('=[ ]+(.*)')
    local comment = string.find(line, '^#+(.*)')
    if comment then
      -- do nothing with comment
    elseif key then
      result[key] = val
    end
  end
  assert(f:close())
  return result
end

function replace(string, table)
  return string:gsub("$(%b{})", function(string)
    return table[string:sub(2,-2)]
   end)
end

function listing (path, extension)
  files = {}
  if lfs.attributes(path) then
    for file in lfs.dir(path) do
      if file ~= "." and file ~= ".." then
        local f = path..'/'..file
        local attr = lfs.attributes (f)
        filext = (string.match(file, "[^\\/]-%.?([^%.\\/]*)$"))
        if attr.mode == 'file' and filext == extension then
          table.insert(files, f)
        end
      end
    end
  else
    files = nil
  end
  return files
end

function basename (string, suffix)
  string = string or ''
  local basename = string.gsub (string, '[^'.. DIR_SEP ..']*'.. DIR_SEP ..'', '')
  if suffix then
    basename = string.gsub (basename, suffix, '')
  end
  return basename
end

function processImage(image, source, img_destination, destination, default_img)
  -- if no image given, use default one
  if not image or image == nil or image == '' then
    image = default_img
  end
  -- create image weblink
  result = img_destination .. '/' .. basename(image)
  -- check if this image exists
  attr = lfs.attributes(destination .. '/' .. result)
  if not attr then
    img_path = source .. '/' .. image
    f = assert(io.open(img_path, 'rb'))
    img_src = assert(f:read('*a'))
    assert(f:close())
    img_dest = assert(io.open(destination .. '/' .. result, 'wb'))
    assert(img_dest:write(img_src))
    assert(img_dest:close())
  end
  return result
end

function process(filepath, template_categ, template_element, img_destination, destination, img_source, default_img)
  -- parse given file
  local categ_page = ''
  local elements = {}
  for line in io.lines(filepath) do
    local element = ''
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
      categ_page = replace(template_categ, {CATEG_TITLE=title, CATEG_DESC=description})
    elseif is_element then
      title = ''
      description = ''
      url = ''
      img = ''
      for t in string.gmatch(line, '(.*)##.*##.*##.*') do title = title .. t end
      for d in string.gmatch(line, '.*##.*##(.*)##.*') do description = description .. d end
      for u in string.gmatch(line, '.*##(.*)##.*##.*') do url = url .. u end
      for i in string.gmatch(line, '.*##.*##.*##(.*)') do img = img .. i end
      img_description = " "
      img_url = processImage(img, img_source, img_destination, destination, default_img)
      url = url:gsub('%&', '%&amp;')
      element = replace(template_element, {ELEMENT_URL=url, ELEMENT_DESC=description, ELEMENT_TITLE=title, IMG_URL=img_url, IMG_DESC=img_description})
      table.insert(elements, element)
    end
  end
  local text_elements = ''
  for k, v in pairs(elements) do
    text_elements = text_elements .. v
  end
  local result = replace(categ_page, {ELEMENTS=text_elements})
  return result
end

--[[ Principal ]]--

-- fetch user defined values
config = getConfig(configFile)

-- create values for directories
categ = config['CATEGORIES'] or default_dir_category
component = config['COMPOSANTS'] or default_dir_component
destination = config['CIBLE'] or default_dir_destination
img_destination = config['CIBLE_IMAGE'] or default_dir_img_destination
img_source = config['IMAGES'] or default_dir_img_source
css_source = config['CSS'] or default_dir_css_source
-- create values for files
index_filename = config['INDEX'] or default_index_filename
main_template = config['TEMPLATE_INDEX'] or default_template_index_filename
template_categ_filename = config['TEMPLATE_CATEG'] or default_template_categ_filename
template_element_filename = config['TEMPLATE_ELEMENT'] or default_template_element_filename
default_img = config['DEFAUT_IMG'] or default_img_filename
css_filename = config['STYLE'] or default_css_filename
css_menu = default_css_menu_without
if config['MENU'] then
  css_menu = default_css_menu_with
end
-- other default values
categ_extension = config['CATEGORIES_EXT'] or default_categ_extension
css_name = config['CSS_NAME'] or default_css_name

-- get pages
index_file = assert(io.open(currentpath .. '/' .. component .. '/' .. index_filename, 'r'))
index = assert(index_file:read('*a'))
assert(index_file:close())
template_categ_file = assert(io.open(currentpath .. '/' .. component .. '/' .. template_categ_filename, 'r'))
template_categ = assert(template_categ_file:read('*a'))
assert(template_categ_file:close())
template_element_file = assert(io.open(currentpath .. '/' .. component .. '/' .. template_element_filename, 'r'))
template_element = assert(template_element_file:read('*a'))
assert(template_element_file:close())
-- FIXME: intro and menu
local introduction = ''
local menu = ''

-- Check if public directory exists
if lfs.attributes(destination) == nil then
  assert(lfs.mkdir(destination))
end
-- Check if image directory exists
if lfs.attributes(destination .. '/' .. img_destination) == nil then
  assert(lfs.mkdir(destination .. '/' .. img_destination))
end

-- Browse categ directory
local categories_files = listing (currentpath .. '/' .. categ, categ_extension)
local content = ''
if categories_files then
  for k,v in pairs(categories_files) do
    -- read category content
    attr = lfs.attributes(v)
    if attr and attr.mode == 'file' then
      content = content .. process(v, template_categ, template_element, img_destination, destination, img_source, default_img)
    end
  end
else
  print ("-- No category file found!")
end

-- Create index file in destination directory
result = assert(io.open(destination .. '/' .. main_template, 'wb'))
-- create substitution table
substitutions = {
  TITLE=config['TITRE'] .. ' - Accueil',
  PORTEAIL_TITLE=config['TITRE'],
  CONTENT=content,
  INTRODUCTION=introduction,
  MENU=menu,
  CSS_COLOR=css_filename,
  DEFAULT_CSS=css_menu,
}
-- replace variables in result
homepage = replace(index, substitutions)
assert(result:write(homepage))
-- close file
assert(result:close())

-- Copy miscellaneous files to destination
to_be_copied = {
  component .. '/' .. 'html5.js',
  css_source .. '/' .. css_filename,
  css_source .. '/' .. css_menu,
}
for i, filepath in pairs(to_be_copied) do
  fileattr = lfs.attributes(filepath)
  if not fileattr or fileattr.mode ~= 'file' then
    print (filepath .. " doesn't exist or is not a file!")
    os.exit(1)
  end
  dest = destination .. '/' .. basename(filepath)
  file = assert(io.open(filepath, 'r'))
  filecontent = assert(file:read('*a'))
  assert(file:close())
  destfile = assert(io.open(dest, 'wb'))
  assert(destfile:write(filecontent))
  assert(destfile:close())
end

--[[ END ]]--
