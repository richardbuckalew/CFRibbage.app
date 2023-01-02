



--GLOBAL CONFIG
_W = 1000
_H = 600

--CARD CONFIG
png_size = {140, 190}
sx = 0.25; sy = 0.25
card_height = _H / 5.5
sy = card_height / png_size[2]
sx = sy
card_width = sx * png_size[1]
select_sx = 0.1
select_sy = 0.1
select_width = (sx + select_sx) * png_size[1]
select_height = (sy + select_sy) * png_size[2]


--DISPLAY CONFIG
_PAD = _H / 96
_HANDW = 6*card_width + 7*_PAD
_HANDH = card_height + 2*_PAD
_PHANDX = _W/2 - _HANDW/2 - _PAD
_PHANDY = _H - _HANDH - 2*_PAD
_CHANDX = _W/2 - _HANDW/2 - _PAD
_CHANDY = 2*_PAD
_TURNX = _W/2 - 5.5*card_width - 2*_PAD
_TURNX = card_width
_TURNY = _H/2 - card_height/2 - _PAD

_PLAYX = _TURNX + card_width + 4*_PAD
_PLAYW = 7*card_width + 2*_PAD

_MESSAGEX = _PHANDX + _PAD
_MESSAGEY = _PHANDY - 2*_PAD - 2*card_height/3

_PCRIBX = 0
_PCRIBY = 0
_CCRIBX = 0
_CCRIBY = 0
_CRIBW = 0
_CRIBH = 0

_FLYTIME = 0.2
_CPAUSE = 0.2       -- delay before opponent plays their card
_SHOWPAUSE = 0.2      -- how long to show each scoring combo
_PEGDURATION = 1
_SCORENOTEDURATION = 2


_ATHRES = card_height

_MCOLOR = {0.9, 0.95, 0.85}


_BOARDX = _PHANDX + _HANDW + 2*_PAD + 2*_PAD
_BOARDY = 2*_PAD
_BOARDH = _H - 4*_PAD
_BOARDW = (_W - _BOARDX) - 4*_PAD

_BOARDCOLOR = {0.6, 0.4, 0.1}
_BOARDBORDER = {0.3, 0.1, 0}


math.randomseed(os.time())

require("core")
deck = buildDeck()

--

PEGHOLES = {{}, {}}
function makeholes()
  
  PEGHOLES[1] = {}
  local x = _BOARDX + _BOARDW/10
  local y = _BOARDY + 4*_PAD + _BOARDH - 12*_PAD
  local d = -(_BOARDH - 12*_PAD)/34
  local nhole = 1
  for i=1,4 do  -- player holes
    for j = 1,30 do
      PEGHOLES[1][nhole] = {x,y}
      nhole = nhole + 1
      if j < 30 then
        y = y + d
        if j % 5 == 0 then 
          y = y + d
        end
      end
    end
    x = x + _BOARDW/10
    d = -1 * d
  end
  PEGHOLES[1][0] = {_BOARDX + _BOARDW/10, _BOARDY + 4*_PAD + 36*(_BOARDH - 12*_PAD)/34}
  PEGHOLES[1][121] = {_BOARDX + 4*_BOARDW/10, _BOARDY + 4*_PAD + 36*(_BOARDH - 12*_PAD)/34}
  
  
  PEGHOLES[2] = {}
  x = _BOARDX + 9*_BOARDW/10
  y = _BOARDY + 4*_PAD + _BOARDH - 12*_PAD
  d = -(_BOARDH - 12*_PAD)/34
  nhole = 1
  for i=9,6,-1 do  -- player holes
    for j = 1,30 do
      PEGHOLES[2][nhole] = {x,y}
      nhole = nhole + 1
      if j < 30 then
        y = y + d
        if j % 5 == 0 then 
          y = y + d
        end
      end
    end
    x = x - _BOARDW/10
    d = -1 * d
  end
  PEGHOLES[2][121] = {_BOARDX + 6*_BOARDW/10, _BOARDY + 4*_PAD + 36*(_BOARDH - 12*_PAD)/34}
  PEGHOLES[2][0] = {_BOARDX + 9*_BOARDW/10, _BOARDY + 4*_PAD + 36*(_BOARDH - 12*_PAD)/34}
  
end
makeholes()

