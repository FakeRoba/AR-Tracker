game 'gta5'
fx_version 'cerulean'

author 'Roba'

client_scripts {
    'Config/Config.lua',
    'Client/*.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'Config/S_Config.lua',
    'Server/*.lua'
}

shared_script '@es_extended/imports.lua'