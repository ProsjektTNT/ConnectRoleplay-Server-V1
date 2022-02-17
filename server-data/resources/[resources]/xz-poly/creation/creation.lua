lastCreatedZone = nil
createdZone = nil
drawZone = false

RegisterNetEvent("polyzone:pzcreate")
AddEventHandler("polyzone:pzcreate", function(name, args)
  if createdZone ~= nil then
    TriggerEvent('chat:addMessage', {
      color = { 255, 0, 0},
      multiline = true,
      args = {"Me", "A shape is already being created!"}
    })
    return
  end

  polyStart(name)
  drawZone = true
  drawThread()
end)

RegisterNetEvent("polyzone:pzfinish")
AddEventHandler("polyzone:pzfinish", function()
  if createdZone == nil then
    return
  end

  polyFinish()

  TriggerEvent('chat:addMessage', {
    color = { 0, 255, 0},
    multiline = true,
    args = {"Me", "Check your server root folder for polyzone_created_zones.txt to get the zone!"}
  })

  lastCreatedZone = createdZone

  drawZone = false
  createdZone = nil
end)

RegisterNetEvent("polyzone:pzlast")
AddEventHandler("polyzone:pzlast", function()
  if createdZone ~= nil or lastCreatedZone == nil then
    return
  end

  TriggerEvent('chat:addMessage', {
    color = { 0, 255, 0},
    multiline = true,
    args = {"Me", "The command pzlast only supports BoxZone and CircleZone for now"}
  })

  local name = GetUserInput("Enter name (or leave empty to reuse last zone's name):")
  if name == nil then
    return
  elseif name == "" then
    name = lastCreatedZone.name
  end
  drawZone = true
  drawThread()
end)

RegisterNetEvent("polyzone:pzcancel")
AddEventHandler("polyzone:pzcancel", function()
  if createdZone == nil then
    return
  end

  TriggerEvent('chat:addMessage', {
    color = {255, 0, 0},
    multiline = true,
    args = {"Me", "Zone creation canceled!"}
  })

  drawZone = false
  createdZone = nil
end)

-- Drawing
function drawThread()
  Citizen.CreateThread(function()
    while drawZone do
      if createdZone then
        createdZone:draw()
      end
      Wait(0)
    end
  end)
end
