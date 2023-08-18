var AsciiTable = require('ascii-table');
const Discord = require('discord.js');
const fs = require('fs');

exports.runcmd = (fivemexports, client, message, params) => {
    if (!params[0]) {
        return message.reply('Invalid args! Correct term is: ' + process.env.PREFIX + 'checkrented [permid]')
    }
    let count = 0
    fivemexports.ghmattimysql.execute("SELECT * FROM `climb_user_vehicles` WHERE rentedid = ?", [params[0]], (result) => {
        if (result.length > 0) {
        var rentedvehicles = []
        let results =  result.length
        let owner = params[0]
        for (i = 0; i < results; i++) {
            let renter = result[i].user_id
            let rentedtime = result[i].rentedtime
            let vehicle = result[i].vehicle
            fivemexports.ghmattimysql.execute("SELECT * FROM `climb_users` WHERE id = ?", [renter], (result) => {
                a = new Date()
                rentedvehicles.push(`${vehicle} rented to ${result[0].username}(${renter}) for ${Math.round((rentedtime-Math.floor(new Date().getTime() / 1000))/3600)} hours.\n`)
                count ++
                if (count == results){
                    let embed = {
                        "title": `ID ${owner}'s Rented Vehicles :`,
                        "description": '\n```'+rentedvehicles.join('').replace(',', '')+'```',
                        "color": settingsjson.settings.botColour,
                        "footer": {
                            "text": `Requested by ${message.author.username}`
                        },
                        "timestamp": new Date()
                    }
                    message.channel.send({ embed }).catch(err => {
                        message.channel.send(`ID ${owner} has too many rented vehicles to display in an embed.`)
                    })
                }     
            });  
        }
        }
        else{
            message.reply(`ID ${owner} has no rented vehicles.`)
        }
    });
}

exports.conf = {
    name: "checkrented",
    perm: 1,
    
}