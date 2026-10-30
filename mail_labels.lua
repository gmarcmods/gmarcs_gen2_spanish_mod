-- Localize native script mail only while displaying it. Quest checks and
-- saves keep their original canonical message; player-written mail is left alone.
return function(Mail,catalog)
 local original=Mail.gen2SpanishOriginalLines or Mail.lines
 Mail.gen2SpanishOriginalLines=original
 Mail.lines=function(entry)
  local top,bottom=original(entry)
  local messages=catalog()
  local translated=messages and entry and entry.type=='FLOWER_MAIL'and messages[entry.message]
  if translated then return translated:match('^(.-)\n(.*)$')end
  return top,bottom
 end
end
