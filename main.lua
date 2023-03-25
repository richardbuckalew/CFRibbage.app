



--GLOBAL CONFIG
_W = 1000
_H = 640

_INFOH = 200

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
_TURNX = card_width/2
_TURNY = _H/2 - card_height/2 - _PAD

_PLAYX = _TURNX + card_width + 4*_PAD
_PLAYW = 7*card_width + 2*_PAD

_MESSAGEX = _PHANDX + _PAD
_MESSAGEY = _PHANDY - 2*_PAD - 2*card_height/3


cbutton_width = (_W - 8*_PAD - 6*_PAD) / 14
cbutton_sx = cbutton_width / png_size[1]
cbutton_sy = cbutton_sx
cbutton_height = cbutton_sy * png_size[2]



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
_BOARDW = (_W - _BOARDX) - 3*_PAD

felt_color = {0.2, 0.6, 0.4}
region_color = {0.7, 0.8, 0.9}
region_trim_color = {0.4, 0.4, 0.4}
dealer_triangle_color = {0.6, 0.3, 0.2}
dealer_triangle_trim_color = {0.4, 0.1, 0}
message_color = {0.9, 0.95, 0.85}
scorenote_box_color = {0.8, 0.7, 0.3}
scorenote_trim_color = {0.4, 0.3, 0.1}
infobox_color = {0.1, 0.15, 0.08}
infobox_trim_color = {0.5, 0.75, 0.68}
active_region_color = {0.85, 0.85, 0.95}


_HANDREGIONX = 3*_PAD
_HANDREGIONY = 10*_PAD + 4*cbutton_height
_HANDREGIONW = 6*card_width + 7*_PAD

_DISCARDREGIONX = 12*_PAD + 6*card_width
_DISCARDREGIONY = 10*_PAD + 4*cbutton_height
_DISCARDREGIONW = 2*card_width + 3*_PAD

_TURNREGIONX = 3*_PAD
_TURNREGIONY = 18*_PAD + 4*cbutton_height + card_height

_HISTORYREGIONX = 7*_PAD + card_width
_HISTORYREGIONY = 18*_PAD + 4*cbutton_height + card_height
_HISTORYREGIONW = _PLAYW + card_width/2







math.randomseed(os.time())

require("core")
deck = buildDeck()
require("model")
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
  mode = 'menu',
  state = 'ingame',
  buttons = {},
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
  currentpeg = {2, 2},  -- the first peg to move will be the one at 121
  activeregion = {}, -- for advisor mode, one of 'hand', 'discard', 'turn', 'history'
  handcards = {},
  discardcards = {},
  turncard = {},
  historycards = {},
  isdealer = false,
  total = 0
}
UI.activeregion = UI.handcards
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
    
    if GS.scores[player] >= 121 then
      UI:gameover()
      return
    end
    
    self.pegs[player][self.currentpeg[player]] = GS.scores[player]
end
function UI:waitforinput()
  self.returnstate = self.state
  self.state = 'wait'
end
function UI:calculate_total()
  UI.total = 0
  for i=1,length(UI.historycards) do
    local c = UI.historycards[i]
    if c.name == 'GO' and i > 1 then
      if UI.historycards[i-1].name == 'GO' then
        UI.total = 0
      end
    else
      UI.total = UI.total + c.value
    end
  end
end
function UI:gameover()
  UI.message = 'Game Over.'
  UI:pausethendo(5, startdeal)
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



function startmenu()  
  UI.mode = 'menu'
  UI.buttons = {oppButton, advButton, expButton, quitButton, aboutButton}  
  
  --startadvisor()
  
end




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
  UI.buttons = {discardButton}
  
  
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
  
    
  UI.buttons = {}
  UI.scorenotes = {}
      
  GS.turncard.faceup = true
    
  GS:startphase('play')
  
  if GS.turncard.name == 'JC' or GS.turncard.name == 'JD' or GS.turncard.name == 'JH' or GS.turncard.name == 'JS' then
    UI:pegscore(3-GS.dealer, 2) --nobs!    
    table.insert(UI.scorenotes, {ix = -2, s = 'Nobs (2)', age = 0, owner = 3-GS.dealer})
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
  
    
  --UI.scorenotes = {}
  UI.buttons = {}
  GS:startphase('show')
  UI.showphase = 'getscores'
  UI:pause(1)

  for i=1,2 do
    UI.currentpeg[i] = 3 - UI.currentpeg[i]
  end
  
