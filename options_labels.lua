-- Presentation fallback for apps predating contextual mod-schema labels.
-- Modern engines perform these lookups themselves and need no wrapper.
local Strings=require('src.core.Strings')
return function(Class,active)
 if Class.LOCALIZED_OPTION_SCHEMA then return end
 if Class.gen2EsOptionLabels then Class.gen2EsOptionLabels.active=active;return end
 local state={active=active};Class.gen2EsOptionLabels=state
 local original=Class.buildOptionRows
 function Class:buildOptionRows(manifest,schema)
  local rows=original(self,manifest,schema)
  if not state.active(self.game)then return rows end
  local context=manifest.id..'.options'
  local kinds={};for _,row in ipairs(schema)do kinds[row.key]=row.type end
  for _,row in ipairs(rows)do
   row.label=Strings.lookup(row.label or'',context)
   if row.value and (kinds[row.id]=='choice' or kinds[row.id]=='toggle')then
    local value=row.value
    row.value=function(...)
     local source=value(...)
     return type(source)=='string' and Strings.lookup(source,context)or source
    end
   end
  end
  return rows
 end
end
