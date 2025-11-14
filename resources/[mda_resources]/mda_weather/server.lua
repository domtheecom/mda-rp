local Config = Config or {}

local function tableKeys(tbl)
    local keys = {}
    for key in pairs(tbl) do
        keys[#keys + 1] = key
    end
    table.sort(keys)
    return keys
end

local function hasPermission(source)
    if source == 0 then return true end
    if not Config.RequireAce then return true end
    return IsPlayerAceAllowed(source, Config.AceName)
end

local function setWeather(source, weatherKey)
    local weatherType = Config.AllowedWeathers[string.lower(weatherKey or '')]
    if not weatherType then
        if source ~= 0 then
            TriggerClientEvent('chat:addMessage', source, { args = { '^1WEATHER', 'Invalid weather type. Available: ' .. table.concat(tableKeys(Config.AllowedWeathers), ', ') } })
        else
            print('Invalid weather type.')
        end
        return
    end

    TriggerClientEvent('mda_weather:setWeather', -1, weatherType)
    TriggerClientEvent('chat:addMessage', -1, { args = { '^3WEATHER', ('Conditions updated to %s by command staff.'):format(weatherKey) } })
end

RegisterCommand('mdaweather', function(source, args)
    if not hasPermission(source) then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1WEATHER', 'You do not have permission to modify weather.' } })
        return
    end

    local weatherKey = args[1]
    if not weatherKey then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1WEATHER', 'Usage: /mdaweather <clear|rain|storm|fog|overcast|snow|hurricane>' } })
        return
    end

    setWeather(source, weatherKey)
end, false)

RegisterCommand('mdaweatheralert', function(source, args)
    if not hasPermission(source) then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1WEATHER', 'You do not have permission to broadcast alerts.' } })
        return
    end

    local message = table.concat(args, ' ')
    if message == '' then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1WEATHER', 'Usage: /mdaweatheralert <message>' } })
        return
    end

    TriggerClientEvent('mda_weather:broadcastAlert', -1, message)
    print(('^3[mda_weather]^0 Alert broadcast: %s'):format(message))
end, false)
