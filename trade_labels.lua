-- TradeMenu and TradeAnim read events.tradeTexts, bypassing data.text.
-- Give each screen its own localized view; never rewrite native event data.
local function copy(t)local out={}for k,v in pairs(t or{})do out[k]=v end;return out end
local function translated(body, original, buffers)
 local slots, count={},0
 for token in tostring(original or''):gmatch('{[^}]+}')do
  if token~='{DONE}'and token~='{PROMPT}'then
   local slot={token=token}
   if token=='{STRBUF}'then count=count+1;slot.buffer=(buffers or{})[count]end
   slots[#slots+1]=slot
  end
 end
 local reordered, sequential={},0
 local result=body:gsub('{[^}]+}',function(token)
  local position=token:match('^{ARG:(%d+)}$')
  if position then
   local slot=assert(slots[tonumber(position)],'Missing native trade argument '..position)
   if slot.token=='{STRBUF}'then
    reordered[#reordered+1]=assert(slot.buffer,'Missing native trade buffer')
   end
   return slot.token
  elseif token=='{STRBUF}'then
   sequential=sequential+1
   reordered[#reordered+1]=assert((buffers or{})[sequential],'Missing native trade buffer')
  end
  return token
 end)
 return result,reordered
end
local function bind(events,catalog,edition)
 events=events or{}
 if events.gen2SpanishTradeCatalog==catalog then return events end
 local view=copy(events)
 view.tradeTexts,view.tradeBuffers=copy(events.tradeTexts),copy(events.tradeBuffers)
 local sets={TRADE_DIALOGSET_COLLECTOR=1,TRADE_DIALOGSET_HAPPY=2,TRADE_DIALOGSET_NEWBIE=3}
 if edition=='crystal'then sets.TRADE_DIALOGSET_GIRL=3;sets.TRADE_DIALOGSET_NEWBIE=4 end
 for _,kind in ipairs({'Intro','Cancel','Wrong','Complete','After'})do
  local key='TRADE_DIALOG_'..kind:upper()
  local texts,bufs=copy(view.tradeTexts[key]),copy(view.tradeBuffers[key])
  for set,n in pairs(sets)do
   -- Crystal's new trader shares HAPPY's intro/refusal/wrong-mon lines,
   -- while its completed/after text is the fourth original personality.
   local number=n
   if n==4 and kind~='Complete'and kind~='After'then number=2 end
   local body=assert(catalog['_NPCTrade'..kind..'Text'..number],'Missing original Spanish trade text')
   texts[set],bufs[set]=translated(body,texts[set],bufs[set])
  end
  view.tradeTexts[key],view.tradeBuffers[key]=texts,bufs
 end
 local shared={NPCTradeCableText='_NPCTradeCableText',TradedForText='Text_NPCTraded'}
 for _,key in ipairs({'_MonWasSentToText','_ForYourMonSendsText','_OTSendsText',
  '_BidsFarewellToMonText','_MonNameBidsFarewellText','_TakeGoodCareOfMonText'})do shared[key]=key end
 for key,label in pairs(shared)do
  local body=assert(catalog[label],'Missing original Spanish trade animation text '..label)
  view.tradeTexts[key],view.tradeBuffers[key]=translated(body,view.tradeTexts[key],view.tradeBuffers[key])
 end
 view.gen2SpanishTradeCatalog=catalog
 return view
end
local function install(Menu,Anim,active)
 for _,screen in ipairs({Menu,Anim})do
  local original=screen.gen2SpanishOriginalNew or screen.new
  screen.gen2SpanishOriginalNew=original
  screen.new=function(game,opts)
   local selected=active(game)
   if not selected then return original(game,opts)end
   local options=copy(opts)
   options.eventTables=bind(options.eventTables or(game and game.data and game.data.gen2EventTables),selected.tradeCatalog,selected.edition)
   return original(game,options)
  end
 end
end
return bind,install
