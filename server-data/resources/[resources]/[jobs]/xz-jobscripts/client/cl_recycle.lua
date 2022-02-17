local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}
XZCore = nil

Citizen.CreateThread(function()
    while XZCore == nil do
        TriggerEvent('XZCore:GetObject', function(obj) XZCore = obj end)
        Citizen.Wait(200)
    end
end)

local carryPackage = nil
local onDuty = false
Citizen.CreateThread(function ()
    local RecycleBlip = AddBlipForCoord(Recycle['delivery'].outsideLocation.x, Recycle['delivery'].outsideLocation.y, Recycle['delivery'].outsideLocation.z)
    SetBlipSprite(RecycleBlip, 365)
    SetBlipColour(RecycleBlip, 2)
    SetBlipScale(RecycleBlip, 0.6)
    SetBlipAsShortRange(RecycleBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Recycle Center")
    EndTextCommandSetBlipName(RecycleBlip)
    while true do
        Citizen.Wait(7)
        local pos = GetEntityCoords(PlayerPedId(), true)
        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Recycle['delivery'].outsideLocation.x, Recycle['delivery'].outsideLocation.y, Recycle['delivery'].outsideLocation.z, true) < 1.3 then
            DrawText3DDD(Recycle['delivery'].outsideLocation.x, Recycle['delivery'].outsideLocation.y, Recycle['delivery'].outsideLocation.z + 1, "~g~E~w~ - To enter")
            if IsControlJustReleased(0, Keys["E"]) then
                DoScreenFadeOut(500)
                while not IsScreenFadedOut() do
                    Citizen.Wait(10)
                end
                SetEntityCoords(PlayerPedId(), Recycle['delivery'].insideLocation.x, Recycle['delivery'].insideLocation.y, Recycle['delivery'].insideLocation.z)
                DoScreenFadeIn(500)
            end
        end
        ---- BINNEN
        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Recycle['delivery'].insideLocation.x, Recycle['delivery'].insideLocation.y, Recycle['delivery'].insideLocation.z, true) < 15 and not IsPedInAnyVehicle(PlayerPedId(), false) and not onDuty then
            DrawMarker(25, Recycle['delivery'].insideLocation.x, Recycle['delivery'].insideLocation.y, Recycle['delivery'].insideLocation.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 98, 102, 185,100, 0, 0, 0,0)
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Recycle['delivery'].insideLocation.x, Recycle['delivery'].insideLocation.y, Recycle['delivery'].insideLocation.z, true) < 1.3 then
                DrawText3DDD(Recycle['delivery'].insideLocation.x, Recycle['delivery'].insideLocation.y, Recycle['delivery'].insideLocation.z + 1, "~g~E~w~ - To go outside")
                if IsControlJustReleased(0, Keys["E"]) then
                    DoScreenFadeOut(500)
                    while not IsScreenFadedOut() do
                        Citizen.Wait(10)
                    end
                    SetEntityCoords(PlayerPedId(), Recycle['delivery'].outsideLocation.x, Recycle['delivery'].outsideLocation.y, Recycle['delivery'].outsideLocation.z + 1)
                    DoScreenFadeIn(500)
                end
            end
        end
        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, 1049.15,-3100.63,-39.95, true) < 15 and not IsPedInAnyVehicle(PlayerPedId(), false) and carryPackage == nil then
            DrawMarker(25, 1049.15,-3100.63,-39.95, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 255, 0, 0,100, 0, 0, 0,0)
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, 1049.15,-3100.63,-39.95, true) < 1.3 then
                if onDuty then
                    DrawText3DDD(1049.15,-3100.63,-39.95 + 1, "~r~E~w~ - To clock out")
                else
                    DrawText3DDD(1049.15,-3100.63,-39.95 + 1, "~g~E~w~ -  To clock in")
                end
                if IsControlJustReleased(0, Keys["E"]) then
                    onDuty = not onDuty
                    if onDuty then
                        XZCore.Functions.Notify("You have checked in")
                    else
                        XZCore.Functions.Notify("You have checked out!", "error")
                    end
                end
            end
        end
    end
end)

local packagePos = nil
Citizen.CreateThread(function ()
    for k, pickuploc in pairs(Recycle['delivery'].pickupLocations) do
        local model = GetHashKey(Recycle['delivery'].warehouseObjects[math.random(1, #Recycle['delivery'].warehouseObjects)])
        RequestModel(model)
        while not HasModelLoaded(model) do Citizen.Wait(0) end
        local obj = CreateObject(model, pickuploc.x, pickuploc.y, pickuploc.z, false, true, true)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
    end
    while true do
        Citizen.Wait(7)
        if onDuty then
            if packagePos ~= nil then
                local pos = GetEntityCoords(PlayerPedId(), true)
                if carryPackage == nil then
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, packagePos.x,packagePos.y,packagePos.z, true) < 2.3 then
                        DrawText3DDD(packagePos.x,packagePos.y,packagePos.z+ 1, "~g~E~w~ - Pack package")
                        if IsControlJustReleased(0, Keys["E"]) then
                            TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
                            XZCore.Functions.Progressbar("pickup_reycle_package", "Picking the package..", 10000, false, true, {}, {}, {}, {}, function() -- Done
                                ClearPedTasks(PlayerPedId())
                                PickupPackage()
                            end)
                        end
                    else
                        DrawText3DDD(packagePos.x, packagePos.y, packagePos.z + 1, "Packaging")
                    end
                else
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Recycle['delivery'].dropLocation.x, Recycle['delivery'].dropLocation.y, Recycle['delivery'].dropLocation.z, true) < 2.0 then
                        DrawText3DDD(Recycle['delivery'].dropLocation.x, Recycle['delivery'].dropLocation.y, Recycle['delivery'].dropLocation.z, "~g~E~w~ - Hand in the package")
                        if IsControlJustReleased(0, Keys["E"]) then
                            DropPackage()
                            ScrapAnim()
                            XZCore.Functions.Progressbar("deliver_reycle_package", "Packaging..", 10000, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                                TriggerServerEvent('xz-recycle:server:getItem')
                                GetRandomPackage()
                            end)
                        end
                    else
                        DrawText3DDD(Recycle['delivery'].dropLocation.x, Recycle['delivery'].dropLocation.y, Recycle['delivery'].dropLocation.z, "Hand your package over here")
                    end
                end
            else
                GetRandomPackage()
            end
        end
    end
end)

function ScrapAnim()
    local time = 5
    loadAnimDict("mp_car_bomb")
    TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(1000)
            time = time - 1
            if time <= 0 then
                openingDoor = false
                StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
            end
        end
    end)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function GetRandomPackage()
    local randSeed = math.random(1, #Recycle["delivery"].pickupLocations)
    packagePos = {}
    packagePos.x = Recycle["delivery"].pickupLocations[randSeed].x
    packagePos.y = Recycle["delivery"].pickupLocations[randSeed].y
    packagePos.z = Recycle["delivery"].pickupLocations[randSeed].z
end

function PickupPackage()
    local pos = GetEntityCoords(PlayerPedId(), true)
    RequestAnimDict("anim@heists@box_carry@")
    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do
        Citizen.Wait(7)
    end
    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    local model = GetHashKey("prop_cs_cardbox_01")
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)
    AttachEntityToEntity(object, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.05, 0.1, -0.3, 300.0, 250.0, 20.0, true, true, false, true, 1, true)
    carryPackage = object
end

function DropPackage()
    ClearPedTasks(PlayerPedId())
    DetachEntity(carryPackage, true, true)
    DeleteObject(carryPackage)
    carryPackage = nil
end