function drawboard()
  love.graphics.setColor(0.6, 0.4, 0.1)
  love.graphics.rectangle('fill', _BOARDX, _BOARDY, _BOARDW, _BOARDH, 2*_PAD, 2*_PAD)
  love.graphics.setColor(0.3, 0.1, 0)
  love.graphics.rectangle('line', _BOARDX, _BOARDY, _BOARDW, _BOARDH, 2*_PAD, 2*_PAD)
  
  local x = _BOARDX + _BOARDW/10
  for i=1,9 do
    if i ~= 5 then
      love.graphics.setColor(0,0,0)
      love.graphics.line(x, _BOARDY + 4*_PAD, x, _BOARDY + _BOARDH - 8*_PAD)
      
    end    
    if i == 1  or i == 3 or i == 6 or i == 8 then
      love.graphics.line(x, _BOARDY + 4*_PAD, x+_BOARDW/10, _BOARDY + 4*_PAD)        
    elseif i ==2 or i == 7 then
      love.graphics.line(x, _BOARDY + _BOARDH - 8*_PAD, x+_BOARDW/10, _BOARDY + _BOARDH - 8*_PAD)
    end  
    x = x + _BOARDW/10
  end  
  for i=1,2 do
    for j,h in pairs(PEGHOLES[i]) do
      love.graphics.circle('fill', h[1], h[2], 0.67*_PAD)
      --love.graphics.print(tostring(j), h[1], h[2])
    end
  end
end

function drawpegs()
  for i = 1,2 do
    
    if i == 1 then
      love.graphics.setColor(0.8, 0.4, 0.1)
    else
      love.graphics.setColor(0.4, 0.6, 0.1)
    end    
    for j,p in pairs(UI.pegs[i]) do
      love.graphics.circle('fill', PEGHOLES[i][p][1], PEGHOLES[i][p][2], _PAD)
    end
    
    if UI.pegechoes and UI.pegechoes[i] then
      if length(UI.pegechoes[i]) > 0 then
        for j,pe in pairs(UI.pegechoes[i]) do
          if i == 1 then
            love.graphics.setColor(0.8, 0.4, 0.1, 1 - pe.age / _PEGDURATION)
          else
            love.graphics.setColor(0.4, 0.6, 0.1, 1 - pe.age / _PEGDURATION)
          end
          love.graphics.circle('fill', PEGHOLES[i][pe.hole][1], PEGHOLES[i][pe.hole][2], 3*_PAD)
        end
      end
    end
  end  
end

--

Button = {text = 'button', x = 0, y = 0, w = 10, h = 10, hover = false, selected = false}
function Button:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end
function Button:collide(x,y)
  return (self.x <= x and self.x + self.w >= x) and (self.y <= y and self.y + self.h >= y)
end
function Button:togglehover()
  self.hover = not self.hover
end
function Button:draw()
  if self.hover or self.selected then
    love.graphics.setColor(1,1,1)
  else
    love.graphics.setColor(0.8, 0.8, 0.8)
  end
  love.graphics.rectangle('fill', self.x, self.y, self.w, self.h, _PAD/2, _PAD/2)
  love.graphics.setColor(0.4, 0.4, 0.4)
  love.graphics.rectangle('line', self.x, self.y, self.w, self.h, _PAD/2, _PAD/2)
  local T = love.graphics.newText(fixedFont, self.text)
  tw, th = T:getDimensions()
  love.graphics.draw(T, self.x + self.w/2 - tw/2, self.y + self.h/2 - th/2)
end
--



showitem = {
  player = 0,
  card_indices = {},
  value = 0,
  message = ''
  }



UI = {
  mode = 'opponent',
  state = 'ingame',
  player_buttons = {},
  message = 'CFRibbage',
  tcool = 0,
  Tcool = 0,
  tanim = 0, 
  Tanim = 0,
  tpause = 0,
  Tpause = 0,
  returnstate = 'ingame',
  scorenotes = {},
  showindex = 1,
  showphase = 'flush',
  showitems = {},
  pegs = {{0, 121}, {0, 121}},
  pegechoes = {{}, {}}, -- the echo of a peg that has moved. Will have a hole # and an age.
  currentpeg = {2, 2}  -- the first peg to move will be the one at 121
}
function UI:animate(T)
  self.tanim = 0
  self.Tanim = T
end
function UI:pause(T)
  self.tpause = 0
  self.Tpause = T
