fx_version 'bodacious'
game 'gta5'

shared_scripts {
	"@xz-core/import.lua",
	"@xz-scripts/client/cl_errorlog.lua",
	'config.lua',
}

client_scripts {
	'client/main.lua',
	'client/camera.lua',
	'client/interactions.lua',
	'client/job.lua',
	'client/gui.lua',
	'client/heli.lua',
	--'client/anpr.lua',
	'client/evidence.lua',
	'client/objects.lua',
	'client/tracker.lua',
}

server_scripts {
	'server/main.lua',
}

ui_page "html/index.html"

files {
    "html/index.html",
    "html/vue.min.js",
	"html/script.js",
	"html/tablet-frame.png",
	"html/fingerprint.png",
	"html/main.css",
	"html/vcr-ocd.ttf",
}

exports {
	'IsHandcuffed'
}

