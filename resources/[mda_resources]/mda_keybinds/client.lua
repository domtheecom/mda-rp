local Config = Config or {}

for _, binding in ipairs(Config.Bindings) do
    RegisterCommand(binding.command, function()
        if Config.EnsureCommands[binding.command] then
            Config.EnsureCommands[binding.command]()
        end
    end, false)
    RegisterKeyMapping(binding.command, binding.description, 'keyboard', binding.default)
end
