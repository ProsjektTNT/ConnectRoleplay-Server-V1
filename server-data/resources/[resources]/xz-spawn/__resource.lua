resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

shared_script "@xz-scripts/client/cl_errorlog.lua"

client_scripts {
	'@xz-houses/config.lua',
	'@xz-scripts/config.lua',
	'config.lua',
	'client.lua',
}

server_scripts {
	'@xz-houses/config.lua',
	'@xz-scripts/config.lua',
	'config.lua',
	'server.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/script.js',
	'html/reset.css',
}

