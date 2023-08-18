PlayerIsInGang = false
GangBalance = 0
CLIMBGangInvites = {}
CLIMBGangInviteIndex = 0
selectedGangInvite = nil
selectedMember = nil
gangID = nil
gangPermission = 0
local d = nil
local e = {}
local f = 1
local g = 1
local h = 1
local i = 1
CLIMBGangMembers = {}
local j = false
local k = nil
local l = nil
local m = {
    ["White"] = {hud = 0, blip = 0},
    ["Red"] = {hud = 6, blip = 1},
    ["Green"] = {hud = 18, blip = 2},
    ["Blue"] = {hud = 9, blip = 3},
    ["Yellow"] = {hud = 12, blip = 5},
    ["Violet"] = {hud = 21, blip = 7},
    ["Pink"] = {hud = 24, blip = 8},
    ["Orange"] = {hud = 15, blip = 17},
    ["Cyan"] = {hud = 52, blip = 30},
    ["Black"] = {hud = 2, blip = 40},
    ["Baby Pink"] = {hud = 193, blip = 34}
}
local n = m["Red"]
local o = GetResourceKvpString("climb_gang_colour") or "Red"
local function p()
    return CLIMBGangMembers
end


RegisterNetEvent("CLIMB:GotGangData")
AddEventHandler(
    "CLIMB:GotGangData",
    function(q, r, k, s, t, u, v)
        if q == nil then
            PlayerIsInGang = false
        else
            PlayerIsInGang = true
            TriggerServerEvent("CLIMB:setPersonalGangBlipColour", o)
            e = {}
            gangLogs = {}
            h = 1
            i = 1
            GangBalance = getMoneyStringFormatted(math.floor(q.money))
            gangID = q.id
            gangPermission = tonumber(k)
            j = t
            gangMaxWithdraw = u
            gangLimitWithdrawDeposit = v
            if r ~= nil then
                CLIMBGangMembers = r
                local w = 1
                e[w] = {}
                for q, x in ipairs(r) do
                    if (q - 1) % 10 == 0 and q ~= 1 then
                        w = w + 1
                        e[w] = {}
                        h = h + 1
                    end
                    e[w][q - (w - 1) * 10] = x
                end
            end
            if s ~= nil then
                local w = 1
                gangLogs[w] = {}
                for l, x in pairs(s) do
                    if l % 11 == 0 then
                        w = w + 1
                        gangLogs[w] = {}
                        i = i + 1
                    else
                        gangLogs[w][l - (w - 1) * 11] = x
                    end
                end
            end
        end
    end
)
RegisterNetEvent("CLIMB:disbandedGang")
AddEventHandler(
    "CLIMB:disbandedGang",
    function()
        d = "none"
        PlayerIsInGang = false
        CLIMBGangMembers = {}
        TriggerEvent("CLIMB:ForceRefreshData")
    end
)
RegisterNetEvent("CLIMB:ForceRefreshData")
AddEventHandler(
    "CLIMB:ForceRefreshData",
    function()
        TriggerServerEvent("CLIMB:GetGangData")
    end
)
RegisterNetEvent("CLIMB:InviteReceived")
AddEventHandler(
    "CLIMB:InviteReceived",
    function(y, z)
        CLIMBGangInvites[CLIMBGangInviteIndex] = z
        CLIMBGangInviteIndex = CLIMBGangInviteIndex + 1
        tCLIMB.notify(y)
    end
)
RegisterNetEvent("CLIMB:gangNameNotTaken")
AddEventHandler(
    "CLIMB:gangNameNotTaken",
    function()
        d = "main"
        PlayerIsInGang = true
    end
)
function func_drawGangUI()
    if d == "none" then
        DrawRect(0.471, 0.329, 0.285, -0.005, 0, 168, 255, 204)
        DrawRect(0.471, 0.304, 0.285, 0.046, 0, 0, 0, 150)
        DrawRect(0.471, 0.428, 0.285, 0.194, 0, 0, 0, 150)
        DrawRect(
            0.383,
            0.442,
            0.066,
            0.046,
            CreateGangSelectionRed,
            CreateGangSelectionGreen,
            CreateGangSelectionBlue,
            150
        )
        DrawRect(0.469, 0.442, 0.066, 0.046, JoinGangSelectionRed, JoinGangSelectionGreen, JoinGangSelectionBlue, 150)
        DrawAdvancedText(0.558, 0.303, 0.005, 0.0028, 0.539, "CLIMB Gangs", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.478, 0.442, 0.005, 0.0028, 0.473, "Create Gang", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.564, 0.443, 0.005, 0.0028, 0.473, "Join Gang", 255, 255, 255, 255, 4, 0)
        DrawRect(0.561, 0.377, 0.065, -0.003, 0, 168, 255, 204)
        DrawAdvancedText(0.654, 0.37, 0.005, 0.0028, 0.364, "Invite list", 255, 255, 255, 255, 4, 0)
        for A, B in pairs(CLIMBGangInvites) do
            DrawAdvancedText(0.656, 0.398 + 0.020 * A, 0.005, 0.0028, 0.234, B, 255, 255, 255, 255, 0, 0)
            if CursorInArea(0.525, 0.59, 0.38 + 0.02 * A, 0.396 + 0.02 * A) and A ~= selectedGangInvite then
                DrawRect(0.56, 0.39 + 0.02 * A, 0.062, 0.019, 0, 168, 255, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    selectedGangInvite = A
                end
            elseif A == selectedGangInvite then
                DrawRect(0.56, 0.39 + 0.02 * A, 0.062, 0.019, 0, 168, 255, 150)
            end
        end
        if CursorInArea(0.35, 0.415, 0.415, 0.46) then
            CreateGangSelectionRed = 0
            CreateGangSelectionGreen = 168
            CreateGangSelectionBlue = 255
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                createGangName = GetGangNameText()
                if createGangName ~= nil and createGangName ~= "null" and createGangName ~= "" then
                    TriggerServerEvent("CLIMB:CreateGang", createGangName)
                else
                    tCLIMB.notify("~r~No gang name entered!")
                end
            end
        else
            CreateGangSelectionRed = 0
            CreateGangSelectionGreen = 0
            CreateGangSelectionBlue = 0
        end
        if CursorInArea(0.435, 0.51, 0.415, 0.46) then
            JoinGangSelectionRed = 0
            JoinGangSelectionGreen = 168
            JoinGangSelectionBlue = 255
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if selectedGangInvite ~= nil then
                    selectedGangInvite = CLIMBGangInvites[selectedGangInvite]
                    TriggerServerEvent("CLIMB:addUserToGang", selectedGangInvite)
                    CLIMBGangInvites = {}
                    d = "main"
                    CLIMBGangInviteIndex = 0
                    PlayerIsInGang = true
                else
                    tCLIMB.notify("~r~No gang invite selected")
                end
            end
        else
            JoinGangSelectionRed = 0
            JoinGangSelectionGreen = 0
            JoinGangSelectionBlue = 0
        end
    end
    if d == "funds" then
        DrawRect(0.501, 0.558, 0.421, 0.326, 0, 0, 0, 150)
        DrawRect(0.501, 0.374, 0.421, 0.047, k.theme.r, k.theme.g, k.theme.b, 248)
        DrawAdvancedText(0.591, 0.378, 0.005, 0.0028, 0.48, "CLIMB Gang - Funds", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.581, 0.464, 0.005, 0.0028, 0.5, "Gang Funds", 255, 255, 255, 255, 0, 0)
        DrawAdvancedText(0.581, 0.502, 0.005, 0.0028, 0.4, "£" .. GangBalance, 25, 199, 65, 255, 0, 0)
        DrawAdvancedText(0.436, 0.578, 0.005, 0.0028, 0.4, "Deposit (1% Fee)", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.536, 0.578, 0.005, 0.0028, 0.4, "Deposit All (1% Fee)", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.637, 0.578, 0.005, 0.0028, 0.4, "Withdraw", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.737, 0.578, 0.005, 0.0028, 0.4, "Withdraw All", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.590, 0.660, 0.005, 0.0028, 0.4, "View Contributions", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.3083, 0.3718, 0.5490, 0.5999) then
            DrawRect(0.341, 0.576, 0.075, 0.056, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                amount = GetMoneyAmountText()
                if amount ~= nil then
                    TriggerServerEvent("CLIMB:depositGangBalance", gangID, amount)
                else
                    tCLIMB.notify("~r~No amount entered!")
                end
            end
        else
            DrawRect(0.341, 0.576, 0.075, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.4083, 0.4718, 0.5490, 0.5999) then
            DrawRect(0.441, 0.576, 0.075, 0.056, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                TriggerServerEvent("CLIMB:depositAllGangBalance", gangID)
            end
        else
            DrawRect(0.441, 0.576, 0.075, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.5088, 0.5739, 0.5481, 0.6018) then
            DrawRect(0.542, 0.576, 0.075, 0.056, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                amount = GetMoneyAmountText()
                if amount ~= nil then
                    if gangPermission >= 3 then
                        TriggerServerEvent("CLIMB:withdrawGangBalance", gangID, amount)
                    else
                        tCLIMB.notify("~r~You don't have a high enough rank to withdraw")
                    end
                else
                    tCLIMB.notify("~r~No amount entered!")
                end
            end
        else
            DrawRect(0.542, 0.576, 0.075, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6088, 0.6739, 0.5481, 0.6018) then
            DrawRect(0.642, 0.576, 0.075, 0.056, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if gangPermission >= 3 then
                    TriggerServerEvent("CLIMB:withdrawAllGangBalance", gangID)
                else
                    tCLIMB.notify("~r~You don't have a high enough rank to withdraw")
                end
            end
        else
            DrawRect(0.642, 0.576, 0.075, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.45, 0.53, 0.63, 0.68) then
            DrawRect(0.495, 0.658, 0.075, 0.056, a, b, c, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                d = "contributions"
            end
        else
            DrawRect(0.495, 0.658, 0.075, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                d = "main"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if d == "contributions" then
        DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
        DrawRect(0.501, 0.308, 0.421, 0.047, k.theme.r, k.theme.g, k.theme.b, 248)
        DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "CLIMB Gang - Contributions", 255, 255, 255, 255, 7, 0)
        DrawRect(0.502, 0.518, 0.387, 0.283, 0, 0, 0, 150)
        DrawAdvancedText(0.449, 0.365, 0.005, 0.0028, 0.4, "Name", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.53, 0.365, 0.005, 0.0028, 0.4, "UserID", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.63, 0.365, 0.005, 0.0028, 0.4, "Last Contribution", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.730, 0.365, 0.005, 0.0028, 0.4, "Total Amount", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.547, 0.688, 0.005, 0.0028, 0.4, "Previous", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.639, 0.688, 0.005, 0.0028, 0.4, "Next", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.591, 0.688, 0.005, 0.0028, 0.4, tostring(f) .. "/" .. tostring(h), 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        for A, C in pairs(e[f]) do
            name, id = table.unpack(C)
            DrawAdvancedText(0.449, 0.361 + 0.0287 * A, 0.005, 0.0028, 0.4, name, 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.53, 0.361 + 0.0287 * A, 0.005, 0.0028, 0.4, id, 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(
                0.63,
                0.361 + 0.0287 * A,
                0.005,
                0.0028,
                0.4,
                C.contributions.date,
                255,
                255,
                255,
                255,
                6,
                0
            )
            DrawAdvancedText(
                0.730,
                0.361 + 0.0287 * A,
                0.005,
                0.0028,
                0.4,
                C.contributions.amount,
                255,
                255,
                255,
                255,
                6,
                0
            )
        end
        if CursorInArea(0.419271, 0.482813, 0.667593, 0.699074) then
            DrawRect(0.452, 0.686, 0.065, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if f <= 1 then
                    tCLIMB.notify("~r~Lowest page reached")
                else
                    f = f - 1
                end
            end
        else
            DrawRect(0.452, 0.686, 0.065, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.512500, 0.575521, 0.667593, 0.699074) then
            DrawRect(0.545, 0.686, 0.065, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if f >= h then
                    tCLIMB.notify("~r~Max page reached")
                else
                    f = f + 1
                end
            end
        else
            DrawRect(0.545, 0.686, 0.065, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                d = "funds"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if d == "members" then
        DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
        DrawRect(0.501, 0.308, 0.421, 0.047, k.theme.r, k.theme.g, k.theme.b, 248)
        DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "CLIMB Gang - Members", 255, 255, 255, 255, 7, 0)
        DrawRect(0.448, 0.52, 0.295, 0.291, 0, 0, 0, 150)
        DrawAdvancedText(0.429, 0.359, 0.005, 0.0028, 0.4, "Name", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.486, 0.359, 0.005, 0.0028, 0.4, "ID", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.535, 0.359, 0.005, 0.0028, 0.4, "Rank", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.605, 0.359, 0.005, 0.0028, 0.4, "Last Seen", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.665, 0.359, 0.005, 0.0028, 0.4, "Playtime", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.746, 0.39, 0.005, 0.0028, 0.4, "Promote", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.746, 0.465, 0.005, 0.0028, 0.4, "Demote", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.746, 0.54, 0.005, 0.0028, 0.4, "Kick", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.746, 0.615, 0.005, 0.0028, 0.4, "Invite", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.491, 0.695, 0.005, 0.0028, 0.4, "Previous", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.581, 0.695, 0.005, 0.0028, 0.4, "Next", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.536, 0.695, 0.005, 0.0028, 0.4, tostring(f) .. "/" .. tostring(h), 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        for A, C in pairs(e[f]) do
            name, id, rank, lastseen, playtime = table.unpack(C)
            rank = tostring(rank)
            if rank == nil or rank == "nil" or rank == "NULL" then
                rank = "1"
            elseif rank <= "1" then
                rank = "Recruit"
            elseif rank == "2" then
                rank = "Member"
            elseif rank == "3" then
                rank = "Senior"
            elseif rank >= "4" then
                rank = "Leader"
            end
            DrawAdvancedText(0.429, 0.361 + 0.0287 * A, 0.005, 0.0028, 0.4, name, 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.486, 0.361 + 0.0287 * A, 0.005, 0.0028, 0.4, id, 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.535, 0.361 + 0.0287 * A, 0.005, 0.0028, 0.4, rank, 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.605, 0.361 + 0.0287 * A, 0.005, 0.0028, 0.4, lastseen, 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(
                0.665,
                0.361 + 0.0287 * A,
                0.005,
                0.0028,
                0.4,
                playtime .. " hours",
                255,
                255,
                255,
                255,
                6,
                0
            )
            if
                CursorInArea(0.3005, 0.5955, 0.3731 + 0.0287 * (A - 1), 0.4018 + 0.0287 * (A - 1)) and
                    selectedMember ~= id
             then
                DrawRect(0.448, 0.388 + 0.0287 * (A - 1), 0.295, 0.027, k.theme.r, k.theme.g, k.theme.b, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    selectedMember = id
                end
            elseif selectedMember == id then
                DrawRect(0.448, 0.388 + 0.0287 * (A - 1), 0.295, 0.027, k.theme.r, k.theme.g, k.theme.b, 150)
            end
        end
        if CursorInArea(0.6182, 0.6822, 0.360, 0.416) then
            DrawRect(0.651, 0.388, 0.065, 0.056, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if selectedMember ~= nil and PlayerIsInGang and gangID ~= nil then
                    if gangPermission >= 4 then
                        TriggerServerEvent("CLIMB:PromoteUser", gangID, tonumber(selectedMember))
                    else
                        tCLIMB.notify("~r~You don't have permission to promote!")
                    end
                else
                    tCLIMB.notify("~r~No gang member selected")
                end
            end
        else
            DrawRect(0.651, 0.388, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6182, 0.6822, 0.435, 0.491) then
            DrawRect(0.651, 0.463, 0.065, 0.056, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if selectedMember ~= nil and PlayerIsInGang and gangID ~= nil then
                    if gangPermission >= 4 then
                        if selectedMember == tCLIMB.getUserId() then
                            tCLIMB.notify("~r~You can't demote yourself.")
                        else
                            TriggerServerEvent("CLIMB:DemoteUser", gangID, selectedMember)
                        end
                    else
                        tCLIMB.notify("~r~You don't have permission to demote!")
                    end
                else
                    tCLIMB.notify("~r~No gang member selected")
                end
            end
        else
            DrawRect(0.651, 0.463, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6182, 0.6822, 0.510, 0.566) then
            DrawRect(0.651, 0.538, 0.065, 0.056, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if selectedMember ~= nil then
                    if gangPermission >= 3 then
                        if YesNoConfirm() then
                            TriggerServerEvent("CLIMB:kickMemberFromGang", gangID, selectedMember)
                        end
                    else
                        tCLIMB.notify("~r~You don't have permission to kick!")
                    end
                else
                    tCLIMB.notify("~r~No gang member selected")
                end
            end
        else
            DrawRect(0.651, 0.538, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6182, 0.6822, 0.585, 0.641) then
            DrawRect(0.651, 0.613, 0.065, 0.056, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                local D = GetPlayerPermID()
                if D ~= nil then
                    if gangPermission >= 2 then
                        TriggerServerEvent("CLIMB:InviteUserToGang", gangID, D)
                    else
                        tCLIMB.notify("~r~You don't have permission to invite players")
                    end
                else
                    tCLIMB.notify("No player name entered")
                end
            end
        else
            DrawRect(0.651, 0.613, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.3735, 0.4185, 0.6768, 0.7074) then
            DrawRect(0.396, 0.693, 0.045, 0.033, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if f <= 1 then
                    tCLIMB.notify("~r~Lowest page reached")
                else
                    f = f - 1
                end
            end
        else
            DrawRect(0.396, 0.693, 0.045, 0.033, 0, 0, 0, 150)
        end
        if CursorInArea(0.4635, 0.5085, 0.6712, 0.7064) then
            DrawRect(0.486, 0.693, 0.045, 0.033, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if f >= h then
                    tCLIMB.notify("~r~Max page reached")
                else
                    f = f + 1
                end
            end
        else
            DrawRect(0.486, 0.693, 0.045, 0.033, 0, 0, 0, 150)
        end
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                d = "main"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if d == "logs" then
        DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
        DrawRect(0.501, 0.308, 0.421, 0.047, k.theme.r, k.theme.g, k.theme.b, 248)
        DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "CLIMB Gang - Logs", 255, 255, 255, 255, 7, 0)
        DrawRect(0.502, 0.518, 0.387, 0.283, 0, 0, 0, 150)
        DrawAdvancedText(0.449, 0.365, 0.005, 0.0028, 0.4, "Name", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.51, 0.365, 0.005, 0.0028, 0.4, "UserID", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.583, 0.365, 0.005, 0.0028, 0.4, "Date", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.460, 0.688, 0.005, 0.0028, 0.4, "Set Webhook", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.547, 0.688, 0.005, 0.0028, 0.4, "Previous", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.639, 0.688, 0.005, 0.0028, 0.4, "Next", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.591, 0.688, 0.005, 0.0028, 0.4, tostring(g) .. "/" .. tostring(i), 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.673, 0.365, 0.005, 0.0028, 0.4, "Action", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.757, 0.365, 0.005, 0.0028, 0.4, "Value", 255, 255, 255, 255, 4, 0)
        if gangLogs[g] ~= nil then
            for A, C in pairs(gangLogs[g]) do
                name, id, date, action, value = table.unpack(C)
                DrawAdvancedText(0.449, 0.361 + 0.0287 * A, 0.005, 0.0028, 0.4, name, 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.51, 0.361 + 0.0287 * A, 0.005, 0.0028, 0.4, id, 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.583, 0.361 + 0.0287 * A, 0.005, 0.0028, 0.4, date, 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.673, 0.361 + 0.0287 * A, 0.005, 0.0028, 0.4, action, 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.757, 0.361 + 0.0287 * A, 0.005, 0.0028, 0.4, value, 255, 255, 255, 255, 6, 0)
            end
        end
        if CursorInArea(0.33, 0.395, 0.667593, 0.699074) then
            DrawRect(0.365, 0.686, 0.065, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                TriggerServerEvent("CLIMB:SetGangWebhook", gangID)
            end
        else
            DrawRect(0.365, 0.686, 0.065, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.419271, 0.482813, 0.667593, 0.699074) then
            DrawRect(0.452, 0.686, 0.065, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if g <= 1 then
                    tCLIMB.notify("~r~Lowest page reached")
                else
                    g = g - 1
                end
            end
        else
            DrawRect(0.452, 0.686, 0.065, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.512500, 0.575521, 0.667593, 0.699074) then
            DrawRect(0.545, 0.686, 0.065, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if g >= i then
                    tCLIMB.notify("~r~Max page reached")
                else
                    g = g + 1
                end
            end
        else
            DrawRect(0.545, 0.686, 0.065, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                d = "main"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if d == "settings" then
        DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
        DrawRect(0.501, 0.308, 0.421, 0.047, k.theme.r, k.theme.g, k.theme.b, 248)
        DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "CLIMB Gang - Settings", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.7, 0.360, 0.005, 0.0028, 0.46, "Current Gang: " .. gangID, 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.7, 0.398, 0.005, 0.0028, 0.46, "Permissions Guide", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(
            0.7,
            0.436,
            0.005,
            0.0028,
            0.46,
            "A Recruit can deposit to the gang funds only.",
            255,
            255,
            255,
            255,
            6,
            0
        )
        DrawAdvancedText(0.7, 0.472, 0.005, 0.0028, 0.46, "A Member can invite users", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(
            0.7,
            0.51,
            0.005,
            0.0028,
            0.46,
            "A Senior can invite and kick members,",
            255,
            255,
            255,
            255,
            6,
            0
        )
        DrawAdvancedText(
            0.7,
            0.532,
            0.005,
            0.0028,
            0.46,
            "withdraw from gang funds and set logs webhook.",
            255,
            255,
            255,
            255,
            6,
            0
        )
        DrawAdvancedText(
            0.7,
            0.572,
            0.005,
            0.0028,
            0.46,
            "A Leader can promote and demote members",
            255,
            255,
            255,
            255,
            6,
            0
        )
        DrawAdvancedText(0.7, 0.594, 0.005, 0.0028, 0.46, "and lock gang funds.", 255, 255, 255, 255, 6, 0)
        local E = k.blips and "Disable" or "Enable"
        DrawAdvancedText(0.451, 0.416, 0.005, 0.0028, 0.4, E .. " Blips", 255, 255, 255, 255, 6, 0)
        if CursorInArea(0.3187, 0.3937, 0.3712, 0.4462) then
            DrawRect(0.357, 0.41, 0.075, 0.076, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                k.blips = not k.blips
                SetResourceKvp("climb_gang_blips", tostring(k.blips))
            end
        else
            DrawRect(0.357, 0.41, 0.075, 0.076, 0, 0, 0, 150)
        end
        local F = k.pings and "Disable" or "Enable"
        DrawAdvancedText(0.554, 0.415, 0.005, 0.0028, 0.4, F .. " Pings", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.4197, 0.4932, 0.3712, 0.4462) then
            DrawRect(0.457, 0.41, 0.075, 0.076, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                k.pings = not k.pings
                SetResourceKvp("climb_gang_pings", tostring(k.pings))
            end
        else
            DrawRect(0.457, 0.41, 0.075, 0.076, 0, 0, 0, 150)
        end
        local G = k.names and "Disable" or "Enable"
        DrawAdvancedText(0.451, 0.516, 0.005, 0.0028, 0.4, G .. " Names", 255, 255, 255, 255, 6, 0)
        if CursorInArea(0.3187, 0.3937, 0.4712, 0.5462) then
            DrawRect(0.357, 0.51, 0.075, 0.076, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                k.names = not k.names
                SetResourceKvp("climb_gang_names", tostring(k.names))
                print("Names", k.names)
            end
        else
            DrawRect(0.357, 0.51, 0.075, 0.076, 0, 0, 0, 150)
        end
        DrawAdvancedText(0.554, 0.515, 0.005, 0.0028, 0.4, "Rename Gang", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.4197, 0.4932, 0.4712, 0.5462) then
            DrawRect(0.457, 0.51, 0.075, 0.076, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                newGangName = GetGangNameText()
                if newGangName ~= nil and newGangName ~= "null" and newGangName ~= "" and gangID ~= nil then
                    TriggerServerEvent("CLIMB:RenameGang", gangID, newGangName)
                else
                    tCLIMB.notify("~r~No gang name entered!")
                end
            end
        else
            DrawRect(0.457, 0.51, 0.075, 0.076, 0, 0, 0, 150)
        end
        DrawAdvancedText(0.451, 0.616, 0.005, 0.0028, 0.4, "Leave Gang", 255, 255, 255, 255, 6, 0)
        if CursorInArea(0.3187, 0.3937, 0.5712, 0.6462) then
            DrawRect(0.357, 0.61, 0.075, 0.076, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if YesNoConfirm() then
                    TriggerServerEvent("CLIMB:memberLeaveGang", gangID)
                    setCursor(0)
                    SetPlayerControl(PlayerId(), 1, 0)
                end
            end
        else
            DrawRect(0.357, 0.61, 0.075, 0.076, 0, 0, 0, 150)
        end
        DrawAdvancedText(0.554, 0.615, 0.005, 0.0028, 0.4, "Disband Gang", 255, 255, 255, 255, 6, 0)
        if CursorInArea(0.4197, 0.4932, 0.5712, 0.6462) then
            DrawRect(0.457, 0.61, 0.075, 0.076, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if gangPermission >= 4 then
                    if YesNoConfirm() == true and gangID ~= nil then
                        TriggerServerEvent("CLIMB:DeleteGang", gangID)
                    end
                else
                    tCLIMB.notify("~r~You don't have permission to disband!")
                end
            end
        else
            DrawRect(0.457, 0.61, 0.075, 0.076, 0, 0, 0, 150)
        end
        DrawAdvancedText(
            0.451,
            0.693,
            0.005,
            0.0028,
            0.4,
            k.healthui and "Disable Health UI" or "Enable Health UI",
            255,
            255,
            255,
            255,
            4,
            0
        )
        if CursorInArea(0.31, 0.39, 0.6712, 0.7064) then
            DrawRect(0.357, 0.689, 0.075, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                k.healthui = not k.healthui
                SetResourceKvp("climb_gang_healthui", tostring(k.healthui))
            end
        else
            DrawRect(0.357, 0.689, 0.075, 0.036, 0, 0, 0, 150)
        end
        DrawAdvancedText(0.551, 0.693, 0.005, 0.0028, 0.4, "Set Gang Fit", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.41, 0.49, 0.6712, 0.7064) then
            DrawRect(0.457, 0.689, 0.075, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if gangPermission >= 4 then
                    TriggerServerEvent("CLIMB:setGangFit", gangID)
                else
                    tCLIMB.notify("~r~You don't have permission to set gang fit!")
                end
            end
        else
            DrawRect(0.457, 0.689, 0.075, 0.036, 0, 0, 0, 150)
        end
        local H, I, J = GetHudColour(m[o].hud)
        DrawAdvancedText(0.645, 0.63, 0.005, 0.0028, 0.46, "Your Blip Colour: ", 255, 255, 255, 255, 6, 0)
        DrawRect(0.62, 0.628, 0.05, 0.025, H, I, J, 255)
        if CursorInArea(0.595, 0.645, 0.6155, 0.6405) then
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                local K = false
                local L = false
                for M in pairs(m) do
                    if M == o then
                        K = true
                    elseif K then
                        o = M
                        L = true
                        break
                    end
                end
                if not L then
                    for M in pairs(m) do
                        o = M
                        break
                    end
                end
                SetResourceKvp("climb_gang_colour", o)
                print("Gang Color changed to", o)
                TriggerServerEvent("CLIMB:setPersonalGangBlipColour", o)
            end
        end
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                d = "main"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if d == "turfs" then
        DrawRect(0.501, 0.533, 0.421, 0.497, 0, 0, 0, 150)
        DrawRect(0.501, 0.308, 0.421, 0.047, k.theme.r, k.theme.g, k.theme.b, 248)
        DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "CLIMB Gang - Turfs", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(
            0.399,
            0.38,
            0.005,
            0.0028,
            0.4,
            "Weed Turf - (Owned by " .. turfData[1].gangOwner .. ") Commission - " .. globalWeedCommissionPercent .. "%",
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(
            0.399,
            0.44,
            0.005,
            0.0028,
            0.4,
            "Cocaine Turf - (Owned by " ..
                turfData[2].gangOwner .. ") Commission - " .. globalCocaineCommissionPercent .. "%",
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(
            0.399,
            0.50,
            0.005,
            0.0028,
            0.4,
            "Meth Turf - (Owned by " .. turfData[3].gangOwner .. ") Commission - " .. globalMethCommissionPercent .. "%",
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(
            0.399,
            0.56,
            0.005,
            0.0028,
            0.4,
            "Heroin Turf - (Owned by " ..
                turfData[4].gangOwner .. ") Commission - " .. globalHeroinCommissionPercent .. "%",
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(
            0.399,
            0.62,
            0.005,
            0.0028,
            0.4,
            "Large Arms - (Owned by " .. turfData[5].gangOwner .. ") Commission - " .. globalLargeArmsCommission .. "%",
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(
            0.399,
            0.68,
            0.005,
            0.0028,
            0.4,
            "LSD North Turf - (Owned by " ..
                turfData[6].gangOwner .. ") Commission - " .. globalLSDNorthCommissionPercent .. "%",
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(
            0.399,
            0.74,
            0.005,
            0.0028,
            0.4,
            "LSD South Turf - (Owned by " ..
                turfData[7].gangOwner .. ") Commission - " .. globalLSDSouthCommissionPercent .. "%",
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                d = "main"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if d == "security" then
        DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
        DrawRect(0.501, 0.308, 0.421, 0.047, k.theme.r, k.theme.g, k.theme.b, 248)
        DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "CLIMB gang - security", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(
            0.4,
            0.375,
            0.005,
            0.0028,
            0.46,
            "Maximum withdraw amount per member:",
            255,
            255,
            255,
            255,
            6,
            1
        )
        DrawAdvancedText(
            0.4,
            0.405,
            0.005,
            0.0028,
            0.4,
            "Sets the maximum amount of money a member can withdraw within a 24 hour time period.",
            255,
            255,
            255,
            255,
            6,
            1
        )
        DrawRect(0.525, 0.377, 0.1, 0.03, 0, 0, 0, 175)
        DrawAdvancedText(
            0.575,
            0.377,
            0.005,
            0.0028,
            0.44,
            "£" .. getMoneyStringFormatted(gangMaxWithdraw),
            255,
            255,
            255,
            255,
            6,
            1
        )
        if CursorInArea(0.31, 0.65, 0.36, 0.41) then
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if gangPermission >= 4 then
                    local amount = GetMoneyAmountText()
                    if amount and tonumber(amount) and tonumber(amount) >= 0 then
                        tCLIMB.notify("~r~Coming soon.")
                    else
                        notify("~r~Invalid amount entered.")
                    end
                else
                    notify("~r~You must be a leader to change security.")
                end
            end
        end
        DrawAdvancedText(
            0.4,
            0.475,
            0.005,
            0.0028,
            0.46,
            "Limit withdraw amount to deposit amount:",
            255,
            255,
            255,
            255,
            6,
            1
        )
        DrawAdvancedText(
            0.4,
            0.505,
            0.005,
            0.0028,
            0.4,
            "Prevents a member withdrawing more money then they have deposited into the funds.",
            255,
            255,
            255,
            255,
            6,
            1
        )
        DrawRect(0.525, 0.475, 0.1, 0.03, 0, 0, 0, 175)
        DrawAdvancedText(
            0.575,
            0.475,
            0.005,
            0.0028,
            0.46,
            gangLimitWithdrawDeposit and "Yes" or "No",
            255,
            255,
            255,
            255,
            6,
            1
        )
        if CursorInArea(0.31, 0.65, 0.46, 0.51) then
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if gangPermission >= 4 then
                    local N = YesNoConfirm()
                    tCLIMB.notify("~r~Coming soon.")
                else
                    notify("~r~You must be a leader to change security.")
                end
            end
        end
        DrawAdvancedText(0.4, 0.575, 0.005, 0.0028, 0.46, "Lock gang funds:", 255, 255, 255, 255, 6, 1)
        DrawAdvancedText(
            0.4,
            0.605,
            0.005,
            0.0028,
            0.4,
            "Prevents any member from withdrawing funds from the gang.",
            255,
            255,
            255,
            255,
            6,
            1
        )
        DrawRect(0.525, 0.575, 0.1, 0.03, 0, 0, 0, 175)
        DrawAdvancedText(0.575, 0.575, 0.005, 0.0028, 0.46, j and "Yes" or "No", 255, 255, 255, 255, 6, 1)
        if CursorInArea(0.31, 0.65, 0.56, 0.61) then
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if gangPermission >= 4 then
                    TriggerServerEvent("CLIMB:LockGangFunds", gangID)
                else
                    notify("~r~You must be a leader to change security.")
                end
            end
        end
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                d = "main"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if d == "theme" then
        DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
        DrawRect(0.501, 0.308, 0.421, 0.047, k.theme.r, k.theme.g, k.theme.b, 248)
        DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "CLIMB Gang - Theme", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(
            0.7,
            0.360,
            0.005,
            0.0028,
            0.46,
            "The theme will be frequent throughout the",
            255,
            255,
            255,
            255,
            6,
            0
        )
        DrawAdvancedText(
            0.7,
            0.396,
            0.005,
            0.0028,
            0.46,
            "gang menu and used as your marker colour.",
            255,
            255,
            255,
            255,
            6,
            0
        )
        DrawAdvancedText(0.490, 0.380, 0.005, 0.0028, 0.48, "Current Theme", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(
            0.490,
            0.405,
            0.005,
            0.0028,
            0.48,
            "(" .. k.theme.r .. "," .. k.theme.g .. "," .. k.theme.b .. ")",
            255,
            255,
            255,
            255,
            6,
            0
        )
        DrawAdvancedText(0.420, 0.693, 0.005, 0.0028, 0.4, "Blue", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.480, 0.693, 0.005, 0.0028, 0.4, "Pink", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.540, 0.693, 0.005, 0.0028, 0.4, "Green", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.600, 0.693, 0.005, 0.0028, 0.4, "Red", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.660, 0.693, 0.005, 0.0028, 0.4, "Cyan", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.720, 0.693, 0.005, 0.0028, 0.4, "Orange", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.647, 0.447, 0.005, 0.0028, 0.4, "Copy theme", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.647, 0.573, 0.005, 0.0028, 0.4, "Random Colour", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.746, 0.447, 0.005, 0.0028, 0.4, "Reset Colour", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.746, 0.572, 0.005, 0.0028, 0.4, "Custom Colour", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        DrawRect(0.395, 0.51, 0.1, 0.13, k.theme.r, k.theme.g, k.theme.b, 248)
        if CursorInArea(0.5187, 0.5828, 0.4138, 0.4694) then
            DrawRect(0.552, 0.443, 0.065, 0.056, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tCLIMB.CopyToClipboard(k.theme.r .. "," .. k.theme.g .. "," .. k.theme.b)
                tCLIMB.notify("~g~Theme copied to clipboard.")
            end
        else
            DrawRect(0.552, 0.443, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.5187, 0.5828, 0.5407, 0.5962) then
            DrawRect(0.552, 0.569, 0.065, 0.056, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tCLIMB.gangMenuTheme(math.random(1, 255), math.random(1, 255), math.random(1, 255))
            end
        else
            DrawRect(0.552, 0.569, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6182, 0.6822, 0.4138, 0.4694) then
            DrawRect(0.651, 0.443, 0.065, 0.056, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tCLIMB.gangMenuTheme(18, 82, 228)
            end
        else
            DrawRect(0.651, 0.443, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6182, 0.6822, 0.5407, 0.5962) then
            DrawRect(0.651, 0.569, 0.065, 0.056, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tCLIMB.clientPrompt(
                    "Enter rgb value eg 255,100,150:",
                    "",
                    function(O)
                        if O ~= "" then
                            local P = stringsplit(O, ",")
                            if P[1] ~= nil and P[2] ~= nil and P[3] ~= nil then
                                tCLIMB.gangMenuTheme(tonumber(P[1]), tonumber(P[2]), tonumber(P[3]))
                            else
                                tCLIMB.notify("~r~Invalid value")
                            end
                        else
                            tCLIMB.notify("~r~Invalid value")
                        end
                    end
                )
            end
        else
            DrawRect(0.651, 0.569, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.3033, 0.3506, 0.6712, 0.7064) then
            DrawRect(0.326, 0.689, 0.045, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tCLIMB.gangMenuTheme(18, 82, 228)
            end
        else
            DrawRect(0.326, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.3633, 0.4106, 0.6712, 0.7064) then
            DrawRect(0.386, 0.689, 0.045, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tCLIMB.gangMenuTheme(255, 0, 255)
            end
        else
            DrawRect(0.386, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.4233, 0.4706, 0.6712, 0.7064) then
            DrawRect(0.446, 0.689, 0.045, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tCLIMB.gangMenuTheme(0, 128, 0)
            end
        else
            DrawRect(0.446, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.4833, 0.5306, 0.6712, 0.7064) then
            DrawRect(0.506, 0.689, 0.045, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tCLIMB.gangMenuTheme(255, 0, 0)
            end
        else
            DrawRect(0.506, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.5433, 0.5906, 0.6712, 0.7064) then
            DrawRect(0.566, 0.689, 0.045, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tCLIMB.gangMenuTheme(0, 100, 100)
            end
        else
            DrawRect(0.566, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.6033, 0.6506, 0.6712, 0.7064) then
            DrawRect(0.626, 0.689, 0.045, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tCLIMB.gangMenuTheme(255, 165, 0)
            end
        else
            DrawRect(0.626, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                d = "main"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if d == "main" then
        DrawRect(0.501, 0.532, 0.375, 0.225, 0, 0, 0, 150)
        DrawRect(0.501, 0.396, 0.375, 0.046, k.theme.r, k.theme.g, k.theme.b, 255)
        DrawAdvancedText(0.591, 0.399, 0.005, 0.0028, 0.51, "CLIMB Gangs", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.46, 0.534, 0.005, 0.0028, 0.4, "funds", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.554, 0.534, 0.005, 0.0028, 0.4, "members", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.642, 0.534, 0.005, 0.0028, 0.4, "logs", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.732, 0.534, 0.005, 0.0028, 0.4, "settings", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.51, 0.604, 0.005, 0.0028, 0.4, "Turfs", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.598, 0.604, 0.005, 0.0028, 0.4, "Security", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.686, 0.604, 0.005, 0.0028, 0.4, "Theme", 255, 255, 255, 255, 7, 0)
        if CursorInArea(0.3333, 0.3973, 0.4981, 0.5537) then
            DrawRect(0.366, 0.527, 0.065, 0.056, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                d = "funds"
            end
        else
            DrawRect(0.366, 0.527, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.4244, 0.4903, 0.4981, 0.5537) then
            DrawRect(0.458, 0.527, 0.065, 0.056, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                d = "members"
            end
        else
            DrawRect(0.458, 0.527, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.5140, 0.5776, 0.4981, 0.5537) then
            DrawRect(0.546, 0.527, 0.065, 0.056, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                d = "logs"
            end
        else
            DrawRect(0.546, 0.527, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6020, 0.6677, 0.4981, 0.5537) then
            DrawRect(0.635, 0.527, 0.065, 0.056, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                d = "settings"
            end
        else
            DrawRect(0.635, 0.527, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.3804, 0.4463, 0.5722, 0.6259) then
            DrawRect(0.414, 0.6, 0.065, 0.056, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                d = "turfs"
            end
        else
            DrawRect(0.414, 0.6, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.47, 0.5336, 0.5722, 0.6259) then
            DrawRect(0.502, 0.6, 0.065, 0.056, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                d = "security"
            end
        else
            DrawRect(0.502, 0.6, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.558, 0.6216, 0.5722, 0.6259) then
            DrawRect(0.59, 0.6, 0.065, 0.056, k.theme.r, k.theme.g, k.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                d = "theme"
            end
        else
            DrawRect(0.59, 0.6, 0.065, 0.056, 0, 0, 0, 150)
        end
    end
end
createThreadOnTick(func_drawGangUI)
tCLIMB.createThreadOnTick(b5)
Citizen.CreateThread(
    function()
        k = {
            blips = GetResourceKvpString("climb_gang_blips") == "true",
            pings = GetResourceKvpString("climb_gang_pings") == "true",
            names = GetResourceKvpString("climb_gang_names") == "true",
            healthui = GetResourceKvpString("climb_gang_healthui") == "true"
        }
        k.theme = json.decode(GetResourceKvpString("climb_gang_theme")) or {r = 18, g = 82, b = 228}
        while true do
            if IsControlJustPressed(0, 166) or IsDisabledControlJustPressed(0, 166) then
                TriggerEvent("CLIMB:ForceRefreshData")
                if not PlayerIsInGang then
                    if d == "none" then
                        d = nil
                        setCursor(0)
                        inGUICLIMB = false
                        selectedGangInvite = nil
                    else
                        d = "none"
                        setCursor(1)
                        inGUICLIMB = true
                    end
                end
                if PlayerIsInGang then
                    if d == "main" then
                        d = nil
                        setCursor(0)
                        inGUICLIMB = false
                        selectedMember = nil
                    else
                        d = "main"
                        setCursor(1)
                        inGUICLIMB = true
                    end
                end
                Wait(100)
            end
            Wait(0)
        end
    end
)
function GetGangNameText()
    AddTextEntry("FMMC_MPM_NA", "Enter Gang Name:")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local O = GetOnscreenKeyboardResult()
        return O
    end
    return nil
end
function GetPlayerPermID()
    AddTextEntry("FMMC_MPM_NA", "Enter exact player permid to invite:")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local O = GetOnscreenKeyboardResult()
        return O
    end
    return nil
end
function YesNoConfirm()
    AddTextEntry("FMMC_MPM_NA", "Are you sure?")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Are you sure?", "Yes | No", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local O = GetOnscreenKeyboardResult()
        if string.upper(O) == "YES" then
            return true
        else
            return false
        end
    end
    return false
end
function GetMoneyAmountText()
    AddTextEntry("FMMC_MPM_NA", "Enter amount:")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter amount:", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local O = GetOnscreenKeyboardResult()
        return O
    end
    return nil
end
RegisterNetEvent(
    "CLIMB:Notify",
    function(m)
        tCLIMB.notify(m)
    end
)
RegisterNetEvent(
    "CLIMB:setGangMemberColour",
    function(Q, M)
        for k, n in pairs(CLIMBGangMembers) do
            if n[2] == Q then
                CLIMBGangMembers[k].colour = M
            end
        end
    end
)
function getMoneyStringFormatted(R)
    local q, r, S, T, U = tostring(R):find("([-]?)(%d+)([.]?%d*)")
    T = T:reverse():gsub("(%d%d%d)", "%1,")
    return S .. T:reverse():gsub("^,", "") .. U
end
function tCLIMB.gangMenuTheme(V, W, X)
    if V ~= nil and W ~= nil and X ~= nil then
        k.theme = {r = V, g = W, b = X}
        SetResourceKvp("climb_gang_theme", json.encode(k.theme))
    else
        tCLIMB.notify("~r~Invalid value")
    end
end
function tCLIMB.hasGangNamesEnabled()
    local P = p()
    return P and k.names
end


function tCLIMB.isPlayerInSelectedGang(Y)
    local P = p()
    if P then
        local Q = tCLIMB.clientGetUserIdFromSource(Y)
        if Q and tCLIMB.getJobType(Q) == "" then
            for a, b in pairs(CLIMBGangMembers) do
                if Q == b[2] then
                    return true, m[b.colour] or n
                end
            end
        end
    end
    return false, n
end
function tCLIMB.hasGangBlipsEnabled()
    if k ~= nil and k.blips then
        return true
    end
    return false
end
local Z = {}
RegisterKeyMapping("drawmarker", "Gang Marker", "MOUSE_BUTTON", "MOUSE_MIDDLE")
RegisterCommand(
    "drawmarker",
    function()
       -- if k.pings and not tCLIMB.isEmergencyService() and not globalHideUi and not tCLIMB.inEvent() then
            local _ = GetGameplayCamCoord()
            local a0 = tCLIMB.rotationToDirection(GetGameplayCamRot(2))
            local a1 = {x = _.x + a0.x * 1000.0, y = _.y + a0.y * 1000.0, z = _.z + a0.z * 1000.0}
            local a, b, c, f = GetShapeTestResult(StartShapeTestRay(_.x, _.y, _.z, a1.x, a1.y, a1.z, -1, -1, 1))
            if c ~= vector3(0.0, 0.0, 0.0) then
                TriggerServerEvent("CLIMB:sendGangMarker", gangID, c)
            end
       -- end
    end
)

local function a2(a3)
    if tCLIMB.getGangPingMarkerIndex() == 2 and not tCLIMB.isEmergencyService() and not tCLIMB.inEvent() then
        local a4, a5 = GetGroundZFor_3dCoord(a3.x, a3.y, a3.z, a3.z, false)
        local a6 = math.abs(a5 - a3.z)
        local a7 = (a6 > 10.0 and a3.z or a5) - 1.0
        return CreateCheckpoint(
            47,
            a3.x,
            a3.y,
            a7,
            a3.x,
            a3.y,
            a3.z + 200.0,
            1.0,
            k.theme.r,
            k.theme.g,
            k.theme.b,
            150,
            0
        )
    else
        return nil
    end
end
RegisterNetEvent("CLIMB:drawGangMarker")
AddEventHandler(
    "CLIMB:drawGangMarker",
    function(a8, a9)
        if k.pings and not tCLIMB.isEmergencyService() and not globalHideUi and not tCLIMB.inEvent() then
            local aa = #(GetEntityCoords(PlayerPedId()) - a9)
            if aa < 1000.0 then
                local ab = Z[a8]
                if ab and ab.checkpoint then
                    DeleteCheckpoint(ab.checkpoint)
                    ab.checkpoint = nil
                end
                if a9 then
                    Z[a8] = {coords = a9, time = GetGameTimer(), dist = aa, creator = a8, checkpoint = a2(a9)}
                    if tCLIMB.getGangPingSoundEnabled() then
                        PlaySoundFrontend(-1, "10_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", true)
                    end
                else
                    Z[a8] = nil
                end
            end
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if k ~= nil and k.pings and PlayerIsInGang then
                for a, b in pairs(Z) do
                    if GetGameTimer() - b.time > 10000 then
                        DeleteCheckpoint(Z[a].checkpoint)
                        Z[a] = nil
                    end
                end
            end
            Citizen.Wait(1000)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if k ~= nil and k.pings and PlayerIsInGang then
                for a, b in pairs(Z) do
                    if Z[a] ~= nil then
                        if tCLIMB.getGangPingMarkerIndex() == 3 then
                            tCLIMB.DrawSprite3d(
                                {
                                    pos = b.coords + vector3(0.0, 0.0, b.dist / 100),
                                    textureDict = "ping",
                                    textureName = "ping",
                                    width = 0.06,
                                    height = 0.1,
                                    r = k.theme.r,
                                    g = k.theme.g,
                                    b = k.theme.b,
                                    a = 255
                                }
                            )
                        end
                        tCLIMB.DrawText3D(b.coords, b.creator .. "\n" .. tostring(math.floor(b.dist)) .. "m", 0.2)
                    end
                end
            end
            Citizen.Wait(0)
        end
    end
)
local ac = {}
RegisterNetEvent("CLIMB:sendGangHPStats",
    function(ad)
        ac = ad
        for ax, data in pairs(ac) do
            PlayerInGang = true
            
        end
    end
)


local ae = 0.008
local af = 0.35
local ag = {0, 0, 0, 255}
local ah = 0.8
local function ai(aj, ak, al, am, H, I, J, b5)
    DrawRect(aj + al / 2.0, ak + am / 2.0, al, am, H, I, J, b5)
end
local function an()
    local ao = 0
    local P = p()
    if k ~= nil and k.healthui and PlayerIsInGang then
       if P and not tCLIMB.isEmergencyService() and not globalHideUi and not tCLIMB.inEvent() then
            local ap = 0
            local aq = tCLIMB.getShowHealthPercentageFlag()
            if CLIMBGangMembers ~= nil then
                for ar, as in pairs(CLIMBGangMembers) do
                    name, id, rank, lastseen, playtime = table.unpack(as)
                 --   print(name)
                 --   print(id)
                 --   print(rank)
                --    print(lastseen)

                --   if lastseen == "~g~Online" and tCLIMB.getJobType(id) == "" then
                        local at = true
                        local au = nil
                        local av = nil
                        local ad = ac[id]
                        if ad then
                            au = ad.health
                            av = ad.armour
                           -- print("au", au)
                          --  print("av", av)

                        end
                        local aw = tCLIMB.getTempFromPerm(id)
                        if aw then
                            local ax = GetPlayerFromServerId(aw)
                            if ax ~= -1 then
                                local ay = GetPlayerPed(ax)
                                if ay ~= 0 then
                                    au = GetEntityHealth(ay)
                                    av = GetPedArmour(ay)
                                    at = false
                                end
                            end
                        end
                        if au and av then
                            local az = ap * 0.05 + af
                            tCLIMB.DrawText(ae, az, name, 0.3)
                            ai(ae + 0.0011, az + 0.025, 0.125, 0.0035, 9, 31, 0, 100)
                            local aA = 0.125 * av / 100
                            if au <= 102 then
                                aA = 0.0
                            end
                            ai(ae + 0.0011, az + 0.025, aA, 0.0035, 66, 145, 243, 255)
                            ai(ae + 0.0011, az + 0.032, 0.125, 0.009, 9, 31, 0, 100)
                            if au >= 198 then
                                au = 200
                            end
                            local aB = 0.125 * (au - 100) / 100
                            if aB < 0.0 then
                                aB = 0.0
                            end
                            ai(ae + 0.0011, az + 0.032, aB, 0.009, 104, 212, 73, 255)
                            if aq then
                                local aC = math.floor((au - 100) / 100.0 * 100)
                                if aC < 0 then
                                    aC = 0
                                end
                                tCLIMB.DrawText(
                                    ae + 0.125 / 2.0 - 0.0025,
                                    az + 0.03,
                                    tostring(aC) .. "%",
                                    0.15,
                                    nil,
                                    nil,
                                    ag
                                )
                            end
                            ap = ap + 1
                        end
                        if at then
                            ao = ao + 1
                        end
                    end
--end
            end
        end
    end
    if l and l == P then
        if ao <= 0 then
            TriggerServerEvent("CLIMB:getGangHealthTable", nil)
            l = nil
        end
    else
        if ao > 0 then
            TriggerServerEvent("CLIMB:getGangHealthTable", gangID)
            l = P
        end
    end
end
tCLIMB.createThreadOnTick(an)
