local identity = {}

RegisterNetEvent('mda_miami_id:setIdentity', function(data)
    identity = data or {}
    TriggerEvent('mda_hud:forceRefresh')
end)

exports('GetClientIdentity', function()
    if not identity or not identity.miamiId then
        TriggerServerEvent('mda_miami_id:requestIdentity')
    end
    return identity
end)

CreateThread(function()
    Wait(2500)
    TriggerServerEvent('mda_miami_id:requestIdentity')
end)