end
--




function startadvisor()
  UI.mode = 'advisor'
  UI.buttons = {clearAllButton, clearButton, removeButton, getDiscardButton, getPlayButton, getInfoButton}
end





fnranks = {'A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'}
fnsuits = {'Clubs', 'Diamonds', 'Hearts', 'Spades'}
faces = {}
card_back = {}
card_buttons = {}
function love.load()
  
  love.window.setMode(_W, _H+_INFOH)
    
    
  deck, deckindex = buildDeck()
  
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
  
  
  
  
  oppButton = Button:new({text = 'Play Against the Computer', x = _W/2 - 2*card_width, y = _H/2 - 1.2*card_height, 
      w = 4*card_width, h = 0.6*card_height})
  advButton = Button:new({text = 'Get Advice from the Computer', x = _W/2 - 2*card_width, y = _H/2 - 0.4*card_height,
      w = 4*card_width, h = 0.6*card_height})
  expButton = Button:new({text = 'Explore the database', x = _W/2 - 2*card_width, y = _H/2 + 0.4*card_height,
      w = 4*card_width, h = 0.6*card_height})
  quitButton = Button:new({text = 'Quit', x = _W/2 - 2*card_width, y=_H/2 + 1.2*card_height, 
      w = 1.9*card_width, h = 0.6*card_height})
  aboutButton = Button:new({text = 'About CFRibbage', x = _W/2 +0.1*card_width, y = _H/2 + 1.2*card_height, 
      w = 1.9*card_width, h = 0.6*card_height})


  for i,c in pairs(deck) do
    table.insert(card_buttons, 
      Card:new({rank = c.rank, suit = c.suit, value = c.value, name = c.name, 
          x = 4*_PAD + (c.rank - 1) * (cbutton_width + _PAD/2) , y = 2*_PAD + (c.suit - 1) * (cbutton_height + _PAD/2), 
          sx = cbutton_sx, sy = cbutton_sy, vx = 0, vy = 0, tx = 0, ty = 0, w = cbutton_width, h = cbutton_height, faceup = true}))
  end
  gocard_button = newgo()
  gocard_button.x = 4*_PAD + 13 * (cbutton_width + _PAD/2)
  gocard_button.y = 2*_PAD + 3*(cbutton_height + _PAD/2)
  gocard_button.w = cbutton_width
  gocard_button.h = cbutton_height
  gocard_button.sx = cbutton_sx
  gocard_button.sy = cbutton_sy
  gocard_button.faceup = true

  clearAllButton = Button:new({text = 'Clear\nall', x = 4*_PAD + 13 * (cbutton_width + _PAD/2), y = 2*_PAD,
      w = cbutton_width, h = cbutton_height})
  clearButton = Button:new({text = 'Clear', x = 4*_PAD + 13 * (cbutton_width + _PAD/2), y = 2*_PAD + cbutton_height + _PAD/2,
      w = cbutton_width, h = cbutton_height})
  removeButton = Button:new({text = 'Remove', x = 4*_PAD + 13 * (cbutton_width + _PAD/2), y = 2*_PAD + 2*(cbutton_height + _PAD/2),
      w = cbutton_width, h = cbutton_height})
  
  getDiscardButton = Button:new({text = 'Get Discard', x = _TURNREGIONX, y = _TURNREGIONY + 8*_PAD + card_height, w = 2.89*card_width, h = card_height/2})
  getPlayButton = Button:new({text = 'Get Play', x = getDiscardButton.x + getDiscardButton.w + 2*_PAD, y = getDiscardButton.y, 
      w = getDiscardButton.w, h = getDiscardButton.h})
  getInfoButton = Button:new({text = 'Get Info', x = getPlayButton.x + getPlayButton.w + 2*_PAD, y = getPlayButton.y, w = getPlayButton.w, h = getPlayButton.h})
  

  fixedFont = love.graphics.newFont('fonts/courierPrime.ttf', 14)
  UIFont = love.graphics.newFont('fonts/segoeUI.ttf', 24)
  
  
  startmenu()
  
  
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
  
  for i,c in pairs(UI.historycards) do
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
            UI:pause(0.5)
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
            UI.buttons = {goButton}
          else            
            UI.buttons = {}
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
            --GS:startphase('deal')
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






