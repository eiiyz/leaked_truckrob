ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local license = 0
local isSilent = false
local licenseArray = {}

RegisterServerEvent('leaked_truckrob:checkRobbed')
AddEventHandler('leaked_truckrob:checkRobbed', function(license)
    local _source = source

    if licenseArray[#licenseArray] ~= nil then
        for k, v in pairs(licenseArray) do
            if v == license then
            print('Bitch')
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = ("This truck has been robbed") })


            local src = source
            local id = source
            local ids = ExtractIdentifiers(id)
            local discord = ids.discord
            local steam = ids.steam:gsub("steam:", "")
            local steamDec = tostring(tonumber(steam,16))
            steam = "https://steamcommunity.com/profiles/" .. steamDec
            local gameLicense = ids.license
            local name = GetPlayerName(src)
            local ip = GetPlayerEndpoint(src)
            local ping = GetPlayerPing(src)
            local steamhex = GetPlayerIdentifier(src)
            embedlog('***```          EXPLOITERIST TRIED TO ROB SINGLE TRUCK MULTIPLE TIMES[leaked_truckrob]          ```***','```\nPlayer: ['..name..']\nIP: ['..ip..']\nSteam Hex: ['..steamhex..']\nSteam Profile: ['..steam..']\nGame License :['..gameLicense..']```\n> Discord Tag: [<@' .. discord:gsub('discord:', '') .. '>]')
            return
            end
        end
    end

    licenseArray[#licenseArray+1] = license

    TriggerClientEvent('leaked_truckrob:AllowHeist', _source)

    local src = source
    local id = source
    local ids = ExtractIdentifiers(id)
    local discord = ids.discord
    local steam = ids.steam:gsub("steam:", "")
    local steamDec = tostring(tonumber(steam,16))
    steam = "https://steamcommunity.com/profiles/" .. steamDec
    local gameLicense = ids.license
	local name = GetPlayerName(src)
    local ip = GetPlayerEndpoint(src)
    local ping = GetPlayerPing(src)
    local steamhex = GetPlayerIdentifier(src)
    if isSilent  then
        embedlog('***```          NEW TRIGGER SILENT START[leaked_truckrob]          ```***','```\nPlayer: ['..name..']\nIP: ['..ip..']\nSteam Hex: ['..steamhex..']\nSteam Profile: ['..steam..']\nGame License :['..gameLicense..']```\n> Discord Tag: [<@' .. discord:gsub('discord:', '') .. '>]')
    else
        embedlog('***```          NEW TRIGGER NORMAL START[leaked_truckrob]          ```***','```\nPlayer: ['..name..']\nIP: ['..ip..']\nSteam Hex: ['..steamhex..']\nSteam Profile: ['..steam..']\nGame License :['..gameLicense..']```\n> Discord Tag: [<@' .. discord:gsub('discord:', '') .. '>]')
    end
end)

RegisterServerEvent('leaked_truckrob:Start')
AddEventHandler('leaked_truckrob:Start', function(source,license)
    local copcount = 0
    local Players = ESX.GetPlayers()

    for i = 1, #Players, 1 do
        local xPlayer = ESX.GetPlayerFromId(Players[i])

        if xPlayer.job.name == "police" then
            copcount = copcount + 1
        end
    end
    if copcount >= 0 then
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        TriggerClientEvent('leaked_truckrob:attemptTruckHeist', source)  
        isSilent = false
    else
        --TriggerClientEvent('DoLongHudText', source, 'There is not enough police on duty!', 2)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'There is not enough police on duty!'})
    end
end)

RegisterServerEvent('leaked_truckrob:Silentstart')
AddEventHandler('leaked_truckrob:Silentstart', function(source,license)
    local copcount = 0
    local Players = ESX.GetPlayers()

    for i = 1, #Players, 1 do
        local xPlayer = ESX.GetPlayerFromId(Players[i])

        if xPlayer.job.name == "police" then
            copcount = copcount + 1
        end
    end
    if copcount >= 3 then
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        TriggerClientEvent('leaked_truckrob:attemptSilentTruckHeist', source)  
        isSilent = true  
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'There is not enough police on duty!'})
    end
