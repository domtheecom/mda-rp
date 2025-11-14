local tips = {
    'Remember to complete your academy training before reporting for duty.',
    'Use /academy to review upcoming classes and schedules.',
    'Dispatch is always available on the Sonoran Radio primary channel.',
    'Use /registerbusiness once your paperwork is approved in Discord.',
    'Visit the DMV to update your Miami ID if your RP name changes.'
}

local function sendNUIMessage(action, payload)
    payload = payload or {}
    payload.action = action
    SendNUIMessage(payload)
end

CreateThread(function()
    while true do
        Wait(500)
        sendNUIMessage('playMusic')
        return
    end
end)

RegisterNetEvent('mda_loading:setPlayerInfo', function(data)
    sendNUIMessage('setPlayerInfo', data)
end)

RegisterNetEvent('mda_loading:setPlayerCount', function(data)
    local payload = data
    if type(payload) ~= 'table' then
        payload = { count = tonumber(data) or 0 }
    end
    if not payload.max or payload.max <= 0 then
        payload.max = GetConvarInt('sv_maxclients', 48)
    end
    sendNUIMessage('setPlayerCount', payload)
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        sendNUIMessage('resourceStart', { resource = resourceName })
    end
end)

AddEventHandler('onClientResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        sendNUIMessage('stopMusic')
    end
end)

local progress = 0
CreateThread(function()
    while progress < 100 do
        progress = math.min(100, progress + math.random(3, 9))
        sendNUIMessage('setProgress', { value = progress })
        if math.random() > 0.6 then
            sendNUIMessage('setTip', { tip = tips[math.random(1, #tips)] })
        end
        Wait(2500)
    end
end)
