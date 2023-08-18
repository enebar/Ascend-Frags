const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

var statusLeaderboard = require(resourcePath + '/statusleaderboard.json')
let descriptionText = ''

exports.runcmd = (fivemexports, client, message, params) => {
    const sortable = Object.fromEntries(
        Object.entries(statusLeaderboard['leaderboard']).sort(([,a],[,b]) => b-a)
    );
    for (i = 0; i < Object.keys(statusLeaderboard['leaderboard']).length; i++) {
        if (Object.keys(sortable)[i] == message.author.id) {
            let embed = {
                "title": `Leaderboard Info`,
                "description": 'To take part in the competition for **£100**, place `discord.gg/climbrp` in your status.'+'```\nYou are currently '+(i+1)+'/'+Object.keys(statusLeaderboard['leaderboard']).length+' on the leaderboard.```<@'+message.author.id+'>',
                "color": settingsjson.settings.botColour,
                "footer": {
                    "text": ""
                },
                "timestamp": new Date()
            }
            message.channel.send({ embed })
            return
        }
    }
}

exports.conf = {
    name: "leaderboard",
    perm: 7,
    
}