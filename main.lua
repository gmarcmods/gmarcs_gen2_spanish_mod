-- One product, edition-specific original cartridge content.
local GameVersion=require('src.core.GameVersion')
return function(mod)
  -- Content is registered before a playthrough/storage context exists.
  local edition=GameVersion.get()
  assert(edition=='gold' or edition=='silver' or edition=='crystal','Unsupported Spanish edition')
  local prefix='variants/'..edition..'/'
  local view=setmetatable({}, {__index=mod})
  function view:read(path)
    return mod:read(path:sub(1,5)=='lang/' and prefix..path or path)
  end
  assert(loadstring(assert(mod:read('entry.lua')),'@GEN2_ES/entry.lua'))()(view)
  assert(loadstring(assert(mod:read('companions.lua')),'@GEN2_ES/companions.lua'))()(mod)
  assert(loadstring(assert(mod:read('options_labels.lua')),'@GEN2_ES/options_labels.lua'))()(
    require('src.mods.ManagerState'),function(game)
      return game and game.mods and game.mods.exports.GEN2_ES~=nil
    end)
  mod.exports.edition=edition
  mod.exports.tradeCatalog=assert(loadstring(assert(view:read('lang/rom_text.lua'))))()
  local _,installTrades=assert(loadstring(assert(mod:read('trade_labels.lua'))))()
  installTrades(require('src.ui.gen2.TradeMenu'),require('src.ui.gen2.TradeAnim'),function(game)
    local selected=game and game.mods and game.mods.exports.GEN2_ES
    return selected and selected.tradeCatalog and selected
  end)
  assert(loadstring(assert(mod:read('native_menus.lua'))))()(
    require('src.ui.gen2.ScriptMenu'),require('src.ui.gen2.HeldItemMenu'),mod.exports.tradeCatalog,
    function(game)return game and game.mods and game.mods.exports.GEN2_ES~=nil end,require('src.core.Strings'))
  local phoneLabels=assert(loadstring(assert(view:read('lang/phone_contacts_names.lua'))))()
  assert(loadstring(assert(mod:read('phone_labels.lua'))))()(
    require('src.core.gen2.PhoneRing'),require('src.core.gen2.Phone'),phoneLabels,
    function()return mod.game and mod.game.mods and mod.game.mods.exports.GEN2_ES~=nil end)

  local mail=assert(loadstring(assert(view:read('lang/mail_messages.lua'))))()
  mod.exports.mailMessages=mail
  assert(loadstring(assert(mod:read('mail_labels.lua'))))()(
    require('src.core.gen2.Mail'),function()
      local active=mod.game and mod.game.mods and mod.game.mods.exports.GEN2_ES
      return active and active.mailMessages
    end)

  local layout=assert(loadstring(assert(view:read('lang/ui_layout.lua')),'@GEN2_ES/ui_layout.lua'))()
  mod.exports.uiLayout=layout
  if mod.game and mod.game.data and mod.game.data.gen2Diploma then
    local copy={}
    for key,value in pairs(mod.game.data.gen2Diploma)do copy[key]=value end
    copy.page1=layout.diplomaMap
    mod.game.data.gen2Diploma=copy
  end
  if mod.game and mod.game.data and mod.game.data.gen2MenuGfx then
    local Card=require('src.ui.gen2.TrainerCard')
    local Strings=require('src.core.Strings')
    if not Card.gen2SpanishPrint then
      local original=Card.print
      Card.gen2SpanishPrint=original
      function Card:print(text,x,y)
        local exports=self.game and self.game.mods and self.game.mods.exports
        local active=exports and exports.GEN2_ES
        local native=active and active.uiLayout.trainerCard
        if native and x==2 then
          if y==2 and text==Strings('NAME/') then text=native.name end
          if y==6 and text==Strings('MONEY') then text=native.money end
        end
        return original(self,text,x,y)
      end
    end
    local Diploma=require('src.ui.gen2.Diploma')
    local Font=require('src.render.Font')
    if not Diploma.gen2SpanishNew then
      local original=Diploma.new
      Diploma.gen2SpanishNew=original
      function Diploma.new(game,opts)
        local screen=original(game,opts)
        if game and game.mods and game.mods.exports.GEN2_ES then
          local gap=math.max(0,math.ceil(Font.width(Strings('PLAYER'))/8)-6)
          screen.playerName=string.rep(' ',gap)..screen.playerName
        end
        return screen
      end
    end
  end
  -- The public title event runs before the first draw. Replace only the
  -- translated background; retain each edition's original animated actors.
  mod.events:on('intro.boot.title',function(event)
    local screen=event.screen
    local name=edition=='crystal' and 'crystal_screen' or 'title_screen'
    screen.screenColor=mod.assets:image(prefix..'overrides/title/'..name..'.png')
    screen.screenGray=mod.assets:image(prefix..'overrides/title/'..name..'_gray.png')
  end)
end
