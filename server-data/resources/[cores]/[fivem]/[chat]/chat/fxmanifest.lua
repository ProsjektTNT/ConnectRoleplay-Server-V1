fx_version 'adamant'
game 'gta5'

ui_page 'interface/interface.html'

files {
  'interface/*.*',
  'interface/js/*.*',
  'interface/vendor/*.*',
  'interface/vendor/fonts/*.*',
}

client_scripts {
  'client/cl_chat.lua'
}

server_scripts {
  'config.lua',
  'server/utils.lua',
  'server/commands.lua',
  'server/sv_chat.lua',
  'server/main.lua',
}

chat_theme 'gtao' {
  styleSheet = 'style.css',
  msgTemplates = {
      default = '<b>{0}</b><span>{1}</span>'
  }
}