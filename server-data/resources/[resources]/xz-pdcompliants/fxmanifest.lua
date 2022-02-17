fx_version ("cerulean")
game ("gta5")

server_script "sv_form.lua"

client_scripts {
    "config.lua",
    "cl_form.lua"
}


ui_page {"ui/index.html"}

files {
    "ui/index.html",
    "ui/main.js",
    "ui/style.css",
    "ui/bg.png"
}