function love.keypressed(key)
  if key == 'escape' then
    startmenu()
  end
end



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
      
      for i,b in pairs(UI.buttons) do
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
      
      for i,b in pairs(UI.buttons) do
        if b:collide(x,y) and not b.hover then
          b:togglehover()
        elseif b.hover and not b:collide(x,y) then
          b:togglehover()
        end
      end
      
    end  --phase
    --
  
  
  elseif UI.mode == 'menu' then
  
    for i,b in pairs(UI.buttons) do
        if b:collide(x,y) and not b.hover then
          b:togglehover()
        elseif b.hover and not b:collide(x,y) then
          b:togglehover()
        end
    end
    
  
  
  
  
  elseif UI.mode == 'advisor' then
    for i,cb in pairs(card_buttons) do
      if cb:collide(x,y) and not cb.hover then
        cb:togglehover()
      elseif cb.hover and not cb:collide(x,y) then
        cb:togglehover()
      end
    end    
  
    if gocard_button:collide(x,y) and not gocard_button.hover then
      gocard_button:togglehover()
    elseif gocard_button.hover and not gocard_button:collide(x,y) then
      gocard_button:togglehover()
    end
  
    for i,b in pairs(UI.buttons) do
        if b:collide(x,y) and not b.hover then
          b:togglehover()
        elseif b.hover and not b:collide(x,y) then
          b:togglehover()
        end
    end
  
  
  
  
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
      
      for i,b in pairs(UI.buttons) do
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
      
      for i,b in pairs(UI.buttons) do
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
  --
    
    
    
  elseif UI.mode == 'menu' then
    
    for i,b in pairs(UI.buttons) do
      if b:collide(x,y) then
        if b.text == 'Play Against the Computer' then
          UI.mode = 'opponent'
          startdeal()
        elseif b.text == 'Quit' then
          love.event.quit()
        elseif b.text == 'Get Advice from the Computer' then
          startadvisor()
        elseif b.text == 'About CFRibbage' then
          os.execute("start http://richardbuckalew.me")
        end
      end
    end
    
    
    
    
    
    
  elseif UI.mode == 'advisor' then
    
    -- selecting active reigon?
    if _HANDREGIONX <= x and x <= _HANDREGIONX + _HANDREGIONW and _HANDREGIONY <= y and y <= _HANDREGIONY + card_height + 2*_PAD then
      UI.activeregion = UI.handcards
    elseif _DISCARDREGIONX <= x and x <= _DISCARDREGIONX + _DISCARDREGIONW and _DISCARDREGIONY <= y and y <= _DISCARDREGIONY + card_height + 2*_PAD then
      UI.activeregion = UI.discardcards
    elseif _TURNREGIONX <= x and x <= _TURNREGIONX + card_width + 2*_PAD and _TURNREGIONY <= y and y <= _TURNREGIONY + card_height + 2*_PAD then
      UI.activeregion = UI.turncard
    elseif _HISTORYREGIONX <= x and x <= _HISTORYREGIONX + _HISTORYREGIONW and _HISTORYREGIONY <= y and y <= _HISTORYREGIONY + card_height + 2*_PAD then
      UI.activeregion = UI.historycards
    end
    
    -- adding a card to the active region
    if (UI.activeregion == UI.handcards and length(UI.handcards) < 6) then
      for i,cb in pairs(card_buttons) do
        if cb:collide(x,y) then
          for j,c in pairs(deck) do
            if c.name == cb.name then
              
              if contains(UI.handcards, c) or contains(UI.discardcards, c) or contains(UI.turncard, c) or contains(UI.historycards, c) then
                goto inserted
              end  
              
              c.x = x
              c.y = y
              c.faceup = true
              c:set_target(_HANDREGIONX + _PAD + length(UI.handcards) * (card_width + _PAD), _HANDREGIONY + _PAD)
              table.insert(UI.handcards, c)
              goto inserted
            end
          end
        end
      end
    
    elseif (UI.activeregion == UI.discardcards and length(UI.discardcards) < 2) then
      for i,cb in pairs(card_buttons) do
        if cb:collide(x,y) then
          for j,c in pairs(deck) do
            if c.name == cb.name then
              
              if contains(UI.handcards, c) or contains(UI.discardcards, c) or contains(UI.turncard, c) or contains(UI.historycards, c) then
                goto inserted
              end    
              
              c.x = x
              c.y = y
              c.faceup = true
              c:set_target(_DISCARDREGIONX + _PAD + length(UI.discardcards) * (card_width + _PAD), _DISCARDREGIONY + _PAD)
              table.insert(UI.discardcards, c)
              goto inserted
              
            end
          end          
        end
      end
    
    
    elseif (UI.activeregion == UI.turncard and length(UI.turncard) < 1) then
      for i,cb in pairs(card_buttons) do
        if cb:collide(x,y) then
          for j,c in pairs(deck) do
            if c.name == cb.name then
              
              if contains(UI.handcards, c) or contains(UI.discardcards, c) or contains(UI.turncard, c) or contains(UI.historycards, c) then
                goto inserted
              end    
              
              c.x = x
              c.y = y
              c.faceup = true
              c:set_target(_TURNREGIONX + _PAD, _TURNREGIONY + _PAD)
              table.insert(UI.turncard, c)
              goto inserted
            end
          end          
        end
      end
    
    
    elseif (UI.activeregion == UI.historycards and UI.total < 31) then
      for i,cb in pairs(card_buttons) do
        if cb:collide(x,y) then
          for j,c in pairs(deck) do
            if c.name == cb.name then
              
              if contains(UI.handcards, c) or contains(UI.discardcards, c) or contains(UI.turncard, c) or contains(UI.historycards, c) then
                goto inserted
              end 
              if UI.total + c.value > 31 then
                goto inserted
              end  
              
              c.x = x
              c.y = y
              c.faceup = true
              c:set_target(_HISTORYREGIONX + _PAD + length(UI.historycards) * (card_width/2), _HISTORYREGIONY + _PAD)
              table.insert(UI.historycards, c)
              UI:calculate_total()
              goto inserted
            end
          end          
        end
      end
      if gocard_button:collide(x,y) then
        c = newgo()
        c.x = x
        c.y = y
        c.faceup = true
        c:set_target(_HISTORYREGIONX + _PAD + length(UI.historycards) * (card_width/2), _HISTORYREGIONY + _PAD)
        table.insert(UI.historycards, c)
        UI:calculate_total()
        goto inserted
      end
            
    end    
    ::inserted::
    
    
    -- The other buttons (clear all, clear, remove, getDiscard, getPlay, getInfo)
    
    if clearAllButton:collide(x,y) then
      UI.handcards = {}
      UI.discardcards = {}
      UI.turncard = {}
      UI.historycards = {}
      UI.activeregion = UI.handcards
      UI.calculate_total()
    
    elseif clearButton:collide(x,y) then
      if UI.activeregion == UI.handcards then
        UI.handcards = {}
        UI.activeregion = UI.handcards
      elseif UI.activeregion == UI.discardcards then
        UI.discardcards = {}
        UI.activeregion = UI.discardcards
      elseif UI.activeregion == UI.turncard then
        UI.turncard = {}
        UI.activeregion = UI.turncard
      elseif UI.activeregion == UI.historycards then
        UI.historycards = {}
        UI.activeregion = UI.historycards
        UI.calculate_total()
      end
    
    elseif removeButton:collide(x,y) then
      if length(UI.activeregion) > 0 then
        table.remove(UI.activeregion, length(UI.activeregion))
        UI.calculate_total()
      end
          
    elseif getDiscardButton:collide(x,y) then
      Model:getDiscard()
    
    elseif getPlayButton:collide(x,y) then
      Model:getPlay()
      
    elseif getInfoButton:collide(x,y) then
      Model:getInfo()
          
    elseif 5*_PAD + 1.6*card_width <= x and x <= 5*_PAD + 1.6*card_width + 15 and 7*_PAD + 4*cbutton_height <= y and y <= 7*_PAD + 4*cbutton_height + 15 then
      UI.isdealer = not UI.isdealer
    end
    
    
      
  end  --UI mode
