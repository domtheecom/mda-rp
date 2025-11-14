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
        ace = 'mda.agency.fhp'
    },
    {
        roleId = 'ROLE_ID_MDFR',
        label = 'Miami Dade Fire Rescue',
        employment = 'Agency - MDFR',
        payoutGroup = 'mdfr',
        ace = 'mda.agency.mdfr'
    },
    {
        roleId = 'ROLE_ID_FWC',
        label = 'Florida Fish & Wildlife',
        employment = 'Agency - FWC',
        payoutGroup = 'fwc',
        ace = 'mda.agency.fwc'
    },
    {
        roleId = 'ROLE_ID_MDPD',
        label = 'Miami-Dade Police Department',
        employment = 'Agency - MDPD',
        payoutGroup = 'mdpd',
        ace = 'mda.agency.mdpd'
    },
    {
        roleId = 'ROLE_ID_SWAT',
        label = 'Miami-Dade SWAT',
        employment = 'Agency - MD-SWAT',
        payoutGroup = 'mdswat',
        ace = 'mda.agency.mdswat'
    },
    {
        roleId = 'ROLE_ID_FDOT',
        label = 'Florida Department of Transportation',
        employment = 'Agency - FDOT',
        payoutGroup = 'fdot',
        ace = 'mda.agency.fdot'
    },
    {
        roleId = 'ROLE_ID_DISPATCH',
        label = 'Miami-Dade Dispatch',
        employment = 'Agency - Dispatch',
        payoutGroup = 'dispatch',
        ace = 'mda.agency.dispatch'
    },
    {
        roleId = 'ROLE_ID_BUSINESS',
        label = 'Business Owner',
        employment = 'Business Owner',
        payoutGroup = 'business',
        ace = 'mda.business'
    },
    {
        roleId = 'ROLE_ID_GANG',
        label = 'Gang Member',
        employment = 'Gang Member',
        payoutGroup = 'gang',
        ace = 'mda.gang'
    },
    {
        roleId = 'ROLE_ID_CIVILIAN',
        label = 'Citizen',
        employment = 'Citizen',
        payoutGroup = 'civilian',
        ace = 'mda.citizen'
    }
}

Config.DefaultEmployment = 'Unemployed'
Config.DefaultPayoutGroup = 'civilian'

Config.RefreshInterval = 5 * 60

Config.WebhookLogging = false
Config.WebhookUrl = ''