end
function UI:pausethendo(T, callback)
  self.callback = callback
  self.Tpause = T
end
function UI:pegscore(player, v)
    local echohole = self.pegs[player][self.currentpeg[player]]
    if self.pegechoes[player] then
      table.insert(self.pegechoes[player], {age = 0, hole = echohole})   
    else
      self.pegechoes[player] = {{age = 0, hole = echohole}}
    end
    GS.scores[player] = GS.scores[player] + v
    self.pegs[player][self.currentpeg[player]] = GS.scores[player]
end
function UI:waitforinput()
  self.returnstate = self.state
  self.state = 'wait'
end
--

function clearcallback()
  UI.callback = nil
end




function get_computer_discard()
  return {GS.hands[2][1], GS.hands[2][2]}
end
function get_computer_play()
  for i,c in pairs(GS.hands[2]) do
    if GS.total + c.value <= 31 then
      return c
    end
  end
  c = newgo()
  c.x = _CHANDX - card_width - _PAD
  c.y = _CHANDY + _PAD
  return c
end
--



function startdeal()
  -- Put cards in position
  for i,c in pairs(deck) do
    c.x = _TURNX + _PAD
    c.y = _TURNY + _PAD
    c.faceup = false
  end
  
  -- Deal hands & turncard. We actually deal *before* the deal phase, annoying!
  GS:deal()
  
  -- Point cards at their destinations  
  local y = _CHANDY + _PAD
  local x = _CHANDX + _PAD
  for j,c in pairs(GS.hands[2]) do
    c:set_target(x,y)
    x = x + card_width + _PAD
  end
  
  y = _PHANDY + _PAD
  x = _PHANDX + _PAD
  for j,c in pairs(GS.hands[1]) do
    c:set_target(x,y)
    x = x + card_width + _PAD
  end
  
  -- Update game state
  GS:startphase('deal')
  
  -- Animate!
  --UI:animate(_FLYTIME)
  UI.message = {}
end
--

function startdiscard()
  
  
  
  -- Put cards in position
  local x = _PHANDX + _PAD
  local y = _PHANDY + _PAD
  for i, c in pairs(GS.hands[1]) do
    c.tx = x
    c.ty = y
    c.vx = (c.tx - c.x) / _FLYTIME
    c.vy = (c.ty - c.y) / _FLYTIME
    c.faceup = true
    x = x + card_width + _PAD
  end  
  
  x = _CHANDX + _PAD
  y = _CHANDY + _PAD
  for i, c in pairs(GS.hands[2]) do
    c.tx = x
    c.ty = y
    c.vx = (c.tx - c.x) / _FLYTIME
    c.vy = (c.ty - c.y) / _FLYTIME
    c.faceup = false
    x = x + card_width + _PAD
  end
    
  GS.turncard.tx = _TURNX + _PAD
  GS.turncard.ty = _TURNY + _PAD
  GS.turncard.vx = (GS.turncard.tx - GS.turncard.x) / _FLYTIME
  GS.turncard.vy = (GS.turncard.ty - GS.turncard.y) / _FLYTIME
  GS.turncard.faceup = false
  
  -- Activate appropriate buttons  
  UI.player_buttons = {discardButton}
  
  
  -- Start the discard phase
  GS:startphase('discard')
  
end
--

function startplay()
  
  GS.discards = {{}, {}}
  for i,c in pairs(GS.hands[1]) do
    if c.selected then
      table.insert(GS.discards[1], c)
    end
  end
  GS.discards[2] = get_computer_discard()
  
  GS:process_discards()
  
  for i,c in pairs(GS.discards[1]) do
    c.faceup = false
    c:reduce()
    c.selected = false
  end
  
  local x = _PHANDX - 2*card_width
  local y = 0
  if GS.dealer == 1 then
    y = _PHANDY + _PAD
  else
    y = _CHANDY + _PAD
  end
  for i,c in pairs(GS.crib) do
    c:set_target(x, y)
    x = x + card_width / 4
  end
  
    
  UI.player_buttons = {}
  UI.scorenotes = {}
      
  GS.turncard.faceup = true
    
  GS:startphase('play')
  if GS.turncard.name == 'JC' or GS.turncard.name == 'JD' or GS.turncard.name == 'JH' or GS.turncard.name == 'JS' then
    UI:pegscore(GS.whoseturn, 2) --nobs!    
    table.insert(UI.scorenotes, {ix = -2, s = 'Nobs (2)', age = 0, owner = GS.dealer})
  end
  UI.tcool = 0
  
  --UI.message = "Total: 0"
  
  
