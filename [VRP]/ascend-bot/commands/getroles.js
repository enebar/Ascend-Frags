const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

let groups = [
    'Supporter',
    'Premium',
    'Supreme',
    'Kingpin',
    'Baller',
]
exports.runcmd = async(fivemexports, client, message, params) => {
    let rolesCount = 0
    let rolesOwned = []
    let descriptionText = ':white_check_mark: You have received your discord roles:'
    fivemexports.ghmattimysql.execute("SELECT user_id FROM `climb_verification` WHERE discord_id = ?", [message.author.id], (result) => {
        let user_id = result[0].user_id
        fivemexports.ghmattimysql.execute("SELECT dvalue FROM `climb_user_data` WHERE user_id = ? AND dkey = 'CLIMB:datatable'", [user_id], async (data) => {
            let groupsdata = JSON.parse(Object.values(data[0])).groups
            for (const [key, value] of Object.entries(groupsdata)) {
                for (j = 0; j < groups.length; j++) { 
                    if (groups[j] === key) {
                        let role = message.guild.roles.find(r => r.name === `| ${groups[j]}`)
                        rolesCount += 1
                        rolesOwned.push(`\n${key}`)
                        await message.member.addRole(role.id).then().catch(console.error);
                    }
                }
            }
            if (rolesCount > 0 ){
                let embed = {
                    "title": "Roles",
                    "description": descriptionText+'```\n'+rolesOwned.join('').replace(',', '')+'```',
                    "color": settingsjson.settings.botColour,
                    "footer": {
                        "text": ""
                    },
                    "timestamp": new Date()
                }
                message.channel.send({ embed })
                return
            }
        });
    });
}

exports.conf = {
    name: "getroles",
    perm: 0,
    
}