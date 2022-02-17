Characters.mainCam = nil
Characters.characters = {}
Characters.secondCam = nil
local activePed = nil
local inSelecting = false
local selectedCid = nil
local switching = false
Characters.thread = nil

Characters.Config.Camera.fov = Characters.Config.Camera.fov * 1920 / 1080

CreateThread(function()
	while (not NetworkIsSessionStarted()) do Wait(50) 
    end
	TriggerServerEvent("xz-characters:setPlayerInCharactersMode")
end)

RegisterNetEvent("xz-characters:initCharacters",function()
    Characters:Init()
end)

RegisterNetEvent("xz:multicharacters:logout",function()
    if not inSelecting then
        Characters:Init()
    end
end)



RegisterNetEvent("xz-characters:setPlayerInClothingMode",function()
    DoScreenFadeOut(10)
    Wait(1000)
    local interior = GetInteriorAtCoords(-811.89245605469, 175.08549499512, 76.745391845703)
    LoadInterior(interior)
    while not IsInteriorReady(interior) do
        Wait(1000)
    end
    Characters:Reset()
    SetEntityCoords(PlayerPedId(),-811.89245605469, 175.08549499512, 76.745391845703)

    NetworkSetEntityInvisibleToNetwork(PlayerPedId(),true)
    TriggerEvent("xz-clothing:setclothes",{})
    DoScreenFadeIn(500)
    Wait(500)
	FreezeEntityPosition(PlayerPedId(), true)
end)

function Characters:Reset()
    SendNUIMessage({
        action="clearscreen"
    })

    inSelecting = false
    selectedChar = nil
    activePed = nil
    self.thread = nil
    self.secondCam = nil
    SetNuiFocus(false)
    NetworkSetEntityInvisibleToNetwork(PlayerPedId(),false)
    if #self.characters > 0 then
        for _,ped in pairs(self.characters) do
            DeletePed(ped.ped)
        end
        self.characters = {}
    end
    RenderScriptCams(false, false, 1, true, true)
    DestroyAllCams(true)
end

function Characters:Init()
    self:Reset()
    inSelecting = true
    DoScreenFadeOut(1000)
    Wait(1000)
    local ped = PlayerPedId()
    print(self.Config.Camera.coords)

    SetEntityCoords(ped,self.Config.Camera.coords.xy,self.Config.Camera.coords.z - 30.0)
    NetworkSetEntityInvisibleToNetwork(ped,true)
    if not DoesCamExist(self.mainCam) then
        self.mainCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    end
    local sx, sy = GetActiveScreenResolution()
    self:CreateCharacters()

    

    SetCamActive(self.mainCam, true)
    SetCamRot(self.mainCam,self.Config.Camera.rot, true)
    SetCamFov(self.mainCam,self.Config.Camera.fov * sy/sx)
    SetCamCoord(self.mainCam, self.Config.Camera.coords)
    PointCamAtCoord(self.mainCam,self.Config.Camera.coords)
    RenderScriptCams(true, false, 2500.0, true, true)
    SetFocusPosAndVel(self.Config.Camera.coords,0.0,0.0,0.0)
    for _,char in pairs(self.characters) do
        SetEntityVisible(char.ped,true)
    end 
end

function Characters:CreateCharacters()
    XZCore.Functions.TriggerCallback("xz:multicharacters:getCharacters", function(characters)
        for slot, loc in ipairs(self.Config.Locations) do
            local char = characters[slot] 
            local chardata = {}
            if char == nil then
                chardata = {
                    name = "Create New",
                    citizenid = ""
                }
            else
                chardata = {
                    name =  char.info.firstname.." "..char.info.lastname,
                    nationality = char.info.nationality,
                    citizenid = char.citizenid,
                    dob = char.info.birthdate,
                    job = char.job.label,
                    cash = char.money.cash,
                    bank = char.money.bank,
                    phone = char.info.phone
                }
            end
            self.characters[#self.characters+1] = {
                ped = self:CreatePed(loc,char),
                isNew = char == nil,
                data = chardata,
                clothing = char ~= nil and char or {},
                cid = slot
            }
        end
        for _,ped in pairs(Characters.characters) do
            SetEntityVisible(ped.ped,true)
        end
        ShutdownLoadingScreenNui()
        ShutdownLoadingScreen()
        SetNuiFocus(true,true)
        self:Thread()
     

        DoScreenFadeIn(3500)

        SetEntityCoordsNoOffset(PlayerPedId(), vector3(-3972.28, 2017.22, 500.92), false, false, false, false)
		FreezeEntityPosition(PlayerPedId(), true)

		while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
			Wait(0)
		end

		while not HasCollisionForModelLoaded(GetHashKey("sp_01_station")) do
			Wait(0)
		end

        while not HasModelLoaded(GetHashKey("sp_01_station")) do
            Wait(100)
        end
		Wait(2500)

        spawnTrain()
    end)
end

function VecLerp(x1, y1, z1, x2, y2, z2, l, clamp)
    if clamp then
        if l < 0.0 then l = 0.0 end
        if l > 1.0 then l = 1.0 end
    end
    local x = Lerp(x1, x2, l)
    local y = Lerp(y1, y2, l)
    local z = Lerp(z1, z2, l)
    return vector3(x, y, z)
end

function Lerp(a, b, t)
    return a + (b - a) * t
end

function LocationInWorld(coords,camera)

    local position = GetCamCoord(camera)

    --- Getting Object using raycast
    local ped = PlayerPedId()
    local raycast = StartShapeTestRay(position.x,position.y,position.z, coords.x,coords.y,coords.z, 8, ped, 0)
    local retval, hit, endCoords, surfaceNormal, entity = GetShapeTestResult(raycast)
    
    return entity

