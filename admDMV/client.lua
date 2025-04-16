vRPC = {}
Tunnel.bindInterface("admDMV", vRPC)
Proxy.addInterface("admDMV", vRPC)
vRP = Proxy.getInterface("vRP")
vRPS = Tunnel.getInterface("admDMV", "admDMV")
-- backend u nu a fost scris de mine
CarSpawnLocs = nil
CarStopsLocs = nil
theBlips = {}
CarStopsBlip = nil
theCar = nil
hasCarRouteStarted = false
CarCheckpoint = 0
atCarStop = false
finishCarRoute = {}
finishBlip = nil
CarBlip = nil
CarStopsBlip2 = nil
started = false
InvokeNative = Citizen.InvokeNative
local greseli = 0
local lastErrorTime = 0
local errorCooldown = 5

local vehicle = {
    ['car'] = 'asbo'
}

RegisterNUICallback('givePermis', function()
    vRPS.startDMV({ 'car' })
    SetNuiFocus(false, false)
end)

RegisterNUICallback('noPermis', function()
    vRP.notify({ "Eroare: Ai picat testul!" })
    SetNuiFocus(false, false)
end)

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

local pedCoords = vec3(217.96939086914, -1391.5068359375, 29.587491989136)

CreateThread(function()
    local blip = AddBlipForCoord(pedCoords)
    SetBlipSprite(blip, 280)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, 2)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Scoala Auto")
    EndTextCommandSetBlipName(blip)

    local pedHash = GetHashKey('a_m_y_business_02')
    RequestModel(pedHash)
    repeat Wait(0) until HasModelLoaded(pedHash)

    npc = CreatePed(1, pedHash, pedCoords, -40.0, false, false)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)

    while true do
        local tiks = 1000
        local pedPos = GetEntityCoords(PlayerPedId())
        if #(pedPos - pedCoords) < 3 then
            DrawText3Ds(217.96939086914, -1391.5068359375, 30.887491989136, 'Scoala Auto \n Apasa ~r~E~w~ pentru a sustine examenul')
            tiks = 1
            if IsControlJustReleased(0, 38) then
                SetNuiFocus(true, true)
                SendNuiMessage(json.encode({ dmvadam = true }))
            end
        end
        Wait(tiks)
    end
end)

function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local scale = (1 / GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.35 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 155)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry('STRING')
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
local function nextCarStop()
    CarCheckpoint = CarCheckpoint + 1
    if CarStopsLocs[CarCheckpoint][4] then
        blipColor = 1
    else
        blipColor = 2
    end

    if CarStopsBlip == nil or DoesBlipExist(CarStopsBlip) then
        if DoesBlipExist(CarStopsBlip) then RemoveBlip(CarStopsBlip) end
        CarStopsBlip = AddBlipForCoord(CarStopsLocs[CarCheckpoint][1], CarStopsLocs[CarCheckpoint][2], CarStopsLocs[CarCheckpoint][3])
        SetBlipRoute(CarStopsBlip, true)
        SetBlipSprite(CarStopsBlip, 11)
        SetBlipColour(CarStopsBlip, blipColor)
        SetBlipRouteColour(CarStopsBlip, 2)
    end

    if CarCheckpoint + 1 <= #CarStopsLocs then
        if CarStopsBlip2 == nil or DoesBlipExist(CarStopsBlip2) then
            if DoesBlipExist(CarStopsBlip2) then RemoveBlip(CarStopsBlip2) end
            CarStopsBlip2 = AddBlipForCoord(CarStopsLocs[CarCheckpoint+1][1], CarStopsLocs[CarCheckpoint+1][2], CarStopsLocs[CarCheckpoint+1][3])
            SetBlipSprite(CarStopsBlip2, 270)
            SetBlipColour(CarStopsBlip2, 1)
        end
    end
end

function startCarRoute()
    hasCarRouteStarted = true
    for i, v in pairs(theBlips) do
        if DoesBlipExist(v) then
            RemoveBlip(v)
            theBlips[i] = nil
        end
    end
    nextCarStop()
    vRP.notify({"Eroare: Mergi si asteapta la fiecare semafor pentru a lua permisul!"})
end

