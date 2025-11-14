<<<<<<< codex/build-custom-fivem-server-scripts-yu6dsk
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

=======
>>>>>>> main
local function pushPlayerInfo(source)
    local identity = exports['mda_miami_id']:GetIdentityBySource(source) or {}
    local playerName = identity.rpName or GetPlayerName(source)
    TriggerClientEvent('mda_loading:setPlayerInfo', source, {
        rpName = playerName,
        miamiId = identity.miamiId or 'MDA-0000',
        discord = identity.discord or 'Unknown'
    })
<<<<<<< codex/build-custom-fivem-server-scripts-yu6dsk
    TriggerClientEvent('mda_loading:setPlayerCount', source, buildPlayerCountPayload())
=======
    TriggerClientEvent('mda_loading:setPlayerCount', -1, #GetPlayers())
>>>>>>> main
end

AddEventHandler('playerJoining', function()
    local src = source
    Citizen.SetTimeout(1000, function()
        pushPlayerInfo(src)
<<<<<<< codex/build-custom-fivem-server-scripts-yu6dsk
        broadcastPlayerCount()
=======
>>>>>>> main
    end)
end)

AddEventHandler('playerDropped', function()
<<<<<<< codex/build-custom-fivem-server-scripts-yu6dsk
    Citizen.SetTimeout(0, broadcastPlayerCount)
end)

CreateThread(function()
    Citizen.Wait(500)
    broadcastPlayerCount()
=======
    TriggerClientEvent('mda_loading:setPlayerCount', -1, #GetPlayers())
>>>>>>> main
end)
