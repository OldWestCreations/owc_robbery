fx_version "adamant"
lua54 'yes'
games {'rdr3'}

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'HerrScaletta | Old West Creations'
description 'NPC Surrender and Money Drop Script'
version '1.3'

shared_scripts {
 	'config.lua',
}

client_scripts {
	'client/client.lua',
}

server_scripts {
	'server/server.lua',
}

vorp_checker 'yes'
vorp_name '^5 Old West Creations ^4version Check^3'
vorp_github 'https://github.com/OldWestCreations/owc_robbery'

