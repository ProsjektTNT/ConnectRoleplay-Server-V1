fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'Ido#8475'
description 'XZ-Garages, new for 24.08.2021'
version '1.0.0'

shared_scripts {
    '@xz-core/import.lua',
    'garages-config.lua'
}

client_scripts {
    'garages-cl.lua',
    'garages-dict.lua',
    'keys.lua'
} 
server_script 'garages-se.lua'

exports {
    'closeToGarage',
    'closeToImpound'
}