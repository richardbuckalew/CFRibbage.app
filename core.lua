function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))      
    elseif type(v) == 'string' then
      print(formatting .. v)
    else
      print(formatting .. tostring(v))
    end
  end
end

function trues(n)
  local B = {}
  for i = 1,n do
    B[i] = true
  end
  return B
end
function falses(n)
  local B = {}
  for i = 1,n do
    B[i] = false
  end
  return B
end

function length(T)
  if (not T) or (#T == 0) then
    return 0
  end
  i = 0
  for k,v in pairs(T) do
    i = i + 1
  end
  return i
end

function contains(T, x)
  for k,v in pairs(T) do
    if v == x then
      return true
    end
  end
  return false
end

function without(T, x)
  local S = {}
  for k,v in pairs(T) do
    if v ~= x then
      table.insert(S, v)
    end
  end
  return S
end



function allcombs()
  
  local C = {}
  
  -- only one combination with all 5 cards
  C[5] = {{1, 2, 3, 4, 5}}
  
  -- five combinations with 4 cards, also with one card
  C[1] = {}
  C[4] = {}
  for i = 1,5 do
    table.insert(C[1], {i})
    table.insert(C[4], {})
    for j = 1,5 do
      if j ~= i then
        table.insert(C[4][i], j)
      end
    end
  end
  
  -- 2s and 3s
  C[2] = {}
  C[3] = {}
  local ci = 1
  for i = 1,5 do
    for j = i+1,5 do
      C[2][ci] = {}
      C[3][ci] = {}
      
      for k = 1,5 do
        if k==i or k==j then
          table.insert(C[2][ci], k)
        else
          table.insert(C[3][ci], k)
        end
      end      
      
      ci = ci + 1
    end
  end
  
  return C
end
--


-- CARD
Card = {rank = 1, suit = 1, value = 1, name = 'AC', 
  x = 0, y = 0, vx = 0, vy = 0, tx = 0, ty = 0, sx = sx, sy = sy, w = 70, h = 95,
  faceup = true, hover = false, selected = false}
function Card:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end
function newgo()
  return Card:new{rank = -1, suit = -1, value = 0, name = 'GO', 
  x = 0, y = 0, tx = 0, ty = 0, sx = sx, sy = sy, w = 70, h = 95,
  faceup = true, hover = false, selected = false}
end
function Card:collide(x,y)
  return (self.x <= x and self.x + self.w >= x) and (self.y <= y and self.y + self.h >= y)
end
function Card:enlarge()
  self.x = self.x - (select_width - card_width)/2
  self.y = self.y - (select_height - card_height)/2
  self.sx = self.sx + select_sx
  self.sy = self.sy + select_sy 
end
function Card:reduce()
  self.x = self.x + (select_width - card_width)/2
  self.y = self.y + (select_height - card_height)/2
  self.sx = self.sx - select_sx
  self.sy = self.sy - select_sy
end
function Card:flip()
  self.is_faceup = not self.is_faceup
end
function Card:togglehover()
  if self.hover == true then
    self.hover = false
  else
    self.hover = true
  end
end
function Card:toggleselect()
  if self.selected == true then
    self.selected = false
    self:reduce()
  else
    self.selected = true
    self:enlarge()
  end
end
function Card:show()
  print(self.name, '(', self.rank, ',', self.suit, ') : faceup =', self.is_faceup, ', hover =', self.hover, ', selected =', self.selected)
end
function Card:draw()
  if self.hover or self.selected then
    love.graphics.setColor(1, 1, 1)
  else
    love.graphics.setColor(0.9, 0.9, 0.9)
  end
  if self.faceup then 
    love.graphics.draw(faces[self.name], self.x, self.y, 0, self.sx, self.sy) 
  else
    love.graphics.draw(card_back, self.x, self.y, 0, self.sx, self.sy)
  end
  --[[
  love.graphics.setColor(0.5, 0.5, 0.8)
  love.graphics.print('(' .. tostring(math.floor(self.x + 0.5)) .. ', ' .. tostring(math.floor(self.y + 0.5)) .. ')', self.x+5, self.y+20)  
  love.graphics.print('(' .. tostring(math.floor(self.tx - self.x + 0.5)) .. ', ' .. tostring(math.floor(self.ty - self.y + 0.5)) .. ')', self.x+5, self.y+35)
  love.graphics.print('(' .. tostring(math.floor(self.vx + 0.5)) .. ', ' .. tostring(math.floor(self.vy + 0.5)) .. ')', self.x+5, self.y+50)
  --]]
end
function Card:set_target(x,y)
    self.tx = x
    self.vx = (self.tx - self.x) / _FLYTIME
    self.ty = y
    self.vy = (self.ty - self.y) / _FLYTIME
end
-- CARD




-- DECK
ranks = {'A', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K'}
suits = {'C', 'D', 'H', 'S'}
function buildDeck()
  local deck = {}
  local deckindex = {}
  for j, suit in pairs({'C', 'D', 'H', 'S'}) do
    for i, rank in pairs(ranks) do
      if rank == 'T' then rank_string = '10' else rank_string = rank end
      name = rank..suit
      table.insert(deck, Card:new{rank = i, suit = j, value = ((i <= 10) and i) or 10, name = name, 
          x = 0, y = 0, vx = 0, vy = 0, tx = 0, ty = 0, w = card_width, h = card_height, faceup = false})
      deckindex[name] = deck[#deck]
    end
  end
  return deck, deckindex
end
-- DECK






-- Game State (GS)
GS = {
  phase = 'init',
  dealer = 1,
  whoseturn = 2,
  hands = {{}, {}},
  discards = {{}, {}},
  showhands = {{}, {}},
  pplay = {},
  crib = {},
  turncard = {},
  history = {},
  pairlength = 0,
  runlength = 0, 
  total = 0,
  scores = {0, 0},
  shows = {{}, {}, {}}
}

function GS:statestring()
  local s = 'phase: ' .. self.phase
  if self.phase == 'show' then s = s .. '  (' .. UI.showphase .. ')' end
  s = s .. '\n' .. 'whoseturn: ' .. tostring(self.whoseturn) .. '\n'
  local hs = 'hands: '
  for i,h in pairs(self.hands) do
    for j,c in pairs(h) do
      hs = hs .. c.name .. ' '
    end
    hs = hs .. '\n       '
  end
  s = s .. hs .. '\n'
  local ds = 'discards: '
  for i,d in pairs(self.discards) do
    for j,c in pairs(d) do
      ds = ds .. c.name .. ' '
    end
    ds = ds .. '\n          '
  end
  s = s .. ds .. '\n'
  local shs = 'show hands: '
  for i,sh in pairs(self.showhands) do
    for j,c in pairs(sh) do
      shs = shs .. c.name .. ' '
    end
    shs = shs .. '\n           '
  end
  s = s .. shs .. '\n'
  if self.pplay then
    if self.pplay.name then
      s = s .. 'play: ' .. self.pplay.name
    else
      s = s .. 'play: none\n'
    end
  else
    s = s .. 'play: none\n'
  end
  local cs = 'crib: '
  if self.crib == {} then
    cs = cs .. 'none\n'
  elseif self.crib == nil then
    cs = cs .. 'none\n'     
  else
    if length(self.crib) > 0 then
      for i,c in pairs(self.crib) do
        cs = cs .. c.name .. ' '
      end
    else
      cs = cs .. 'none'
    end
  end
  s = s .. cs .. '\n'
  local ts = 'turn: '
  if self.turncard then
    if length(self.turncard) > 0 then
      ts = ts .. self.turncard.name .. '\n'
    else
      ts = ts .. 'none\n'
    end
  else
    ts = ts .. 'none\n'
  end
  s = s .. ts
  hs = 'history: '
  if length(self.history) > 0 then
    for i,c in pairs(self.history) do
      hs = hs .. c.name .. ' '
    end
  else
    hs = hs .. 'none'
  end
  hs = hs .. '\n'
  s = s .. hs
  s = s .. 'total: ' .. tostring(self.total) .. '\n'
  s = s .. 'pairlength: ' .. tostring(self.pairlength) .. '\nrunlength:  ' .. tostring(self.runlength) .. '\n'
  s = s .. 'scores:  ' .. tostring(self.scores[1]) .. '  ' .. tostring(self.scores[2])
  return s
end
function GS:reset(dealer)
  self.phase = 'deal'
  self.dealer = dealer
  self.whoseturn = 3-dealer
  self.hands = {{}, {}}
  self.discards = {{}, {}}
  self.showhands = {{}, {}}
  self.pplay = {}
  self.crib = {}
  self.turncard = {}
  self.history = {}
  self.pairlength = 0
  self.runlength = 0
  self.total = 0
  self.shows = {{}, {}, {}}
end

function GS:startphase(phase)
  if phase == 'play' then
    self.whoseturn = 3 - self.dealer
        
  elseif phase == 'show' then
    self.whoseturn = 3 - self.dealer
  end
  self.phase = phase
end

function GS:deal()
  self.hands = {{}, {}}
  local dealt = falses(52)
  local cards = {}
  local n_dealt = 0
  while n_dealt < 13 do
    i = math.random(1,52)
    if not dealt[i] then
      table.insert(cards, deck[i])
      dealt[i] = true
      n_dealt = n_dealt + 1
    end
  end
  for i,c in pairs(cards) do
    if i < 7 then
      table.insert(self.hands[1], c)
    elseif i < 13 then
      table.insert(self.hands[2], c)
    else
      self.turncard = c
    end
  end
end

function GS:process_discards()
  for i,d in pairs(self.discards[1]) do    
    for k,c in pairs(self.hands[1]) do
      if d.name == c.name then
        table.remove(self.hands[1], k)
        table.insert(self.crib, c)
      end
    end        
  end
  for i,d in pairs(self.discards[2]) do    
    for k,c in pairs(self.hands[2]) do
      if d.name == c.name then
        table.remove(self.hands[2], k)
        table.insert(self.crib, c)
      end
    end        
  end
  for i,h in pairs(self.hands) do
    for j,c in pairs(h) do
      table.insert(self.showhands[i], c)
    end
  end
end

function GS:scoreplay(card)
  local s = 0
  local L = length(self.history)
  
  if L > 0 then
    if card.rank == self.history[L].rank then
      self.pairlength = self.pairlength + 1
      s = s + ({2, 6, 12})[self.pairlength]
      table.insert(UI.scorenotes, {ix = L+1, s = 'pair (' .. tostring(({2, 6, 12})[self.pairlength]) ..')', age = 0, owner = self.whoseturn})
    else
      self.pairlength = 0
    end
  else
    self.pairlength = 0    
  end
  
  if L > 1 then
    local diffs = {}
    for i = 1, L-1 do
      table.insert(diffs, self.history[i+1].rank - self.history[i].rank)
    end
    
    if self.runlength == 0 then  -- this would be the first card making a run
      -- but it might be a four-or-five card run, still! BIG OOPS
      for run_length_cand = L+1, 3, -1 do
        local ranks = {}
        for i = 1, run_length_cand-1 do
          table.insert(ranks, self.history[i + (L - run_length_cand+1)].rank)
        end
        table.insert(ranks, card.rank)
        table.sort(ranks)
        
        runfound = true
        for i=1,run_length_cand-1 do
          if ranks[i+1] - ranks[i] ~= 1 then
            runfound = false
          end
        end
        if runfound then
          self.runlength = run_length_cand-2
          s = s + self.runlength + 2
          table.insert(UI.scorenotes, {ix = L+1, s = 'run (' .. tostring(self.runlength+2) ..')', age = 0, owner = self.whoseturn})
          goto endrun
        end    
      end
      
    else
      --local currentrun = {table.unpack(self.history, L-self.runlength+1, L)}
      local currentrun = {}
      for i=1,self.runlength+2 do
        table.insert(currentrun, self.history[L-i+1])
      end
      local runranks = {}
      local m = 14
      local M = 0
      for i,c in pairs(currentrun) do
        M = math.max(M, c.rank)
        m = math.min(m, c.rank)
      end
      if (card.rank == M+1) or (card.rank == m-1) then
        self.runlength = self.runlength + 1
        s = s + self.runlength + 2
      table.insert(UI.scorenotes, {ix = L+1, s = 'run (' .. tostring(self.runlength+2) ..')', age = 0, owner = self.whoseturn})
      else
        self.runlength = 0
      end
    end
    
  else
    self.runlength = 0
  end
  ::endrun::
  
  if self.total == 15 then
    s = s + 2
      table.insert(UI.scorenotes, {ix = L+1, s = '15 (2)', age = 0, owner = self.whoseturn})
  elseif self.total == 31 then
    s = s + 1
      table.insert(UI.scorenotes, {ix = L+1, s = '31 (2)', age = 0, owner = self.whoseturn})
  end
  
  return s
  
end

function GS:process_play(card)
  
  if card.name == 'GO' then
    
    if self.history[length(self.history)].name == 'GO' then  -- second GO
      self.total = 0
    else                                                     -- first GO; score current player
      UI:pegscore(3-self.whoseturn, 1)
      if GS.total < 31 then
        table.insert(UI.scorenotes, {ix = length(self.history), s = 'GO (1)', age = 0, owner = 3-self.whoseturn})
      end
    end
    table.insert(self.history, card)    
    self.runlength = 0
    self.pairlength = 0
    
  else
  
    for i,c in pairs(GS.hands[self.whoseturn]) do    -- remove from player's hand
      if c.name == card.name then
        table.remove(GS.hands[self.whoseturn], i)
      end
    end
    
    self.total = self.total + card.value        -- update total
    local s = self:scoreplay(card)              -- score the play
    if card.suit == GS.turncard.suit and card.rank == 11 then       --nibs!
      s = s + 1
      table.insert(UI.scorenotes, {ix = -2, s = 'Nibs (1)', age = 0, owner = self.whoseturn})
    end
    if s > 0 then
      UI:pegscore(self.whoseturn, s)
    end
    table.insert(self.history, card)            -- add to history (IMPORTANT: AFTER SCORING)
    
  end
  
end

function GS:scoreshow()
  -- idea: find all scoring combos, then yield them one by one (or category by category) as a coroutine
  
  local AC = allcombs()
  
  UI.showitems = {}
  
  
  self.shows = {{GS.turncard}, {GS.turncard}, {GS.turncard}}
  for i,c in pairs(GS.showhands[1]) do
    table.insert(self.shows[1], c)
  end
  for i,c in pairs(GS.showhands[2]) do
    table.insert(self.shows[2], c)
  end
  for i,c in pairs(GS.crib) do
    table.insert(self.shows[3], c)
  end
  --
  
    
  for xxx,nshow in pairs({3, GS.dealer, 3-GS.dealer}) do  
    
  
    flushfound = false
    runlen = 0
    flushlen = 0
    nruns = 0
    nfifteens = 0
    npairs = 0
    
    for n = 5, 2, -1 do
      
      for ci,comb in pairs(AC[n]) do        
        
        if (n >= 4) and (not flushfound) then
          if (nshow < 3) or (not contains(comb, 1)) then  -- crib can't flush on the turn
            local suit_counts = {0, 0, 0, 0}
            for j,c in pairs(self.shows[nshow]) do
              suit_counts[c.suit] = suit_counts[c.suit] + 1
            end
            for j,s in pairs(suit_counts) do
              if s >= 4 then
                flushfound = true
                flushlen = s
              end
            end
            if flushfound then
              
              table.insert(UI.showitems, {whichhand = nshow, value = n, message = 'a flush for ' .. tostring(flushlen)})
              
            end   
          end
        end
        --
        
        if (n >= 3) and (runlen <= n) then
          local ranks = {}
          for i,c in pairs(self.shows[nshow]) do
            if contains(comb, i) then
              table.insert(ranks, c.rank)
            end
          end
          table.sort(ranks)
          local runfound = true
          for ix = 2,n do
            if ranks[ix] ~= ranks[ix-1] + 1 then
              runfound = false
            end
          end
          if runfound then
            runlen = n
            nruns = nruns + runlen             
          end        
        end
        --
        
        local vsum = 0
        for _,i in pairs(comb) do
          vsum = vsum + self.shows[nshow][i].value
        end
        if vsum == 15 then
          nfifteens = nfifteens + 2
        end
        --
        
        if n == 2 then
          if self.shows[nshow][comb[1]].rank == self.shows[nshow][comb[2]].rank then
            npairs = npairs + 2
          end
        end
        --
                
      end -- combinations
      
    end
    
    if nruns > 0 then   
            
      table.insert(UI.showitems, {whichhand = nshow, value = nruns, message = 'runs for ' .. tostring(nruns)})
      
    end
      
    if nfifteens > 0 then            
          
      table.insert(UI.showitems, {whichhand = nshow, value = nfifteens, message = 'fifteen for ' .. tostring(nfifteens)})
        
    end
    
    if npairs > 0 then                  
          
      table.insert(UI.showitems, {whichhand = nshow, value = npairs, message = 'pairs for ' .. tostring(npairs)})
        
    end
    
    
  end
  --
  
  return 
  
end

--


--[[
deck = buildDeck()
GS:reset(1)
for i=1,4 do
  table.insert(GS.showhands[1], deck[i])
  table.insert(GS.showhands[2], deck[i+4])
  table.insert(GS.crib, deck[i+8])
end
GS.turncard = deck[13]

print(GS:statestring())

tprint(GS:scoreshow())
--]]