end
--

function startshow()

  local px = _PHANDX + _PAD
  local py = _PHANDY + _PAD
  local cx = _CHANDX + _PAD
  local cy = _CHANDY + _PAD
  
  for i,c in pairs(GS.showhands[1]) do
    c:set_target(px, py)
    px = px + card_width + _PAD
  end
  
  for i,c in pairs(GS.showhands[2]) do
    c:set_target(cx, cy)
    cx = cx + card_width + _PAD
  end
  
  for i,c in pairs(GS.history) do
    if c.name == 'GO' then
      c = nil
    end
  end
  
    
  UI.scorenotes = {}
  UI.player_buttons = {}
  GS:startphase('show')
  UI.showphase = 'getscores'
  UI:pause(2)

  for i=1,2 do
    UI.currentpeg[i] = 3 - UI.currentpeg[i]
  end
  
end
--



fnranks = {'A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'}
fnsuits = {'Clubs', 'Diamonds', 'Hearts', 'Spades'}
faces = {}
card_back = {}
function love.load()
  
  love.window.setMode(_W, _H)
    
    
  deck, go = buildDeck()
  
  for j, suit in pairs({'Clubs', 'Diamonds', 'Hearts', 'Spades'}) do
    for i, rank in pairs(fnranks) do
      local fn = 'images/card' .. suit .. rank .. '.png'
      local rs = (rank == '10' and 'T') or rank
      local sn = rs .. string.sub(suit,1,1)
      faces[sn] = love.graphics.newImage(fn)
    end
  end
 
  card_back = love.graphics.newImage('images/cardBack_blue4.png')
  faces['GO'] = love.graphics.newImage('images/goCard.png')

  discardButton = Button:new({text = 'Discard', x = _PHANDX + _PAD, y = _PHANDY - _PAD - card_height/3, 
      w = 6*card_width + 5*_PAD, h = card_height/3})
  goButton = Button:new({text = 'Go', x = _PHANDX + _PAD, y = _PHANDY - _PAD - card_height/3, 
      w = 6*card_width + 5*_PAD, h = card_height/3})

  fixedFont = love.graphics.newFont('fonts/courierPrime.ttf', 14)
  UIFont = love.graphics.newFont('fonts/segoeUI.ttf', 24)
  
end
--




 


