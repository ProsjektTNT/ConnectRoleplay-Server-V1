fx_version "cerulean"
game "gta5"

shared_scripts {
    "@xz-core/import.lua",
    "config.lua"
}

client_scripts {
    '@PolyZone/CircleZone.lua',
    '@PolyZone/client.lua',
    "cl_hunting.lua"
}
server_script "sv_hunting.lua"
