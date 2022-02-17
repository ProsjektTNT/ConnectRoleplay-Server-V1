fx_version 'adamant'
games {'gta5'}

description 'IronShield'
dependency 'screenshot-basic'
startResource("screenshot-basic")

client_scripts {
	'client.lua',
}

server_scripts {
	'configs/*.lua',
	'tables/*.lua',
	'server.lua',
	'installer.lua',
}






