fx_version 'cerulean'
games { 'gta5' }
author 'JamesUK#6793'
description 'This is a discord bot made by JamesUK#6793. Give credit where credit is due!'

server_only 'yes'

dependency 'yarn'
--dependency 'climb'

server_scripts {
    "@climb/lib/utils.lua",
    "bot.js"
}

server_exports {
    'dmUser',
}