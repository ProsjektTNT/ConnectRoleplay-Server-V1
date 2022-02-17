fx_version 'adamant'
game 'gta5'

shared_script "@xz-scripts/client/cl_errorlog.lua"
ui_page "html/meter.html"

client_scripts {
    "client/cl_*.*",
    "config.lua",
    "@PolyZone/client.lua",
}

files {
    "html/meter.css",
    "html/meter.html",
    "html/meter.js",
    "html/reset.css",
    "html/g5-meter.png"
}

server_scripts {
    "server/sv_*.*",
    "config.lua",
}


exports {
	'GetVehicleStatusList',
	'GetVehicleStatus',
	'SetVehicleStatus',
}


