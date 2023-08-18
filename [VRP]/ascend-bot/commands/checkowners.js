var AsciiTable = require('ascii-table');
const Discord = require('discord.js');
const fs = require('fs');

let descriptionText = ''

exports.runcmd = (fivemexports, client, message, params) => {
    if (!params[0]) {
        return message.reply('Invalid args! Correct term is: ' + process.env.PREFIX + 'gco [spawn code]')
    }
    let count = 0
    fivemexports.ghmattimysql.execute("SELECT * FROM `climb_user_vehicles` WHERE vehicle = ?", [params[0]], (result) => {
        var owners = []
        for (i = 0; i < result.length; i++) { 
            let user_id = result[i].user_id
            let results =  result.length
            let rented = false
            let locked = false
            if (result[i].rented)  {
                rented = true
            } 
            if (result[i].locked)  {
                descriptionText = '🔒 Vehicle is locked'
            }  
            else{
                descriptionText = '🔓 Vehicle is not locked'
            }
            fivemexports.ghmattimysql.execute("SELECT * FROM `climb_users` WHERE id = ?", [user_id], (result) => {
                if (result[0].bantime  == 'perm') {
                    if (rented){
                        owners.push(`${result[0].username}(${user_id}) - Rented (Permanently Banned)\n`)
                    }
                    else{
                        owners.push(`${result[0].username}(${user_id}) - (Permanently Banned)\n`)
                    }
                }
                else{
                    if (rented){
                        owners.push(`${result[0].username}(${user_id}) - Rented\n`)
                    }
                    else{
                        owners.push(`${result[0].username}(${user_id})\n`)
                    }
                }
                count ++ 
                if (count == results){
                    let embed = {
                        "title": `All Users that own ${params[0]}:`,
                        "description": descriptionText+'```\n'+owners.join('').replace(',', '')+'```',
                        "color": settingsjson.settings.botColour,
                        "footer": {
                            "text": `Requested by ${message.author.username}`
                        },
                        "timestamp": new Date()
                    }
                    message.channel.send({ embed }).catch(err => {
                        message.channel.send(`${params[0]} has too many owners to display in an embed.`)
                    })
                }    
            });  
        }
        if (result.length == 0){
            return message.reply(`Nobody owns ${params[0]}`)
        }
    });
}

exports.conf = {
    name: "gco",
    perm: 1,
    
}