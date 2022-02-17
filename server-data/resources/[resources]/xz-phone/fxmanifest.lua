fx_version 'cerulean'
game 'gta5'

ui_page 'html/index.html'

shared_scripts {
    'config.lua',
	'@xz-core/import.lua',
}

client_scripts {
    'client/main.lua',
    'client/animation.lua',
    'client/rentel.lua',
    'client/gui.lua'
}

server_script 'server/main.lua'

files {
    'html/*.html',
    'html/js/*.js',
    'html/img/*.png',
    'html/css/*.css',
    'html/fonts/*.ttf',
    'html/fonts/*.otf',
    'html/fonts/*.woff',
    'html/img/backgrounds/*.png',
    'html/img/apps/*.png',
}