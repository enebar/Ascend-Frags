const Discord = require('discord.js');
const client = new Discord.Client();
const path = require('path')
const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
require('dotenv').config({ path: path.join(resourcePath, './.env') })
const fs = require('fs');
const settingsjson = require(resourcePath + '/settings.js')
var statusLeaderboard = require(resourcePath + '/statusleaderboard.json');

client.path = resourcePath
client.ip = settingsjson.settings.ip

if (process.env.TOKEN == "" || process.env.TOKEN == "TOKEN") {
    console.log(`Error! No Token Provided you forgot to edit the .env`);
    throw new Error('Whoops!')
}

client.on('ready', () => {
    console.log(`Logged in as ${client.user.tag}! Players: ${GetNumPlayerIndices()}`);
    console.log(`Your Prefix Is ${process.env.PREFIX}`)
    init()
});

let onlinePD = 0
let onlineStaff = 0
let onlineNHS = 0
let serverStatus = ""

if (settingsjson.settings.StatusEnabled) {
    setInterval(() => {
        if (!client.guilds.get(settingsjson.settings.GuildID)) return console.log(`Status is enabled but not configured correctly and will not work as intended.`)
        let channelid = client.guilds.get(settingsjson.settings.GuildID).channels.find(r => r.name === settingsjson.settings.StatusChannel);
        if (!channelid) return console.log(`Status channel is not available / cannot be found.`)
        let settingsjsons = require(resourcePath + '/params.json')
        let totalSeconds = (client.uptime / 1000);
        totalSeconds %= 86400;
        let hours = Math.floor(totalSeconds / 3600);
        totalSeconds %= 3600;
        let minutes = Math.floor(totalSeconds / 60);
        client.user.setActivity(`${GetNumPlayerIndices()}/${GetConvarInt("sv_maxclients",60)} players`, { type: 'WATCHING' });
        exports.ghmattimysql.execute("SELECT * FROM `climb_user_moneys`", (result) => {
            playersSinceRelease = result.length
        });
        exports.climb.climbbot('getUsersByPermission', ['admin.tickets'], function(result) {
            if (!result.length)
                onlineStaff = 0
            else
                onlineStaff = result.length
        })
        exports.climb.climbbot('getUsersByPermission', ['police.onduty.permission'], function(result) {
            if (!result.length)
                onlinePD = 0
            else
                onlinePD = result.length
        })
        exports.climb.climbbot('getUsersByPermission', ['nhs.onduty.permission'], function(result) {
            if (!result.length)
                onlineNHS = 0
            else
                onlineNHS = result.length
        })
        exports.climb.getServerStatus([], function(result) {
            serverStatus = result
        })
        channelid.fetchMessage(settingsjsons.messageid).then(msg => {
            let status = {
                "color": settingsjson.settings.botColour,
                "fields": [{
                        "name": "Server Status",
                        "value": `🟠 Under Development`,
                        "inline": true
                    }, 
                    {
                        "name": "👫 Players Online:",
                        "value": `${GetNumPlayerIndices()}/${GetConvarInt("sv_maxclients",64)}`,
                        "inline": true
                    },
                    {
                        "name": "✅ Uptime:",
                        "value": `${hours} hours, ${minutes} minutes`,
                        "inline": true
                    },                    
                    {
                        "name": "💂 Staff Online:",
                        "value": `${onlineStaff}`,
                        "inline": true
                    },                    
                    {
                        "name": "👮🏻 MET PD Online:",
                        "value": `${onlinePD}`,
                        "inline": true
                    },                      
                    {
                        "name": "🚑 NHS Online:",
                        "value": `${onlineNHS}`,
                        "inline": true
                    },                      
                    {
                        "name": "💻 How do I connect?",
                        "value": '``F8 -> connect s1.climb.uk``',
                        //"value": "``Search 'Vesper' on FiveM Server List``",
                        "inline": true
                    }
                ],
                "title": "Vesper Status",
                "footer": {
                    "text": "⚙️ Vesper"
                },
                "timestamp": new Date()
            }
            msg.edit({ embed: status }) // uncomment when not using testing bot
        }).catch(err => {
            channelid.send('Vesper Status Page Starting...').then(id => {
                settingsjsons.messageid = id.id
                fs.writeFile(`${resourcePath}/params.json`, JSON.stringify(settingsjsons), function(err) {});
                return
            })
        })
    }, 15000);
}


