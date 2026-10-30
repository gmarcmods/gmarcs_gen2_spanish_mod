-- Optional mods expose English source text. GEN2_ES owns Spanish wording.
return function(mod)
 local strings=assert(loadstring(assert(mod:read('companions/strings.lua')),'@GEN2_ES/companions/strings.lua'))()
 for key,value in pairs(strings)do
  assert(type(key)=='string' and type(value)=='string' and value~='','Invalid companion translation')
  mod.content.strings:override(key,value)
 end
 for key,value in pairs({
  ['quality_of_life.options|DEVICE CLOCK']='RELOJ DEL DISPOSITIVO',
  ['touch_tools|VOXEL SETTINGS']='AJUSTES VÓXEL',
 })do mod.content.strings:override(key,value)end
 -- The optional dependency orders this after Celebi's English registrations.
 -- Do not create quest dialogue when the content mod is absent or disabled.
 if mod.find and mod.find('gmarcs_gen2_celebi_time_travel')then
  local dialogue=assert(loadstring(assert(mod:read('companions/celebi.lua')),'@GEN2_ES/companions/celebi.lua'))()
  for id,body in pairs(dialogue)do mod.content.text:override('gmarcs_gen2_celebi_time_travel:'..id,body)end
 end
end
