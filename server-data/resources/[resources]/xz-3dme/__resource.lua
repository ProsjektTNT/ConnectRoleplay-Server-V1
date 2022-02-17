resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

shared_script "@xz-scripts/client/cl_errorlog.lua"


client_script 'bb_c.lua'
server_script 'bb_s.lua'

files {
	"bb_index.html",
	"bb_js.js"
}

ui_page {
	'bb_index.html',
}
