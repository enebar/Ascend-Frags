
fx_version 'cerulean'
games {  'gta5' }

description "CLIMB MySQL async - Modified Version"
dependency "ghmattimysql"
-- server scripts
server_scripts{ 
  "@CLIMB/lib/utils.lua",
  "MySQL.lua"
}

