

function build(X, s)
  if type(X) ~= 'table' then
    return tostring(X)
  else
    t = '['
    for i,x in pairs(X) do
      t = t .. build(x, t)
      if i < #X then
        t = t .. ', '
      end
    end
    return t .. ']'
  end  
end
function aprint(X) -- for printing arrays, or arrays of arrays, as long as all contents have a tostring method or contain only such items
  print(build(X, ''))
end


function hprint(hand)
  local s = '['
  for i,c in pairs(hand) do
    s = s .. c.name
    if i < #hand then
      s = s .. ', '
    end
  end
  print(s .. ']')
end
--


function lexcomp(T1, T2)
  -- Assume T1 and T2 are arrays of values that compare with <
  if #T1 > 0 and #T2 > 0 then
    if T1[1] == T2[1] then
      return lexcomp({table.unpack(T1, 2)}, {table.unpack(T2, 2)})
    elseif T1[1] < T2[1] then
      return true
    else
      return false
    end
  elseif #T1 == 0 and #T2 == 0 then
    return false
  else
    return #T1 < #T2      
  end
end


function lexfirst(a,b)
  return lexcomp(a[1], b[1])
end

function reverse(T)
  local R = {}
  for i = #T, 1, -1 do
    R[#T - i + 1] = T[i]
  end
  return R
end


function sortperm_len(T)
  n = #T
  local X = {}
  for i,t in pairs(T) do
    table.insert(X, {t, i})
  end
  local S = {X[1]}
  for ix = 2,n do
    local L = #T[ix]
    if L > #S[1][1] then
      table.insert(S, 1, X[ix])
    elseif L <= #S[#S][1] then
      table.insert(S, #S+1, X[ix])
    else
      for jx = 1, #X-1 do
        if L > #S[jx+1][1] then
          table.insert(S, jx+1, X[ix])
          goto placed
        end
      end  
      ::placed::
    end 
  end
  
  X = {}
  local P = {}
  for i,x in pairs(S) do
    table.insert(X, x[1])
    table.insert(P, x[2])
  end
  return X, P
  --return reverse(X), reverse(P)
end



function sortperm(T, f)
  local X = {}
  for i,t in pairs(T) do
    table.insert(X, {t,i})
  end
  table.sort(X, f)
  ---[[
  local P = {}
  local Y = {}
  for i,p in pairs(X) do
    Y[i] = p[1]
    P[i] = p[2]
  end  
  return Y, P
  --]]
end



function canonicalize(hand)
  local H = {{}, {}, {}, {}}
  local sp1 = {}
  local sp2 = {}
  local sp = {}
  for i,c in pairs(hand) do
    table.insert(H[c.suit], c.rank)
  end
    
  for i = 1,4 do
    table.sort(H[i])
  end    
  H, sp1 = sortperm(H, lexfirst)  
  H, sp2 = sortperm_len(H)
  
  sp = {}
  for i = 1,4 do
    sp[i] = sp1[sp2[i]]
  end  
  
  return H, sp  
end
--


function makediscard(canonicalhand, canonicaldiscard, sp)
  local newcanon = {{}, {}, {}, {}}
  for i = 1,4 do
    for j,x in pairs(canonicalhand[i]) do
      for k,y in pairs(canonicaldiscard[i]) do
        if x == y then
          goto indiscard
        end
      end
      table.insert(newcanon[i], x)
      ::indiscard:: 
    end   
  end
  local playhand = {}
  local discard = {}
  for i = 1,4 do
    for j,x in pairs(newcanon[i]) do
      table.insert(playhand, deckindex[ranks[x] .. suits[sp[i]]])
    end
    for j,x in pairs(canonicaldiscard[i]) do
      table.insert(discard, deckindex[ranks[x] .. suits[sp[i]]])
    end
  end
  return playhand, discard
end
--


-- p_deal;discard;profile_dealer;profile_pone;p_play_dealer;p_play_pone

function parse_df_item(x, n)
  if n == 1 then
    k = 'p_deal'
    v = tonumber(x)
  elseif n == 2 then
    k = 'nothing here'
    v = 'seriously'
  elseif n == 3 then
    k = 'profile_dealer'
    v = tonumber(x)
  elseif n == 4 then
    k = 'profile_pone'
    v = tonumber(x)
  elseif n == 5 then
    k = 'p_play_dealer'
    v = tonumber(x)
  elseif n == 6 then
    k = 'p_play_pone'
    v = tonumber(x)
  end
  return k,v
end





json = require("json")
http = require("socket.http")
ltn12 = require("ltn12")




InformationState = {
  knowncards = {},
  }


Model = {
    IS = {},
    display = 'Model info'
  }
function Model:getDiscard()
  cardnames = {}
  for i,c in pairs(UI.handcards) do
    table.insert(cardnames, c.name)
  end
  payload = json.encode({hand=cardnames, isdealer=UI.isdealer})
  
  local response = {}
  r,c,h = http.request {
    method = "POST",
    url = 'http://localhost:8000/discard',
    headers = {["Content-Type"] = "application/json", ["Content-Length"] = string.len(payload)},
    source = ltn12.source.string(payload),
    sink = ltn12.sink.table(response)    
  }
  discard = json.decode(response[1]).discard
  s = ''
  for k,v in pairs(discard) do
    s = s .. v .. ' '
  end
  self:set_display(s)
end


function Model:getPlay()
  self:set_display('Once I am connected to the database, I will be able to do this')  
end


function Model:getInfo()
  self:set_display('Once I am connected to the database, I will be able to do this')  
end


function Model:set_display(s)
  line_width = 28
  local t = ''
  for i=1,string.len(s) do
    t = t .. string.sub(s, i,i)
    if (i % line_width == 0) then
      t = t .. '\n'
    end
  end
  self.display = t
end


--[[
require('core')

deck, deckindex = buildDeck()

hand = {}
IX = {49, 50, 14, 45, 28, 5}
for i,ix in pairs(IX) do
  table.insert(hand, deck[ix])
end
hprint(hand)


H, sp = canonicalize(hand)
D = {{6}, {1}, {}, {}}

aprint(H)
aprint(sp)

hand, discard = makediscard(H, D, sp)

hprint(hand)
hprint(discard)



--]]









