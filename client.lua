-- CONFIG 
local lockDistance = 20 -- The radius you have to be in to lock/unlock your vehicle.

--[[
─────────────────────────────────────────────────────────────────

	CarLock (client.lua) - Created by Lama
	
	Support - Lama#9612 on Discord
	
	DO NOT EDIT BELOW IF YOU DON'T KNOW WHAT YOU ARE DOING	

─────────────────────────────────────────────────────────────────
]]--

saved = false

-- Request animation
Citizen.CreateThread(function()
    local dict = "anim@mp_player_intmenu@key_fob@"
	RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
    Citizen.Wait(0)
end
	
-- Lock lights event
RegisterNetEvent('lockLights')
AddEventHandler('lockLights',function()
local vehicle = saveVehicle
	SetVehicleLights(vehicle, 2)
	Wait (200)
	SetVehicleLights(vehicle, 0)
	Wait (200)
	SetVehicleLights(vehicle, 2)
	Wait (400)
	SetVehicleLights(vehicle, 0)
end)

-- Lock vehicle
-- You can change the keybind in your game settings 
RegisterKeyMapping('lock', 'Lock and unlock your saved car', 'keyboard', 'u') 
RegisterCommand("lock", function()
    local vehicle = saveVehicle
	local vehcoords = GetEntityCoords(vehicle)
	local coords = GetEntityCoords(PlayerPedId())
	local isLocked = GetVehicleDoorLockStatus(vehicle)
		if DoesEntityExist(vehicle) then
			if #(vehcoords - coords) < lockDistance then
				if (isLocked == 1) then
				PlaySoundFrontend(-1, "BUTTON", "MP_PROPERTIES_ELEVATOR_DOORS", 1)
				TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
				SetVehicleDoorsLocked(vehicle, 2)
				ShowNotification("~w~Vehicle ~r~locked")
				TriggerEvent('lockLights')
				else
				PlaySoundFrontend(-1, "BUTTON", "MP_PROPERTIES_ELEVATOR_DOORS", 1)
				TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
				SetVehicleDoorsLocked(vehicle,1)
				ShowNotification("~w~Vehicle ~g~unlocked")
				TriggerEvent('lockLights')
				end
			else
				ShowNotification("~r~You must be closer to your vehicle")
			end
		else
			ShowNotification("~r~No saved vehicle ~b~ You must press DEL to save you car")
		end
	end)
end) 

-- Save vehicle
-- You can change the keybind in your game settings 
RegisterKeyMapping('save', 'Save and unsave the car you are in', 'keyboard', 'delete') 
RegisterCommand("save",function()
	local player = PlayerPedId()
	  if (IsPedSittingInAnyVehicle(player)) then
			if saved == true then
			saveVehicle = nil
			RemoveBlip(targetBlip)
			ShowNotification("~w~Vehicle ~r~removed~")
			saved = false
		else
			RemoveBlip(targetBlip)
			saveVehicle = GetVehiclePedIsIn(player,true)
			local vehicle = saveVehicle
			targetBlip = AddBlipForEntity(vehicle)
			SetBlipSprite(targetBlip,225)
			ShowNotification("~w~Vehicle ~g~saved")
			saved = true
		end
	end
end)

-- Notification function
function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end
