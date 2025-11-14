local Config = Config or {}
local showHud = true
local lastPayload = {}
local jsonLib = json or {}

local function encode(data)
    if jsonLib and jsonLib.encode then
        return jsonLib.encode(data)
    end
    return tostring(data)
end

local function safeExport(resource, exportName, ...)
    if not resource or not exportName then return nil end
    local ok, result = pcall(function(...)
        return exports[resource][exportName](...)
    end, ...)
    if ok then return result end
    return nil
end

local function fetchIdentity()
    local identity = safeExport('mda_miami_id', 'GetClientIdentity') or {}
    return identity.rpName or 'Recruit', identity.miamiId or '0000'
end

local function fetchEmployment()
    return safeExport('mda_rolesync', 'GetEmploymentLabel') or Config.DefaultEmployment
end

local function fetchPostal()
    return safeExport('mda_postals', 'GetPostal') or (Config.EnablePostalFallback and '000' or nil)
end

local function fetchStreet()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local streetHash, crossHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local streetName = GetStreetNameFromHashKey(streetHash)
    local crossName = GetStreetNameFromHashKey(crossHash)

    local label = streetName and safeExport('mda_postals', 'GetStreetLabel', streetName) or streetName
    local crossLabel = crossName and safeExport('mda_postals', 'GetStreetLabel', crossName) or crossName

    if label and crossLabel and crossLabel ~= '' then
        return string.format('%s / %s', label, crossLabel)
    end

    if label and label ~= '' then
        return label
    end

    return 'Unknown'
end

local function fetchMoney()
    local amount = safeExport('mda_framework', 'GetWalletBalance') or 0
    return string.format('%s%s', Config.CurrencySymbol or '$', amount)
end

local function fetchTime()
    local offset = GetConvarInt('mda_est_offset', -5)
    local now = os.time()
    local est = now + (offset * 3600)
    return os.date('!%H:%M', est) .. ' EST'
end

local function refreshHUD()
    if not showHud then return end

    local rpName, miamiId = fetchIdentity()
    local payload = {
        rpName = rpName,
        miamiId = miamiId,
        employment = fetchEmployment(),
        time = fetchTime(),
        street = fetchStreet(),
        postal = fetchPostal(),
        money = fetchMoney()
    }

    if encode(payload) == encode(lastPayload) then
        return
    end

    lastPayload = payload

    SendNUIMessage({
        action = 'updateHUD',
        payload = payload
    })
end

CreateThread(function()
    while true do
        Wait(1000)
        refreshHUD()
    end
end)

RegisterNetEvent('mda_hud:forceRefresh', refreshHUD)

RegisterCommand('togglehud', function()
    showHud = not showHud
    SendNUIMessage({ action = 'setVisible', visible = showHud })
end, false)

RegisterKeyMapping('togglehud', 'Toggle Miami HUD', 'keyboard', 'F7')

RegisterNetEvent('mda_hud:weatherAlert', function(message)
    SendNUIMessage({ action = 'weatherAlert', message = message })
end)
