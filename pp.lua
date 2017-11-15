require('Class')
require('Praktikum_4/pddl')
require('Praktikum_1/queue/fifo')

progression_planning = {}

function progression_planning:init_contains( pred )
  return self:contains( self.init, pred )
end

function progression_planning:preds_contains( pred )
  return self:contains( self.preds, pred, true )
end

function progression_planning:contains( init, pred, skip_args )
  skip_args = skip_args or false
  local init_list = init[1]
  
  for i, inits in ipairs( init_list ) do
    if pred[1] == inits[1] and #pred[2] == #inits[2] then
      local equal = true
      if not skip_args then
        for j,args in ipairs( inits[2] ) do
          if #pred[2] < j or pred[2][j] ~= args then
            equal = false
          end
        end
      end
      if equal then return true end
    end
  end
  return false
end

function progression_planning:delete( init, pred )
  local init_list = init[1]
  
  for i, inits in ipairs( init_list ) do
    if pred[1] == inits[1] and #pred[2] == #inits[2] then
      local equal = true
      for j,args in ipairs( inits[2] ) do
        if #pred[2] < j or pred[2][j] ~= args then
          equal = false
        end
      end
      if equal then 
        table.remove( init[1], i ) 
      end
    end
  end
end

function progression_planning:init_validate( act )
  return self:Validate( self.init, act )
end

function progression_planning:Validate( state, precon )
  local result = false
  local op = 0 -- Operand
  
  for i,v in ipairs( precon ) do
    
    if  v == "and" then 
      op = 1
      result = true
    elseif v == "or" then 
      op = 2 
      result = false
    elseif v == "not" then
      op = 3
    elseif v == "=" then
      op = 4
    end
      
    if type( v ) == "table" and self:preds_contains( v ) then
      if op == 1 then 
        result = result and self:contains( state, v )
      elseif op == 2 then
        reslut = result or self:contains( state, v )
      elseif op == 2 then 
        result = not self:contains( state, v )
      end
    elseif type( v ) == "table" then 
      if op == 1 then 
        result = result and self:Validate( state, v )
      elseif op == 2 then
        reslut = result or self:Validate( state, v )
      elseif op == 3 then 
        result = not self:Validate( state, v )
      elseif op == 4 then
        reslut = v[1] == v[2]
      else
        result = self:Validate( state, v )
      end
    end
  end
  return result
end

function progression_planning:set_params( action, params ) 
  local param_set = {}
  
  if #action.params ~= #params then 
    print("Parameterzahl stimmt nicht mit action überein - set_Params")
    return false
  end
  
  for i,v in ipairs( action.params ) do
    param_set[ v ] = params[ i ]
  end
  
  self:write_params( action.params, param_set )
  self:write_params( action.preconds, param_set )
  self:write_params( action.effects, param_set )
  
  return action
end

function progression_planning:write_params( action, params )
  for i,v in ipairs( action ) do
    if type( v ) == "table" then
      self:write_params( v, params )
    elseif params[ v ] ~= nil then
      action[ i ] = params[ v ]
    end
  end
end

function progression_planning:apply( init, act )
  local op = 0 -- Operand
  local effect = act.effects
  
  for i,v in ipairs( effect ) do
    if type( v ) == "table" and #v == 2 and v[1] == "not" and self:contains( init, v[2] ) then
      self:delete( init, v[2] )
    elseif type( v ) == "table" and not self:contains( init, v ) then
      table.insert( init[1], v )
    end
  end
end

function progression_planning:Apply( state, act )
  local p = self.objs[1]
  local anz_p = #act.params
  local param_select = {}
  local param_list = {}
  
  local result_states = {}
  
  for i=1,anz_p do
    table.insert( param_select, 1 )
    table.insert( param_list, p[1] )
  end
  
  while not ( param_select[ #param_select ] > #p ) do
    if equal_params( param_select ) then
    else
      local p_act = self:set_params( copy_act( act ), param_list )
      if self:Validate( state, p_act.preconds ) then
        local new_state = copy( state )
        self:apply( new_state, p_act )
        table.insert( result_states, { new_state, { unpack(param_list) } } )
      end
    end
    
    param_select[1] = param_select[1] + 1
    param_list[1] = p[ param_select[1] ]
    
    for i,v in ipairs( param_select ) do
      if v > #p and i ~= #param_select then
        param_select[i] = 1
        param_list[i] = p[1]
        if param_select[i+1] then
          param_select[i+1] = param_select[i+1] + 1
          param_list[i+1] = p[ param_select[i+1] ]
        end
      end
    end
  end
  
  return result_states
end

function progression_planning:find()
  local tree = FIFO:new()
  local done = { self.init }
  tree:push( { self.init, {} } )
  
  while #tree.elements > 0 do
    local state = tree:pop()
    for _,act in ipairs( self.acts ) do
      local history = copy( state[2] )
      for _,new_state_info in ipairs( self:Apply( state[1], act ) ) do
        
        local new_state = new_state_info[1]
        local new_state_params = new_state_info[2]
        local new_state_history = copy( history )
        table.insert( new_state_history, { act.name, new_state_params } )
        
        if self:Validate( new_state, self.goal ) then 
          return { new_state, new_state_history }
        elseif not state_in( done, new_state ) then
          tree:push( { new_state, new_state_history } )
          table.insert( done, new_state )
          --printT( new_state )
        end
      end
    end
  end
  return { {}, {"Ziel konnte nicht erfüllt werden."} }
end

function progression_planning:FIND()
  local res = self:find()
  print("\n\n====== Pfad zum Ziel ======")
  local path = "init"
  local arrow = "\n -> "
  for i,step in ipairs( res[2] ) do
    path = path .. arrow .. printt( step )
  end
  print( path )
  
  print( "\nGoal:" )
  printT( res[1] )
end

local progression_planning_mt = Class( progression_planning )

function progression_planning:new( domain, problem )
  
  local d
  local p
  
  d,p = readspecs( domain, problem )
  
  pretty_print_domain(d)
  pretty_print_problem(p)
  
  return setmetatable( { d = d, p = p, reqs = d.reqs, preds = d.preds, acts = d.acts, objs = p.objs, init = p.init, goal = p.goal }, progression_planning_mt )
end


function copy( tabelle )
  local table_copy = {}
  for i, v in ipairs( tabelle ) do
    if type( v ) == "table" then
      table.insert( table_copy, copy( v ) )
    else
      table.insert( table_copy, v )
    end
  end
  return table_copy
end

function copy_act( act )
  local _copy = {}
  
  _copy.name = act.name
  _copy.params = copy( act.params )
  _copy.preconds = copy( act.preconds )
  _copy.effects = copy( act.effects )
  
  return _copy
end

function printT( tab )
  print( printt( tab ) )
end

function printt( tab )
  local begin = "{"
  local ende = " }"
  
  for i,v in ipairs( tab ) do
    if i > 1 then begin = begin .. "," end
    if type( v ) == "table" then
      begin = begin .. " " .. printt( v )
    else
      begin = begin .. " " .. v
    end
  end
  
  return begin .. ende
end

function equal_params( list )
  for i,v in ipairs( list ) do
    for j,k in ipairs( list ) do
      if i ~= j and v == k then
        return true
      end
    end
  end
  return false
end

function state_in( done, state )
  for _,s in ipairs( done ) do
    if equal_states( s, state ) then
      return true
    end
  end
  return false
end

function equal_states( state1, state2 )
  local equals = true
  if #state1[1] ~= #state2[1] then
    return false
  end
  
  for _,v in ipairs( state2[1] ) do
    if not progression_planning:contains( state1, v ) then
      return false
    end
  end
  return true
end

  