end)

RegisterServerEvent('leaked_truckrob:IllegalNotificationSV')
AddEventHandler('leaked_truckrob:IllegalNotificationSV', function()
    local Players = ESX.GetPlayers()
    for i = 1, #Players, 1 do
        local xPlayer = ESX.GetPlayerFromId(Players[i])

        if xPlayer.job.name == "police" then
            TriggerClientEvent('leaked_truckrob:IllegalNotification', Players[i])
        end
    end
end)

ESX.RegisterUsableItem('gruppe6_emp_id', function(source)
    TriggerEvent('leaked_truckrob:Silentstart', source)
end)

ESX.RegisterUsableItem('advance_lockpick', function(source)
    TriggerEvent('leaked_truckrob:Start', source)
end)


-- Input your webook
local webhook = 'Your Webhook Here'
-- LOGS SYSTEM DONT TOUCH

RegisterServerEvent("leaked_truckrob:recievedlogs")
AddEventHandler("leaked_truckrob:recievedlogs", function(recieved)
    local src = source
    local id = source
    local ids = ExtractIdentifiers(id)
    local discord = ids.discord
    local steam = ids.steam:gsub("steam:", "")
    local steamDec = tostring(tonumber(steam,16))
    steam = "https://steamcommunity.com/profiles/" .. steamDec
    local gameLicense = ids.license
    local name = GetPlayerName(src)
    local ip = GetPlayerEndpoint(src)
    local ping = GetPlayerPing(src)
    local steamhex = GetPlayerIdentifier(src)
	embedlog('***```          LOGS SYSTEM[leaked_truckrob]          ```***','```\nGot: ['..recieved..']\nPlayer: ['..name..']\nIP: ['..ip..']\nSteam Hex: ['..steamhex..']\nSteam Profile: ['..steam..']\nGame License :['..gameLicense..']```\n> Discord Tag: [<@' .. discord:gsub('discord:', '') .. '>]')
end)

RegisterServerEvent("leaked_truckrob:triggerlogs")
AddEventHandler("leaked_truckrob:triggerlogs", function(triggger)
    local src = source
    local id = source
    local ids = ExtractIdentifiers(id)
    local discord = ids.discord
    local steam = ids.steam:gsub("steam:", "")
    local steamDec = tostring(tonumber(steam,16))
    steam = "https://steamcommunity.com/profiles/" .. steamDec
    local gameLicense = ids.license
	local name = GetPlayerName(src)
    local ip = GetPlayerEndpoint(src)
    local ping = GetPlayerPing(src)
    local steamhex = GetPlayerIdentifier(src)
    if trigger == 1 then
        embedlog('***```          ATTEMPTED TRIGGER SILENT START[leaked_truckrob]          ```***','```\nPlayer: ['..name..']\nIP: ['..ip..']\nSteam Hex: ['..steamhex..']\nSteam Profile: ['..steam..']\nGame License :['..gameLicense..']```\n> Discord Tag: [<@' .. discord:gsub('discord:', '') .. '>]')
    elseif trigger == 2 then
        embedlog('***```          ATTEMPTED TRIGGER NORMAL START[leaked_truckrob]          ```***','```\nPlayer: ['..name..']\nIP: ['..ip..']\nSteam Hex: ['..steamhex..']\nSteam Profile: ['..steam..']\nGame License :['..gameLicense..']```\n> Discord Tag: [<@' .. discord:gsub('discord:', '') .. '>]')
    end
end)

function embedlog(title, message)
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({embeds = {{["color"] = 11750815,["title"] = title,["description"] = "".. message .."",["footer"] = {["text"] = os.date()},}}, }), { ['Content-Type'] = 'application/json' })
end

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end