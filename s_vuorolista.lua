ESX = nil
local polwebhook = "https://discord.com/api/webhooks/831192464958291988/ccXr08VKf2BwOp4JuxNx0furbkw0MBBeud-EwnZLfpbdSxQbV80BFkU4ppnQcsF5BdFY"
local ambulancehook = "https://discord.com/api/webhooks/869965800386203698/W_UOEdOvmXYJVmBrl7ti-_N-4npiIG54Yauek7xG262u5on07TLJU3XVo1eunYdTFZ8b"
local mechhook = "https://discord.com/api/webhooks/869966000647471134/644w2LPvYUlX70GbXr6P5s42Qx0DzXDaUH1u_VQgmtc9Z6Qt_q4MpBUkx7Nj5IQiH65E"

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			name = identity['name'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height'],
			job = identity['job'],
			group = identity['group']
		}
	else
		return nil
	end
end

function WebHook(job)
	if job == "police" then
		return polwebhook
	elseif job == "ambulance" then
		return ambulancehook
	elseif job == "mechanic" then
		return mechhook
	end
end

RegisterServerEvent('esx_kellokortti:function')
AddEventHandler('esx_kellokortti:function', function(job)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade
	local getHook = WebHook(job)

    if job == "police" or job == "ambulance" or job == "mechanic" then
        xPlayer.setJob('off' ..job, grade)
        SendToDiscord("Poistui vuorosta", getHook)
        TriggerClientEvent("esx:showNotification", _source, "Poistuit vuorosta")
    elseif job == "offpolice" then
        xPlayer.setJob('police', grade)
        SendToDiscord("Palasi vuoroon", polwebhook)
        TriggerClientEvent("esx:showNotification", _source, "Palasit vuoroon")
	elseif job == "offambulance" then
        xPlayer.setJob('ambulance', grade)
        SendToDiscord("Palasi vuoroon", ambulancehook)
        TriggerClientEvent("esx:showNotification", _source, "Palasit vuoroon")
	elseif job == "offmechanic" then
        xPlayer.setJob('mechanic', grade)
        SendToDiscord("Palasi vuoroon", mechhook)
        TriggerClientEvent("esx:showNotification", _source, "Palasit vuoroon")
    end
end)

function SendToDiscord(paska, webhookki)
	local DiscordWebHook = webhookki
    local nimi = getIdentity(source)
	local embeds = {
		{
			["title"]= ""..os.date("%d.%m. klo %X"),
			["type"]="rich",
			["color"] = 16711680,
			["description"] = "**"..nimi.firstname.." "..nimi.lastname.."** "..paska.."",
			["footer"]=  {
				["text"] =  "katsni#0001",
		},
	}
}
	if paska == nil or paska == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = "Vuorolista", embeds = embeds}), { ['Content-Type'] = 'application/json' })
end