client.commands = new Discord.Collection();

const init = async() => {
    fs.readdir(resourcePath + '/commands/', (err, files) => {
        if (err) console.error(err);
        console.log(`Loading a total of ${files.length} commands.`);
        files.forEach(f => {
            let command = require(`${resourcePath}/commands/${f}`);
            client.commands.set(command.conf.name, command);
        });
        if (!statusLeaderboard['leaderboard']) {
            statusLeaderboard['leaderboard'] = {}
        }
        else {
            statusLeaderboard['leaderboard'] = statusLeaderboard['leaderboard']
        }
    });
}

// setInterval(function(){
//     promotionDetection();
// }, 60*1000);

function promotionDetection(){
  client.users.forEach(user =>{ //iterate over each user
    if(user.presence.status == "online" || user.presence.status == 'dnd' || user.presence.status == 'idle' && !user.bot){ //check if user is online and is not a bot
        if(!statusLeaderboard['leaderboard'][user.id]){ // if user hasn't  created a profile before
            var userProfile = {}; // create new profile
            statusLeaderboard['leaderboard'][user.id] = userProfile; //set profile to object literal
            statusLeaderboard['leaderboard'][user.id] = 0; //set minutes to 0
        }
        if(Object.entries(user.presence.activities).length > 0 && typeof(user.presence.activities[0].state) === 'string' && user.presence.activities[0].state.includes('discord.gg/climbrp') ){ //check if they have a status
            statusLeaderboard['leaderboard'][user.id] += 1;
            fs.writeFileSync(`${resourcePath}/statusleaderboard.json`, JSON.stringify(statusLeaderboard), function(err) {});
        }
    }
  })
}

client.getPerms = function(msg) {

    let settings = settingsjson.settings
    let lvl1 = msg.guild.roles.find(r => r.name === settings.Level1Perm);
    let lvl2 = msg.guild.roles.find(r => r.name === settings.Level2Perm);
    let lvl3 = msg.guild.roles.find(r => r.name === settings.Level3Perm);
    let lvl4 = msg.guild.roles.find(r => r.name === settings.Level4Perm);
    let lvl5 = msg.guild.roles.find(r => r.name === settings.Level5Perm);
    let lvl6 = msg.guild.roles.find(r => r.name === settings.Level6Perm);
    let lvl7 = msg.guild.roles.find(r => r.name === settings.Level7Perm);
    if (!lvl1 || !lvl2 || !lvl3 || !lvl4 || !lvl5 || !lvl6 || !lvl7) {
        console.log(`Your permissions are not setup correctly and the bot will not function as intended.\nStatus: Please check permission levels are setup correctly.`)
    }

    // hot fix for Discord role caching 
    const guild = client.guilds.get(msg.guild.id);
    if (guild.members.has(msg.author.id)) {
        guild.members.delete(msg.author.id);
    }
    const member = guild.members.get(msg.author.id);
    // hot fix for Discord role caching 

    let level = 0;
    if (msg.member.roles.has(lvl7.id)) {
        level = 7;
    } else if (msg.member.roles.has(lvl6.id)) {
        level = 6;
    } else if (msg.member.roles.has(lvl5.id)) {
        level = 5;
    } else if (msg.member.roles.has(lvl4.id)) {
        level = 4;
    } else if (msg.member.roles.has(lvl3.id)) {
        level = 3;
    } else if (msg.member.roles.has(lvl2.id)) {
        level = 2;
    } else if (msg.member.roles.has(lvl1.id)) {
        level = 1;
    }
    return level
}

