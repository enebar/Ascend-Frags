const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = async(fivemexports, client, message, params) => {
    message.delete()
    if (!params[0] && !parseInt(params[0]) || !params[1] && !parseInt(params[1])) {
        let embed = {
            "title": "Verify",
            "description": `:x: Invalid command usage \`${process.env.PREFIX}reverify [permid] [discord-id]\``,
            "color": settingsjson.settings.botColour,
            "footer": {
                "text": ""
            },
            "timestamp": new Date()
        }
        message.channel.send({ embed }).then(msg => {
            msg.delete(10000)
        })
    }
    else{
        fivemexports.ghmattimysql.execute("UPDATE `climb_verification` SET discord_id = ?, verified = 1 WHERE user_id = ?", [params[1], params[0]], async (result) => {
            if (result) {
                let embed = {
                    "title": "Verify",
                    "description": `:white_check_mark: The user has been reverified.`,
                    "color": settingsjson.settings.botColour,
                    "footer": {
                        "text": ""
                    },
                    "timestamp": new Date()
                }
                message.channel.send({ embed }).then(msg => {
                    msg.delete(10000)
                })
                await message.member.addRole("989273243414298778").then().catch(console.error);
            }
        });
    }
}

exports.conf = {
    name: "reverify",
    perm: 6,
    
}