t = 0
function love.update(dt)
  t = t + dt
    
  
  -- ANIMATIONS
  
  for i,c in pairs(deck) do
    if math.abs(c.tx - c.x) > _ATHRES or math.abs(c.ty - c.y) > _ATHRES then
      c.x = c.x + c.vx * dt
      c.y = c.y + c.vy * dt
    else
      c.x = c.tx
      c.vx = 0
      c.y = c.ty
      c.vy = 0
    end
  end
  
  for i,c in pairs(GS.history) do
    if c.name == 'GO' then
      if math.abs(c.tx - c.x) > _ATHRES or math.abs(c.ty - c.y) > _ATHRES then
        c.x = c.x + c.vx * dt
        c.y = c.y + c.vy * dt
      else
        c.x = c.tx
        c.vx = 0
        c.y = c.ty
        c.vy = 0
      end
    end
  end
    
    
    
   -- UPDATE PEG ECHOES 
  for i = 1,2 do
    if UI.pegechoes and UI.pegechoes[i] then
      for j,pe in pairs(UI.pegechoes[i]) do
        pe.age = pe.age + dt
        if pe.age > _PEGDURATION then
          pe = nil
        end
      end
    end
  end
  
   -- UPDATE SCORE NOTES
  for i,sn in pairs(UI.scorenotes) do
    sn.age = sn.age + dt
    if sn.age > _SCORENOTEDURATION then
      sn = nil
    end
  end
    
    
  
   -- UI PAUSE
    
  if UI.Tpause > 0 then
    
    UI.tpause = UI.tpause + dt
    if UI.tpause >= UI.Tpause then
      UI.Tpause = 0   
      if UI.callback then
        UI.callback()
      end 
    end
    return
  end
    --
  
  
    
   -- GAME LOGIC
    
  if UI.state == 'ingame' then  
  
    if UI.mode == 'opponent' then
      
      
      
      if GS.phase == 'init' then        
        startdeal()
        
        
    
      elseif GS.phase == 'deal' then      
        startdiscard()
        
        
        
      elseif GS.phase == 'discard' then        
        if length(GS.discards[1]) == 2 and length(GS.discards[2]) == 2 then          
          startplay()          
        end
        
        
        
      elseif GS.phase == 'play' then
        
        if length(GS.hands[1]) == 0 and length(GS.hands[2]) == 0 then
          c = newgo()
          c:set_target(_PLAYX + _PAD + (length(GS.history) - 1) * card_width / 2, _TURNY + _PAD)
          GS:process_play(c)
          UI.message = ''
          UI:pausethendo(1, function () clearcallback(); startshow() end)
          return
        end
        
        if GS.whoseturn == 2 then
          UI.tcool = UI.tcool + dt
          if UI.tcool < _CPAUSE then
            return
          else
            c = get_computer_play()
            GS:process_play(c)
            UI.message = "Total: " .. tostring(GS.total)
            c:set_target(_PLAYX + _PAD + (length(GS.history) - 1) * card_width / 2, _TURNY + _PAD)
            c.faceup = true
            GS.whoseturn = 1
            UI.tcool = 0
          end
          
        elseif GS.whoseturn == 1 then
          local has_play = false
          for i,c in pairs(GS.hands[1]) do
            if GS.total + c.value <= 31 then
              has_play = true
            end
          end
          if not has_play then
            UI.player_buttons = {goButton}
          else            
            UI.player_buttons = {}
          end
          
        end
        --
        
        
        
      elseif GS.phase == 'show' then
              
        
        if UI.showphase == 'getscores' then 
                    
          GS:scoreshow() 
          
          for i,c in pairs(GS.crib) do
            c:set_target(_PLAYX + _PAD + (i-1) * (card_width + _PAD), _TURNY + _PAD)
            c.faceup = true
          end
          UI.showphase = 'showscores'
          
          
      
        elseif UI.showphase == 'showscores' then
                    
          
          if UI.showitems and (length(UI.showitems) > 0) then
            
            if GS.dealer == 1 then    
              players = {1, 2, 1}
            else
              players = {1, 2, 2}
            end
  
            SI = table.remove(UI.showitems)
            local whichplayer = players[SI.whichhand]
            if SI.whichhand == 1 then
              UI.message = 'Player has '
              GS.turncard:set_target(_PHANDX - 2*_PAD - card_width, _PHANDY + _PAD)
            elseif SI.whichhand == 2 then
              UI.message = 'Computer has '
              GS.turncard:set_target(_CHANDX - 2*_PAD - card_width, _CHANDY + _PAD)
            else
              UI.message = 'Crib has '
              GS.turncard:set_target(_TURNX + _PAD, _TURNY + _PAD)
            end
            
            UI.message = UI.message .. SI.message
            UI:pegscore(whichplayer, SI.value)
            UI:waitforinput()
            --UI:pause(3)
            
            
          else
            GS:reset(3-GS.dealer)
            UI.message = ''
            GS:startphase('deal')
            UI:pausethendo(1, function () clearcallback(); GS:startphase('deal'); startdeal() end)
          end
          
        end
        
      end  -- phase
      --
      
      
    end -- UI.mode
  --
  
  elseif UI.state == 'wait' then
    

  end -- UI.state

end
--





function love.mousemoved(x, y, dx, dy, istouch)
  
  if UI.mode == 'opponent' then
    
    if GS.phase == 'deal' then
      
    
    elseif GS.phase == 'discard' then
      
      -- Check number of selected cards
      local nselected = 0
      for i,c in pairs(GS.hands[1]) do
        if c.selected then
          nselected = nselected + 1
        end
      end
      
      -- highlight hovered card
      for i,c in pairs(GS.hands[1]) do
        if c:collide(x,y) and not c.hover then
          c:togglehover()
        elseif c.hover and not c:collide(x,y) then
          c:togglehover()
        end
      end
      
      for i,b in pairs(UI.player_buttons) do
        if nselected == 2 and b:collide(x,y) and not b.hover then
          b:togglehover()
        elseif b.hover and not b:collide(x,y) then
          b:togglehover()
        end
      end
      
      
    elseif GS.phase == 'play' then
      for i,c in pairs(GS.hands[1]) do
        
        if (GS.total + c.value) > 31 then
          goto continue
        end
        
        if c:collide(x,y) and not c.hover then
          c:togglehover()
          c:toggleselect()
        elseif c.hover and not c:collide(x,y) then
          c:togglehover()
          c:toggleselect()
        end
        
        ::continue::
      end
      
      for i,b in pairs(UI.player_buttons) do
        if b:collide(x,y) and not b.hover then
          b:togglehover()
        elseif b.hover and not b:collide(x,y) then
          b:togglehover()
        end
      end
      
    end  --phase
    
  end  --mode
  
