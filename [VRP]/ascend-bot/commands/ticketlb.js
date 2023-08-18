var AsciiTable = require('ascii-table');
const resourcePath = global.GetResourcePath ?
    global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const settingsjson = require(resourcePath + '/settings.js')

exports.runcmd = (fivemexports, client, message, params) => {
    fivemexports.ghmattimysql.execute("SELECT * FROM climb_staff_tickets ORDER BY ticket_count DESC", [], (result) => {
        var tickets = []
        if (result) {
            for (i = 0; i < result.length; i++) {
                tickets.push(`\n${result[i].username}(${result[i].user_id}) - ${result[i].ticket_count}`)
            }
            let embed = {
                "title": `Ticket Leaderboard`,
                "description": '```'+tickets.join('').replace(',', '')+'```',
                "color": settingsjson.settings.botColour,
                "footer": {
                    "text": ""
                },
                "timestamp": new Date()
            }
            message.channel.send({embed})
        }
    })
}

exports.conf = {
    name: "ticketlb",
    perm: 6,
    
}