fx_version 'cerulean'
game 'gta5'

shared_scripts { 
	'@xz-core/import.lua',
	'config.lua'
}

client_scripts {
	'cl_apartments.lua',
	'cl_gui.lua'
}

server_script 'sv_apartments.lua'