client.on('message', (message) => {
    if (!message.author.bot){
        if (message.channel.name.includes('auction-')){
            if (message.channel.name == '・auction-room'){
                return
            }
            else{
                if (!message.content.includes(`${process.env.PREFIX}bid`)){
                    if (!message.content.includes(`${process.env.PREFIX}auction`) && !message.content.includes(`${process.env.PREFIX}houseauction`) && !message.content.includes(`${process.env.PREFIX}embed`)){
                        message.delete()
                        return
                    }
                }
            }
        }else if (message.channel.name.includes('verify')){
            if (!message.content.includes(`${process.env.PREFIX}verify `)){
                message.delete()
                return
            }
        }
    }
    let client = message.client;
    if (message.author.bot) return;
    if (!message.content.startsWith(process.env.PREFIX)) return;
    let command = message.content.split(' ')[0].slice(process.env.PREFIX.length).toLowerCase();
    let params = message.content.split(' ').slice(1);
    let cmd;
    let permissions = 0
    if (message.guild.id === settingsjson.settings.GuildID) {
        permissions = client.getPerms(message)
    }
    if (client.commands.has(command)) {
        cmd = client.commands.get(command);
    }
    if (cmd) {
        if (message.guild.id === cmd.conf.guild) {
            if (!message.channel.name.includes('verify') && cmd.conf.name === 'verify'){
                message.delete()
                message.reply('Please use #verify for this command.').then(msg => {
                    msg.delete(5000)
                })
                return
            }else if (!message.channel.name.includes('bot') && !message.channel.name.includes('verify') && !cmd.name === 'embed') {
                message.delete()
                message.reply('Please use bot commands for this command.').then(msg => {
                    msg.delete(5000)
                })
            }
            else {
                if (permissions < cmd.conf.perm) return;
                try {
                    cmd.runcmd(exports, client, message, params, permissions);
                    if (cmd.conf.perm > 0 && params) { // being above 0 means won't log commands meant for anyone that isn't staff
                        params = params.join('\n ');
                        if (params != '') {
                            let { Webhook, MessageBuilder } = require('discord-webhook-node');
                            let hook = new Webhook(settingsjson.settings.botLogWebhook);
                            let embed = new MessageBuilder()
                            .setTitle('Bot Command Log')
                            .addField('Command Used:', `${cmd.conf.name}`)
                            .addField('Parameters:', `${params}`)
                            .addField('Admin:', `${message.author.username} - <@${message.author.id}>`)
                            .setColor('16448403')
                            .setFooter('Vesper RP')
                            .setTimestamp();
                            hook.send(embed);
                        }
                    }
                } catch (err) {
                    let embed = {
                        "title": "Error Occured!",
                        "description": "\nAn error occured. Contact <@609044650019258407> about the issue:\n\n```" + err.message + "\n```",
                        "color": 13632027
                    }
                    message.channel.send({ embed })
                }
            }
        } else {
            if (cmd.conf.support && message.guild.id === "991500085672288308"){
                if (message.member.roles.has("991500950533574686")){
                    cmd.runcmd(exports, client, message, params, permissions);
                }
            } else {
                message.reply('This command is expected to be used within another guild.').then(msg => {
                    msg.delete(5000)
                })
                return;
            }
        }
    }
});

client.on("guildMemberAdd", function (member) {
    if (member.guild.id === settingsjson.settings.GuildID){
        try {
            exports.ghmattimysql.execute("SELECT * FROM `climb_verification` WHERE discord_id = ? AND verified = 1", [member.id], (result) => {
                if (result.length > 0){
                    let role = member.guild.roles.find(r => r.name === '| Verified');
                    member.addRole(role);
                }
            });
        
        } catch (error) {}
    }
});

exports('dmUser', (source, args) => {
    let discordid = args[0].trim()
    let verifycode = args[1]
    let permid = args[2]
    const guild = client.guilds.get(settingsjson.settings.GuildID);
    const member = guild.members.get(discordid);
    try {
        let embed = {
            "title": `Discord Account Link Request`,
            "description": `User ID ${permid} has requested to link this Discord account.\n\nThe code to link is **${verifycode}**\nThis code will expire in 5 minutes.\n\nIf you have not requested this then you can safely ignore the message. Do **NOT** share this message or code with anyone else.`,
            "color": settingsjson.settings.botColour,
            "thumbnail": {
                "url": "https://cdn.discordapp.com/icons/989273243414298774/719d25a3f8b4852159905244bfed520b.webp?size=2048",
            },
        }
        member.send({embed})
    } catch (error) {}
});

client.login(process.env.TOKEN)
