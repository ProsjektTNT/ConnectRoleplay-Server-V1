fx_version 'adamant'
game 'gta5'

shared_script "@xz-scripts/client/cl_errorlog.lua"

client_scripts {
    "client/cl_*.*",
    "client/cl_core.lua",
    "config.lua",
    "@warmenu/warmenu.lua",
}

server_scripts {
    "server/sv_*.*",
    "server/sv_core.lua",
    "config.lua",
}

ui_page 'html/index.html'
files {
	'meta/gunmeta.meta',
    "html/*.*",
}

data_file 'WEAPONINFO_FILE' 'meta/gunmeta.meta'

exports {
    "HasHarness",
    "IsNearPoliceGarage",
}


