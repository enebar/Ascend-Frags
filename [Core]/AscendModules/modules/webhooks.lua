local webhooks = {
    -- general
    ['join'] = 'https://discord.com/api/webhooks/1074458440409301004/Be1URSgexHl3WUeW06iUPEgQhXhcP4qaVos-aoMPuOTUWbNcs7PY_KmKPBaJCcTCj6NJ',
    ['leave'] = 'https://discord.com/api/webhooks/991556666095050803/cGTvcrMqB4wmub370MCRQHwW74tzLIHsmgkqXyNBqLPExMWNnB7lTXFRrcDmSNUYhAWQ',
    -- civ
    ['give-cash'] = 'https://discord.com/api/webhooks/1074458687361519809/Kit_CGOHquu-4Sv012AMq61jPLR4aD6X8bYyUK5Mulweo-kKUOfVd0sfKwowpWZADrHd',
    ['bank-transfer'] = 'https://discord.com/api/webhooks/1074458959928365067/GqxUS-6FhjJbhr6QBw106K2Wr-FRBjPP0pUUC0qTV5y2n4BIAuEAs2gV6MIQcy7x6WMo',
    ['search-player'] = 'https://discord.com/api/webhooks/1074459058188341429/D05lggM3jLlqGa_eyvuNdnaTSLsM6NCFNvg1er8-6CkY0qjmEHJ-MUbmMW9IMS6q8hq5',
    ['ask-id'] = 'https://discord.com/api/webhooks/1074460940310941696/Y3hxDHzO_b5ze5ossPQxVJ8S2tVXL0uOBO5cOABia1TQfYS-Gku7fU-HuNGQBVwcaf8a',
    -- chat
    ['ooc'] = 'https://discord.com/api/webhooks/1074461037383917659/xSY67sOztVetHf5B9gPQ-M7U-Z0TpioSvfnuulvFliPEl50Vy3ft5LTiFRM5j3QJQXVD',
    ['twitter'] = 'https://discord.com/api/webhooks/1074461215927046246/fOtF_DjFbfs8fcWtdxk81Xs4-49K-7gAWu1vw0jFLeZgIec9W61Tqev91Xm3BHMTPx5j',
    ['staff'] = 'https://discord.com/api/webhooks/1074461327969497230/nDrSQxL1cWuMNRDL7_Jyt7czMynpfAnx3O_OLUCOdu5xZ_oJ65Z2-FF7fEwoQYccQWED',
    ['gang'] = 'https://discord.com/api/webhooks/1074461409867477012/murdWa--rIM2IUdru5fBWAjGi48oMvJQdDUql3TNEJUysZ4O9sn-ZuOArrGCEJsf4PB0',
    ['anon'] = 'https://discord.com/api/webhooks/1074461132368134214/Ud2CPNn7ZcjOq57Wo77Sqxyv3Tz9viOyXGXB3tZscR5jG-EIGB5n6naRXF6ZNZiUUExw',
    -- admin menu
    ['kick-player'] = 'https://discord.com/api/webhooks/1074462342940721213/pOo_a5SNOHXdb_gCdfKVV6EIj-pVdbJGvK0xFk_Bwh-zbhD_OQcaVmbwWQX7XfkIt9sd',
    ['ban-player'] = 'https://discord.com/api/webhooks/1074462408518672505/NBtcRE-bQPIa2M61H4PBLRfCzsdgkGDP4reScHo0bJDsE6dw3wRdAASxGadJIMbLiuSY',
    ['spectate'] = 'https://discord.com/api/webhooks/1074462479565996133/Nchbubn4qMMw8F2GExSj5FUiUQI33p7v0tnERDn4WN0OyUwVYW4DXwBj3qoNROEE43f-',
    ['revive'] = 'https://discord.com/api/webhooks/1074462539154468925/vSO9eddRU7sYfoAxzg38RPfyDnoYABIFQyTEiw2dS13GZd_0rK-h6gNyYzi5VfBxVKrr',
    ['tp-player-to-me'] = 'https://discord.com/api/webhooks/1074462607353839759/fnALW2lZxQcelYMdFxqk91KuqLrpbPz--56WTePdl3ZKpJ90wpi9FBcLDf_zFQAY7cvU',
    ['tp-to-player'] = 'https://discord.com/api/webhooks/1074462699343314954/bXOpb2hlsBkKmUgLM5wmtDNcWvXkukEtCBSuVnwgF128Rrhcv0G13FF_V9ghJBA5HCGo',
    ['tp-to-admin-zone'] = 'https://discord.com/api/webhooks/1074462774404579399/iZQcfxNi2fQBV79dQ4h_XraAJnaqTahem8VmmRNle2MlsmvCK8gIDBjz5QTKVPdq5a2J',
    ['tp-back-from-admin-zone'] = 'https://discord.com/api/webhooks/1074462919099686922/YZoOBstE6q8V7n8lOm0gYlpJRxf0Z2ezZvtkHCjJbYkjCBkBaqq9-L8baMOWTSR3ncfk',
    ['tp-to-legion'] = 'https://discord.com/api/webhooks/1074463007268163674/U0nx3qEdjPRCTAAP-L4s9XqsiMd1C2aPNQaRUldx-_brDgw3Ui1lOtRKphO5Z-SyZwq1',
    ['freeze'] = 'https://discord.com/api/webhooks/1074463090185355334/sZVNeFUlK5G3_cygdZoM0h7nqZNdUV7j5MRKPUFUBHVEP3TZ9VzAwFag2Mb3JLG7WeNQ',
    ['slap'] = 'https://discord.com/api/webhooks/1074463162860060722/4iUHv2b-VUtKj_LquWN87YSKOxEVCjuJKZynil5YTNkpl94AK3e7QbFaYk0XB0NW6qyG',
    ['force-clock-off'] = 'https://discord.com/api/webhooks/1074463249807982704/nLKGLmbw3N610Wx5uGI8EeDyQpiGF6QeZp60J8jlHdIidKdTEK_A_ZMQYz0LQ_Z8u3zw',
    ['screenshot'] = 'https://discord.com/api/webhooks/1074463318565203989/EneJJYpH5EZfLsXOTVC9NU6HBKfR0BlmmgZC4pH4uPVMKXNGV32srx1TzHKB24Y_DHf7',
    ['video'] = 'https://discord.com/api/webhooks/1074463404850425976/j8am3qCMUTnOWLCfYqDMyVtH5TO-PD_-MDqe90IqgGM1jf7X_hj8xsnfIDVWySlCylzY',
    ['group'] = 'https://discord.com/api/webhooks/1074463473410519131/u7mnAV1XJUCT6A0Lsd_zVB_1lbMZk2SsfmQwhYL3oRCl-DafrcpAtkEWx4uS4m6F8qrn',
    ['unban-player'] = 'https://discord.com/api/webhooks/1074463534978707537/3l3UkOqssJVJpFJUSkAHUzNwvR2WG3RF0S2KSpgNxJSh0yctP0RMRc6RyKgHBNUNI2PN',
    ['remove-warning'] = 'https://discord.com/api/webhooks/1074463620668325888/hVfizq4IRL2Zjkp1mz1ttYd6tNebJ2VhX3O5FDpWnjy1rt0nmVJTZpCyT5tui6R4n6TC',
    ['add-car'] = 'https://discord.com/api/webhooks/1074463693837963375/hjK3DuE55Qs7aLlXmAsk5nF0mQJK9ZJgDuILG6rkjXJbjB4Jl3f4qRRzc9oEhjQSD0R4',
    ['manage-balance'] = 'https://discord.com/api/webhooks/1074463768706293892/phueJpOHnq_R3UqQRJu-Hih-jA3ynP7t_HIQ82vkLJYLLqpu09optc_sGz5H1IxAZrAk',
    ['ticket-logs'] = 'https://discord.com/api/webhooks/1074463834527506493/gdcr6-VqSz5e9LFTDQ0VCwmodLBiib2E6uJysh9JodhAhc1byV9p-gCsoyl3GQD6c6Wm',
    ['com-pot'] = 'https://discord.com/api/webhooks/1074464017646628964/ejMeHsVEWsBx_LAEWFtnec8sfLJYBPjutizErwRTT6qqZ_B8Duiwrxmdc-iituAZiUvW',
    -- vehicles
    ['crush-vehicle'] = 'https://discord.com/api/webhooks/1074464221703708682/E7Uwi6PjVuQ1BxsvPGMN3D8Q2uGuzR04C8L67Hrh89SB260wkcd7tGdEqR_im2gMqThM',
    ['rent-vehicle'] = 'https://discord.com/api/webhooks/1074464291127820318/gkjSaIr5nXoOHpvFCZdgG_XngJiRS5rgeFQTFD-PWUdl4qGUtT6G-yKaWT26klRICZ2d',
    ['sell-vehicle'] = 'https://discord.com/api/webhooks/1074464344974299177/NcTc-txyCCjTTlELmOOZIa-AXe4rZhhsKMHyNFgdr4g1ZRcIABak7zgi3_ujbcOyMz_e',
    -- mpd
    ['pd-clock'] = 'https://discord.com/api/webhooks/1074488759434874951/rU6dIgF8Wz8GpCDUEqkmLuf-1eLGqKprby4PIUTT-gN9lScWs9IoEaKcjH_i4mUKJFP4',
    ['pd-afk'] = 'https://discord.com/api/webhooks/1074488821883867215/5WKQDNgGJ5AxmCWooiw2rM50mNJS-zIj1lQVHmYcfbmXfYk43F02oHjmHEh_Ns1dbdGs',
    ['pd-armoury'] = 'https://discord.com/api/webhooks/1074488558460612750/wpnwpJRha1wfC9HXH2IaRT45MB50WjnyvHKfcNU---QkSm4qYHu0VnEiIVEeBqrig2Kr',
    ['fine-player'] = 'https://discord.com/api/webhooks/1074488351794663554/KvPqKz47ZdltddKR9wowCIGVJOgZeQr9HMmyzEFoJFKQu3n4RMvNXVD7b1cRi5UL87-e',
    ['jail-player'] = 'https://discord.com/api/webhooks/1074488401807548476/3NkYV03HQAFsg6kqNi7X_RHiOk6sGyI0hiqMKNkVobPHHNC0O_7qISY3XOib73nOs0KX',
    ['pd-panic'] = 'https://discord.com/api/webhooks/1074488283549151292/-nWknW58tbXwR5jtQHJIgZ59ilcXpuOF3r1L1Sm2oEY9hbI-UmqnM0tn_6kwiZy1VCBd',
    ['seize-boot'] = 'https://discord.com/api/webhooks/1074488956676210790/lf5z1fV6ljGCJRIrpvV6cN0CAqKxCIBChFfKXo1lwan5t4MY6WS52rQ-gCVEZROVK7Uw',
    ['impound'] = 'https://discord.com/api/webhooks/1074489043376672790/qbjHdjDioswnBckxYmIK_SUw5gNhCb2hRz2Z8Wz0hv2TJc7PDfqqjALVI5-iyDC08LZl',
    ['police-k9'] = 'https://discord.com/api/webhooks/1074489139375902821/94MATWUAYVpaWEq38wn4KZP1pC08R_fKyU5lWV08--0PusehnO0G9oXoH3lOreedPm0b',
    -- nhs
    ['nhs-clock'] = 'https://discord.com/api/webhooks/1074465973781926058/fm0S75J4Fy45BXZ5GM31-JffRhsCuh4pVm12V8PmZxP2IQOUMyB4LTcRQwSzP96GtT8X',
    ['nhs-panic'] = 'https://discord.com/api/webhooks/1074466065486204948/uwMhaE-qPLeLYSSgjFOwJg6lSAtzWMcSjs7OfD4mgu-TpRSNUzWRFTdAsVs1bZeY6KXw',
    ['nhs-afk'] = 'https://discord.com/api/webhooks/1074466157958008842/LZX0Xjk5DcmGV075CGd6XDLsQTdIxg-vUBbJT1c0wUxHon4TNWQPFysLcvi10v5R7Lpe',
    ['cpr'] = 'https://discord.com/api/webhooks/1074466252375990313/kp8BkaaPG3XYHBKRddbUxqz8hCuDArTjSPviq2zWp7cVPaYi8aWbV7saY7qcdEAPB7Yw',
    -- licenses
    ['purchases'] = 'https://discord.com/api/webhooks/1074466496635478136/3_C2aSIxmWrOaM3A880p579Yq7HDTNSVsKpWa5OEd9TdtvHyvkxP1tapQQnM9cprLlLH',
    ['sell-to-nearest-player'] = 'https://discord.com/api/webhooks/1074466561127108678/dfaCsKEMlEeQf7KkURt85jACI5MVJWjbWoscrN8MuISIJEbJYWC8bAMbDUbc4KIgOvMZ',
    -- casino
    ['blackjack-bet'] = 'https://discord.com/api/webhooks/1050352894127390740/h29WYQilD31Ism7YcOUR827S4d3G_X6lbhXmws-HkyUxHEEy5AVl49EDO4roc-QTw99G',
    ['coinflip-bet'] = 'https://discord.com/api/webhooks/1057570226801217556/mToQntSgGYtp0AjGMWj9YyhwMY-_hzdA_ocP-fpgxGmLtQoVvWx59gLpsobG-79qNQ9b',
    ['purchase-chips'] = 'https://discord.com/api/webhooks/1074466958961016852/uGHXHyOEThMCCYPCUAusDD0gU9aDgeLly7E1oGwR2KHWBB89P3E2HqDvkrFjDVfXff_w',
    ['sell-chips'] = 'https://discord.com/api/webhooks/1074467046450003979/IEXLnsjW3W79L8eh1AyRdW6GGPxT6W1uVY3YVGOwnGprbH_iVwDBKik7dsDWGXVAof3X',
    ['purchase-highrollers'] = 'https://discord.com/api/webhooks/1074467113726652598/nOTjtDIlpvt1wu9GiVUvA37VNkyPH_M81UYTVoBhheWtsm40-4AfAzqbjnNUoF9u6nBx',
    -- weapon shops
    ['weapon-shops'] = 'https://discord.com/api/webhooks/1074467302042505246/cV3CQCIQ6HO2wc9aNKHUMOjspoIttRLUWWJEmXZwo4egCOwQA5R7gCO1ZK1LWY-Ye4Au',
    -- housing (no logs atm)
    [''] = '',
    -- anticheat
    ['anticheat'] = 'https://discord.com/api/webhooks/1074467379335155743/DVCULxYn6kOCOi9Lyxqdy0WcynhPYIhr8JMMvZ1NoUFeN7w0R0cj4spkoE-NIiVBSVaP',
    ['ban-evaders'] = 'https://discord.com/api/webhooks/1074467464110420028/2SDMhA3u_t85CffBeDSk7R54Ko15D8n4P7kbEvrVrvmhlrZJyY_PKqbMG645F4XWuFLk',
    -- dono
    ['donation'] = 'https://discord.com/api/webhooks/1074695911508279406/P2uFen64uae9S7X2E1lFVSvmd1QWDM8uIxv1akxFBaw4V4j_2ds-Gl8yhY9kF_CWYG2o',
}

