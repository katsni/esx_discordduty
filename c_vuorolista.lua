ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end)

local zones = false

function KolmeDTeksti(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local factor = #text / 370
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 120)
end

local paikka = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local cc = GetEntityCoords(PlayerPedId())
        for k,v in pairs(Config.Zones) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == v.Job then
                local dist = #(cc - v.Coords)
                paikka = v.Coords

                if dist < 5 then
                    if dist < 1.2 then
                        zones = true
                    else
                        zones = false
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if zones then
            KolmeDTeksti(paikka.x, paikka.y, paikka.z, "E - Käytä kellokorttia")
            if IsControlPressed(0, 38) then
                Citizen.Wait(500)
                TriggerServerEvent("esx_kellokortti:function")
            end
        else
            Citizen.Wait(200)
        end
    end
end)