end
--


function love.mousepressed(x, y, button)
  
  --tprint(UI.pegs)
  --tprint(UI.currentpeg)
  
  
  if UI.mode == 'opponent' then
    
    if GS.phase == 'discard' then 
        
      -- Check number of selected cards
      local nselected = 0
      for i,c in pairs(GS.hands[1]) do
        if c.selected then
          nselected = nselected + 1
        end
      end
      
      for i,c in pairs(GS.hands[1]) do
        if c:collide(x,y) then
          if c.selected then
            c:toggleselect()
          elseif nselected < 2 then
            c:toggleselect()
          end
        end
      end    
      
      for i,b in pairs(UI.player_buttons) do
        if b:collide(x,y) then
          if b.text == 'Discard' then
            if nselected == 2 then
              startplay()
            end
          end
        end
      end
      --
      
      
      
    elseif GS.phase == 'play' then
      
      for i,c in pairs(GS.hands[1]) do
        if c.hover then
          c:reduce()
          c.selected = false
          c.hover = false
          GS:process_play(c)
          UI.message = "Total: " .. tostring(GS.total)
          c:set_target(_PLAYX + _PAD + (length(GS.history) - 1) * card_width / 2, _TURNY + _PAD)
          GS.whoseturn = 2
        end
      end
      
      for i,b in pairs(UI.player_buttons) do
        if b:collide(x,y) then
          if b.text == 'Go' then
            c = newgo()
            c.x = _PHANDX - card_width - _PAD
            c.y = _PHANDY + _PAD
            GS:process_play(c)
            UI.message = "Total: " .. tostring(GS.total)
            c:set_target(_PLAYX + _PAD + (length(GS.history) - 1) * card_width / 2, _TURNY + _PAD)
            GS.whoseturn = 2
            UI.tcool = 0
          end
        end
      end
      
      
      
    elseif GS.phase == 'show' then
      
      if UI.state == 'wait' then
        UI.state = UI.returnstate
        
      end
      
      
      
    end  --phase  
    
  end  --UI mode
end
--







