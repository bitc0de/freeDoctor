local doctorCoords = {x = 1814.57, y = 3677.66, z = 33.28, h = 34.07}
local ped = 0

local blips = {
	{title="Doctor", colour=29, id=61, x = 1814.57, y = 3677.66, z = 33.28},
  }

Citizen.CreateThread(function()

    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 0.9)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


function ShowInfo(text, state)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)DisplayHelpTextFromStringLabel(0, state, 0, -1)
end


Citizen.CreateThread(function()
	local hash = GetHashKey("s_m_m_doctor_01")
	while not HasModelLoaded(hash) do
		RequestModel(hash)
		Wait(20)
	end
	ped = CreatePed("PED_TYPE_CIVFEMALE", "s_m_m_doctor_01", doctorCoords.x, doctorCoords.y, doctorCoords.z, doctorCoords.h, false, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	FreezeEntityPosition(ped, true)
end)


Citizen.CreateThread(function()
	local playerID = GetPlayerServerId(PlayerId())
	local health = GetEntityHealth(PlayerPedId())
	local can = true
	while true do
		Citizen.Wait(0)
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),GetEntityCoords(ped)) < 2 then
			ShowInfo("Press ~INPUT_VEH_HORN~ to heal", 0)
			if (IsControlJustPressed(1,38)) and (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),GetEntityCoords(ped))) then 
				if can then
					TriggerEvent("esx_ambulancejob:revive", GetPlayerServerId(PlayerId()))
					TriggerServerEvent("pase:addXP",GetPlayerServerId(PlayerId()),100)
					can = false
				else
					ESX.ShowNotification("~r~You must wait a few minutes to be cured again!")
					Citizen.Wait(120000)
					can = true
				end

			end
		end
	end
end)


