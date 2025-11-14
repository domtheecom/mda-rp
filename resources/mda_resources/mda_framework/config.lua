Config = {}

Config.Database = {
    tableName = 'mda_accounts',
    identifierColumn = 'discord',
    walletColumn = 'wallet',
    bankColumn = 'bank'
}

Config.DefaultWallet = 500
Config.DefaultBank = 2000

Config.StatusDefaults = {
    hunger = 80,
    thirst = 80,
    stamina = 100,
    stress = 10
}

Config.StatusDrain = {
    hunger = 0.08,
    thirst = 0.1,
    stamina = 0.05,
    stress = -0.02
}

Config.UpdateInterval = 10
Config.StatusEvent = 'mda_framework:updateStatus'
