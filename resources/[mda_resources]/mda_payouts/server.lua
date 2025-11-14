local Config = Config or {}
local nextPayout = os.time() + (Config.IntervalMinutes * 60)

local function hasPermission(source)
    if source == 0 then return true end
    if not Config.RequireAceForCommands then return true end
    return IsPlayerAceAllowed(source, Config.AdminAce)
end

local function payoutPlayer(playerId)
    local source = tonumber(playerId)
    if not source then return end
    local payoutGroup = exports['mda_rolesync']:GetPayoutGroup(source) or 'civilian'
    local amount = Config.Payouts[payoutGroup] or Config.Payouts.civilian or 200
    amount = math.floor(amount * Config.BonusMultiplier)
    exports['mda_framework']:AddMoney(source, amount)
    TriggerClientEvent('chat:addMessage', source, { args = { '^2PAYDAY', ('You received $%s for your service.'):format(amount) } })
end

local function handlePayouts()
    for _, playerId in ipairs(GetPlayers()) do
        payoutPlayer(playerId)
    end
end

Citizen.CreateThread(function()
    while true do
        local now = os.time()
        local waitTime = math.max(5, nextPayout - now)
        Wait(waitTime * 1000)
        now = os.time()
        if now >= nextPayout then
            handlePayouts()
            nextPayout = now + (Config.IntervalMinutes * 60)
        end
    end
end)

RegisterCommand('mdapayout', function(source, args)
    if not hasPermission(source) then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1PAYDAY', 'You do not have permission to adjust payouts.' } })
        return
    end

    local group = args[1]
    local amount = tonumber(args[2])
    if not group or not amount then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1PAYDAY', 'Usage: /mdapayout <group> <amount>' } })
        return
    end

    Config.Payouts[group] = amount
    TriggerClientEvent('chat:addMessage', -1, { args = { '^2PAYDAY', ('Payouts for %s updated to $%s.'):format(group, amount) } })
end, false)

RegisterCommand('mdapaynow', function(source)
    if not hasPermission(source) then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1PAYDAY', 'You do not have permission to trigger payouts.' } })
        return
    end

    handlePayouts()
    nextPayout = os.time() + (Config.IntervalMinutes * 60)
end, false)
