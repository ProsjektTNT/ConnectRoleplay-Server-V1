fx_version 'cerulean'
game 'gta5'

shared_scripts { 
	'@xz-core/import.lua',
	'@xz-scripts/client/cl_errorlog.lua',
    '@warmenu/warmenu.lua'
}

client_scripts {
    'client/main.lua',
    'client/noclip.lua',
}

server_script 'server/main.lua'
