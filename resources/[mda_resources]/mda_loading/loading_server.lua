local function buildPlayerCountPayload()
    local maxClients = GetConvarInt('sv_maxclients', 48)
    if maxClients <= 0 then maxClients = 48 end
    return {
        count = #GetPlayers(),
        max = maxClients
    }
end

local function broadcastPlayerCount()
    TriggerClientEvent('mda_loading:setPlayerCount', -1, buildPlayerCountPayload())
end

local function pushPlayerInfo(source)
    local identity = exports['mda_miami_id']:GetIdentityBySource(source) or {}
    local playerName = identity.rpName or GetPlayerName(source)
    TriggerClientEvent('mda_loading:setPlayerInfo', source, {
        rpName = playerName,
        miamiId = identity.miamiId or 'MDA-0000',
        discord = identity.discord or 'Unknown'
    })
    TriggerClientEvent('mda_loading:setPlayerCount', source, buildPlayerCountPayload())
end

AddEventHandler('playerJoining', function()
    local src = source
    Citizen.SetTimeout(1000, function()
        pushPlayerInfo(src)
        broadcastPlayerCount()
    end)
end)

AddEventHandler('playerDropped', function()
    Citizen.SetTimeout(0, broadcastPlayerCount)
end)

CreateThread(function()
    Citizen.Wait(500)
    broadcastPlayerCount()
end)
