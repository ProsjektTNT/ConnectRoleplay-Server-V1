
  
  function rotationToDirection(rotation)
    local z = degToRad(rotation.z)
    local x = degToRad(rotation.x)
    local num = math.abs(math.cos(x))
  
    return vector3((-math.sin(z) * num),math.cos(z) * num,math.sin(x))
  end
  
  function w2s(position)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(position.x, position.y, position.z)
    if not onScreen then
        return nil
    end
    return vector3((_x - 0.5) * 2,(_y - 0.5) * 2,0.0)
  end
  
  function processCoordinates(x, y)
    local screenX, screenY = GetActiveScreenResolution()
    local relativeX = 1 - (x / screenX) * 1.0 * 2
    local relativeY = 1 - (y / screenY) * 1.0 * 2
  
    if relativeX > 0.0 then
        relativeX = -relativeX;
    else
        relativeX = math.abs(relativeX)
    end
  
    if relativeY > 0.0 then
        relativeY = -relativeY
    else
        relativeY = math.abs(relativeY)
    end
  
    return { x = relativeX, y = relativeY }
  end
  
  function s2w(camPos, relX, relY,cam)
    local camRot = GetCamRot(cam,2)
    local camForward = rotationToDirection(camRot)
    local rotUp = ( camRot + vector3(10.0,0.0,0.0) )
    local rotDown = ( camRot + vector3(-10.0,0.0,0.0) )
    local rotLeft = ( camRot + vector3(0.0,0.0,-10.0) )
    local rotRight = ( camRot + vector3(0.0,0.0,10.0) )
  
    local camRight = (rotationToDirection(rotRight) - rotationToDirection(rotLeft))
    local camUp = (rotationToDirection(rotUp)- rotationToDirection(rotDown))
  
    local rollRad = -degToRad(camRot.y)
    local camRightRoll = ((camRight* math.cos(rollRad))- (camUp* math.sin(rollRad)))
    local camUpRoll = ((camRight* math.sin(rollRad))+ (camUp* math.cos(rollRad)))
  
    local point3D = (((camPos+ (camForward* 10.0))+camRightRoll)+camUpRoll)
  
    local point2D = w2s(point3D)
  
    if point2D == nil then
        return (camPos +  (camForward* 10.0))
    end
  
    local point3DZero = (camPos+ (camForward* 10.0))
    local point2DZero = w2s(point3DZero)
  
    if point2DZero == nil then
        return (camPos+ (camForward* 10.0))
    end
  
    local eps = 0.001
    if math.abs(point2D.x - point2DZero.x) < eps or math.abs(point2D.y - point2DZero.y) < eps then
        return (camPos + (camForward* 10.0))
    end
  
    local scaleX = (relX - point2DZero.x) / (point2D.x - point2DZero.x)
    local scaleY = (relY - point2DZero.y) / (point2D.y - point2DZero.y)
    local point3Dret = (((camPos+ (camForward* 10.0))+ (camRightRoll* scaleX))+ (camUpRoll* scaleY))
  
    return point3Dret
  end
  
  function degToRad(deg)
    return (deg * math.pi) / 180.0
  end
  
  function screenToWorld(flags, cam)
    local x, y = GetNuiCursorPosition()
  
    local absoluteX = x
    local absoluteY = y
  
    local camPos = GetGameplayCamCoord()
    camPos = GetCamCoord(cam)
    local processedCoords = processCoordinates(absoluteX, absoluteY)
    local target = s2w(camPos, processedCoords.x, processedCoords.y,cam)
  
    local dir = (target-camPos)
    local from = (camPos+(dir* 0.05))
    local to = (camPos+(dir* 300))
  
    local ray = StartShapeTestRay(from.x, from.y, from.z, to.x, to.y, to.z, flags, ignore, 0)
    local a, b, c, d, e = GetShapeTestResult(ray)
    return b, c, e, to
  end
  
