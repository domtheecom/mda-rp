Config = {}

Config.Bindings = {
    {
        command = 'togglehud',
        description = 'Toggle Miami HUD',
        default = 'F7'
    },
    {
        command = 'sonoran_push_to_talk',
        description = 'Radio Push-To-Talk',
        default = 'CAPITAL'
    },
    {
        command = 'mdamenu',
        description = 'Open Academy Menu',
        default = 'F5'
    },
    {
        command = 'mdaprop',
        description = 'Toggle Duty Belt Props',
        default = 'F6'
    },
    {
        command = 'panic',
        description = 'Panic Alarm',
        default = 'CAPSLOCK'
    },
    {
        command = 'mdaseatbelt',
        description = 'Toggle Seatbelt',
        default = 'B'
    }
}

Config.EnsureCommands = {
    mdamenu = function()
        TriggerEvent('chat:addMessage', { args = { '^3MDA', 'Bind mdamenu to your preferred key. Implement menu command later.' } })
    end,
    mdaprop = function()
        TriggerEvent('chat:addMessage', { args = { '^3MDA', 'Bind mdaprop to your preferred key. Add functionality later.' } })
    end,
    panic = function()
        TriggerEvent('chat:addMessage', { args = { '^1MDA', 'Panic alert triggered. Integrate with dispatch system.' } })
    end,
    mdaseatbelt = function()
        TriggerEvent('chat:addMessage', { args = { '^2MDA', 'Seatbelt toggled (placeholder).' } })
    end
}
