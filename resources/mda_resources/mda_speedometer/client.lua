local function round(value)
    return math.floor(value + 0.5)
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local speed = round(GetEntitySpeed(vehicle) * 2.236936) -- mph
            local gear = GetVehicleCurrentGear(vehicle)
            local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
            SendNUIMessage({
                action = 'updateSpeed',
                payload = {
                    speed = speed,
                    gear = gear == 0 and 'R' or tostring(gear),
                    vehicle = vehicleName,
                    visible = true
                }
            })
        else
            SendNUIMessage({
                action = 'updateSpeed',
                payload = { visible = false }
            })
        end
        Wait(150)
    end
end)
