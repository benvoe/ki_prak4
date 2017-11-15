require('Praktikum_4/pp')


---[[
local domain = "Praktikum_4/blocksworld.pddl"
local problem = "Praktikum_4/pb3.pddl"
local pp = progression_planning:new( domain, problem )
pp:FIND()
--]]

--[[
local domain2 = "Praktikum_4/apeworld.pddl"
local problem2 = "Praktikum_4/apeproblem.pddl"
local pp2 = progression_planning:new( domain2, problem2 )
pp2:FIND()
--]]