function love.draw()
  
  love.graphics.setBackgroundColor(0.2, 0.6, 0.4)
    
    
  if UI.mode == 'opponent' then
    
     -- The table
     
    love.graphics.setColor(0.7, 0.8, 0.9)
    love.graphics.rectangle('fill', _PHANDX, _PHANDY, _HANDW, _HANDH, _PAD/2, _PAD/2)
    love.graphics.rectangle('fill', _CHANDX, _CHANDY, _HANDW, _HANDH, _PAD/2, _PAD/2)
    love.graphics.rectangle('fill', _TURNX, _TURNY, card_width + 2*_PAD, card_height + 2*_PAD, _PAD/2, _PAD/2)
    
    love.graphics.setColor(0.4, 0.4, 0.4)
    love.graphics.rectangle('line', _PHANDX, _PHANDY, _HANDW, _HANDH, _PAD/2, _PAD/2)
    love.graphics.rectangle('line', _CHANDX, _CHANDY, _HANDW, _HANDH, _PAD/2, _PAD/2)
    love.graphics.rectangle('line', _TURNX, _TURNY, card_width + 2*_PAD, card_height + 2*_PAD, _PAD/2, _PAD/2)
     
     
     
     
     
    if GS.phase == 'deal' then 
      
      for i,c in pairs(deck) do
        c:draw()
      end
     
      
    elseif GS.phase == 'discard' then
            
      for i,h in pairs(GS.hands) do
        for j,c in pairs(h) do
          c:draw()
        end
      end      
      GS.turncard:draw()
      
      
      
    elseif GS.phase == 'play' then
      love.graphics.setColor(0.7, 0.8, 0.9)
      love.graphics.rectangle('fill', _PLAYX, _TURNY, _PLAYW, _HANDH, _PAD/2, _PAD/2)
      love.graphics.setColor(0.4, 0.4, 0.4)
      love.graphics.rectangle('line', _PLAYX, _TURNY, _PLAYW, _HANDH, _PAD/2, _PAD/2)
    
      GS.turncard:draw()
    
      for i = 1,2 do
        for j,c in pairs(GS.hands[i]) do
          c:draw()
        end
      end
      
      for i,c in pairs(GS.crib) do
        c:draw()
      end
    
      x = _PLAYX + _PAD
      y = _TURNY + _PAD
      for i,c in pairs(GS.history) do
        c:draw()
        x = x + card_width/2
      end
      
      
      
      
      
      
      
    elseif GS.phase == 'show' then
      
      for i,sh in pairs(GS.showhands) do
        for j,c in pairs(GS.showhands[i]) do
          c:draw()
        end
      end
      GS.turncard:draw()
      for i,c in pairs(GS.crib) do
        c:draw()
      end
      
      
    end
  
  
  
  
    for i,b in pairs(UI.player_buttons) do
      b:draw()
    end
    
    
    if GS.dealer == 1 then
      V = {_TURNX + 2*_PAD, _TURNY + card_height + 3*_PAD, _TURNX + card_width, _TURNY + card_height + 3*_PAD, 
        _TURNX + _PAD + card_width/2, _TURNY + card_height + 7*_PAD}
    else
      V = {_TURNX + 2*_PAD, _TURNY - _PAD, _TURNX + card_width, _TURNY - _PAD, 
        _TURNX + _PAD + card_width/2, _TURNY - 4*_PAD}
    end
    love.graphics.setColor(0.6, 0.3, 0.2)
    love.graphics.polygon('fill', V)
    love.graphics.setColor(0.4, 0.1, 0)
    love.graphics.polygon('line', V)
    local D = love.graphics.newText(fixedFont, 'D')
    local dw, dh = D:getDimensions()
    if GS.dealer == 1 then      
      love.graphics.draw(D, (V[1] + V[3] - dw)/2, _H/2 + card_height/2 + 3*_PAD)
    else
      love.graphics.draw(D, (V[1] + V[3] - dw)/2, _H/2 - card_height/2 - 4*_PAD)
    end
  
  end

  if UI.message then
      love.graphics.setFont(UIFont)
      love.graphics.setColor(0.9, 0.95, 0.85)
      love.graphics.print(UI.message, _MESSAGEX, _MESSAGEY)
  end
  
  drawboard()
  drawpegs()
  
  -- Floating score notes 
     
  for i,sn in pairs(UI.scorenotes) do
    x = _PLAYX + 2*_PAD + (sn.ix - 1) * card_width / 2
    owner_mod = ((sn.owner == 2 and -1) or 1)
    y = _H/2 + owner_mod * (sn.age / _SCORENOTEDURATION) * 2*card_height
    
    S = love.graphics.newText(fixedFont, sn.s)
    sw, sh = S:getDimensions()
    love.graphics.setColor(0.8, 0.7, 0.3, 1-(sn.age / _SCORENOTEDURATION))        
    love.graphics.rectangle('fill', x-sw/2+_PAD, y, sw+3*_PAD, sh + 1.5*_PAD, _PAD, _PAD)
    
    love.graphics.setColor(0.4, 0.3, 0.1, 1-(sn.age / _SCORENOTEDURATION))
    love.graphics.rectangle('line', x-sw/2+_PAD, y, sw+3*_PAD, sh + 1.5*_PAD, _PAD, _PAD)
    
    love.graphics.setFont(fixedFont)
    love.graphics.print(sn.s, x-sw/2+2*_PAD, y+_PAD)
    
  end

  --[[
  love.graphics.setFont(fixedFont)
  love.graphics.print(GS:statestring(), _W - 250, 10)
  love.graphics.print(UI.state, 10, 10)
  love.graphics.print(UI.showphase, 10, 30)
  love.graphics.print(UI.Tpause, 10, 50)
  --]]
  
  
end
--

--UI.pegechoes[1] = {{hole = 30, age = 0}}


