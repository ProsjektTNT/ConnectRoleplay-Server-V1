fx_version 'cerulean'
game 'gta5'

shared_scripts { 
	'@xz-core/import.lua',
	'config.lua'
}

server_script 'sv_pawnshop.lua'

client_scripts {
	'cl_pawnshop.lua',
	'cl_pawnmelt.lua'
}