local cfg = module("CLIMBModules", "cfg/cfg_licenses")

local Tunnel = module("CLIMB", "lib/Tunnel")
local Proxy = module("CLIMB", "lib/Proxy")
CLIMB = Proxy.getInterface("CLIMB")
CLIMBclient = Tunnel.getInterface("CLIMB","CLIMB")

RegisterNetEvent("CLIMB:RequestLicenses")
AddEventHandler("CLIMB:RequestLicenses", function()
    local user_id = CLIMB.getUserId({source})
    local licenses = {}

    if user_id ~= nil then
        for k, v in pairs(cfg.licenses) do
            if CLIMB.hasGroup({user_id, v.group}) then
                table.insert(licenses, v.name)
            end
        end
        for k, v in pairs(cfg.ilegallicenses) do
            if CLIMB.hasGroup({user_id, v.group}) then
                table.insert(licenses, v.name)
            end
        end
        for k, v in pairs(cfg.illegal) do
            if CLIMB.hasGroup({user_id, v.group}) then
                table.insert(licenses, v.name)
            end
        end

        TriggerClientEvent("CLIMB:RecieveLicenses", source, licenses)
    end
end)