function GetEntityMouseOn(cam)
    local hit,endCoords,entityHit,_ = screenToWorld(8,cam)
    return hit,endCoords,entityHit
end

function Characters:CreatePed(location,char)
    if char == nil then
        local hashKey = `mp_m_freemode_01`
        local pedType = 3
        RequestModel(hashKey)
        while not HasModelLoaded(hashKey) do
            Wait(100)
        end
        local myped = CreatePed(pedType,hashKey,location.pos.x,location.pos.y,location.pos.z -1.0,90.0, 0, 0)
        SetEntityCanBeDamaged(myped,false)
        FreezeEntityPosition(myped,true)
        ClearPedTasks(myped)
        SetEntityAlpha(myped, 130, false)
        ClearPedSecondaryTask(myped)
        TaskSetBlockingOfNonTemporaryEvents(myped, true)
        SetPedFleeAttributes(myped, 0, 0)
        SetPedCombatAttributes(myped, 17, 1)
        SetPedSeeingRange(myped, 0.0)
        SetPedHearingRange(myped, 0.0)
        SetPedAlertness(myped, 0)
        SetPedKeepTask(myped, true)
        SetModelAsNoLongerNeeded(hashKey)
        SetEntityHeading(myped,location.heading)
        SetEntityVisible(myped,false)
        return myped
    else
        local hashKey = char.model ~= nil and tonumber(char.model) or `mp_m_freemode_01`
        local pedType = 3

        print(tonumber(char.model))
        for k, v in pairs(Characters.Config.BlackList) do
            if(hashKey == v) then
                hashKey = `mp_m_freemode_01`
            end
        end

        RequestModel(hashKey)
        while not HasModelLoaded(hashKey) do
            Wait(100)
        end

        local myped = CreatePed(pedType, hashKey, location.pos.x, location.pos.y, location.pos.z - 1.0, 90.0, 0, 0);

        SetClothing(myped,char.drawables, char.props, char.drawtextures, char.proptextures, char.tattoos)
        SetFace(myped,char.headBlend, char.hairColor, char.headStructure, char.headOverlay)
        SetEntityCanBeDamaged(myped,false)
        FreezeEntityPosition(myped,true)
        ClearPedTasks(myped)
        ClearPedSecondaryTask(myped)
        TaskSetBlockingOfNonTemporaryEvents(myped, true)
        SetPedFleeAttributes(myped, 0, 0)
        SetPedCombatAttributes(myped, 17, 1)
        SetPedSeeingRange(myped, 0.0)
        SetPedHearingRange(myped, 0.0)
        SetPedAlertness(myped, 0)
        SetPedKeepTask(myped, true)
        SetModelAsNoLongerNeeded(hashKey)
        SetEntityHeading(myped,location.heading)
        SetEntityVisible(myped,false)
        return myped
    end
end


local drawable_names = {"face", "masks", "hair", "torsos", "legs", "bags", "shoes", "neck", "undershirts", "vest", "decals", "jackets"}
local prop_names = {"hats", "glasses", "earrings", "mouth", "lhand", "rhand", "watches", "braclets"}
local head_overlays = {"Blemishes","FacialHair","Eyebrows","Ageing","Makeup","Blush","Complexion","SunDamage","Lipstick","MolesFreckles","ChestHair","BodyBlemishes","AddBodyBlemishes"}
local face_features = {"Nose_Width","Nose_Peak_Hight","Nose_Peak_Lenght","Nose_Bone_High","Nose_Peak_Lowering","Nose_Bone_Twist","EyeBrown_High","EyeBrown_Forward","Cheeks_Bone_High","Cheeks_Bone_Width","Cheeks_Width","Eyes_Openning","Lips_Thickness","Jaw_Bone_Width","Jaw_Bone_Back_Lenght","Chimp_Bone_Lowering","Chimp_Bone_Lenght","Chimp_Bone_Width","Chimp_Hole","Neck_Thikness"}

