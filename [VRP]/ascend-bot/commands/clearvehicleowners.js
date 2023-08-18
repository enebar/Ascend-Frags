const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    if (!params[0]) {
        return message.reply('Invalid args! Correct term is: ' + process.env.PREFIX + 'clearvehicleowners [spawn code]')
    }
    fivemexports.ghmattimysql.execute("DELETE FROM `climb_user_vehicles` WHERE vehicle = ?", [params[0]])
    let embed = {
        "title": `Database Update`,
        "description": `${params[0]} has been deleted from the database.`,
        "color": settingsjson.settings.botColour,
        "footer": {
            "text": ""
        },
        "timestamp": new Date()
    }
    message.channel.send({ embed })
}

exports.conf = {
    name: "clearvehicleowners",
    perm: 7,
    
}