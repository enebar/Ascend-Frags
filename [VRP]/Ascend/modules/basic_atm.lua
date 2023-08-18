-- a basic ATM implementation
local lang = CLIMB.lang
local cfg = module("cfg/atms")
local atms = cfg.atms
local onesync = GetConvar("onesync", nil)

RegisterNetEvent("CLIMB:Withdraw")
AddEventHandler(
    "CLIMB:Withdraw",
    function(amount)
        local source = source
        amount = parseInt(amount)
        if amount < 0 then
            return
        end
        if onesync ~= "off" then
            --Onesync allows extra security behind events should enable it if it's not already.
            local ped = GetPlayerPed(source)
            local playerCoords = GetEntityCoords(ped)
            for i, v in pairs(cfg.atms) do
                local coords = vec3(v[1], v[2], v[3])
                if #(playerCoords - coords) <= 2.50 then
                    if amount > 0 then
                        local user_id = CLIMB.getUserId(source)
                        if user_id ~= nil then
                            if CLIMB.tryWithdraw(user_id, amount) then
                                CLIMBclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
                                CLIMBclient.playAnim(source, {false, {{"amb@prop_human_atm@male@exit", "exit"}}, false})
                            else
                                CLIMBclient.notify(source, {lang.atm.withdraw.not_enough()})
                            end
                        end
                    else
                        CLIMBclient.notify(source, {lang.common.invalid_value()})
                    end
                end
            end
        else
            if amount > 0 then
                local user_id = CLIMB.getUserId(source)
                if user_id ~= nil then
                    if CLIMB.tryWithdraw(user_id, amount) then
                        CLIMBclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
                        CLIMBclient.playAnim(source, {false, {{"amb@prop_human_atm@male@exit", "exit"}}, false})
                    else
                        CLIMBclient.notify(source, {lang.atm.withdraw.not_enough()})
                    end
                end
            else
                CLIMBclient.notify(source, {lang.common.invalid_value()})
            end
        end
    end
)

RegisterNetEvent("CLIMB:Deposit")
AddEventHandler(
    "CLIMB:Deposit",
    function(amount)
        local source = source
        amount = parseInt(amount)
        if onesync ~= "off" then
            --Onesync allows extra security behind events should enable it if it's not already.
            local ped = GetPlayerPed(source)
            local playerCoords = GetEntityCoords(ped)
            for i, v in pairs(cfg.atms) do
                local coords = vec3(v[1], v[2], v[3])
                if #(playerCoords - coords) <= 2.50 then
                    if amount > 0 then
                        local user_id = CLIMB.getUserId(source)
                        if user_id ~= nil then
                            if CLIMB.tryDeposit(user_id, amount) then
                                CLIMBclient.notify(source, {lang.atm.deposit.deposited({amount})})
                                CLIMBclient.playAnim(
                                    source,
                                    {
                                        false,
                                        {
                                            {"amb@prop_human_atm@male@enter", "enter"},
                                            {"amb@prop_human_atm@male@idle_a", "idle_a"}
                                        },
                                        false
                                    }
                                )
                            else
                                CLIMBclient.notify(source, {lang.money.not_enough()})
                            end
                        end
                    else
                        CLIMBclient.notify(source, {lang.common.invalid_value()})
                    end
                end
            end
        else
            if amount > 0 then
                local user_id = CLIMB.getUserId(source)
                if user_id ~= nil then
                    if CLIMB.tryDeposit(user_id, amount) then
                        CLIMBclient.notify(source, {lang.atm.deposit.deposited({amount})})
                        CLIMBclient.playAnim(
                            source,
                            {
                                false,
                                {
                                    {"amb@prop_human_atm@male@enter", "enter"},
                                    {"amb@prop_human_atm@male@idle_a", "idle_a"}
                                },
                                false
                            }
                        )
                    else
                        CLIMBclient.notify(source, {lang.money.not_enough()})
                    end
                end
            else
                CLIMBclient.notify(source, {lang.common.invalid_value()})
            end
        end
    end
)

RegisterNetEvent("CLIMB:DepositALL")
AddEventHandler(
    "CLIMB:DepositALL",
    function()
        local source = source
        local userid = CLIMB.getUserId(source)
        local amount = CLIMB.getMoney(userid)
        local ped = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(ped)
        if onesync ~= "off" then
        if userid ~= nil then
            for a, b in pairs(cfg.atms) do
                local coords = vec3(b[1], b[2], b[3])
                if #(playerCoords - coords) <= 2.50 then
                    if amount > 0 then
                        if CLIMB.tryDeposit(userid, amount) then
                            CLIMBclient.notify(source, {lang.atm.deposit.deposited({roundnumber(amount, 1)})})
                            CLIMBclient.playAnim(
                                source,
                                {
                                    false,
                                    {
                                        {"amb@prop_human_atm@male@enter", "enter"},
                                        {"amb@prop_human_atm@male@idle_a", "idle_a"}
                                    },
                                    false
                                }
                            )
                        else
                            CLIMBclient.notify(source, {lang.money.not_enough()})
                        end
                    end
                end
            end
        end
    end
end
)

RegisterNetEvent('CLIMB:WithdrawAll')
AddEventHandler('CLIMB:WithdrawAll', function()
    local source = source
    userid = CLIMB.getUserId(source)
    amount = CLIMB.getBankMoney(userid)
    print(amount)
    if onesync ~= "off" then    
        --Onesync allows extra security behind events should enable it if it's not already.
        local ped = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(ped)
        for i, v in pairs(cfg.atms) do
            local coords = vec3(v[1], v[2], v[3])
            if #(playerCoords - coords) <= 5.0 then
            
                    local user_id = CLIMB.getUserId(source)
                    if user_id ~= nil then
                        if CLIMB.tryWithdraw(user_id, amount) then
                            CLIMBclient.notify(source, {lang.atm.withdraw.withdrawn({roundnumber(amount, 1)})})
                            CLIMBclient.playAnim(
                                source,
                                {
                                    false,
                                    {
                                        {"amb@prop_human_atm@male@enter", "enter"},
                                        {"amb@prop_human_atm@male@idle_a", "idle_a"}
                                    },
                                    false
                                }
                            )
                        else
                            CLIMBclient.notify(source, {lang.atm.withdraw.not_enough()})
                        end
                    end
                end
        end
    end
end)


function roundnumber(P, Q)
    local R = 10 ^ (Q or 0)
    return math.floor(P * R + 0.5) / R
end
