resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

shared_script "@xz-scripts/client/cl_errorlog.lua"

client_scripts {
	'config.lua',
	'client/main.lua',
	'client/jobs.lua',
	'client/prisonbreak.lua',
}

server_scripts {
	'config.lua',
	'server/main.lua',
}

