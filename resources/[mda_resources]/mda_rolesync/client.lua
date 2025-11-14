local employmentLabel = 'Employment Pending'

RegisterNetEvent('mda_rolesync:setEmployment', function(label)
    employmentLabel = label or employmentLabel
    TriggerEvent('mda_hud:forceRefresh')
end)

exports('GetEmploymentLabel', function()
    return employmentLabel
end)

CreateThread(function()
    Wait(5000)
    TriggerServerEvent('mda_miami_id:requestIdentity')
end)
