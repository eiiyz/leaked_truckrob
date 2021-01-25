ESX = nil
local playerGender

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	TriggerEvent('skinchanger:getSkin', function(skin)
		playerGender = skin.sex
	end)

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

AddEventHandler('skinchanger:loadSkin', function(character)
	playerGender = character.sex
end)

local attempted = 0
local targetVehicle = 0
local isSilent = false
local ped2 = 0
local ped3 = 0
local ped4 = 0

RegisterNetEvent('leaked_truckrob:attemptTruckHeist')
AddEventHandler('leaked_truckrob:attemptTruckHeist', function()
	local veh = ESX.Game.GetVehicleInDirection()

	local playerPed = PlayerPedId()
	local pedCoords = GetEntityCoords(playerPed)

	if veh ~= nil and GetHashKey('stockade') == GetEntityModel(veh) then
		local vehCoords = GetOffsetFromEntityInWorldCoords(veh, 0.0, -4.0, 0.0)
		local veh_dist = GetDistanceBetweenCoords(pedCoords, vehCoords, 1)
		targetVehicle = veh
		local plate = GetVehicleNumberPlateText(veh)

        if veh_dist <= 2.0 then
			if IsPedArmed(PlayerPedId(), 4) then
				exports['mythic_notify']:DoCustomHudText ('error', 'You cannot lockpick with a gun.' , 5000)     
			else
		    	local success = exports['cfx_lockpick']:StartLockpickGame(math.random(5, 7))    
		    	if not success then
		    		exports['mythic_notify']:DoCustomHudText ('error', 'Lockpick bent out of shape.' , 5000)     
		    		TriggerServerEvent('cfx_vehdamage:server:removeItem', 'advance_lockpick', 1)
		    		return
            	end	
            	isSilent = false	
		    	ClearPedTasks(playerPed)
            	TriggerEvent("leaked_truckrob:AttemptHeist", targetVehicle)
            	Citizen.Wait(5000)		    		
				TriggerServerEvent('cfx_vehdamage:server:removeItem', 'advance_lockpick', 1)
			end
		else
			exports['mythic_notify']:DoLongHudText('error', 'You have to do it behind the vehicle.')
		end
	end
end)


RegisterNetEvent('leaked_truckrob:attemptSilentTruckHeist')
AddEventHandler('leaked_truckrob:attemptSilentTruckHeist', function()
	local veh = ESX.Game.GetVehicleInDirection()

	local playerPed = PlayerPedId()
	local pedCoords = GetEntityCoords(playerPed)

	if veh ~= nil and GetHashKey('stockade') == GetEntityModel(veh) then
		local vehCoords = GetOffsetFromEntityInWorldCoords(veh, 0.0, -4.0, 0.0)
		local veh_dist = GetDistanceBetweenCoords(pedCoords, vehCoords, 1)
		targetVehicle = veh
		local plate = GetVehicleNumberPlateText(veh)

        if veh_dist <= 2.0 then

		    local finished = exports["taskbar"]:taskBar(5000, "Unlocking Vehicle")
            if finished == 100 then
		        ClearPedTasks(playerPed)
                TriggerEvent("leaked_truckrob:AttemptHeist", targetVehicle)
                Citizen.Wait(5000)
                TriggerServerEvent('cfx_vehdamage:server:removeItem', 'gruppe6_emp_id', 1)
                isSilent = true		  
            end  		

		else
			exports['mythic_notify']:DoLongHudText('inform', 'You have to do it behind the vehicle.')
		end
	--else
	--	trigger shit that advance lockpick is used
	end
end)

local pickingUp = false
local started = false

RegisterNetEvent('leaked_truckrob:startTruckHeist')
AddEventHandler('leaked_truckrob:startTruckHeist', function()
	TriggerEvent('esx_status:add', 'stress', 25000)
	
	local duration = 120000  -- 120000
	started = true
    SetVehicleDoorOpen(targetVehicle, 2, 0, 0)
    SetVehicleDoorOpen(targetVehicle, 3, 0, 0)
    AddSecurityPed()
    Citizen.Wait(5000)

    Citizen.CreateThread(function()
		while started do
			Citizen.Wait(1)

			local playerPed = PlayerPedId()
			local pedCoords = GetEntityCoords(playerPed)
			local vehCoords = GetOffsetFromEntityInWorldCoords(targetVehicle, 0.0, -4.0, 0.0)
			local pickup_dist = GetDistanceBetweenCoords(pedCoords, vehCoords, 1)

			if pickup_dist <= 5.0 and not pickingUp then
				Draw3DText(vehCoords.x, vehCoords.y, vehCoords.z + 1.0, '[E] Pickup Cash')

				if pickup_dist <= 2.0 and IsControlJustReleased(0, 38) then
					if IsPedArmed(PlayerPedId(), 4) then
						exports['mythic_notify']:DoCustomHudText ('error', 'You cannot pickup cash with a gun.' , 5000)     
					else
						PickUpCash()
					end
				end
			end 
		end
    end)

    Citizen.Wait(duration)
    started = false
    pickingUp = false
    isSilent = false

    if DoesEntityExist(ped2) then
    	DeleteEntity(ped2)
    end

    if DoesEntityExist(ped3) then
    	DeleteEntity(ped3)
    end

    if DoesEntityExist(ped4) then
    	DeleteEntity(ped4)
    end        

end)


