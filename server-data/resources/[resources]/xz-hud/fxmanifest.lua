fx_version 'bodacious'
game 'gta5'
version '1.0.0'

shared_scripts {
    "@xz-core/import.lua",
}

client_script 'cl_hud.lua'
client_script 'cl_veh.lua'

ui_page 'interface/interface.html'

files {
    'interface/index.html',
    'interface/*',
    'interface/imgs/*',
}