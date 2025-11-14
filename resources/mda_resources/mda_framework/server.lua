local Config = Config or {}
local accounts = {}

local function extractDiscordId(source)
    for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
        if identifier:find('discord:') then
            return identifier:sub(9)
        end
    end
    return nil
end

local function ensureTable()
    local query = string.format([[CREATE TABLE IF NOT EXISTS `%s` (
        `id` INT AUTO_INCREMENT PRIMARY KEY,
        `%s` VARCHAR(32) NOT NULL UNIQUE,
        `%s` INT NOT NULL DEFAULT %d,
        `%s` INT NOT NULL DEFAULT %d,
        `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]],
        Config.Database.tableName,
        Config.Database.identifierColumn,
        Config.Database.walletColumn,
        Config.DefaultWallet,
        Config.Database.bankColumn,
        Config.DefaultBank
    )

    MySQL.query(query)
end

MySQL.ready(function()
    ensureTable()
end)

local function loadAccount(discordId)
    if not discordId then return nil end
    if accounts[discordId] then return accounts[discordId] end
    local result = MySQL.query.await(string.format('SELECT * FROM `%s` WHERE `%s` = ? LIMIT 1', Config.Database.tableName, Config.Database.identifierColumn), { discordId })
    if result and result[1] then
        accounts[discordId] = result[1]
        return accounts[discordId]
    end

    MySQL.prepare.await(string.format('INSERT INTO `%s` (`%s`, `%s`, `%s`) VALUES (?, ?, ?)',
        Config.Database.tableName,
        Config.Database.identifierColumn,
        Config.Database.walletColumn,
        Config.Database.bankColumn
    ), {
        discordId,
        Config.DefaultWallet,
        Config.DefaultBank
    })

    accounts[discordId] = {
        [Config.Database.identifierColumn] = discordId,
        [Config.Database.walletColumn] = Config.DefaultWallet,
        [Config.Database.bankColumn] = Config.DefaultBank
    }

    return accounts[discordId]
end

local function saveAccount(discordId)
    local account = accounts[discordId]
    if not account then return end
    MySQL.prepare.await(string.format('UPDATE `%s` SET `%s` = ?, `%s` = ? WHERE `%s` = ?',
        Config.Database.tableName,
        Config.Database.walletColumn,
        Config.Database.bankColumn,
        Config.Database.identifierColumn
    ), {
        account[Config.Database.walletColumn],
        account[Config.Database.bankColumn],
        discordId
    })
end

local function notifyClient(source, account)
    TriggerClientEvent('mda_framework:setAccounts', source, {
        wallet = account[Config.Database.walletColumn],
        bank = account[Config.Database.bankColumn]
    })
end

RegisterNetEvent('mda_framework:requestAccounts', function()
    local src = source
    local discordId = extractDiscordId(src)
    local account = loadAccount(discordId)
    if account then
        notifyClient(src, account)
    end
end)

RegisterNetEvent(Config.StatusEvent, function(payload)
    local src = source
    local discordId = extractDiscordId(src)
    if not discordId then return end
    local account = loadAccount(discordId)
    if account then
        notifyClient(src, account)
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    local discordId = extractDiscordId(src)
    if discordId then
        saveAccount(discordId)
    end
end)

exports('GetWalletBalance', function(playerId)
    local src = playerId or source
    local discordId = extractDiscordId(src)
    if not discordId then return 0 end
    local account = loadAccount(discordId)
    return account and account[Config.Database.walletColumn] or 0
end)

exports('AddMoney', function(playerId, amount)
    local src = playerId or source
    local discordId = extractDiscordId(src)
    if not discordId then return end
    local account = loadAccount(discordId)
    if not account then return end
    account[Config.Database.walletColumn] = account[Config.Database.walletColumn] + math.floor(amount)
    saveAccount(discordId)
    notifyClient(src, account)
end)

exports('RemoveMoney', function(playerId, amount)
    local src = playerId or source
    local discordId = extractDiscordId(src)
    if not discordId then return end
    local account = loadAccount(discordId)
    if not account then return end
    account[Config.Database.walletColumn] = math.max(0, account[Config.Database.walletColumn] - math.floor(amount))
    saveAccount(discordId)
    notifyClient(src, account)
end)
