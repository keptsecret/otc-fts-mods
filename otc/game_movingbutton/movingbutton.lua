movingButtonWindow = nil
movingButton = nil

posx, posy = 0, 0

showButton = nil

function init()
  showButton = modules.client_topmenu.addRightGameToggleButton('showMovingButton', 
    tr('Moving Button'), '/images/topbuttons/minimap', toggle)
  showButton:setOn(false)

  movingButtonWindow = g_ui.displayUI('movingbutton')
  movingButtonWindow:disableResize()

  movingButton = movingButtonWindow:recursiveGetChildById('movingButton')
  movingButtonWindow.onHoverChange = move

  movingButtonWindow:setup()

  posx = movingButtonWindow:getWidth() - 100
  posy = movingButtonWindow:getHeight() * 0.75

  movingButton:setX(posx + movingButtonWindow:getX())
  movingButton:setY(posy + movingButtonWindow:getY())

  periodicalEvent(move, function()
    return movingButtonWindow:isVisible()
  end, 30, 30)

  connect(g_game, { onGameEnd = hide,
                    onOpenMovingButton = onOpenMovingButton } )
end

function terminate()
  movingButtonWindow:destroy()
  showButton:destroy()

  disconnect(g_game, {  onGameEnd = hide,
                        onOpenMovingButton = onOpenMovingButton } )
end

function move()
  local windowSize = {width = movingButtonWindow:getWidth(), height = movingButtonWindow:getHeight()}

  posx = posx - 5

  if posx < 50 then
    posx = windowSize.width - 100
    posy = posy - (windowSize.height * 0.25)
  end

  if posy < (windowSize.height * 0.1) then
    posx = windowSize.width - 100
    posy = windowSize.height * 0.75
  end
  
  movingButton:setX(posx + movingButtonWindow:getX())
  movingButton:setY(posy + movingButtonWindow:getY())
end

function onOpenMovingButton()
  movingButtonWindow:open()
  showButton:setOn(true)
end

function hide()
  movingButtonWindow:close()
end

function onMiniWindowClose()
  showButton:setOn(false)
end

function toggle()
  if showButton:isOn() then
    movingButtonWindow:close()
    showButton:setOn(false)
  else
    movingButtonWindow:open()
    showButton:setOn(true)
  end
end

function doNothing()
  -- do nothing!
end
