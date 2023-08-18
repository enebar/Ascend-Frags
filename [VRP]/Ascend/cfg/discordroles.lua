cfg = {
	Guild_ID = '1140756160840994909',
  	Multiguild = false,
  	Guilds = {
		['Main'] = '1140756160840994909', 
		-- ['Police'] = '1071245461849116713', 
	--	['NHS'] = '1062753698528382976',
		-- ['HMP'] = '1016844313591812128',
		-- ['LFB'] = '1016858643293024308',
  	},
	RoleList = {},

	CacheDiscordRoles = false, -- true to cache player roles, false to make a new Discord Request every time
	CacheDiscordRolesTime = 60, -- if CacheDiscordRoles is true, how long to cache roles before clearing (in seconds)
}

cfg.Guild_Roles = {
	['Main'] = {
		['Founder'] = 1140756160983601186, -- 12
		['Lead Developer'] = 1140756160983601185, -- 11
		['Developer'] = 1140756160983601184, -- 10
		['Community Manager'] = 1140756160983601183, -- 9
		['Staff Manager'] = 1140756160983601182, -- 8
		['Head Admin'] = 1140756160941654147, -- 7
		['Senior Admin'] = 1140756160941654145, -- 6
		['Administrator'] = 1140756160941654144, -- 5
		['Senior Moderator'] = 1140756160941654143, -- 4
		['Moderator'] = 1140756160941654142, -- 3
		['Support Team'] = 1140756160941654141, -- 2
		['Trial Staff'] = 1140756160941654140, -- 1
		['cardev'] = 1140756160887140381,
		['Cinematic'] = 1140756160840994912,
	},

	-- ['Police'] = {
	-- 	['Commissioner'] = 1071245892667064400,
	-- 	['Deputy Commissioner'] = 1071245893166178306,
	-- 	['Assistant Commissioner'] = 1071245893942136973,
	-- 	['Dep. Asst. Commissioner'] = 1071245894957146143,
	-- 	['Commander'] = 1071245895686963340,
	-- 	['Chief Superintendent'] = 1071245897586970747,
	-- 	['Superintendent'] = 1071245898262270082,
	-- 	['Chief Inspector'] = 1071245903924572210,
	-- 	['Inspector'] = 1071245904801189958,
	-- 	['Sergeant'] = 1071245905359011861,
	-- 	['Special Constable'] = 1071245908353749022,
	-- 	['Senior Constable'] = 1071245905879113759,
	-- 	['PC'] = 1071245906894127117,
	-- 	['PCSO'] = 1071245907758166106,
	-- 	['Large Arms Access'] = 1071245949634089091,
	-- 	['Police Horse Trained'] = 1071245957292900462,
	-- 	['Drone Trained'] = 1071245959914332221,
	-- 	['NPAS'] = 1071245942046609439,
	-- 	['Trident Officer'] = 1071245937197994124,
	-- 	['Trident Command'] = 1071245933154664599,
	-- 	['K9 Trained'] = 1071245959218086029,
	-- },

	--['NHS'] = {
	--	['NHS Head Chief'] = 1062753858419441664,
	--	['NHS Assistant Chief'] = 1062753858910167072,
	--	['NHS Deputy Chief'] = 1062753859950362684,
	--	['NHS Captain'] = 1062753860432699432,
		--['NHS Consultant'] = 1062753873682518039,
	--	['NHS Specialist'] = 1062753874781405184,
		--['NHS Senior Doctor'] = 1062753878975729744,
		--['NHS Doctor'] = 1062753879877484565,
		--['NHS Junior Doctor'] = 1062753880481472602,
		--['NHS Critical Care Paramedic'] = 1062753881072869526,
	--	['NHS Paramedic'] = 1062753887917965372,
	--	['NHS Trainee Paramedic'] = 1062753888572280882,
	--	['Drone Trained'] = 1065226113158234134,
	--	['HEMS'] = 1065228761198493726,
	--},

	-- ['HMP'] = {
	-- 	['Governor'] = 1017619823804547113,
	-- 	['Deputy Governor'] = 1017619884177358882,
	-- 	['Divisional Commander'] = 1017619931526877246,
	-- 	['Custodial Supervisor'] = 1017619970349334590,
	-- 	['Custodial Officer'] = 1017620004373544992,
	-- 	['Honourable Guard'] = 1017620044798251148,
	-- 	['Supervising Officer'] = 1017620085654958080,
	-- 	['Principal Officer'] = 1017620118433431653,
	-- 	['Specialist Officer'] = 1017620166990888960,
	-- 	['Senior Officer'] = 1017620204655755317,
	-- 	['Prison Officer'] = 1017620239686582403,
	-- 	['Trainee Prison Officer'] = 1017620274537046086,
	-- },

	-- ['LFB'] = {
	-- 	['Chief Fire Command'] = 1017621455120379944,
	-- 	['Divisional Command'] = 1017621512255197254,
	-- 	['Sector Command'] = 1017621546212261888,
	-- 	['Honourable Firefighter'] = 1017621584850190417,
	-- 	['Leading Firefighter'] = 1017621616416538677,
	-- 	['Specialist Firefighter'] = 1017621659332644865,
	-- 	['Advanced Firefighter'] = 1017621694740959233,
	-- 	['Senior Firefighter'] = 1017621729885036597,
	-- 	['Firefighter'] = 1017621763531751434,
	-- 	['Junior Firefighter'] = 1017621801355976756,
	-- 	['Provisional Firefighter'] = 1017621836089016420,
	-- },
	
}

for faction_name, faction_roles in pairs(cfg.Guild_Roles) do
	for role_name, role_id in pairs(faction_roles) do
		cfg.RoleList[role_name] = role_id
	end
end


cfg.Bot_Token = 'MTE0MTA3MTM0MTQxNjYxNjExNw.GG2omN.sHrNkbAtyHlxQLFCGFqAi3zIcSENdsL87m-UZY'

return cfg