-- Older/current shopping calls bypass the localized phone-contact registry.
-- Normalize only that vanilla caller label; leave the call and custom names alone.
return function(Ring,Phone,labels,active)
 local original=Ring.gen2SpanishOriginalScript or Ring.script
 Ring.gen2SpanishOriginalScript=original
 Ring.script=function(call,name,className)
  if active() and call and call.contact==Phone.PHONECONTACT_MOM
     and name==Phone.NON_TRAINER_NAMES[Phone.PHONECONTACT_MOM]then
   name=assert(labels.PHONE_MOM,'Missing original Spanish mother caller name')
  end
  return original(call,name,className)
 end
end
