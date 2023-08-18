const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    let embed = {
        "title": "CLIMB Staff Applications",
        "description": `https://forms.gle/mtadzyW9gXNKouy99`,
        "color": settingsjson.settings.botColour,
        "footer": {
            "text": ""
        },
        "timestamp": new Date()
    }
    message.channel.send({ embed })
}

exports.conf = {
    name: "staffapp",
    perm: 0,
    
}