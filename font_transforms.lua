local gold=(function()
local main=(function()
-- Original Spanish Gold glyph differences; generated from verified ROMs.
local changes = {
  {58, {0,0,0,0,0,0,0,0}, {32,16,56,4,60,68,62,0}},
  {59, {0,0,0,0,0,0,0,0}, {16,8,60,66,126,64,62,0}},
  {60, {0,0,0,0,0,0,0,0}, {48,192,60,66,126,64,62,0}},
  {61, {0,0,0,0,0,0,0,0}, {32,16,68,68,68,68,60,0}},
  {62, {0,0,0,0,0,0,0,0}, {16,8,16,40,68,254,130,0}},
  {63, {0,0,0,0,0,0,0,0}, {16,32,16,40,68,254,130,0}},
  {70, {0,0,0,0,0,0,0,0}, {16,8,254,128,252,128,254,0}},
  {71, {0,0,0,0,0,0,0,0}, {16,32,254,128,252,128,254,0}},
  {72, {0,0,0,0,0,0,0,0}, {16,8,124,16,16,16,124,0}},
  {73, {0,0,0,0,0,0,0,0}, {16,32,124,16,16,16,124,0}},
  {74, {0,0,0,0,0,0,0,0}, {50,76,194,162,146,138,134,0}},
  {75, {0,0,0,0,0,0,0,0}, {16,8,124,130,130,130,124,0}},
  {76, {0,0,0,0,0,0,0,0}, {16,32,124,130,130,130,124,0}},
  {77, {0,0,0,0,0,0,0,0}, {16,8,130,130,130,66,62,0}},
  {78, {0,0,0,0,0,0,0,0}, {16,32,130,130,130,66,62,0}},
  {79, {0,0,0,0,0,0,0,0}, {8,16,56,4,60,68,62,0}},
  {80, {194,66,130,62,66,66,62,0}, {32,16,0,16,16,16,16,0}},
  {81, {200,72,136,8,8,8,8,0}, {8,16,0,16,16,16,16,0}},
  {82, {192,64,150,41,41,41,41,0}, {50,76,60,34,34,34,34,0}},
  {83, {192,64,147,20,24,16,16,0}, {32,16,60,66,66,66,60,0}},
  {84, {192,64,158,32,30,1,62,0}, {8,16,60,66,66,66,60,0}},
  {85, {192,72,190,8,8,8,6,0}, {8,16,68,68,68,68,60,0}},
  {86, {192,64,162,34,34,20,8,0}, {48,72,72,48,0,0,0,0}},
  {87, {0,0,0,0,0,0,0,0}, {48,104,104,50,90,204,122,0}},
  {88, {0,0,0,0,0,0,0,0}, {194,66,130,62,66,66,62,0}},
  {89, {0,0,0,0,0,0,0,0}, {200,72,136,8,8,8,8,0}},
  {90, {0,0,0,0,0,0,0,0}, {192,64,182,41,41,41,41,0}},
  {91, {0,0,0,0,0,0,0,0}, {192,64,166,40,48,32,32,32}},
  {92, {0,0,0,0,0,0,0,0}, {192,64,158,32,30,1,62,0}},
  {93, {0,0,0,0,0,0,0,0}, {192,72,190,8,8,8,6,0}},
  {94, {0,0,0,0,0,0,0,0}, {192,64,162,34,34,20,8,0}},
  {98, {216,168,136,136,18,26,22,18}, {136,216,168,136,146,26,22,18}},
  {100, {0,0,0,0,0,0,0,0}, {0,24,24,0,24,115,231,126}},
  {101, {0,0,0,0,0,0,0,0}, {0,24,0,24,24,60,60,24}},
}
return function(ctx)
  local image=ctx.readImage('fonts/font.png')
  local w,h=image:getDimensions()
  assert(w==128 and h==64,'Spanish font requires the Gold base font')
  for _,change in ipairs(changes) do
    local tx=(change[1]%16)*8
    local ty=math.floor(change[1]/16)*8
    for y=0,7 do
      for x=0,7 do
        local divisor=2^(7-x)
        local before=math.floor(change[2][y+1]/divisor)%2
        local after=math.floor(change[3][y+1]/divisor)%2
        local _,_,_,alpha=image:getPixel(tx+x,ty+y)
        assert((alpha>0.5 and 1 or 0)==before,'Spanish font base glyph differs')
        image:setPixel(tx+x,ty+y,0,0,0,after)
      end
    end
  end
  ctx.writeImage(image,'fonts/font.png')
end
end)()
local battle=(function()
-- Original Spanish battle font differences; preserve unchanged tiles.
local changes = {
  {0,4,2,3,1},
  {0,7,4,1,3},
  {0,5,5,1,3},
  {1,2,3,1,3},
  {1,0,4,1,3},
  {1,1,5,3,1},
  {1,2,5,3,1},
  {14,4,2,3,0},
  {14,6,2,0,3},
  {14,6,3,0,3},
  {14,5,4,0,3},
  {14,6,4,0,3},
  {14,4,5,3,0},
  {14,5,5,0,3},
  {14,6,5,0,3},
  {14,4,6,3,0},
  {14,5,6,3,0},
  {16,2,0,3,0},
  {16,4,0,3,0},
  {16,6,0,3,0},
  {16,2,1,3,0},
  {16,4,1,3,0},
  {16,6,1,3,0},
  {16,2,2,3,0},
  {16,2,3,3,0},
  {16,3,3,3,0},
  {16,4,3,3,0},
  {16,5,3,3,0},
  {16,1,4,3,0},
  {16,1,5,3,0},
  {16,1,6,3,0},
  {16,2,7,3,0},
  {16,3,7,3,0},
  {16,4,7,3,0},
  {16,5,7,3,0},
  {16,6,7,3,0},
  {20,6,1,0,3},
  {20,5,2,0,3},
  {20,7,2,0,3},
  {20,5,3,3,0},
  {20,7,3,3,0},
  {20,5,4,3,0},
  {20,7,4,3,0},
  {20,5,5,3,0},
  {20,7,5,3,0},
  {20,5,6,3,0},
  {20,6,6,3,0},
  {20,7,6,3,0},
}
return function(ctx)
  for _,target in ipairs({{'fonts/font_battle_extra.png',128,16,true},
      {'battle/hud/hp_bar.png',96,8,false}}) do
    local image=ctx.readImage(target[1])
    local w,h=image:getDimensions()
    assert(w==target[2] and h==target[3],'Spanish battle font dimensions differ')
    for _,change in ipairs(changes) do
      local tile,x,y,before,after=unpack(change)
      if target[4] or tile<12 then
        x=(tile%(w/8))*8+x;y=math.floor(tile/(w/8))*8+y
        local r,g,b,a=image:getPixel(x,y)
        if target[4] then
          assert((a>0.5 and 1 or 0)==(before>=2 and 1 or 0),'Spanish battle font base ink differs')
          image:setPixel(x,y,0,0,0,after>=2 and 1 or 0)
        else
          local shade=1-before/3
          assert(math.abs(r-shade)<0.01 and math.abs(g-shade)<0.01 and math.abs(b-shade)<0.01 and a>0.99,'Spanish HP base shade differs')
          shade=1-after/3;image:setPixel(x,y,shade,shade,shade,1)
        end
      end
    end
    ctx.writeImage(image,target[1])
  end
end
end)()
return function(ctx) main(ctx);battle(ctx) end

end)()
local crystal=(function()
local main=(function()
-- Original Spanish Gold glyph differences; generated from verified ROMs.
local changes = {
  {58, {0,0,0,0,0,0,0,0}, {32,16,56,4,60,68,62,0}},
  {59, {0,0,0,0,0,0,0,0}, {16,8,60,66,126,64,62,0}},
  {60, {0,0,0,0,0,0,0,0}, {48,192,60,66,126,64,62,0}},
  {61, {0,0,0,0,0,0,0,0}, {32,16,68,68,68,68,60,0}},
  {62, {0,0,0,0,0,0,0,0}, {16,8,16,40,68,254,130,0}},
  {63, {0,0,0,0,0,0,0,0}, {16,32,16,40,68,254,130,0}},
  {70, {0,0,0,0,0,0,0,0}, {16,8,254,128,252,128,254,0}},
  {71, {0,0,0,0,0,0,0,0}, {16,32,254,128,252,128,254,0}},
  {72, {0,0,0,0,0,0,0,0}, {16,8,124,16,16,16,124,0}},
  {73, {0,0,0,0,0,0,0,0}, {16,32,124,16,16,16,124,0}},
  {74, {0,0,0,0,0,0,0,0}, {50,76,194,162,146,138,134,0}},
  {75, {0,0,0,0,0,0,0,0}, {16,8,124,130,130,130,124,0}},
  {76, {0,0,0,0,0,0,0,0}, {16,32,124,130,130,130,124,0}},
  {77, {0,0,0,0,0,0,0,0}, {16,8,130,130,130,66,62,0}},
  {78, {0,0,0,0,0,0,0,0}, {16,32,130,130,130,66,62,0}},
  {79, {0,0,0,0,0,0,0,0}, {8,16,56,4,60,68,62,0}},
  {80, {194,66,130,62,66,66,62,0}, {32,16,0,16,16,16,16,0}},
  {81, {200,72,136,8,8,8,8,0}, {8,16,0,16,16,16,16,0}},
  {82, {192,64,150,41,41,41,41,0}, {50,76,60,34,34,34,34,0}},
  {83, {192,64,147,20,24,16,16,0}, {32,16,60,66,66,66,60,0}},
  {84, {192,64,158,32,30,1,62,0}, {8,16,60,66,66,66,60,0}},
  {85, {192,72,190,8,8,8,6,0}, {8,16,68,68,68,68,60,0}},
  {86, {192,64,162,34,34,20,8,0}, {0,0,48,72,72,48,0,0}},
  {87, {0,0,0,0,0,0,0,0}, {48,104,104,50,90,204,122,0}},
  {88, {0,0,0,0,0,0,0,0}, {194,66,130,62,66,66,62,0}},
  {89, {0,0,0,0,0,0,0,0}, {200,72,136,8,8,8,8,0}},
  {90, {0,0,0,0,0,0,0,0}, {192,64,182,41,41,41,41,0}},
  {91, {0,0,0,0,0,0,0,0}, {192,64,166,40,48,32,32,32}},
  {92, {0,0,0,0,0,0,0,0}, {192,64,158,32,30,1,62,0}},
  {93, {0,0,0,0,0,0,0,0}, {192,72,190,8,8,8,6,0}},
  {94, {0,0,0,0,0,0,0,0}, {192,64,162,34,34,20,8,0}},
  {98, {216,168,136,136,18,26,22,18}, {136,216,168,136,146,26,22,18}},
  {100, {0,0,0,0,0,0,0,0}, {0,24,24,0,24,115,231,126}},
  {101, {0,0,0,0,0,0,0,0}, {0,24,0,24,24,60,60,24}},
}
return function(ctx)
  local image=ctx.readImage('fonts/font.png')
  local w,h=image:getDimensions()
  assert(w==128 and h==64,'Spanish font requires the Gold base font')
  for _,change in ipairs(changes) do
    local tx=(change[1]%16)*8
    local ty=math.floor(change[1]/16)*8
    for y=0,7 do
      for x=0,7 do
        local divisor=2^(7-x)
        local before=math.floor(change[2][y+1]/divisor)%2
        local after=math.floor(change[3][y+1]/divisor)%2
        local _,_,_,alpha=image:getPixel(tx+x,ty+y)
        assert((alpha>0.5 and 1 or 0)==before,'Spanish font base glyph differs')
        image:setPixel(tx+x,ty+y,0,0,0,after)
      end
    end
  end
  ctx.writeImage(image,'fonts/font.png')
end
end)()
local battle=(function()
-- Original Spanish battle font differences; preserve unchanged tiles.
local changes = {
  {0,4,2,3,1},
  {0,7,4,1,3},
  {0,5,5,1,3},
  {1,2,3,1,3},
  {1,0,4,1,3},
  {1,1,5,3,1},
  {1,2,5,3,1},
  {14,4,2,3,0},
  {14,6,2,0,3},
  {14,6,3,0,3},
  {14,5,4,0,3},
  {14,6,4,0,3},
  {14,4,5,3,0},
  {14,5,5,0,3},
  {14,6,5,0,3},
  {14,4,6,3,0},
  {14,5,6,3,0},
  {16,2,0,3,0},
  {16,4,0,3,0},
  {16,6,0,3,0},
  {16,2,1,3,0},
  {16,4,1,3,0},
  {16,6,1,3,0},
  {16,2,2,3,0},
  {16,2,3,3,0},
  {16,3,3,3,0},
  {16,4,3,3,0},
  {16,5,3,3,0},
  {16,1,4,3,0},
  {16,1,5,3,0},
  {16,1,6,3,0},
  {16,2,7,3,0},
  {16,3,7,3,0},
  {16,4,7,3,0},
  {16,5,7,3,0},
  {16,6,7,3,0},
  {20,6,1,0,3},
  {20,5,2,0,3},
  {20,7,2,0,3},
  {20,5,3,3,0},
  {20,7,3,3,0},
  {20,5,4,3,0},
  {20,7,4,3,0},
  {20,5,5,3,0},
  {20,7,5,3,0},
  {20,5,6,3,0},
  {20,6,6,3,0},
  {20,7,6,3,0},
}
return function(ctx)
  for _,target in ipairs({{'fonts/font_battle_extra.png',128,16,true},
      {'battle/hud/hp_bar.png',96,8,false}}) do
    local image=ctx.readImage(target[1])
    local w,h=image:getDimensions()
    assert(w==target[2] and h==target[3],'Spanish battle font dimensions differ')
    for _,change in ipairs(changes) do
      local tile,x,y,before,after=unpack(change)
      if target[4] or tile<12 then
        x=(tile%(w/8))*8+x;y=math.floor(tile/(w/8))*8+y
        local r,g,b,a=image:getPixel(x,y)
        if target[4] then
          assert((a>0.5 and 1 or 0)==(before>=2 and 1 or 0),'Spanish battle font base ink differs')
          image:setPixel(x,y,0,0,0,after>=2 and 1 or 0)
        else
          local shade=1-before/3
          assert(math.abs(r-shade)<0.01 and math.abs(g-shade)<0.01 and math.abs(b-shade)<0.01 and a>0.99,'Spanish HP base shade differs')
          shade=1-after/3;image:setPixel(x,y,shade,shade,shade,1)
        end
      end
    end
    ctx.writeImage(image,target[1])
  end
end
end)()
return function(ctx) main(ctx);battle(ctx) end

end)()
return function(ctx)
 if ctx.exists("title/crystal_screen.png") then crystal(ctx) else gold(ctx) end
end
