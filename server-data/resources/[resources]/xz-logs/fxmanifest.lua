fx_version 'adamant'
game 'gta5'

shared_script "@xz-core/import.lua"

client_script 'client/main.lua'
server_scripts {
    'config.lua',
    'server/main.lua',
    'server/functions.lua'
}

