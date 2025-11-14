fx_version 'cerulean'
game 'gta5'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server.lua'
}

client_script 'client.lua'

export 'GetClientIdentity'
server_export 'GetIdentityBySource'