function SetClothing(ped, drawables, props, drawTextures, propTextures, playerTattoos)
    for i = 1, #drawable_names do
        print(drawables)
        if drawables[0] == nil then
            if drawable_names[i] == "undershirts" and drawables[tostring(i-1)][2] == -1 then
                SetPedComponentVariation(ped, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(ped, i-1, drawables[tostring(i-1)][2], drawTextures[i][2], 2)
            end
        else
            if drawable_names[i] == "undershirts" and drawables[i-1][2] == -1 then
                SetPedComponentVariation(ped, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(ped, i-1, drawables[i-1][2], drawTextures[i][2], 2)
            end
        end
    end

    for i = 1, #prop_names do
        local propZ = (drawables[0] == nil and props[tostring(i-1)][2] or props[i-1][2])
        ClearPedProp(ped, i-1)
        SetPedPropIndex(ped,i-1,propZ,propTextures[i][2], true)
    end

    if ped == 1885233650 and ped == -1667301416 then
        ClearPedDecorations(ped)

        for index = 1, #playerTattoos do
            ApplyPedOverlay(ped, playerTattoos[index][1], playerTattoos[index][2])
        end
    end
end

function SetFace(player, head, haircolor, headStructure, headOverlay)
    if head then
        SetPedHeadBlendData(player,
            tonumber(head['shapeFirst']),
            tonumber(head['shapeSecond']),
            tonumber(head['shapeThird']),
            tonumber(head['skinFirst']),
            tonumber(head['skinSecond']),
            tonumber(head['skinThird']),
            tonumber(head['shapeMix']),
            tonumber(head['skinMix']),
            tonumber(head['thirdMix']),
        false)
    end
    if headStructure then
        for i = 1, #face_features do
            SetPedFaceFeature(player, i-1, headStructure[i])
        end
    end
    if haircolor then
        SetPedHairColor(player, tonumber(haircolor[1]), tonumber(haircolor[2]))
    end
    if headOverlay then
        if json.encode(headOverlay) ~= "[]" then
            for i = 1, #head_overlays do
                SetPedHeadOverlay(player,  i-1, tonumber(headOverlay[i].overlayValue),  tonumber(headOverlay[i].overlayOpacity))
            end
            SetPedHeadOverlayColor(player, 0, 0, tonumber(headOverlay[1].firstColour), tonumber(headOverlay[1].secondColour))
            SetPedHeadOverlayColor(player, 1, 1, tonumber(headOverlay[2].firstColour), tonumber(headOverlay[2].secondColour))
            SetPedHeadOverlayColor(player, 2, 1, tonumber(headOverlay[3].firstColour), tonumber(headOverlay[3].secondColour))
            SetPedHeadOverlayColor(player, 3, 0, tonumber(headOverlay[4].firstColour), tonumber(headOverlay[4].secondColour))
            SetPedHeadOverlayColor(player, 4, 2, tonumber(headOverlay[5].firstColour), tonumber(headOverlay[5].secondColour))
            SetPedHeadOverlayColor(player, 5, 2, tonumber(headOverlay[6].firstColour), tonumber(headOverlay[6].secondColour))
            SetPedHeadOverlayColor(player, 6, 0, tonumber(headOverlay[7].firstColour), tonumber(headOverlay[7].secondColour))
            SetPedHeadOverlayColor(player, 7, 0, tonumber(headOverlay[8].firstColour), tonumber(headOverlay[8].secondColour))
            SetPedHeadOverlayColor(player, 8, 2, tonumber(headOverlay[9].firstColour), tonumber(headOverlay[9].secondColour))
            SetPedHeadOverlayColor(player, 9, 0, tonumber(headOverlay[10].firstColour), tonumber(headOverlay[10].secondColour))
            SetPedHeadOverlayColor(player, 10, 1, tonumber(headOverlay[11].firstColour), tonumber(headOverlay[11].secondColour))
            SetPedHeadOverlayColor(player, 11, 0, tonumber(headOverlay[12].firstColour), tonumber(headOverlay[12].secondColour))
        end
    end
end