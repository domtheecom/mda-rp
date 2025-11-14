Config = {}

Config.Discord = {
    GuildId = '1431156290402652182',
    BotTokenConvar = 'mda_discord_bot_token',
    RequestTimeout = 8000
}

Config.RoleMappings = {
    {
        roleId = 'ROLE_ID_FHP',
        label = 'Florida Highway Patrol',
        employment = 'Agency - FHP',
        payoutGroup = 'fhp',
        ace = 'group.mda.agency.fhp'
    },
    {
        roleId = 'ROLE_ID_MDFR',
        label = 'Miami Dade Fire Rescue',
        employment = 'Agency - MDFR',
        payoutGroup = 'mdfr',
        ace = 'group.mda.agency.mdfr'
    },
    {
        roleId = 'ROLE_ID_FWC',
        label = 'Florida Fish & Wildlife',
        employment = 'Agency - FWC',
        payoutGroup = 'fwc',
        ace = 'group.mda.agency.fwc'
    },
    {
        roleId = 'ROLE_ID_MDPD',
        label = 'Miami-Dade Police Department',
        employment = 'Agency - MDPD',
        payoutGroup = 'mdpd',
        ace = 'group.mda.agency.mdpd'
    },
    {
        roleId = 'ROLE_ID_SWAT',
        label = 'Miami-Dade SWAT',
        employment = 'Agency - MD-SWAT',
        payoutGroup = 'mdswat',
        ace = 'group.mda.agency.mdswat'
    },
    {
        roleId = 'ROLE_ID_FDOT',
        label = 'Florida Department of Transportation',
        employment = 'Agency - FDOT',
        payoutGroup = 'fdot',
        ace = 'group.mda.agency.fdot'
    },
    {
        roleId = 'ROLE_ID_DISPATCH',
        label = 'Miami-Dade Dispatch',
        employment = 'Agency - Dispatch',
        payoutGroup = 'dispatch',
        ace = 'group.mda.agency.dispatch'
    },
    {
        roleId = 'ROLE_ID_BUSINESS',
        label = 'Business Owner',
        employment = 'Business Owner',
        payoutGroup = 'business',
        ace = 'group.mda.business'
    },
    {
        roleId = 'ROLE_ID_GANG',
        label = 'Gang Member',
        employment = 'Gang Member',
        payoutGroup = 'gang',
        ace = 'group.mda.gang'
    },
    {
        roleId = 'ROLE_ID_CIVILIAN',
        label = 'Citizen',
        employment = 'Citizen',
        payoutGroup = 'civilian',
        ace = 'group.mda.citizen'
    }
}

Config.DefaultEmployment = 'Unemployed'
Config.DefaultPayoutGroup = 'civilian'

Config.RefreshInterval = 5 * 60

Config.WebhookLogging = false
Config.WebhookUrl = ''
