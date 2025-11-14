local Config = Config or {}
local currentAlert = nil

RegisterNetEvent('mda_weather:setWeather', function(weatherType)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypeOvertimePersist(weatherType, 15.0)
    Wait(15000)
    SetWeatherTypePersist(weatherType)
    SetWeatherTypeNowPersist(weatherType)
    SetWeatherTypeNow(weatherType)
    SetOverrideWeather(weatherType)
end)

RegisterNetEvent('mda_weather:broadcastAlert', function(message)
    currentAlert = message
    TriggerEvent('mda_hud:weatherAlert', message)
    Wait(Config.AnnouncementDuration or 15000)
    currentAlert = nil
    TriggerEvent('mda_hud:weatherAlert', '')
end)
