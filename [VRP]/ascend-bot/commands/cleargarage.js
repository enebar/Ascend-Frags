const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    if (!params[0] || !parseInt(params[0])) {
        return message.reply('Invalid args! Correct term is: ' + process.env.PREFIX + 'cleargarage [perm id]')
    }
    fivemexports['ghmattimysql'].execute("DELETE FROM climb_user_vehicles WHERE user_id = ?", [parseInt(params[0])])
    
    let embed = {
        "title": "Cleared Garage",
        "description": `\nPerm ID: **${params[0]}**\n\nAdmin: <@${message.author.id}>`,
        "color": settingsjson.settings.botColour,
        "footer": {
            "text": ""
        },
        "timestamp": new Date()
    }
    message.channel.send({ embed })
}

exports.conf = {
    name: "cleargarage",
    perm: 7,
    
}