end
--







function love.draw()
  
    
    
  if UI.mode == 'opponent' then
    
    
     -- The table
    love.graphics.setBackgroundColor(felt_color)
     
    love.graphics.setColor(region_color)
    love.graphics.rectangle('fill', _PHANDX, _PHANDY, _HANDW, _HANDH, _PAD/2, _PAD/2)
    love.graphics.rectangle('fill', _CHANDX, _CHANDY, _HANDW, _HANDH, _PAD/2, _PAD/2)
    love.graphics.rectangle('fill', _TURNX, _TURNY, card_width + 2*_PAD, card_height + 2*_PAD, _PAD/2, _PAD/2)
    
    love.graphics.setColor(region_trim_color)
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
      love.graphics.setColor(region_color)
      love.graphics.rectangle('fill', _PLAYX, _TURNY, _PLAYW, _HANDH, _PAD/2, _PAD/2)
      love.graphics.setColor(region_trim_color)
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
  
  
  
  
    for i,b in pairs(UI.buttons) do
      b:draw()
    end
    
    
    if GS.dealer == 1 then
      V = {_TURNX + 2*_PAD, _TURNY + card_height + 3*_PAD, _TURNX + card_width, _TURNY + card_height + 3*_PAD, 
        _TURNX + _PAD + card_width/2, _TURNY + card_height + 7*_PAD}
    else
      V = {_TURNX + 2*_PAD, _TURNY - _PAD, _TURNX + card_width, _TURNY - _PAD, 
        _TURNX + _PAD + card_width/2, _TURNY - 4*_PAD}
    end
    love.graphics.setColor(dealer_triangle_color)
    love.graphics.polygon('fill', V)
    love.graphics.setColor(dealer_triangle_trim_color)
    love.graphics.polygon('line', V)
    local D = love.graphics.newText(fixedFont, 'D')
    local dw, dh = D:getDimensions()
    if GS.dealer == 1 then      
      love.graphics.draw(D, (V[1] + V[3] - dw)/2, _H/2 + card_height/2 + 3*_PAD)
    else
      love.graphics.draw(D, (V[1] + V[3] - dw)/2, _H/2 - card_height/2 - 4*_PAD)
    end
  
    if UI.message then
        love.graphics.setFont(UIFont)
        love.graphics.setColor(message_color)
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
  
    
    love.graphics.setColor(infobox_color)
    love.graphics.rectangle('fill', 2*_PAD, _H+_PAD, _W - 4*_PAD, _INFOH - 3*_PAD, _PAD, _PAD)
    love.graphics.setColor(infobox_trim_color)
    love.graphics.rectangle('line', 2*_PAD, _H+_PAD, _W - 4*_PAD, _INFOH - 3*_PAD, _PAD, _PAD)
  
    love.graphics.setFont(fixedFont)
    love.graphics.print(Model.display, 3*_PAD, _H+2*_PAD)
  --
  
  ---------------------------
  -- END OPPONENT MODE DRAW  
  -----------------------
    
    
    
    
  elseif UI.mode == 'menu' then
    
    love.graphics.setBackgroundColor(0.1, 0.15, 0.08)
    
    for i,b in pairs(UI.buttons) do
      
      b:draw()
      
    end
  --
    
    
    
    
  elseif UI.mode == 'advisor' then
    
    for i,cb in pairs(card_buttons) do
      cb:draw()
    end
    gocard_button:draw()
    
    for i,b in pairs(UI.buttons) do
      b:draw()
    end
    
    
    
    -- DRAW CARD REGIONS
    
    if UI.activeregion == UI.handcards then      
      love.graphics.setColor(active_region_color)
    else
      love.graphics.setColor(region_color)
    end
    love.graphics.rectangle('fill', _HANDREGIONX, _HANDREGIONY, _HANDREGIONW, card_height + 2*_PAD, _PAD, _PAD)
    
    
    if UI.activeregion == UI.discardcards then      
      love.graphics.setColor(active_region_color)
    else
      love.graphics.setColor(region_color)
    end
    love.graphics.rectangle('fill', _DISCARDREGIONX, _DISCARDREGIONY, _DISCARDREGIONW, card_height + 2*_PAD, _PAD, _PAD)
    
    if UI.activeregion == UI.turncards then      
      love.graphics.setColor(active_region_color)
    else
      love.graphics.setColor(region_color)
    end
    love.graphics.rectangle('fill', _TURNREGIONX, _TURNREGIONY, card_width + 2*_PAD, card_height + 2*_PAD, _PAD, _PAD)
    
    if UI.activeregion == UI.historycards then      
      love.graphics.setColor(active_region_color)
    else
      love.graphics.setColor(region_color)
    end
    love.graphics.rectangle('fill', _HISTORYREGIONX, _HISTORYREGIONY, _HISTORYREGIONW, card_height + 2*_PAD, _PAD, _PAD)
    
    
    
    love.graphics.setColor(region_trim_color)
    love.graphics.rectangle('line', _HANDREGIONX, _HANDREGIONY, _HANDREGIONW, card_height + 2*_PAD, _PAD, _PAD)
    love.graphics.line(_HANDREGIONX + 4*card_width + 4.5*_PAD, _HANDREGIONY + 2*_PAD, _HANDREGIONX + 4*card_width + 4.5*_PAD, _HANDREGIONY + card_height)
    love.graphics.rectangle('line', _DISCARDREGIONX, _DISCARDREGIONY, _DISCARDREGIONW, card_height + 2*_PAD, _PAD, _PAD)
    love.graphics.rectangle('line', _TURNREGIONX, _TURNREGIONY, card_width + 2*_PAD, card_height + 2*_PAD, _PAD, _PAD)
    love.graphics.rectangle('line', 7*_PAD + card_width, 18*_PAD + 4*cbutton_height + card_height, 
      _PLAYW + card_width/2, card_height + 2*_PAD, _PAD, _PAD)
    
    
    love.graphics.setColor(infobox_trim_color)
    love.graphics.print('hand', 5*_PAD, 7*_PAD + 4*cbutton_height)
    love.graphics.print('dealer?', 5*_PAD + card_width, 7*_PAD + 4*cbutton_height)
    love.graphics.rectangle((UI.isdealer and 'fill') or 'line', 5*_PAD + 1.6*card_width, 7*_PAD + 4*cbutton_height, 15, 15)
    love.graphics.print('discard', 14*_PAD + 6*card_width, 7*_PAD + 4*cbutton_height)
    love.graphics.print('turn', 5*_PAD, 15*_PAD + 4*cbutton_height + card_height)
    love.graphics.print('history (' .. tostring(UI.total) .. ')', 9*_PAD + card_width, 15*_PAD + 4*cbutton_height + card_height)
    
    
    
    -- DRAW CARD
    for i,c in pairs(UI.handcards) do
      c:draw()
    end
    for i,c in pairs(UI.discardcards) do
      c:draw()
    end
    for i,c in pairs(UI.turncard) do
      c:draw()
    end    
    for i,c in pairs(UI.historycards) do
      c:draw()
    end
    
    
    
    love.graphics.setColor(infobox_trim_color)
    love.graphics.rectangle('line', _DISCARDREGIONX + 5*_PAD + 2*card_width, 6*_PAD + 4*cbutton_height, _W - (_DISCARDREGIONX + 7*_PAD + 2*card_width), (_H + _INFOH - (9*_PAD + 4*cbutton_height)))
    
    love.graphics.print(Model.display, _DISCARDREGIONX + 5*_PAD + 2*card_width + _PAD/2, 6*_PAD + 4*cbutton_height + _PAD/2)
    
    
  end
  
  --

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


