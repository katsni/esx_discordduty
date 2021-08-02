ESX = nil

local jobs = {
    'police', --Jos lisäät uusia jobeja lisää ne myös serveriin ja databaseen--
    'offpolice',
    'ambulance',
    'offambulance',
    'mechanic',
    'offmechanic'
}

local coords = {
    vector3(441.27, -981.83, 30.69), --Näillä ei ole oikeastaan väliä, toiseen versioon tulee työkohtaset coordsit.--
    vector3(307.06, -597.57, 43.28),
    vector3(-345.52, -123.0, 39.01)
}

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


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local cc = GetEntityCoords(PlayerPedId())
        for k,v in pairs(coords) do
            local dist = #(cc-v)
            if dist < 5 then
                if dist < 1.2 then
                    zones = true
                else
                    zones = false
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for ucon,tyo in pairs(jobs) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == tyo then
                if zones then
                    ESX.ShowHelpNotification("Paina ~INPUT_CONTEXT~ avataksesi kellokortti")
                    if IsControlPressed(0, 38) then
                        Citizen.Wait(500)
                        TriggerServerEvent("esx_kellokortti:function")
                    end
                end
            end
        end
    end
end)
