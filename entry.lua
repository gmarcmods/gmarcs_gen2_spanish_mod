-- Original Spanish Gen 2 text, independent of graphics mods.
return function(mod)
  local counts = {}
  -- Load and validate every catalog before registering any overrides.
  local catalogs = {}
  for _, name in ipairs({"dialogue", "rom_text", "items_names", "moves_names", "trainers_names", "pokemon_names", "trainer_party_names", "items_descriptions", "moves_descriptions", "strings", "type_chart_names", "landmarks_names", "pokedex_entries", "radio_channels_names", "phone_contacts_names"}) do
    local path = "lang/" .. name .. ".lua"
    local source = assert(mod:read(path), "Missing Spanish catalog: " .. path)
    catalogs[name] = assert(loadstring(source, "@GOLD_ES/" .. path))()
    assert(type(catalogs[name]) == "table", "Invalid Spanish catalog")
  end
  local naming=assert(loadstring(assert(mod:read("lang/naming_grids.lua")),"@GOLD_ES/lang/naming_grids.lua"))()
  mod.hooks:wrap("ui.naming.grid",function(next,base,context)
    local game=context and context.game
    if not game or not game.data or not game.data.gen2Text then return next(base,context) end
    local key=(context.box and "box_" or "name_")..(context.lower and "lower" or "upper")
    local source=assert(naming[key],"Missing Spanish naming grid")
    local grid={step=source.step,origin=source.origin,targets=source.targets,bottom=source.bottom}
    for row,cells in ipairs(source.rows) do grid[row]=cells end
    return grid
  end)
  counts.naming_grids=4
  local intro=assert(loadstring(assert(mod:read("lang/intro_names.lua")),"@GOLD_ES/lang/intro_names.lua"))()
  mod.hooks:wrap("ui.namepick.menu",function(next,base,context)
    local game=context and context.game
    if not game or not game.data or not game.data.gen2Text then return next(base,context) end
    local choice=(intro.variants or {intro})[1]
    local matches=false
    for _,candidate in ipairs(intro.variants or {intro}) do
      local native=candidate.sourceItems or {"NEW NAME","GOLD","HIRO","TAYLOR","KARL"}
      local equal=#base.items==#native
      for index,name in ipairs(native) do if base.items[index]~=name then equal=false end end
      if equal then choice=candidate;matches=true;break end
    end
    local items={choice.items[1]}
    for index=2,#base.items do items[index]=matches and choice.items[index] or base.items[index] end
    return {items=items,title=choice.title,titleX=choice.titleX}
  end)
  counts.intro_presets=4
  -- Older app builds retain the English intro extraction on the screen.
  -- Refresh that instance through the public hook, leaving ROM data intact.
  local oakLabels={"_OakText1","_OakText2","_OakText4","_OakText5","_OakText6","_OakText7"}
  for _,label in ipairs(oakLabels) do assert(catalogs.rom_text[label],"Missing Spanish Oak text: "..label) end
  mod.hooks:wrap("intro.oak_speech.build",function(next,steps,speech)
    local game=speech and speech.game
    if game and game.data and game.data.gen2Text then
      local texts={}
      for key,value in pairs(speech.texts or {}) do texts[key]=value end
      for _,label in ipairs(oakLabels) do texts[label]=catalogs.rom_text[label] end
      speech.texts=texts
    end
    return next(steps,speech)
  end)
  counts.oak_intro=#oakLabels
  local fontMap=assert(loadstring(assert(mod:read("lang/font_charmap.lua")),"@GOLD_ES/lang/font_charmap.lua"))()
  for seq,code in pairs(fontMap) do
    assert(type(seq)=="string" and type(code)=="number" and code>=0x80 and code<=0xff)
    mod.content.font:register("charmap:es_"..string.format("%02x",code),{seq=seq,code=code})
  end
  for name, values in pairs(catalogs) do
    if name == "pokedex_entries" then
      local count=0
      for id,entry in pairs(values) do
        assert(type(id)=="string" and type(entry)=="table")
        assert(type(entry.kind)=="string" and type(entry.text)=="string" and type(entry.text2)=="string")
        assert(type(entry.heightM)=="number" and type(entry.weightKg)=="number")
        mod.content.pokemon:patch(id,{dexEntry=entry})
        count=count+1
      end
      counts[name]=count
    elseif name == "trainer_party_names" then
      local count = 0
      for id, names in pairs(values) do
        local base = assert(mod.content.trainers:get(id), "Missing trainer class " .. id)
        local trainers = {}
        for index, trainer in ipairs(base.trainers) do
          local copy = {}
          for field, value in pairs(trainer) do copy[field] = value end
          if names[tostring(index)] then
            copy.name = names[tostring(index)]
            count = count + 1
          end
          trainers[index] = copy
        end
        if next(names) then mod.content.trainers:patch(id, {trainers = trainers}) end
      end
      counts[name] = count
    else
      local nameRegistry = name:match("^(.*)_names$")
      local descriptionRegistry = name:match("^(.*)_descriptions$")
      local registry = (nameRegistry or descriptionRegistry) and mod.content[nameRegistry or descriptionRegistry]
        or (name == "strings" and mod.content.strings)
        or (name == "dialogue" and mod.content.text or mod.content.rom_text)
      local count = 0
      for id, value in pairs(values) do
        assert(type(id) == "string" and type(value) == "string" and value ~= "")
        if descriptionRegistry then registry:patch(id, {description = value})
        elseif nameRegistry then registry:patch(id, {name = value})
        else registry:override(id, value) end
        count = count + 1
      end
      counts[name] = count
    end
  end
  local source=mod:read("lang/map_dialogue.lua")
  local mapDialogue=source and assert(loadstring(source,"@Spanish/map_dialogue.lua"))() or {}
  local fieldBuffers=false
  for _,body in pairs(catalogs.dialogue) do
    if body:find("{ESBUF:",1,true) then fieldBuffers=true;break end
  end
  if next(mapDialogue) or fieldBuffers then
    mod.hooks:wrap("script.command",function(nextCommand,ctx,name,args,cmd)
      if not ctx or ctx.generation~=2 or not ctx.vm then return nextCommand(ctx,name,args,cmd) end
      local vm=ctx.vm;cmd=cmd or {};vm.spanishBuffers=vm.spanishBuffers or {}
      local key=cmd.text or (name=="repeattext" and vm.lastTextKey)
      local body=key and ((mapDialogue[ctx.mapId] or {})[key] or vm.text[key])
      local previous=vm.text
      if body and (body:find("{ESBUF:",1,true) or (mapDialogue[ctx.mapId] or {})[key]) then
        body=body:gsub("{ESBUF:(%d+)}",function(id)
          return assert(vm.spanishBuffers[tonumber(id)],"Missing original phone field "..id)
        end)
        -- Instance-local overlay: never edit the shared content registry or
        -- another script's text while the native textbox yields.
        vm.text=setmetatable({[key]=body},{__index=previous})
      end
      local ok,result=pcall(nextCommand,ctx,name,args,cmd)
      vm.text=previous
      if not ok then error(result) end
      if fieldBuffers then
        if cmd.buffer~=nil then vm.spanishBuffers[cmd.buffer]=vm.stringBuffer end
        if name=="special" then
          local special=(vm.specialOrder or {})[(cmd.id or -1)+1]
          if special=="RandomPhoneMon" or special=="RandomPhoneWildMon" or special=="RandomUnseenWildMon" then
            vm.spanishBuffers[1]=vm.stringBuffer
          end
        end
      end
      return result
    end)
  end
  mod.exports.counts = counts
  mod.log:info("Original Spanish Gen 2: %d dialogue, %d system texts", counts.dialogue, counts.rom_text)
end
