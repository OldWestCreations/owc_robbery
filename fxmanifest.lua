fx_version "adamant"
lua54 'yes'
games {'rdr3'}

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'HerrScaletta | Old West Creations'
description 'NPC Surrender and Money Drop Script'
version '2.0'

shared_scripts {
    'translations.lua',
 	'config.lua',
}

client_scripts {
	'client/client.lua',
}

server_scripts {
	'server/server.lua',
}

