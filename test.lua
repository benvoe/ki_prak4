require('Praktikum_4/pp')

--[[
local tab = { 1, 2, "3", { "5", "6" }, "4", 7 }

printT( tab )

local table2 = copy( tab )

for i, v in ipairs( tab ) do
  if v == table2[i] then
    print( "true: " .. v )
  else
    for j,k in ipairs( v ) do
      if k == table2[i][j] then
        print( "true: " .. k )
      else
        print( "false: " .. k )
      end
    end
  end
end
--]]
local pp = progression_planning:new()

local list = { { { { "on-table", { "a" } }, { "clear", { "c" } }, { "on-table", { "c" } }, { "clear", { "a" } }, { "clear", { "b" } }, { "arm-empty", { } }, { "on-table", { "b" } } } }, { { { "on-table", { "a" } }, { "clear", { "b" } }, { "on-table", { "c" } }, { "clear", { "a" } }, { "clear", { "b" } }, { "arm-empty", { } }, { "on-table", { "b" } } } }, { { { "on-table", { "a" } }, { "clear", { "c" } }, { "on-table", { "c" } }, { "on-table", { "a" } }, { "clear", { "b" } }, { "arm-empty", { } }, { "on-table", { "b" } } } } }

local state = { { { "on-table", { "a" } }, { "arm-empty", { } }, { "clear", { "c" } }, { "on-table", { "c" } }, { "clear", { "a" } }, { "clear", { "b" } }, { "on-table", { "b" } } } }

local state2 = { { { "on-table", { "a" } }, { "on-table", { "c" } }, { "clear", { "a" } }, { "clear", { "b" } }, { "arm-empty", { } }, { "clear", { "c" } }, { "on-table", { "b" } } } }

print( state_in( list, state2 ) )

--local go = { { { "on", { "b", "c" } }, { "on", { "a", "b" } }, { "clear", {"a"} } } }
local done = { "or", unpack(list)}
printT(done)

print( pp:Validate( state, state ) )

-- Eliminate permuttation for equal state
-- Validate Goal reached 


--[[
local para = { "a" }
local para2 = { "a", "b" }

local ac = 1
local ac2 = 3

printT( pp.acts[ac].params )
printT( pp.acts[ac].preconds )
printT( pp.acts[ac].effects )
printT( pp.init[1] )
print()

pp:set_params( pp.acts[ac] , para )

printT( pp.acts[ac].params )
printT( pp.acts[ac].preconds )
printT( pp.acts[ac].effects )
printT( pp.init[1] )
print()

print( pp:init_validate( pp.acts[ac] ) )

if pp:init_validate( pp.acts[ac] ) then
  pp:apply( pp.init, pp.acts[ac] )
end

printT( pp.acts[ac].params )
printT( pp.acts[ac].preconds )
printT( pp.acts[ac].effects )
printT( pp.init[1] )
print()

pp:set_params( pp.acts[ac2] , para2 )

printT( pp.acts[ac2].params )
printT( pp.acts[ac2].preconds )
printT( pp.acts[ac2].effects )
print()

print( pp:init_validate( pp.acts[ac2] ) )

if pp:init_validate( pp.acts[ac2] ) then
  pp:apply( pp.init, pp.acts[ac2] )
end

printT( pp.acts[ac2].params )
printT( pp.acts[ac2].preconds )
printT( pp.acts[ac2].effects )
printT( pp.init[1] )
print()

local res = pp:Apply( pp.init, pp.acts[1] )

for _,v in ipairs( res ) do
  printT( v )
end
print()
res2 = pp:Apply( res[1], pp.acts[3] )

for _,v in ipairs( res2 ) do
  printT( v )
end
--]]


