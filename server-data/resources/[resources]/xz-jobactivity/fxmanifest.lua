
fx_version 'cerulean'
games { 'gta5' }

author 'XZone And Elior#0590'
description 'A Job Active List'
version '1.0.0'

shared_script "config.lua"
client_script "client/main.lua"
server_script "server/main.lua"

ui_page {
    'interface/index.html'
}

files {
    'interface/*.*'
}
