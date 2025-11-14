local displayDistance = 20.0
local fadeDistance = 15.0
local playerIdentities = {}

local function drawText3D(coords, text, alpha)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if not onScreen then return end

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(247, 233, 195, alpha or 215)
    SetTextCentre(true)
    SetTextOutline()
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(_x, _y)
end

local function getIdentity(serverId)
    if serverId == GetPlayerServerId(PlayerId()) then
        return exports['mda_miami_id'] and exports['mda_miami_id']:GetClientIdentity()
    end
    return playerIdentities[serverId]
end

RegisterNetEvent('mda_nametags:setIdentity', function(serverId, data)
    if not serverId then return end
    if data then
        playerIdentities[serverId] = data
    else
        playerIdentities[serverId] = nil
    end
end)

CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, player in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(player)
            if ped ~= 0 and ped ~= playerPed then
                local coords = GetEntityCoords(ped)
                local distance = #(coords - playerCoords)
                if distance <= displayDistance then
                    local serverId = GetPlayerServerId(player)
                    local identity = getIdentity(serverId)
                    if identity and identity.rpName then
                        local alpha = 255
                        if distance > fadeDistance then
                            alpha = math.floor(255 * (1 - (distance - fadeDistance) / (displayDistance - fadeDistance)))
                        end
                        drawText3D(coords + vector3(0.0, 0.0, 1.05), string.format('%s | %s', identity.rpName, identity.miamiId or 'MDA-0000'), alpha)
                    end
                end
            end
        end

        Wait(0)
    end
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    TriggerServerEvent('mda_miami_id:requestIdentity')
end)
