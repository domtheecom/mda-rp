local mlos = {}

RegisterNetEvent('mda_mlo_loader:register', function(resourceName)
    if type(resourceName) ~= 'string' then return end
    mlos[#mlos + 1] = resourceName
    print(('^2[mda_mlo_loader]^0 Registered MLO resource %s'):format(resourceName))
end)

exports('GetRegisteredMlos', function()
    return mlos
end)
