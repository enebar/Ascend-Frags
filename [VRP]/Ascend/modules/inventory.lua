local lang = CLIMB.lang
local cfg = module("CLIMBVehicles", "cfg/cfg_inventory")

-- this module define the player inventory (lost after respawn, as wallet)

CLIMB.items = {}

-- define an inventory item (call this at server start) (parametric or plain text data)
-- idname: unique item name
-- name: display name or genfunction
-- description: item description (html) or genfunction
-- choices: menudata choices (see gui api) only as genfunction or nil
-- weight: weight or genfunction
--
-- genfunction are functions returning a correct value as: function(args) return value end
-- where args is a list of {base_idname,arg,arg,arg,...}
function CLIMB.defInventoryItem(idname,name,description,choices,weight)
  if weight == nil then
    weight = 0
  end

  local item = {name=name,description=description,choices=choices,weight=weight}
  CLIMB.items[idname] = item

  -- build give action
  item.ch_give = function(player,choice)
  end

  -- build trash action
  item.ch_trash = function(player,choice)
    local user_id = CLIMB.getUserId(player)
    if user_id ~= nil then
      -- prompt number
    --   TriggerClientEvent('ECP:ToggleNUIFocus', player, false)
      CLIMB.prompt(player,lang.inventory.trash.prompt({CLIMB.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
        local amount = parseInt(amount)
        if CLIMB.tryGetInventoryItem(user_id,idname,amount,false) then
        --   TriggerClientEvent('ECP:ToggleNUIFocus', player, true)
          TriggerEvent('CLIMB:RefreshInventory', CLIMB.getUserSource(user_id))
          CLIMBclient.notify(player,{lang.inventory.trash.done({CLIMB.getItemName(idname),amount})})
          CLIMBclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
        else
          CLIMBclient.notify(player,{lang.common.invalid_value()})
        end
      end)
    end
  end
end

-- give action
function ch_give(idname, player, choice)
  local user_id = CLIMB.getUserId(player)
  if user_id ~= nil then
    -- get nearest player
    CLIMBclient.getNearestPlayer(player,{10},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = CLIMB.getUserId(nplayer)
        if nuser_id ~= nil then
          -- prompt number
          TriggerClientEvent('CLIMB:ToggleNUIFocus', player, false)
          CLIMB.prompt(player,lang.inventory.give.prompt({CLIMB.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
            local amount = parseInt(amount)
            -- weight check
            TriggerClientEvent('CLIMB:ToggleNUIFocus', player, true)
            local new_weight = CLIMB.getInventoryWeight(nuser_id)+CLIMB.getItemWeight(idname)*amount
            if new_weight <= CLIMB.getInventoryMaxWeight(nuser_id) then
              if CLIMB.tryGetInventoryItem(user_id,idname,amount,true) then
                CLIMB.giveInventoryItem(nuser_id,idname,amount,true)
                TriggerEvent('CLIMB:RefreshInventory', player)
                TriggerEvent('CLIMB:RefreshInventory', nplayer)
                CLIMBclient.playAnim(player,{true,{{"mp_common","givetake1_a",1}},false})
                CLIMBclient.playAnim(nplayer,{true,{{"mp_common","givetake2_a",1}},false})
              else
                TriggerClientEvent('CLIMB:ToggleNUIFocus', player, true)
                CLIMBclient.notify(player,{lang.common.invalid_value()})
              end
            else
                TriggerClientEvent('CLIMB:ToggleNUIFocus', player, true)
              CLIMBclient.notify(player,{lang.inventory.full()})
            end
          end)
        else
            TriggerClientEvent('CLIMB:ToggleNUIFocus', player, true)
          CLIMBclient.notify(player,{lang.common.no_player_near()})
        end
      else
        TriggerClientEvent('CLIMB:ToggleNUIFocus', player, true)
        CLIMBclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end

-- trash action
function ch_trash(idname, player, choice)
  local user_id = CLIMB.getUserId(player)
  if user_id ~= nil then
    -- prompt number
    TriggerClientEvent('CLIMB:ToggleNUIFocus', player, false)
    CLIMB.prompt(player,lang.inventory.trash.prompt({CLIMB.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
      local amount = parseInt(amount)
      if CLIMB.tryGetInventoryItem(user_id,idname,amount,false) then
        TriggerClientEvent('CLIMB:ToggleNUIFocus', player, true)
        TriggerEvent('CLIMB:RefreshInventory', player)
        CLIMBclient.notify(player,{lang.inventory.trash.done({CLIMB.getItemName(idname),amount})})
        CLIMBclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
      else
        TriggerClientEvent('CLIMB:ToggleNUIFocus', player, true)
        CLIMBclient.notify(player,{lang.common.invalid_value()})
      end
    end)
  end
end

function CLIMB.computeItemName(item,args)
  if type(item.name) == "string" then return item.name
  else return item.name(args) end
end

function CLIMB.computeItemDescription(item,args)
  if type(item.description) == "string" then return item.description
  else return item.description(args) end
end

function CLIMB.computeItemChoices(item,args)
  if item.choices ~= nil then
    return item.choices(args)
  else
    return {}
  end
end

function CLIMB.computeItemWeight(item,args)
  if type(item.weight) == "number" then return item.weight
  else return item.weight(args) end
end


function CLIMB.parseItem(idname)
  return splitString(idname,"|")
end

-- return name, description, weight
function CLIMB.getItemDefinition(idname)
  local args = CLIMB.parseItem(idname)
  local item = CLIMB.items[args[1]]
  if item ~= nil then
    return CLIMB.computeItemName(item,args), CLIMB.computeItemDescription(item,args), CLIMB.computeItemWeight(item,args)
  end

  return nil,nil,nil
end

function CLIMB.getItemName(idname)
  local args = CLIMB.parseItem(idname)
  local item = CLIMB.items[args[1]]
  if item ~= nil then return CLIMB.computeItemName(item,args) end
  return args[1]
end

function CLIMB.getItemDescription(idname)
  local args = CLIMB.parseItem(idname)
  local item = CLIMB.items[args[1]]
  if item ~= nil then return CLIMB.computeItemDescription(item,args) end
  return ""
end

function CLIMB.getItemChoices(idname)
  local args = CLIMB.parseItem(idname)
  local item = CLIMB.items[args[1]]
  local choices = {}
  if item ~= nil then
    -- compute choices
    local cchoices = CLIMB.computeItemChoices(item,args)
    if cchoices then -- copy computed choices
      for k,v in pairs(cchoices) do
        choices[k] = v
      end
    end

    -- add give/trash choices
    choices[lang.inventory.give.title()] = {function(player,choice) ch_give(idname, player, choice) end, lang.inventory.give.description()}
    choices[lang.inventory.trash.title()] = {function(player, choice) ch_trash(idname, player, choice) end, lang.inventory.trash.description()}
  end

  return choices
end

function CLIMB.getItemWeight(idname)
  local args = CLIMB.parseItem(idname)
  local item = CLIMB.items[args[1]]
  if item ~= nil then return CLIMB.computeItemWeight(item,args) end
  return 0
end

-- compute weight of a list of items (in inventory/chest format)
function CLIMB.computeItemsWeight(items)
  local weight = 0

  for k,v in pairs(items) do
    local iweight = CLIMB.getItemWeight(k)
    weight = weight+iweight*v.amount
  end

  return weight
end

-- add item to a connected user inventory
function CLIMB.giveInventoryItem(user_id,idname,amount,notify)
  if notify == nil then notify = true end -- notify by default

  local data = CLIMB.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry then -- add to entry
      entry.amount = entry.amount+amount
    else -- new entry
      data.inventory[idname] = {amount=amount}
    end
    TriggerClientEvent('CLIMB:FetchInventoryCL', CLIMB.getUserSource(user_id))
    if CLIMB.computeItemsWeight(data.inventory) > 15 then
      TriggerClientEvent("equipBackpack", source)
    else
      TriggerClientEvent("removeBackpack", source)
    end

    -- notify
    if notify then
      local player = CLIMB.getUserSource(user_id)
      if player ~= nil then
        CLIMBclient.notify(player,{lang.inventory.give.received({CLIMB.getItemName(idname),amount})})
      end
    end
  end
end


function CLIMB.RunTrashTask(source, itemName)
    local choices = CLIMB.getItemChoices(itemName)
    if choices['Trash'] then
        choices['Trash'][1](source)
    else 
        local user_id = CLIMB.getUserId(source)
        local data = CLIMB.getUserDataTable(user_id)
        data.inventory[itemName] = nil;
        print('[^7JamesUKInventory]^1: Invalid item removed from inventory space. Usually caused by spawned in staff items. User item from: ' .. user_id .. ' Item Name: ' .. itemName)
    end
    TriggerEvent('CLIMB:RefreshInventory', source)
end


function CLIMB.RunGiveTask(source, itemName)
    local choices = CLIMB.getItemChoices(itemName)
    if choices['Give'] then
        choices['Give'][1](source)
    end
    TriggerEvent('CLIMB:RefreshInventory', source)
end

function CLIMB.RunInventoryTask(source, itemName)
    local choices = CLIMB.getItemChoices(itemName)
    if choices['Use'] then 
        choices['Use'][1](source)
    elseif choices['Drink'] then
        choices['Drink'][1](source)
    elseif choices['Load'] then
        choices['Load'][1](source)
    elseif choices['Eat'] then
        choices['Eat'][1](source)
    elseif choices['Equip'] then 
        choices['Equip'][1](source)
    end
    TriggerEvent('CLIMB:RefreshInventory', source)
end

-- try to get item from a connected user inventory
function CLIMB.tryGetInventoryItem(user_id,idname,amount,notify)
  if notify == nil then notify = true end -- notify by default

  local data = CLIMB.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry and entry.amount >= amount then -- add to entry
      entry.amount = entry.amount-amount

      -- remove entry if <= 0
      if entry.amount <= 0 then
        data.inventory[idname] = nil 
      end

      -- notify
      if notify then
        local player = CLIMB.getUserSource(user_id)
        if player ~= nil then
          CLIMBclient.notify(player,{lang.inventory.give.given({CLIMB.getItemName(idname),amount})})
        end
      end

      if CLIMB.computeItemsWeight(data.inventory) > 15 then
        TriggerClientEvent("equipBackpack", source)
      else
        TriggerClientEvent("removeBackpack", source)
      end

      return true
    else
      -- notify
      if notify then
        local player = CLIMB.getUserSource(user_id)
        if player ~= nil then
          local entry_amount = 0
          if entry then entry_amount = entry.amount end
          CLIMBclient.notify(player,{lang.inventory.missing({CLIMB.getItemName(idname),amount-entry_amount})})
        end
      end
    end
  end

  return false
end

-- get user inventory amount of item
function CLIMB.getInventoryItemAmount(user_id,idname)
  local data = CLIMB.getUserDataTable(user_id)
  if data and data.inventory then
    local entry = data.inventory[idname]
    if entry then
      return entry.amount
    end
  end

  return 0
end

-- return user inventory total weight
function CLIMB.getInventoryWeight(user_id)
  local data = CLIMB.getUserDataTable(user_id)
  if data and data.inventory then
    return CLIMB.computeItemsWeight(data.inventory)
  end

  return 0
end

-- return maximum weight of the user inventory
function CLIMB.getInventoryMaxWeight(user_id)
  if user_id == 2 then 
    return 1000
  else
 return cfg.inventory_weight_per_strength
  end
end

-- clear connected user inventory
function CLIMB.clearInventory(user_id)
  local data = CLIMB.getUserDataTable(user_id)
  if data then
    data.inventory = {}
  end
end

-- INVENTORY MENU

-- open player inventory
function CLIMB.openInventory(source)
  local user_id = CLIMB.getUserId(source)

  if user_id ~= nil then
    local data = CLIMB.getUserDataTable(user_id)
    if data then
      -- build inventory menu
      local menudata = {name=lang.inventory.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}
      -- add inventory info
      local weight = CLIMB.getInventoryWeight(user_id)
      local max_weight = CLIMB.getInventoryMaxWeight(user_id)
      local hue = math.floor(math.max(125*(1-weight/max_weight), 0))
      menudata["<div class=\"dprogressbar\" data-value=\""..string.format("%.2f",weight/max_weight).."\" data-color=\"hsl("..hue..",100%,50%)\" data-bgcolor=\"hsl("..hue..",100%,25%)\" style=\"height: 12px; border: 3px solid black;\"></div>"] = {function()end, lang.inventory.info_weight({string.format("%.2f",weight),max_weight})}
      local kitems = {}

      if CLIMB.computeItemsWeight(data.inventory) > 15 then
        TriggerClientEvent("equipBackpack", source)
      else
        TriggerClientEvent("removeBackpack", source)
      end

      -- choose callback, nested menu, create the item menu
      local choose = function(player,choice)
        if string.sub(choice,1,1) ~= "@" then -- ignore info choices
        local choices = CLIMB.getItemChoices(kitems[choice])
          -- build item menu
          local submenudata = {name=choice,css={top="75px",header_color="rgba(0,125,255,0.75)"}}

          -- add computed choices
          for k,v in pairs(choices) do
            submenudata[k] = v
          end

          -- nest menu
          submenudata.onclose = function()
            CLIMB.openInventory(source) -- reopen inventory when submenu closed
          end

          -- open menu
          CLIMB.openMenu(source,submenudata)
        end
      end

      -- add each item to the menu
      for k,v in pairs(data.inventory) do 
        local name,description,weight = CLIMB.getItemDefinition(k)
        if name ~= nil then
          kitems[name] = k -- reference item by display name
          menudata[name] = {choose,lang.inventory.iteminfo({v.amount,description,string.format("%.2f",weight)})}
        end
      end

      -- open menu
      CLIMB.openMenu(source,menudata)
    end
  end
end

-- init inventory
AddEventHandler("CLIMB:playerJoin", function(user_id,source,name,last_login)
  local data = CLIMB.getUserDataTable(user_id)
  if data.inventory == nil then
    data.inventory = {}

    if CLIMB.computeItemsWeight(data.inventory) > 15 then
      TriggerClientEvent("equipBackpack", source)
    else
      TriggerClientEvent("removeBackpack", source)
    end
  end
end)


-- add open inventory to main menu
local choices = {}
choices[lang.inventory.title()] = {function(player, choice) CLIMB.openInventory(player) end, lang.inventory.description()}

CLIMB.registerMenuBuilder("main", function(add, data)
  add(choices)
end)

-- CHEST SYSTEM

local chests = {}

-- build a menu from a list of items and bind a callback(idname)
local function build_itemlist_menu(name, items, cb)
  local menu = {name=name, css={top="75px",header_color="rgba(0,255,125,0.75)"}}

  local kitems = {}

  -- choice callback
  local choose = function(player,choice)
    local idname = kitems[choice]
    if idname then
      cb(idname)
    end
  end

  -- add each item to the menu
  for k,v in pairs(items) do 
    local name,description,weight = CLIMB.getItemDefinition(k)
    if name ~= nil then
      kitems[name] = k -- reference item by display name
      menu[name] = {choose,lang.inventory.iteminfo({v.amount,description,string.format("%.2f", weight)})}
    end
  end

  return menu
end

-- open a chest by name
-- cb_close(): called when the chest is closed (optional)
-- cb_in(idname, amount): called when an item is added (optional)
-- cb_out(idname, amount): called when an item is taken (optional)
function CLIMB.openChest(source, name, max_weight, cb_close, cb_in, cb_out)
  local user_id = CLIMB.getUserId(source)
  if user_id ~= nil then
    local data = CLIMB.getUserDataTable(user_id)
    if data.inventory ~= nil then
      if not chests[name] then
        local close_count = 0 -- used to know when the chest is closed (unlocked)

        -- load chest
        local chest = {max_weight = max_weight}
        chests[name] = chest 
        CLIMB.getSData("chest:"..name, function(cdata)
          chest.items = json.decode(cdata) or {} -- load items

          -- open menu
          local menu = {name=lang.inventory.chest.title(), css={top="75px",header_color="rgba(0,255,125,0.75)"}}
          -- take
          local cb_take = function(idname)
            local citem = chest.items[idname]
            CLIMB.prompt(source, lang.inventory.chest.take.prompt({citem.amount}), "", function(player, amount)
              amount = parseInt(amount)
              if amount >= 0 and amount <= citem.amount then
                -- take item
                
                -- weight check
                local new_weight = CLIMB.getInventoryWeight(user_id)+CLIMB.getItemWeight(idname)*amount
                if new_weight <= CLIMB.getInventoryMaxWeight(user_id) then
                  CLIMB.giveInventoryItem(user_id, idname, amount, true)
                  citem.amount = citem.amount-amount

                  if citem.amount <= 0 then
                    chest.items[idname] = nil -- remove item entry
                  end

                  if cb_out then cb_out(idname,amount) end

                  -- actualize by closing
                  CLIMB.closeMenu(player)
                else
                  CLIMBclient.notify(source,{lang.inventory.full()})
                end
              else
                CLIMBclient.notify(source,{lang.common.invalid_value()})
              end
            end)
          end

          local ch_take = function(player, choice)
            local submenu = build_itemlist_menu(lang.inventory.chest.take.title(), chest.items, cb_take)
            -- add weight info
            local weight = CLIMB.computeItemsWeight(chest.items)
            local hue = math.floor(math.max(125*(1-weight/max_weight), 0))
            submenu["<div class=\"dprogressbar\" data-value=\""..string.format("%.2f",weight/max_weight).."\" data-color=\"hsl("..hue..",100%,50%)\" data-bgcolor=\"hsl("..hue..",100%,25%)\" style=\"height: 12px; border: 3px solid black;\"></div>"] = {function()end, lang.inventory.info_weight({string.format("%.2f",weight),max_weight})}


            submenu.onclose = function()
              close_count = close_count-1
              CLIMB.openMenu(player, menu)
            end
            close_count = close_count+1
            CLIMB.openMenu(player, submenu)
          end


          -- put
          local cb_put = function(idname)
            CLIMB.prompt(source, lang.inventory.chest.put.prompt({CLIMB.getInventoryItemAmount(user_id, idname)}), "", function(player, amount)
              amount = parseInt(amount)

              -- weight check
              local new_weight = CLIMB.computeItemsWeight(chest.items)+CLIMB.getItemWeight(idname)*amount
              if new_weight <= max_weight then
                if amount >= 0 and CLIMB.tryGetInventoryItem(user_id, idname, amount, true) then
                  local citem = chest.items[idname]

                  if citem ~= nil then
                    citem.amount = citem.amount+amount
                  else -- create item entry
                    chest.items[idname] = {amount=amount}
                  end

                  -- callback
                  if cb_in then cb_in(idname,amount) end

                  -- actualize by closing
                  CLIMB.closeMenu(player)
                end
              else
                CLIMBclient.notify(source,{lang.inventory.chest.full()})
              end
            end)
          end

          local ch_put = function(player, choice)
            local submenu = build_itemlist_menu(lang.inventory.chest.put.title(), data.inventory, cb_put)
            -- add weight info
            local weight = CLIMB.computeItemsWeight(data.inventory)
            local max_weight = CLIMB.getInventoryMaxWeight(user_id)
            local hue = math.floor(math.max(125*(1-weight/max_weight), 0))
            submenu["<div class=\"dprogressbar\" data-value=\""..string.format("%.2f",weight/max_weight).."\" data-color=\"hsl("..hue..",100%,50%)\" data-bgcolor=\"hsl("..hue..",100%,25%)\" style=\"height: 12px; border: 3px solid black;\"></div>"] = {function()end, lang.inventory.info_weight({string.format("%.2f",weight),max_weight})}

            submenu.onclose = function() 
              close_count = close_count-1
              CLIMB.openMenu(player, menu) 
            end
            close_count = close_count+1
            CLIMB.openMenu(player, submenu)
          end


          -- choices
          menu[lang.inventory.chest.take.title()] = {ch_take}
          menu[lang.inventory.chest.put.title()] = {ch_put}

          menu.onclose = function()
            if close_count == 0 then -- close chest
              -- save chest items
              CLIMB.setSData("chest:"..name, json.encode(chest.items))
              chests[name] = nil
              if cb_close then cb_close() end -- close callback
            end
          end

          -- Ugly patch to close the "already opened" chest. 
			    SetTimeout(300000, function()
            if not close_count == 0 then
			        close_count = 0
              CLIMB.setSData("chest:"..name, json.encode(chest.items))
              chests[name] = nil
			      end
          end)
          -- Ugly patch to close the "already opened" chest.

          -- open menu
          CLIMB.openMenu(source, menu)
        end)
      else
        CLIMBclient.notify(source,{lang.inventory.chest.already_opened()})
      end
    end
  end
end

function CLIMB.getUserItemAmount(user_id,idname)
  local data = CLIMB.getUserDataTable(user_id)

  if data then 
    return data.inventory[idname]
  end
end

function CLIMB.getUserHasItem(user_id,idname)
  local data = CLIMB.getUserDataTable(user_id)

  if data then 
    return data.inventory[idname] ~= nil 
  end
end