local webhookQueue = {}
Citizen.CreateThread(function()
    while true do
        if next(webhookQueue) then
            for k,v in pairs(webhookQueue) do
                Citizen.Wait(100)
                if webhooks[v.webhook] ~= nil then
                    PerformHttpRequest(webhooks[v.webhook], function(err, text, headers) 
                    end, "POST", json.encode({username = "CLIMB Logs", avatar_url = 'https://cdn.discordapp.com/avatars/988120850546962502/50ca540f28908bf89c1f8af3bea62025.webp?size=2048', embeds = {
                        {
                            ["color"] = 16448403,
                            ["title"] = v.name,
                            ["description"] = v.message,
                            ["footer"] = {
                                ["text"] = "CLIMB - "..v.time,
                                ["icon_url"] = "",
                            }
                    }
                    }}), { ["Content-Type"] = "application/json" })
                end
                webhookQueue[k] = nil
            end
        end
        Citizen.Wait(0)
    end
end)
local webhookID = 1
function tCLIMB.sendWebhook(webhook, name, message)
    webhookID = webhookID + 1
    webhookQueue[webhookID] = {webhook = webhook, name = name, message = message, time = os.date("%c")}
end

function CLIMB.sendWebhook(webhook, name, message) -- used for other resources to send through webhook logs 
   tCLIMB.sendWebhook(webhook, name, message)
end

function tCLIMB.getWebhook(webhook)
    if webhooks[webhook] ~= nil then
        return webhooks[webhook]
    end
end