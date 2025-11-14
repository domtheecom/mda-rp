local cache = {}
local lastCachePurge = os.time()

local function ensureTable()
    local tableName = Config.Database.tableName
    local columns = string.format([[CREATE TABLE IF NOT EXISTS `%s` (
        `id` INT AUTO_INCREMENT PRIMARY KEY,
        `%s` VARCHAR(32) NOT NULL UNIQUE,
        `%s` VARCHAR(16) NOT NULL,
        `%s` VARCHAR(64) NOT NULL,
        `%s` VARCHAR(32) NOT NULL DEFAULT 'Unemployed',
        `%s` VARCHAR(32) NOT NULL DEFAULT 'pending',
        `%s` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]],
        tableName,
        Config.Database.identifierColumn,
        Config.Database.idColumn,
        Config.Database.nameColumn,
        Config.Database.employmentColumn,
        Config.Database.statusColumn,
        Config.Database.lastSeenColumn
    )

    MySQL.query(columns)
end

MySQL.ready(function()
    ensureTable()
end)

local function extractDiscordId(source)
    for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
        if identifier:find('discord:') then
            return identifier:sub(9)
        end
    end
    return nil
end

local function findPlayerByDiscord(discordId)
    for _, playerId in ipairs(GetPlayers()) do
        local numericId = tonumber(playerId)
        if numericId then
            local id = extractDiscordId(numericId)
            if id == discordId then
                return numericId
            end
        end
    end
    return nil
end

local function generateMiamiId()
    local random = math.random(10 ^ (Config.IdLength - 1), (10 ^ Config.IdLength) - 1)
    return string.format('%s-%s', Config.MiamiIdPrefix, random)
end

local function fetchIdentityByDiscord(discordId)
    if not discordId then return nil end
    local cacheEntry = cache[discordId]
    if cacheEntry and (os.time() - cacheEntry.cachedAt) < Config.CacheDuration then
        return cacheEntry.data
    end

    local query = string.format('SELECT * FROM `%s` WHERE `%s` = ? LIMIT 1', Config.Database.tableName, Config.Database.identifierColumn)
    local result = MySQL.query.await(query, { discordId })

    if result and result[1] then
        local row = result[1]
        cache[discordId] = { cachedAt = os.time(), data = row }
        return row
    end

    return nil
end

local function upsertIdentity(data)
    local query = string.format([[INSERT INTO `%s` (`%s`, `%s`, `%s`, `%s`, `%s`) VALUES (?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE `%s` = VALUES(`%s`), `%s` = VALUES(`%s`), `%s` = VALUES(`%s`), `%s` = CURRENT_TIMESTAMP]],
        Config.Database.tableName,
        Config.Database.identifierColumn,
        Config.Database.idColumn,
        Config.Database.nameColumn,
        Config.Database.employmentColumn,
        Config.Database.statusColumn,
        Config.Database.idColumn, Config.Database.idColumn,
        Config.Database.nameColumn, Config.Database.nameColumn,
        Config.Database.employmentColumn, Config.Database.employmentColumn,
        Config.Database.lastSeenColumn
    )

    MySQL.prepare.await(query, {
        data.discord,
        data.miamiId,
        data.rpName,
        data.employment or 'Unemployed',
        data.status or 'active'
    })

    cache[data.discord] = { cachedAt = os.time(), data = data }
end

local function updateEmployment(discordId, employment, status)
    local query = string.format('UPDATE `%s` SET `%s` = ?, `%s` = ?, `%s` = CURRENT_TIMESTAMP WHERE `%s` = ?',
        Config.Database.tableName,
        Config.Database.employmentColumn,
        Config.Database.statusColumn,
        Config.Database.lastSeenColumn,
        Config.Database.identifierColumn
    )

    MySQL.prepare.await(query, {
        employment or 'Unemployed',
        status or 'active',
        discordId
    })

    if cache[discordId] then
        cache[discordId].data[Config.Database.employmentColumn] = employment
        cache[discordId].data[Config.Database.statusColumn] = status
    end
end

local function log(message)
    print(('^2[mda_miami_id]^0 %s'):format(message))
end

local function broadcastIdentity(source, data)
    TriggerClientEvent('mda_nametags:setIdentity', -1, source, identityToClient(data))
end

local function purgeCache()
    local now = os.time()
    if now - lastCachePurge < Config.CacheDuration then return end
    for discord, entry in pairs(cache) do
        if now - entry.cachedAt > Config.CacheDuration then
            cache[discord] = nil
        end
    end
    lastCachePurge = now
end

local function identityToClient(row)
    if not row then return nil end
    if row[Config.Database.nameColumn] then
        return {
            rpName = row[Config.Database.nameColumn],
            miamiId = row[Config.Database.idColumn],
            employment = row[Config.Database.employmentColumn],
            status = row[Config.Database.statusColumn]
        }
    end

    return {
        rpName = row.rpName,
        miamiId = row.miamiId,
        employment = row.employment,
        status = row.status
    }
end

local function ensureIdentity(row, discordId)
    if not row then
        local miamiId = generateMiamiId()
        local placeholder = {
            discord = discordId,
            miamiId = miamiId,
            rpName = 'Pending Academy',
            employment = 'Unemployed',
            status = 'pending'
        }
        upsertIdentity(placeholder)
        return placeholder
    end

    return {
        discord = discordId,
        miamiId = row[Config.Database.idColumn],
        rpName = row[Config.Database.nameColumn],
        employment = row[Config.Database.employmentColumn],
        status = row[Config.Database.statusColumn]
    }
end

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    deferrals.defer()
    deferrals.update('Validating your Miami ID registration...')

    Wait(100)

    local discordId = extractDiscordId(src)

    if Config.RequireDiscord and not discordId then
        deferrals.done('You must link your Discord account to join Miami-Dade Academy RP.')
        return
    end

    local identity = fetchIdentityByDiscord(discordId)
    identity = ensureIdentity(identity, discordId)

    if identity.status ~= 'active' then
        deferrals.done('Your Miami ID is pending approval. Please finish your academy registration in Discord.')
        return
    end

    upsertIdentity(identity)

    deferrals.update('Welcome to the academy, ' .. (identity.rpName or 'Recruit') .. '.')
    Wait(300)
    deferrals.done()
end)

AddEventHandler('playerDropped', function()
    purgeCache()
    local src = source
    broadcastIdentity(src, nil)
end)

RegisterNetEvent('mda_miami_id:requestIdentity', function()
    local src = source
    local discordId = extractDiscordId(src)
    local identity = fetchIdentityByDiscord(discordId)
    identity = ensureIdentity(identity, discordId)
    TriggerClientEvent('mda_miami_id:setIdentity', src, identity)
    local playerState = Player(src).state
    playerState:set('mdaIdentity', identityToClient(identity), true)
    broadcastIdentity(src, identity)
end)

exports('GetIdentityBySource', function(source)
    local discordId = extractDiscordId(source)
    local identity = fetchIdentityByDiscord(discordId)
    if not identity then return nil end
    return ensureIdentity(identity, discordId)
end)

exports('UpdateEmployment', function(discordId, employment, status)
    updateEmployment(discordId, employment, status)
    local data = fetchIdentityByDiscord(discordId)
    if data then
        local playerId = findPlayerByDiscord(discordId)
        if playerId then
            local identity = ensureIdentity(data, discordId)
            local playerState = Player(playerId).state
            playerState:set('mdaIdentity', identityToClient(identity), true)
            broadcastIdentity(playerId, data)
        end
    end
end)

RegisterCommand('mda_register', function(source, args)
    if source ~= 0 and not IsPlayerAceAllowed(source, 'mda.admin') then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'You do not have permission to use this command.' } })
        return
    end

    local discordId = args[1]
    local rpName = table.concat(args, ' ', 2)

    if not discordId or discordId == '' or not rpName or rpName == '' then
        if source == 0 then
            print('Usage: mda_register <discordId> <RP Name> [Employment] [Status]')
        else
            TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Usage: /mda_register <discordId> <RP Name> [Employment] [Status]' } })
        end
        return
    end

    local employment = 'Unemployed'
    local status = 'active'

    if args[3] then employment = args[3] end
    if args[4] then status = args[4] end

    local data = {
        discord = discordId,
        miamiId = generateMiamiId(),
        rpName = rpName,
        employment = employment,
        status = status
    }

    upsertIdentity(data)

    log(('Registered Miami ID %s for Discord %s'):format(data.miamiId, discordId))
end, true)

AddEventHandler('playerJoining', function()
    local src = source
    local identity = exports[GetCurrentResourceName()]:GetIdentityBySource(src)
    if not identity then return end
    local playerState = Player(src).state
    playerState:set('mdaIdentity', identityToClient(identity), true)
    broadcastIdentity(src, identity)
end)