end

local isTrainMoving = false

function spawnTrain()

	local tempmodel = GetHashKey("metrotrain")
	RequestModel(tempmodel)
	while not HasModelLoaded(tempmodel) do
		RequestModel(tempmodel)
		Citizen.Wait(0)
	end 

    local coords = vector3(-3948.49,2036.35,499.1)
    vehicle = CreateVehicle(tempmodel, coords, 160.0, false, false)
    FreezeEntityPosition(vehicle, true)
     
    local heading = GetEntityHeading(vehicle)
    local coords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -11.0, 0.0)

    vehicleBack = CreateVehicle(tempmodel, coords, 158.0, false, false)
    FreezeEntityPosition(vehicleBack, true)
    AttachEntityToEntity(vehicleBack , vehicle , 51 , 0.0, -11.0, 0.0, 180.0, 180.0, 0.0, false, false, false, false, 0, true)

    Citizen.CreateThread(function()
        print("CHOOCHOO")
    	isTrainMoving = true
	    for i=1,100 do
	    	local posoffset = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 0.0, 0.0)
	    	local setpos = VecLerp(-3948.49,2036.35,499.1, -3957.58,2008.75, 499.1, i/100, true)
	    	SetEntityCoords(vehicle,setpos)
	  		Wait(15)
	    end
	    isTrainMoving = false
	end)
end

function deleteTrain()
	if vehicle ~= nil then
		DeleteEntity(vehicle)
		DeleteEntity(vehicleBack)
	end
end

RegisterNetEvent("xz:multicharacters:spawnCharacter",function(isNew,gender)
    SendNUIMessage({
        action="clearscreen"
    })
    Characters:Reset()
    deleteTrain()
    DoScreenFadeOut(1000)
    Wait(1000)
    ClearFocus()
end)

RegisterNUICallback("register",function(data,cb)
    if selectedChar ~= nil and selectedChar.ped ~= nil and not switching then
        switching = true
        SetCamActiveWithInterp(Characters.mainCam ,Characters.secondCam , 750, 200, 200)
        for _,char in pairs(Characters.characters) do
            if char.ped ~= selctedPed then
                SetEntityVisible(char.ped,true)
            end
        end
        data.r_data.cid = selectedChar.cid
        local newData = {
            cid = selectedChar.cid,
            charinfo = {
                firstname = data.r_data.firstname,
                lastname = data.r_data.lastname,
                birthdate = data.r_data.date,
                gender = (data.r_data.gender == "male") and 0 or 1,
                nationality = data.r_data.nationality
            }
        }
        selectedChar = nil
        cb("false")
        Wait(700)
        switching = false
        TriggerServerEvent("xz:multicharacters:registerCharacter",newData)
    end
end)

RegisterNUICallback("playChar",function (data,cb)
    TriggerServerEvent("xz:multicharacters:loadCharacter", selectedChar.data.citizenid)
end)

RegisterNUICallback("delete",function(data,cb)
    XZCore.Functions.TriggerCallback("xz:multicharacters:deleteCharacter",function()
        SendNUIMessage({
            action = "reset"
        })
        DoScreenFadeOut(500)
        Wait(500)
        Characters:Init()
    end,selectedChar.data.citizenid)
end)

RegisterNUICallback("click_event",function(data,cb)
    local primary = data.primary

    if primary then
        if(activePed) ~= nil and not switching then
            switching = true
            if not DoesCamExist(Characters.secondCam) then
                Characters.secondCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            end
            selectedChar = activePed
            for _,char in pairs(Characters.characters) do
                if char.ped ~= selectedChar.ped then
                    SetEntityVisible(char.ped,false)
                end
            end
            SetCamCoord(Characters.secondCam,Characters.Config.Camera.coords)
            local rx,ry,rz = table.unpack(GetEntityCoords(selectedChar.ped))
            PointCamAtCoord(Characters.secondCam,rx,ry,rz-0.1)
            SetCamFov(Characters.secondCam,15.0)
            if selectedChar.cid == 5 or selectedChar.cid == 1 then SetCamFov(Characters.secondCam,17.5) end
            SendNUIMessage({
                action = "hideIcons"
            })
            SetCamActiveWithInterp(Characters.secondCam, Characters.mainCam, 750, 200, 200)
            if selectedChar.isNew then
                cb("register")
            else
                cb(selectedChar.data)
            end
            Wait(750)
            switching = false
        else
            cb("none")
        end
    else
        if selectedChar ~= nil and selectedChar.ped ~= nil and not switching then
            switching = true
            SetCamActiveWithInterp(Characters.mainCam ,Characters.secondCam , 750, 200, 200)
            for _,char in pairs(Characters.characters) do
                if char.ped ~= selectedChar.ped then
                    SetEntityVisible(char.ped,true)
                end
            end
            selectedChar = nil
            cb("true")
            Wait(700)
            switching = false
        end
    end
end)

function Characters:Thread()
    Characters.thread = CreateThread(function()
        local temp = false
        while inSelecting do
            local hit,coords,entity = GetEntityMouseOn(Characters.mainCam)
            local found = false
            for _, char in pairs(Characters.characters) do
              if entity == char.ped and selectedChar == nil then
                activePed = char
                SendNUIMessage({
                  action = "showDetails",
                  data = char.data
                })
                temp = true
                found = true
              end
            end

            if not found and temp then
                activePed = nil
              SendNUIMessage({
                action = "clearDetails"
              })
              temp = false
            end
            Wait(200)
        end
    end)
end

AddEventHandler("onResourceStop",function(res)
    if res == GetCurrentResourceName() then
        Characters:Reset()
    end
end)

RegisterCommand("characters:fix",function()
    SetNuiFocus(true,true)
end)