Config = {}

Config.RequireDiscord = true
Config.DiscordGuildId = '1431156290402652182'
Config.VerifiedRoleIds = {
    ['Recruit'] = 'academy_recruit',
    ['Citizen'] = 'civilian_role',
    ['BusinessOwner'] = 'business_owner',
    ['GangMember'] = 'gang_member',
    ['Agency'] = 'agency_member'
}

Config.Database = {
    tableName = 'mda_identities',
    identifierColumn = 'discord',
    idColumn = 'miami_id',
    nameColumn = 'rp_name',
    employmentColumn = 'employment',
    statusColumn = 'status',
    lastSeenColumn = 'last_seen'
}

Config.MiamiIdPrefix = 'MDA'
Config.IdLength = 4

Config.CacheDuration = 5 * 60

Config.WebhookLogging = false
Config.WebhookUrl = ''
