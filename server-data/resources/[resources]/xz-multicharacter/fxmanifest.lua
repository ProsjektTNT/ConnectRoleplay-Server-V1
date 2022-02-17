fx_version "adamant"
game "gta5"

shared_scripts {
    "@xz-core/import.lua",
    "@xz-scripts/client/cl_errorlog.lua"
}

client_scripts {
    'config.lua',
    'client/cl_functions.lua',
    'client/cl_main.lua'
}

server_script "server/sv_main.lua"

ui_page 'ui/index.html'
files {
    'ui/index.html',
    'ui/main.js',
    'ui/style.css'
}