local Config = Config or {}
local employmentCache = {}
local payoutCache = {}
local roleCache = {}

local function getBotToken()
    return GetConvar(Config.Discord.BotTokenConvar, '')
end

local function log(message)
    print(('^2[mda_rolesync]^0 %s'):format(message))
end

local function findMapping(roleId)
    for _, mapping in ipairs(Config.RoleMappings) do
        if mapping.roleId == roleId then
            return mapping
        end
    end
    return nil
end

local function httpRequest(url, method, headers)
    local p = promise.new()
    PerformHttpRequest(url, function(status, body)
        if status == 200 or status == 204 then
            p:resolve({ status = status, body = body })
        else
            p:reject({ status = status, body = body })
        end
    end, method or 'GET', '', headers or {})
    return Citizen.Await(p)
end

local function fetchDiscordRoles(discordId)
    local token = getBotToken()
    if token == '' then
        log('Discord bot token missing. Set convar ' .. Config.Discord.BotTokenConvar)
        return {}
    end

    local url = string.format('https://discord.com/api/v10/guilds/%s/members/%s', Config.Discord.GuildId, discordId)
    local headers = {
        ['Content-Type'] = 'application/json',
        ['Authorization'] = 'Bot ' .. token
    }

    local ok, response = pcall(httpRequest, url, 'GET', headers)
    if not ok then
        log(('Failed to fetch Discord roles: %s'):format(response.status or 'unknown'))
        return {}
    end

    local data = json.decode(response.body or '{}')
    return data.roles or {}
end

local function determineEmployment(discordId, roles)
    for _, roleId in ipairs(roles) do
        local mapping = findMapping(roleId)
        if mapping then
            employmentCache[discordId] = mapping.employment
            payoutCache[discordId] = mapping.payoutGroup
            return mapping
        end
    end
    employmentCache[discordId] = Config.DefaultEmployment
    payoutCache[discordId] = Config.DefaultPayoutGroup
    return nil
end

local function applyAcePermissions(source, mapping)
    if not mapping or not mapping.ace then return end
    ExecuteCommand(('add_principal identifier.discord:%s %s'):format(extractDiscordId(source), mapping.ace))
end

local function extractDiscordId(source)
    for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
        if identifier:find('discord:') then
            return identifier:sub(9)
        end
    end
    return nil
end

local function syncPlayer(source)
    local discordId = extractDiscordId(source)
    if not discordId then
        employmentCache[discordId or source] = Config.DefaultEmployment
        return
    end

    local roles = fetchDiscordRoles(discordId)
    roleCache[source] = roles
    local mapping = determineEmployment(discordId, roles)

    local employmentLabel = mapping and mapping.employment or Config.DefaultEmployment
    employmentCache[discordId] = employmentLabel
    payoutCache[discordId] = mapping and mapping.payoutGroup or Config.DefaultPayoutGroup

    if mapping and mapping.ace then
        ExecuteCommand(('add_principal identifier.discord:%s %s'):format(discordId, mapping.ace))
    end

    local status = mapping and 'active' or 'pending'
    exports['mda_miami_id']:UpdateEmployment(discordId, employmentLabel, status)

    TriggerClientEvent('mda_rolesync:setEmployment', source, employmentLabel)
    log(('Synced %s as %s'):format(GetPlayerName(source), employmentLabel))
end

AddEventHandler('playerJoining', function()
    local src = source
    Citizen.SetTimeout(5000, function()
        syncPlayer(src)
    end)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    roleCache[src] = nil
end)

RegisterCommand('mda_rolesync', function(source)
    if source ~= 0 and not IsPlayerAceAllowed(source, 'mda.admin') then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'You do not have permission to resync roles.' } })
        return
    end

    if source == 0 then
        for _, playerId in ipairs(GetPlayers()) do
            syncPlayer(tonumber(playerId))
        end
    else
        syncPlayer(source)
    end
end, true)

Citizen.CreateThread(function()
    while true do
        Wait(Config.RefreshInterval * 1000)
        for _, playerId in ipairs(GetPlayers()) do
            syncPlayer(tonumber(playerId))
        end
    end
end)

exports('GetEmploymentLabel', function(playerId)
    local src = playerId or source
    local discordId = extractDiscordId(src)
    if not discordId then return Config.DefaultEmployment end
    return employmentCache[discordId] or Config.DefaultEmployment
end)

exports('GetPayoutGroup', function(playerId)
    local src = playerId or source
    local discordId = extractDiscordId(src)
    if not discordId then return Config.DefaultPayoutGroup end
    return payoutCache[discordId] or Config.DefaultPayoutGroup
end)