function vRPC.StartSchool(CarSpawns, CarLocs, finishTrash, t)
    TriggerEvent("InteractSound_CL:PlayOnOne", "permis", 5)
    started = true
    vehicul = t
    spawnTheCar(vehicul, CarSpawns)
    CarSpawnLocs = CarSpawns
    CarStopsLocs = CarLocs
    finishCarRoute = finishTrash

    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle ~= 0 then
        local npcModel = "a_m_m_business_01"
        RequestModel(GetHashKey(npcModel))
        while not HasModelLoaded(GetHashKey(npcModel)) do Wait(100) end
        local npc = CreatePedInsideVehicle(vehicle, 4, GetHashKey(npcModel), 0, true, false)
        SetBlockingOfNonTemporaryEvents(npc, true)
        SetEntityInvincible(npc, true)
        FreezeEntityPosition(npc, true)
        TaskSetBlockingOfNonTemporaryEvents(npc, true)
    end
	CreateThread(function()
		while started do
			Wait(0)
			local ped = PlayerPedId()	
			local pos = GetEntityCoords(ped, true)
			local playerPed = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(playerPed, false)
	
			if((not DoesEntityExist(theCar)) or (IsEntityDead(theCar))) and (hasCarRouteStarted)then
				stopCarRoute()
				theCar = nil
			end
			if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == playerPed then
				local speed = GetEntitySpeed(vehicle) * 3.6 -- conversie m/s în km/h
				if speed > 90 then
					local currentTime = GetGameTimer() / 1000 -- în secunde
				
					if currentTime - lastErrorTime >= errorCooldown then
						greseli = greseli + 1
						lastErrorTime = currentTime
						print('Trecut limita de viteză! Greșeli: ' .. greseli)
				
						if greseli >= 3 then
							stopCarRoute()
						end
					end
				end				
			end				
			if theCar ~= nil then
				if GetVehiclePedIsIn(ped, false) == theCar and GetPedInVehicleSeat(theCar, -1) == ped then
					if(hasCarRouteStarted == false)then
						startCarRoute()
					end
					if tonumber(#CarStopsLocs) > tonumber(CarCheckpoint) then
						if(#CarStopsLocs >= CarCheckpoint+1)then
							if CarStopsLocs[CarCheckpoint+1][4] then
								DrawMarker(1, CarStopsLocs[CarCheckpoint+1][1], CarStopsLocs[CarCheckpoint+1][2], CarStopsLocs[CarCheckpoint+1][3]-1.0, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 200.0, 0, 255, 0, 180, 0, 0, 0, 0)
							else
								DrawMarker(1, CarStopsLocs[CarCheckpoint+1][1], CarStopsLocs[CarCheckpoint+1][2], CarStopsLocs[CarCheckpoint+1][3]-1.0, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 200.0, 255, 255, 0, 180, 0, 0, 0, 0)
							end
						end
						if CarStopsLocs[CarCheckpoint][4] then
							DrawMarker(1, CarStopsLocs[CarCheckpoint][1], CarStopsLocs[CarCheckpoint][2], CarStopsLocs[CarCheckpoint][3]-1.0, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 200.0, 0, 255, 0, 180, 0, 0, 0, 0)
							if #(pos - vector3(CarStopsLocs[CarCheckpoint][1],CarStopsLocs[CarCheckpoint][2],CarStopsLocs[CarCheckpoint][3])) < 8.0 then
								if not atCarStop then
									stopAtCarStop(true)
								end
							else
								atCarStop = false
							end
						else
							DrawMarker(1, CarStopsLocs[CarCheckpoint][1], CarStopsLocs[CarCheckpoint][2], CarStopsLocs[CarCheckpoint][3]-1.0, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 200.0, 255, 255, 0, 180, 0, 0, 0, 0)
							if #(pos - vector3(CarStopsLocs[CarCheckpoint][1],CarStopsLocs[CarCheckpoint][2],CarStopsLocs[CarCheckpoint][3])) < 8.0 then
								stopAtCarStop(false)
							end
						end
					end
					if CarCheckpoint == #CarStopsLocs then
						if finishBlip == nil then
							finishBlip = AddBlipForCoord(finishCarRoute[1], finishCarRoute[2], finishCarRoute[3])
							SetBlipSprite(finishBlip, 270)
							SetBlipColour(finishBlip, 15)
							SetBlipAsShortRange(finishBlip, false)
						end
						DrawMarker(1, finishCarRoute[1], finishCarRoute[2], finishCarRoute[3]-1.0, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 200.0, 0, 255, 0, 180, 0, 0, 0, 0)
						if #(pos - vector3(finishCarRoute[1],finishCarRoute[2],finishCarRoute[3])) < 5.0 then
							if IsControlJustReleased(1, 51) then
								vRPC.finishCarRoute(vehicul)
							end
						end
					end
					if DoesBlipExist(CarBlip) then
						RemoveBlip(CarBlip)
						CarBlip = nil
					end
				else
					if CarBlip == nil then
						CarBlip = AddBlipForEntity(theCar)
						SetBlipSprite(CarBlip, 227)
						SetBlipColour(CarBlip, 1)
						SetBlipAsShortRange(CarBlip, false)
					end
				end
			else
				if hasCarRouteStarted then
					stopCarRoute()
				end
			end
		end
	end)	
end

function vRPC.finishCarRoute(asd)
    hasCarRouteStarted = false
    CarCheckpoint = 0
    if DoesBlipExist(CarStopsBlip) then RemoveBlip(CarStopsBlip) CarStopsBlip = nil end
    if DoesBlipExist(CarStopsBlip2) then RemoveBlip(CarStopsBlip2) CarStopsBlip2 = nil end
    if DoesBlipExist(CarBlip) then RemoveBlip(CarBlip) CarBlip = nil end
    if DoesBlipExist(finishBlip) then RemoveBlip(finishBlip) finishBlip = nil end
    atCarStop = false
    vRPS.giveDMV({asd})
    DeleteEntity(theCar)
    started = false
end

function stopCarRoute()
    hasCarRouteStarted = false
    vRP.notify({"Eroare: Ai picat testul pentru permis !"})
    CarCheckpoint = 0
    if DoesBlipExist(CarStopsBlip) then RemoveBlip(CarStopsBlip) CarStopsBlip = nil end
    if DoesBlipExist(CarStopsBlip2) then RemoveBlip(CarStopsBlip2) CarStopsBlip2 = nil end
    if DoesBlipExist(CarBlip) then RemoveBlip(CarBlip) CarBlip = nil end
    if DoesBlipExist(finishBlip) then RemoveBlip(finishBlip) finishBlip = nil end
    vRPS.stopCarRoute({})
    atCarStop = false
    started = false
end

function spawnTheCar(veh, coordV)
    if theCar == nil then
        SetEntityCoords(PlayerPedId(), coordV)
        coords = GetEntityCoords(PlayerPedId())
        vehicle = GetHashKey(vehicle[veh])
        RequestModel(vehicle)
        while not HasModelLoaded(vehicle) do Wait(0) end
        theCar = CreateVehicle(vehicle, coords.x, coords.y, coords.z+0.5, 213.7, true, false)
        SetVehicleOnGroundProperly(theCar)
        SetEntityInvincible(theCar, false)
        SetPedIntoVehicle(PlayerPedId(), theCar, -1)
        InvokeNative(0xAD738C3085FE7E11, theCar, true, true)
        SetVehicleHasBeenOwnedByPlayer(theCar, true)
        SetModelAsNoLongerNeeded(vehicle)
    end
end

function stopAtCarStop(isCarStop)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if not isCarStop then 
        nextCarStop()
    else
        if not atCarStop then
            atCarStop = true
            FreezeEntityPosition(vehicle, true)
            vRP.notify({"Eroare: Asteapta la semafor!"})
            SetTimeout(8000, function()
                if atCarStop then
                    atCarStop = false
                    if #CarStopsLocs > CarCheckpoint then
                        nextCarStop()
                        FreezeEntityPosition(vehicle, false)
                        vRP.notify({"Succes: S-a facut verde! Poti merge mai departe!"})
                    else
                        if DoesBlipExist(CarStopsBlip) then
                            RemoveBlip(CarStopsBlip)
                            CarStopsBlip = nil
                        end
                    end
                else
                    vRP.notify({"Eroare: Trebuie sa astepti la semafor !"})
                end
            end)
        end
    end
end
