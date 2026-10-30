-- Native script menus carry literal ROM labels, unlike item-name registries.
-- Use the selected edition's item names and system text without touching the
-- shared headers or the world VM's text table.
local function copy(t)local out={}for k,v in pairs(t or{})do out[k]=v end;return out end
return function(Menu,Held,texts,active,translate)
 local original=Menu._spanishNativeNew or Menu.new
 Menu._spanishNativeNew=original
 Menu.new=function(game,opts)
  if not active(game)then return original(game,opts)end
  opts=copy(opts);local header=copy(opts.header);opts.header=header
  local items=game.world and game.world.items or game.data and(game.data.gen2Items or game.data.items)or{}
  local products={['FRESH WATER']='FRESH_WATER',['SODA POP']='SODA_POP',['LEMONADE']='LEMONADE'}
  for _,field in ipairs({'items','gridItems'})do if header[field]then
   local labels={};for i,label in ipairs(header[field])do
    labels[i]=translate and translate(label)or label
    for english,id in pairs(products)do
     local suffix=label:sub(#english+1)
     if label:sub(1,#english)==english and suffix:match('^%s+¥%d+$')and items[id]then
      labels[i]=items[id].name..' '..suffix:match('¥%d+$');break
     end
    end
   end
   header[field]=labels
  end end
  return original(game,opts)
 end
 local heldNew=Held._spanishNativeNew or Held.new;Held._spanishNativeNew=heldNew
 Held.new=function(game,opts)
  if not active(game)then return heldNew(game,opts)end
  opts=copy(opts)
  local source=opts.text or game.world and game.world.text
  local overlay=copy(source);overlay.labels=copy(source and source.labels)
  for _,label in pairs(Held.LABELS or {tookItem='_PokemonTookItemText'})do
   if texts[label]then
    local key=overlay.labels[label]or('GEN2_ES:'..label)
    overlay.labels[label]=key;overlay[key]=texts[label]
   end
  end
  opts.text=overlay
  return heldNew(game,opts)
 end
end
