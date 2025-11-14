local Config = Config or {}
local status = {
    hunger = Config.StatusDefaults.hunger,
    thirst = Config.StatusDefaults.thirst,
    stamina = Config.StatusDefaults.stamina,
    stress = Config.StatusDefaults.stress
}
local accounts = {
    wallet = Config.DefaultWallet,
    bank = Config.DefaultBank
}

local function clamp(value, min, max)
    return math.min(math.max(value, min), max)
end

local function sendStatus()
    local ped = PlayerPedId()
    local health = (GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100) * 100
    local payload = {
        meters = {
            health = clamp(health, 0, 100),
            hunger = clamp(status.hunger, 0, 100),
            thirst = clamp(status.thirst, 0, 100),
            stamina = clamp(status.stamina, 0, 100),
            stress = clamp(status.stress, 0, 100)
        },
        accounts = {
            wallet = string.format('$%s', accounts.wallet or 0),
            bank = string.format('$%s', accounts.bank or 0)
        }
    }

    SendNUIMessage({ action = 'updateStatus', payload = payload })
end

local function applyDrain()
    status.hunger = status.hunger - Config.StatusDrain.hunger
    status.thirst = status.thirst - Config.StatusDrain.thirst
    status.stamina = clamp(status.stamina - Config.StatusDrain.stamina, 0, 100)
    status.stress = clamp(status.stress + Config.StatusDrain.stress, 0, 100)

    if status.hunger <= 0 or status.thirst <= 0 then
        ApplyDamageToPed(PlayerPedId(), 5, false)
    end
end

CreateThread(function()
    Wait(4000)
    TriggerServerEvent('mda_framework:requestAccounts')
    while true do
        applyDrain()
        sendStatus()
        TriggerServerEvent(Config.StatusEvent, status)
        Wait(Config.UpdateInterval * 1000)
    end
end)

RegisterNetEvent('mda_framework:setAccounts', function(data)
    accounts.wallet = data.wallet or accounts.wallet
    accounts.bank = data.bank or accounts.bank
    sendStatus()
end)

exports('GetWalletBalance', function()
    return accounts.wallet or 0
end)