function PickUpCash()
	if not pickingUp then
		pickingUp = true
		playAnim('anim@mp_snowball', 'pickup_snowball', -1)
		local startingCoords = GetEntityCoords(PlayerPedId())
		while pickingUp do
			Citizen.Wait(1)
			local success = true
			local factor = math.random(5, 10)
			local currentCoords = GetEntityCoords(PlayerPedId())
			local dist = GetDistanceBetweenCoords(startingCoords, currentCoords, 1)
			if dist > 1.0 or not started then
				pickingUp = false
				--started = false
				ClearPedTasks(PlayerPedId())
				return
			end
			if not IsEntityPlayingAnim(GetPlayerPed(-1), "anim@mp_snowball", "pickup_snowball", 3) then
				playAnim('anim@mp_snowball', 'pickup_snowball', -1)
			end
		    local finished = exports['np-taskbarskill']:taskBar(1000 * factor, math.random(3, 4))
		    if finished <= 0 then
		      exports['mythic_notify']:DoLongHudText('error', 'Failed.')
		      success = false
              if not isSilent then
				print('Money Truck Rob')
				SendAlert()
              else
                print('Money Truck Rob| SILENT')
              end
		    end 
		
		    if success then
		    	local amount = 100 * factor
                local chance = math.random(1, 100)
                print('Chance:'..chance)
		    	TriggerServerEvent('cfx_vehdamage:server:givePlayerDirtyMoney', amount)
                exports['mythic_notify']:DoLongHudText('inform', 'You stole ' .. ESX.Math.GroupDigits(amount) .. '$')
                TriggerServerEvent("leaked_truckrob:recievedlogs", ESX.Math.GroupDigits(amount) ..'$')
                Citizen.Wait(5000)
		    	local itemnum = math.random(1, #Config.TruckHeistItems)
		    	if chance > 98 then
                    TriggerServerEvent('leaked_base:giveItem', Config.TruckHeistItems[itemnum], 1)
                    TriggerServerEvent("leaked_truckrob:recievedlogs", Config.TruckHeistItems[itemnum] ..'.')
		    	end
			
		    	if chance > 70 then
					SendAlert()
		    	end
		    end
		    Citizen.Wait(2000)
		end
		ClearPedTasks(PlayerPedId())
	end
end


function AddSecurityPed()
    local pedType = 's_m_m_highsec_01'

    local pedModel = GetHashKey(pedType)
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        RequestModel(pedModel)
        Citizen.Wait(100)
    end


   ped2 = CreatePedInsideVehicle(targetVehicle, 4, pedModel, 0, 1, 0.0)
   ped3 = CreatePedInsideVehicle(targetVehicle, 4, pedModel, 1, 1, 0.0)
   ped4 = CreatePedInsideVehicle(targetVehicle, 4, pedModel, 2, 1, 0.0)

   GiveWeaponToPed(ped2, GetHashKey('WEAPON_SpecialCarbine'), 420, 0, 1)
   GiveWeaponToPed(ped3, GetHashKey('WEAPON_SpecialCarbine'), 420, 0, 1)
   GiveWeaponToPed(ped4, GetHashKey('WEAPON_SpecialCarbine'), 420, 0, 1)


   SetPedDropsWeaponsWhenDead(ped2,false)
   SetPedRelationshipGroupDefaultHash(ped2,GetHashKey('COP'))
   SetPedRelationshipGroupHash(ped2,GetHashKey('COP'))
   SetPedAsCop(ped2,true)
   SetCanAttackFriendly(ped2,false,true)

   SetPedDropsWeaponsWhenDead(ped3,false)
   SetPedRelationshipGroupDefaultHash(ped3,GetHashKey('COP'))
   SetPedRelationshipGroupHash(ped3,GetHashKey('COP'))
   SetPedAsCop(ped3,true)
   SetCanAttackFriendly(ped3,false,true)
   

   SetPedDropsWeaponsWhenDead(ped4,false)
   SetPedRelationshipGroupDefaultHash(ped4,GetHashKey('COP'))
   SetPedRelationshipGroupHash(ped4,GetHashKey('COP'))
   SetPedAsCop(ped4,true)
   SetCanAttackFriendly(ped4,false,true)

   TaskCombatPed(ped2, GetPlayerPed(-1), 0, 16)
   TaskCombatPed(ped3, GetPlayerPed(-1), 0, 16)
   TaskCombatPed(ped4, GetPlayerPed(-1), 0, 16)
end

-- Thread for Police Notify
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		streetName,_ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
		streetName = GetStreetNameFromHashKey(streetName)
	end
end)

-- Outlawalert
function SendAlert()
	local playerPed = PlayerPedId()
	PedPosition		= GetEntityCoords(playerPed)

	local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
	TriggerServerEvent('esx_outlawalert:truckrob', {
		x = ESX.Math.Round(PedPosition.x, 1),
		y = ESX.Math.Round(PedPosition.y, 1),
		z = ESX.Math.Round(PedPosition.z, 1)
	}, streetName, playerGender)
	--TriggerServerEvent('esx_TruckRobbery:TruckRobberyInProgress',GetEntityCoords(PlayerPedId()),streetName)
end

RegisterNetEvent('leaked_truckrob:AttemptHeist')
AddEventHandler('leaked_truckrob:AttemptHeist', function(veh)
    attempted = veh
    SetEntityAsMissionEntity(attempted,true,true)
    local plate = GetVehicleNumberPlateText(veh)
    TriggerServerEvent("leaked_truckrob:checkRobbed",plate)
end)

RegisterNetEvent('leaked_truckrob:AllowHeist')
AddEventHandler('leaked_truckrob:AllowHeist', function()
	ESX.TriggerServerCallback('cfx_shipments:getRep', function(rep)
		if rep >= 50 then
			TriggerEvent("leaked_truckrob:startTruckHeist")
		else
			TriggerEvent('cfx_shipments:BadReputationMessage')
		end
	end)
end)

function Draw3DText(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function playAnim(animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
    TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
    RemoveAnimDict(animDict)
end