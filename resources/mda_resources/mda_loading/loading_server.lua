local function pushPlayerInfo(source)
    local identity = exports['mda_miami_id']:GetIdentityBySource(source) or {}
    local playerName = identity.rpName or GetPlayerName(source)
    TriggerClientEvent('mda_loading:setPlayerInfo', source, {
        rpName = playerName,
        miamiId = identity.miamiId or 'MDA-0000',
        discord = identity.discord or 'Unknown'
    })
    TriggerClientEvent('mda_loading:setPlayerCount', -1, #GetPlayers())
end

AddEventHandler('playerJoining', function()
    local src = source
    Citizen.SetTimeout(1000, function()
        pushPlayerInfo(src)
    end)
end)

AddEventHandler('playerDropped', function()
    TriggerClientEvent('mda_loading:setPlayerCount', -1, #GetPlayers())
end)
