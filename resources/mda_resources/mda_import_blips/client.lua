local Config = Config or {}
local blips = {}

local function createBlip(data, index)
    local blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
    SetBlipSprite(blip, data.sprite or 280)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, data.scale or 0.8)
    SetBlipColour(blip, data.color or 2)
    SetBlipAsShortRange(blip, data.shortRange ~= false)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(data.label or ('Import Location %s'):format(index))
    EndTextCommandSetBlipName(blip)

    if Config.UseStaticIds then
        SetBlipPriority(blip, 6)
    end

    blips[index] = blip
end

local function removeBlips()
    for index, blip in pairs(blips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
        blips[index] = nil
    end
end

local function setupBlips()
    removeBlips()
    for i, data in ipairs(Config.Blips or {}) do
        createBlip(data, i)
    end
end

RegisterCommand('mda_refresh_blips', function(source, args)
    if source ~= 0 then return end
    setupBlips()
end, true)

AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        setupBlips()
    end
end)

exports('RefreshBlips', setupBlips)
exports('ClearBlips', removeBlips)
